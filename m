Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35448 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0H0P2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 11:28:54 -0400
Received: by iwn5 with SMTP id 5so2698923iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 08:28:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100827090655.GA15873@jm.kir.nu>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com> <20100827090655.GA15873@jm.kir.nu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 27 Aug 2010 08:28:34 -0700
Message-ID: <AANLkTimw1MpiKM=rCfp_zxkw855SyaoZg6m1oB354tCF@mail.gmail.com>
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 2:06 AM, Jouni Malinen <j@w1.fi> wrote:
> On Fri, Aug 27, 2010 at 01:38:47AM -0400, Luis R. Rodriguez wrote:
>> The new scan implementation only takes into consideration
>> the the listen interval which the driver itself sets. The AP
>> however will send all buffered broadcast and multicast data
>> every dtim_period which typically is less than the listen
>> interval. We are also currently not respecting the pm-qos
>> network latency. Since dynamic powersave work already computes
>> for us the minimum allowed sleep period reuse that work
>> and ensure we don't sleep longer than what we allowed for.
>>
>> Without this we drop buffered broadcast and multicast traffic.
>
> Did you test how much this patch would help? While reducing the length
> of each off-channel phase in background scan is indeed needed to receive
> the broadcast frames, I don't see how this by itself would help at all.
> Quite the opposite, I would not be surprised if this actually makes us
> drop even larger number of broadcast frames by lengthening the total
> scan duration and by adding more channel changes..

I only tested how often we go off the home channel compared to before.

> In order for this to provide real help for receiving broadcast/multicast
> frames, the start of each off-channel scan sequence needs to be
> synchronized with DTIM Beacon + PS broadcast/multicast RX. In other
> words, when we are on the operating channel, we need to start the next
> scan sequence immediately after receiving the last buffered
> broadcast/multicast frame from our current AP (or if no buffered frames
> are indicated in the DTIM Beacon, immediately after that Beacon frame is
> received). This is obviously assuming that we are associated with an AP
> (and only one AP for that matter; multiple virtual interfaces will make
> this quite a bit more complex, but we can leave that for future work
> while handling the simpler case now).

Indeed... I do not see where we keep track of the DTIM count and was
afraid this was not sufficient. I had not thought about the last
received multicast / broadcast frame, that will require some more
work. But I also noticed even ieee80211_recalc_ps() does not take this
into account when computing the max_sleep_period ieee80211_enable_ps()
for dynamic power save, it only considers the DTIM period. We send the
nullfunc frame for dynamic power save and it does not seem we take
into consideration the DTIM count and last RX's broadcast / multicast
data prior to sending the nullfunc to go into power save. So it seems
to me dynamic power save would also loses broadcast / multicast data
frames. It also means though that if we fix this through
hw.conf.max_sleep_period we could take care of both.

>> If this requires a bit too many changes I am not sure how to handle
>> this for stable. We'll see.
>
> I would not even think about stable for this at the moment.. I don't
> really consider this as a simple fix, but rather a completely new
> feature for the background scan which was not previously designed to
> handle broadcast/multicast receiving.

Fair enough, if we do get this work done I'm motivated enough to carry
these onto compat-wireless as linux-next-cherry-pick patches for a
compat-wireless-2.6.36 release (another release can be provided
without applying the linux-next-cherry-pick stuff which only carries
vanilla 2.6.36).

  Luis
