Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37841 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbeIJILk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 04:11:40 -0400
Received: by mail-lf1-f67.google.com with SMTP id j8-v6so16205160lfb.4
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 20:19:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
From: Kan Yan <kyan@google.com>
Date: Sun, 9 Sep 2018 15:08:01 -0700
Message-ID: <CA+iem5te2vFq+aXiVDZ7OhuWkR+cScOKiV8bSb85ycD6WDK1WQ@mail.gmail.com> (sfid-20180910_051953_035673_4D978FAE)
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Toke,

It is great to see finally there will be a general airtime fairness
support in mac80211. I feel this patch set could still use some
improvements to make it works better with 11ac drivers like ath10k. I
did a version of airtime fairness in the ath10k driver that used in
Google Wifi and I'd like to share a few things I learned from this
experience.

Airtime fairness is a cool feature, but that's not the motivation for
me to implement that. The goal is to solve the bufferbloat problem at
wireless interface. Fq_CoDel has been proved to be very effective in
fixing bufferbloat for wired interface, and it has been integrated
with mac802.11 for more than 2 years. However, it still does not work
well with 11ac drivers like ath10k, which relies heavily on firmware
to do most of transmit scheduling, and hence has deep firmware queue.
FQ_CoDel expects a thin driver layer queue so it can get an accurate
measurement of sojourn time and use the sojourn time to control
latency.  However, the queue in ath10k firmware is so deep, that
packets only stay in mac80211 layer queue transiently. The sojourn
time is almost always below target, and hence CoDel doesn't do much to
control the latency.

The key to make Fq_Codel works effectively with 11ac wireless driver
is to limit the queue depth in lower layer. It looks to me this patch
set only enforce fairness among stations (airtime wise), but did not
limit how many packets can be released to firmware/hardware.  When a
txq run out of its airtime deficit, the txq is put to the back of the
list but will get a refill of airtime deficit in next round. It
doesn't keep counts of the total pending airtime released to hardware
or firmware. Packets will be released as long as wireless driver keeps
calling the dequeue function. This maybe not an issue for ath9k,
because the number of available tx descriptors is more limited.
However, for 11ac drivers like ath10k, it routinely queues thousands
packets when the bandwidth is oversubscribed in my test.

The version I did is to use pending airtime to restrict the firmware
queue depth. Another difference is it does not use airtime reported
from firmware, which is "past" or spent airtime, but use "future"
airtime, the estimated airtime calculated using last reported tx rate
for the inflight packets pending in the firmware queue. Host driver
keeps counts of total pending airtime for each TxQ (per station, per
AC). It tries to release up to 4-8 ms worth of frames for each TxQ.
The idea is to use airtime accounting to give firmware just enough
frames to keep it busy and form good aggregations, and keeps the rest
of frames in mac80211 layer queues so Fq_Codel can work on it to
control latency.

Here are some of the patches from the version I did in ath10k for
kernel in ChromeOs.
CHROMIUM: net: mac80211: Recording last tx bitrate.
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/=
588189

CHROMIUM: ath10k: Implementing airtime fairness based TX scheduler.
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/=
588190/13

CHROMIUM: ath10k: use frame count as defict for fq_codel.
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/=
588192/13

I had some discussions with Rajkumar on how to adapt some methods from
my patch and make it fit with the new TXQ scheduling API proposed
here. The major issue is the lack of pending airtime accounting. It
could be done in individual wireless drivers, such as in ath10k, or
even in firmware, but implement it in mac80211 could be a better
choice than do it one driver at a time.

Thanks,
Kan

On Fri, Sep 7, 2018 at 3:22 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:
> This is an updated version of the patch series to move TXQ scheduling and
> airtime fairness scheduling into mac80211. I've only compile tested this
> version, but thought it was better to get the conversation moving instead
> of being blocked on me.
>
> This addresses most of the comments from the last round. Specifically:
>
> - It folds in Rajkumar's patches to keep per-AC TXQ lists, and to add an
>   API that ath10k can use to check if a TXQ may transmit according even
>   when not using get_next_txq(). I changed a few names and descriptions,
>   but otherwise it's mostly the same. After the discussions we had in the
>   last series, I *think* it will work this way, but I'm not entirely sure=
.
>
> - I got rid of any mention of seqno in next_txq() and schedule_txq() - an=
d
>   removed the third parameter to schedule_txq() entirely, so drivers can =
no
>   longer signal that a TXQ should be allowed to re-appear in a scheduling
>   round. We can add that back if needed.
>
> - Added a helper function to schedule and wake TXQs in a single call, for
>   internal mac80211 use.
>
> - Changed the default station weight to 256 and got rid of the per-phy
>   quantum. This makes it possible to lower station weights without having
>   to change the weights of every other station.
>
> A few things that were discussed in the last round that I did *not* chang=
e:
>
> - I did not add any locking around next_txq(); the driver is still suppos=
ed
>   to maintain a lock that prevents two threads from trying to schedule th=
e
>   same AC at the same time. This is what drivers already do, so I figured=
 it
>   was easier to just keep it that way rather than do it in mac80211.
>
> - I didn't get rid of the register_airtime() callback. As far as I can te=
ll,
>   only iwlwifi uses the tx_time field in the struct tx_info. Which means =
that
>   we *could* probably use it for this and just make the other drivers set=
 it;
>   but I'm not sure what effects that would have in relation to WMM-AC for
>   those drivers, so I chickened out. Will have to try it out, I guess; bu=
t it
>   also depends on whether ath10k needs to be able to report airtime
>   asynchronously anyway. So I'll hold off on that for a bit more.
>
> -Toke
>
> ---
>
> Toke H=C3=B8iland-J=C3=B8rgensen (4):
>       mac80211: Add TXQ scheduling API
>       mac80211: Add airtime accounting and scheduling to TXQs
>       cfg80211: Add airtime statistics and settings
>       ath9k: Switch to mac80211 TXQ scheduling and airtime APIs
>
>
>  drivers/net/wireless/ath/ath9k/ath9k.h     |   14 --
>  drivers/net/wireless/ath/ath9k/debug.c     |    3
>  drivers/net/wireless/ath/ath9k/debug.h     |    8 -
>  drivers/net/wireless/ath/ath9k/debug_sta.c |   54 ------
>  drivers/net/wireless/ath/ath9k/init.c      |    3
>  drivers/net/wireless/ath/ath9k/recv.c      |    9 -
>  drivers/net/wireless/ath/ath9k/xmit.c      |  245 ++++++++--------------=
------
>  include/net/cfg80211.h                     |   12 +
>  include/net/mac80211.h                     |   97 +++++++++++
>  include/uapi/linux/nl80211.h               |   15 ++
>  net/mac80211/agg-tx.c                      |    2
>  net/mac80211/cfg.c                         |    3
>  net/mac80211/debugfs.c                     |    3
>  net/mac80211/debugfs_sta.c                 |   42 ++++-
>  net/mac80211/driver-ops.h                  |    7 +
>  net/mac80211/ieee80211_i.h                 |   11 +
>  net/mac80211/main.c                        |    5 +
>  net/mac80211/sta_info.c                    |   49 +++++-
>  net/mac80211/sta_info.h                    |   13 +
>  net/mac80211/tx.c                          |  125 ++++++++++++++
>  net/wireless/nl80211.c                     |   25 +++
>  21 files changed, 471 insertions(+), 274 deletions(-)
>
> X-Clacks-Overhead: GNU Terry Pratchett
