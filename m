Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:16425 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZERSGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 14:06:55 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1667559rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 11:06:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242478657.10005.72.camel@johannes.local>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	<1242327298.4227.25.camel@localhost.localdomain> <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
	<1242334636.4227.134.camel@localhost.localdomain> <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com>
	<43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com>
	<1242478657.10005.72.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 May 2009 11:06:35 -0700
Message-ID: <43e72e890905181106j78367219mf16eadf4276f709c@mail.gmail.com>
Subject: Re: Scan while TX/RX'ing a lot of data
To: Johannes Berg <johannes@sipsolutions.net>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com, Gaurav.Jauhar@atheros.com,
	David Miller <davem@davemloft.net>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 16, 2009 at 5:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-05-15 at 23:12 -0700, Luis R. Rodriguez wrote:
>
>> > I think this is a good idea, although it wouldn't solve anything for
>> > people stuck on old userspace (my oldest target is distributions
>> > releases circa 2.6.27). Not sure what is best for that case. The
>> > kernel could be informed of the lack of userspace regulating this and
>> > then take some reasonable action. What the reasonable action and the
>> > terms for that remain unclear to me.
>>
>> OK so what if we just let let old wext scan be just a dump of the
>> current bss list provided we do selective scanning once per channel
>> throughout a period of time.
>
> Hmm, no. I don't think we want to scan automatically. On the other hand,
> a scan that the user triggered could be spread out over more time like I
> just wrote in the other mail.

The other mail talks about things to do for new stuff. Keep in mind
I'm talking about here a way to get whatever we do with the new stuff
somehow usable with the old stuff somehow while still not changing the
expected behavior dramatically. Granted I was making the assumption
automatic scanning was a good idea which it seems it may not be. But
more on this below.

>> For new userspace can obviously do whatever we like but since we'd
>> implement the above we could just let this automatic scanning can be
>> tweaked for roaming purpose with exposed knobs. That is -- make the
>> code so that it can be tweaked to act like a regular good old scan or
>> take breaks throughout.
>>
>> If you're already associated it makes little sense to be scanning all
>> over. If you're not associated it makes sense to do the good old scan
>> we're used to. Of course this would just be fof mac80211 and cfg80211
>> drivers, old wext will obviously still behave the same for old
>> hardware.
>
> Ick.
>
> [other mail]
>
>> Additionally we could add Kconfig for SMART_WEXT or whatever, and old
>> configs would behave the same. However users of old distributions
>> wanting new shiny drivers with new shiny benefits can enable it -- and
>> it would still work with old userspace.
>
> How complicated do you want to make it?

Implementation of scattered "soft scanning, I guess you can call it,
is a bit complicated in itself. I was trying to figure out a way to
keep the old behavior intact while still allowing old userspace to
gain the benefits of whatever it is that we do come up with for the
new stuff.

> No, I just think we should, if associated, spread out the scan a little
> more, and not change anything in the userspace API at all, just change
> the time it takes to do the scan and allow data to pass by going back to
> the operational channel.

 If we enhance scanning in mac80211 while your associated by relying
on some metrics we're leaving userspace out of the decision. It would
seem nicer to expose these metrics to userspace so it can take a
better informed decision. The issue still remains with old wext unless
are OK with some defaults. Which is why I was suggesting a SMART_WEXT.
But it seems we are OK with penalizing a userspace wext scan by
delaying it quite a bit when associated at the expense of doing
scattered scan.

> Now, I'm not saying this is easy, it can be almost arbitrarily tricky,
> but I still think we should do it.

OK!

> One thing for example could be if
> we're scanning the operational channel then the only thing we do is send
> probe requests, nothing more.
>
> The other thing to notice is that there's a race between RX and channel
> switch that I pointed out before -- and not all hardware is capable of
> closing that race. Atheros hardware for example doesn't seem to contain
> the channel the frame was received on in the RX information, so that the
> driver fills that in based on the current operating channel, which means
> that in order to report that correctly you have to flush RX...

Hm, yeah I just noticed we don't rx flush on channel change... I do
see this notice on ath_set_channel()

        /* XXX: do not flush receive queue here. We don't want
         * to flush data frames already in queue because of
         * changing channel. */

I forget why we added that now.. Anyway I guess we can test something like this:

diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
index bbbfdcd..a5db284 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -261,6 +261,11 @@ int ath_set_channel(struct ath_softc *sc, struct
ieee80211_hw *hw,
        ath9k_hw_set_interrupts(ah, 0);
        ath_drain_all_txq(sc, false);
        stopped = ath_stoprecv(sc);
+       ath_flushrecv(sc);
+
+       spin_lock_bh(&sc->rx.rxflushlock);
+       ath_rx_tasklet(sc, 0);
+       spin_unlock_bh(&sc->rx.rxflushlock);

        /* XXX: do not flush receive queue here. We don't want
         * to flush data frames already in queue because of



But not quite sure if this would resolve that race you mention of.

> Then again I don't quite see why we discard frames received during a
> scan even if they were for us.

We do discard them?

> Anyway, bottom line is that I don't think we should change the APIs in
> any way, we should instead make the scan smarter by spreading it out if
> we're active. This even applies to scanning while in an IBSS -- stop
> beaconing, then go scan etc.

OK sounds like a plan.

  Luis
