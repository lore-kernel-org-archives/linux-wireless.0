Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57888 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0IOHXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 03:23:42 -0400
Received: by iwn5 with SMTP id 5so6810794iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 00:23:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
References: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 15 Sep 2010 00:23:21 -0700
Message-ID: <AANLkTi=+3i779OVCbR9LO+u-Mm47VVVb6y_eNqYSqU9b@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] ath9k / mac80211: power save fixes
To: linville@tuxdriver.com, stable@kernel.org,
	Greg KH <greg@kroah.com>, Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 4:40 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> I reordered the patches, enhanced the commit log entries and
> and added a new patch to address ANI / the TX monitor, figured I'd just
> send a new series just to be clear.
>
> My next peet peeve is this:
>
> Sep 14 16:36:02 tux kernel: [ 1369.000106] ath: Set channel: 5220 MHz
> Sep 14 16:36:02 tux kernel: [ 1369.000116] ath: tx chmask: 3, rx chmask: 3
> Sep 14 16:36:02 tux kernel: [ 1369.000240] ath: (2412 MHz) -> (5220 MHz), conf_is_ht40: 0
> Sep 14 16:36:02 tux kernel: [ 1369.063449] ath: Set channel: 2412 MHz
> Sep 14 16:36:03 tux kernel: [ 1369.063459] ath: tx chmask: 3, rx chmask: 3
> Sep 14 16:36:03 tux kernel: [ 1369.063584] ath: (5220 MHz) -> (2412 MHz), conf_is_ht40: 0
> Sep 14 16:36:03 tux kernel: [ 1369.360111] ath: Set channel: 5240 MHz
> Sep 14 16:36:03 tux kernel: [ 1369.360120] ath: tx chmask: 3, rx chmask: 3
> Sep 14 16:36:03 tux kernel: [ 1369.360245] ath: (2412 MHz) -> (5240 MHz), conf_is_ht40: 0
> Sep 14 16:36:03 tux kernel: [ 1369.422736] ath: Set channel: 2412 MHz
> Sep 14 16:36:03 tux kernel: [ 1369.422745] ath: tx chmask: 3, rx chmask: 3
> Sep 14 16:36:03 tux kernel: [ 1369.422867] ath: (5240 MHz) -> (2412 MHz), conf_is_ht40: 0
> Sep 14 16:36:03 tux kernel: [ 1369.564685] __ratelimit: 81 callbacks suppressed
> Sep 14 16:36:03 tux kernel: [ 1369.564692] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564698] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564703] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564708] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564713] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564718] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564723] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564728] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564733] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.564738] phy0: release an RX reorder frame due to timeout on earlier frames
> Sep 14 16:36:03 tux kernel: [ 1369.720129] ath: Set channel: 5260 MHz
> Sep 14 16:36:03 tux kernel: [ 1369.720139] ath: tx chmask: 3, rx chmask: 3
> Sep 14 16:36:03 tux kernel: [ 1369.720263] ath: (2412 MHz) -> (5260 MHz), conf_is_ht40: 0
>
> My guess is we are not suspending / stopping the aggregations sessions /
> or simply extending the timer when going off channel.
>
> Luis R. Rodriguez (10):
>  ath9k: fix power save race conditions
>  ath9k: fix regression on beacon loss after bgscan
>  ath9k: fix enabling ANI / tx monitor after bg scan
>  mac80211: add helper for reseting the connection monitor
>  mac80211: reset probe send counter upon connection timer reset
>  mac80211: reset connection idle when going offchannel
>  mac80211: make the beacon monitor available externally
>  mac80211: disable beacon monitor while going offchannel
>  mac80211: send last 3/5 probe requests as unicast
>  ath9k: fix regression which disabled ps on ath9k
>
> Senthil Balasubramanian (1):
>  ath9k: fix regression which prevents chip sleep after CAB data
>
>  drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
>  drivers/net/wireless/ath/ath9k/init.c  |    3 +-
>  drivers/net/wireless/ath/ath9k/main.c  |   15 ++++++-----
>  drivers/net/wireless/ath/ath9k/recv.c  |    9 ++++--
>  net/mac80211/ieee80211_i.h             |    2 +
>  net/mac80211/mlme.c                    |   40 +++++++++++++++++++++++--------
>  net/mac80211/offchannel.c              |    7 +++++
>  7 files changed, 54 insertions(+), 23 deletions(-)

The respective stable patches are now backported to each kernel to
which they apply to. To make life easier for stable maintenance you
can just download the backported patches. I have put an all-in-one
git-am-able file and also split up. I should note that we also had
some CTL fixes pending merge. I've updated the wiki to help keep track
of what is pending merge:

http://wireless.kernel.org/en/developers/stable-pending

If you are a distribution waiting consumption you can either start
testing these patches or wait until Linus applies to his tree as that
is what is required for the patches to trickle down to the other older
stable series. The commit ID from Linus' tree is required so that the
patches can be applied to older kernels.

Although I provide the links above, you can download the pending stuff from:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010/08/
http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2010/09/14/

  Luis
