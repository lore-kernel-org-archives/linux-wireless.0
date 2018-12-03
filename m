Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6884C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 17:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7986720848
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 17:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7986720848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbeLCR5T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 12:57:19 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40162 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeLCR5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 12:57:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gTsSv-0005WH-Jv; Mon, 03 Dec 2018 18:57:05 +0100
Message-ID: <bb855ffd6043743ef10058c9395d0c6b42a7832a.camel@sipsolutions.net>
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        =?UTF-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        lorenzo.bianconi@redhat.com
Cc:     kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, brouer@redhat.com
Date:   Mon, 03 Dec 2018 18:57:04 +0100
In-Reply-To: <87k1kwq9bo.fsf@toke.dk> (sfid-20181129_145320_748252_63BF551A)
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
         <8736rla4ow.fsf@purkki.adurom.net>
         <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk>
         <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk>
         <20181128143533.GE2298@localhost.localdomain> <87zhtttg8p.fsf@toke.dk>
         <20181128153508.GG2298@localhost.localdomain> <87in0gu78s.fsf@toke.dk>
         <20181129125929.GB6365@localhost.localdomain>
         <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com>
         <87k1kwq9bo.fsf@toke.dk> (sfid-20181129_145320_748252_63BF551A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Toke, all,

Sorry I wasn't around for the discussion, I've been travelling and sick.

I'm picking this as an arbitrary point in the discussion to reply to,
hope you don't feel bad about that.

>> [A-MPDU reordering]
> In principle, all of this could be done. But we need to think carefully
> about what things it really makes sense to offload to XDP. In the
> general case, we will end up re-implementing all of mac80211 in eBPF,
> which is obviously not ideal.

Agree with this, completely. Mind you, it's not even simple to do that,
because each kind of hardware behaves differently. See below.

> For crypto in particular, I wonder if there is much of a speedup to be
> had if the crypto is in software anyway. Wouldn't that dominate the
> processing time?

Yeah, I'd also think the cost of skb allocation is dwarfed by the cost
of doing the crypto, but not really sure, maybe you have a fast special
AES instruction? :)


Anyway, here are my thoughts after reading most of the thread and having
discussed it with Lorenzo a while back and today:

1) I'm going to restrict most of the discussion to mac80211, but there
   are interesting cases outside of it as well. Much of the same
   arguments apply, though it means *more* feature combinatorial
   explosion to be able to handle everything.

2) We don't yet have it (but it's been suggested for years and we might
   also get it on Intel hardware eventually), but if we have TX and/or
   RX 802.3/802.11 frame conversion offload then I think we have no
   argument - XDP applies pure and simple as is in each direction you
   have offloads for, unless you do something really stupid in HW like
   still having to do reorder buffer or PN checking based on RX frame
   metadata. I hope nobody does that, but then I suppose you could do it
   before the XDP hooks w/o allocating SKBs.

3) TX from XDP (i.e. X -> wifi) could be implemented in mac80211, but is
   subject to some rather iffy details, for example:
   a) mac80211 may need more headroom than the input has, do we have to
      copy the whole data? depending on xdp_mem_type I think we may need
      that, rather than being able to make an skb with frag pages and
      extra headroom? We don't know it was just a single page and I
      guess we can't ref that page anyway, but maybe we could meddle
      with the SKB frag data somehow to avoid that.
   b) mac80211 may need to software encrypt - copy the whole data
   c) lifetime issues - we need to call xdp_return_frame(), which I
      guess we can tie to the skb we'd create anyway [2]
   (and IMHO we need to allocate an skb anyway, due to TXQs like Toke
    mentioned and much other possible software handling)

4) XDP during RX - well, that's _mostly_ what this thread has been
   about, but really I think it's a can of worms. Consider:
   a) drivers may or may not do SW decryption
   b) drivers may or may not do PN checking - so your XDP program might
      end up having to do that or risk security/replay bugs!
      (which, btw, you can only do after reordering so see below)
   c) drivers may or may not do A-MSDU deaggregation, do you[1] really
      want to handle that in XDP? You could argue outer code should walk
      over the subframes, but then dropping becomes hard - and this
      really should only happen after a) and b)
      Oh, and IIRC there are cases that use A-MSDUs for single frames
      just to encapsulate different MAC addresses.
      Speaking of which, you have to validate the inner MAC addresses
      (but it's not a trivial comparison) or risk security bugs again.
   d) drivers may or may not do A-MPDU reordering (this was discussed
      earlier in the thread), which means even if you drop a frame you
      haven't just affected that connection but potentially stalled
      everything until the reorder buffer times out (~100ms), or we need
      a way for mac80211 to insert a fake skb into the reorder buffer at
      that spot (but then you allocate an skb again and high-speed
      traffic where you'd care most is always in an A-MPDU session)
   e) speaking of which, Intel's device has hardware assist things for
      reordering, but not fully offloaded reordering, so you might end
      up with hardware-specific ways of doing this in XDP?
   f) Some data frames are used internally in the stack, e.g. for TDLS.
   g) data frames may also affect the powersave state of a station, so
      if you have e.g. ath9k and the station sends a frame to wake up,
      but you decide you XDP_DROP it, the powersave state will get
      messed up, unless ... special handling (either mac80211 or the
      bpf program) again. Also, U-APSD.
   h) There are also simple things like QoS/non-QoS that add to the
      combinatorial explosion of things you have to handle
   i) data frames could be sent by anyone, not just STAs connected to
      your network, so I guess you'd have to filter that and mac80211
      would have to expose a station table lookup helper or something?
      Alternatively shuffle the code around so mac80211 does that first,
      but then we already have an SKB anyway since we got it from the
      driver, and you want this stuff to run in the driver.
   j) in AP mode, if data frames are sent by somebody not belonging to
      the network, we should send an event to hostapd so it can tell
      them they're not on the network
   k) some drivers implement client-side powersave in mac80211 and need
      the more-data bit even if you were to XDP_DROP a frame. I hate
      this code with a passion, but it's there for now.
   m) did somebody mention fragmentation yet? and the special security
      handling for CCMP/GCMP there?
   n) I guess checking for port authorized/not would be one of the more
      trivial things, just adds another helper/bit/state/something.
   o) not supported yet by anyone (well, mac80211 at least), but the
      standard is adding provisions to leave out the SNAP/LLC header,
      which requires more out-of-band data (i.e. data not directly in
      the frame)
   p) there's also iwlwifi with it's multiqueue RX, but let's not go
      there now

[Toke, do you still think it's not sufficiently different? ;-P]

Of course with XDP anyone can shoot themselves in the foot easily, but I
also think we shouldn't make it too easy to do things like XDP_REDIRECT
on a frame that hasn't even had its security properties validated. It'd
work, but an attacker's frame could be accepted as well. We have enough
security bugs as is, I'm not sure I'd want that extra surface...


Now, of course you can pick each one of these points and say "but that's
not relevant for my ${favourite_hw}", which is true. Each hardware
(family) will likely make *most* of fixed or not relevant. Restrict
sufficiently though and you'll end up with *exactly* ${favourite_hw}
doing it the way you want to assume it is like.

E.g. let's say you require PN checking in hardware - maybe 2 or 3
drivers (I'm thinking ath10k, maybe mt76, maybe some ralink family)?

Or let's say you want A-MPDU reordering offload to not have to worry
about that and replays and all - I'm guessing only ath10k now and that
perhaps even only in 802.3 mode?

Or let's say you have enough filtering to not have to worry about 4j),
what if you enable monitor mode at the same time? Can you tell the
difference in the driver before calling the XDP program?


As fun as it sounds (on paper) to have XDP available for wifi, I'm not
sure we really should do that. We'd have to handle many of the issues
outlined above (which is at minimum a LOT of helper code that each at
least somewhat secure and portable XDP-wifi program would have to call),
and it looks like in the future we'll be moving more towards offloaded
802.11/.3 frame conversion anyway, at which point it all becomes more or
less useless.

So I see a few ways this might go:
 A) We basically allow everything, and let the XDP program authors
    figure it out. They'll eventually learn to handle the whole mac80211
    datapath (items in 4)), and will add a TON of helper code for it.
 B) We try to foresee all the needed helper code, and essentially build
    a parallel mac80211 datapath equivalent to the one today, but
    without SKBs.
 C) We rebuild the mac80211 datapath w/o SKBs so we can put XDP behind
    it. Ugh.
 D) We restrict it to ~1 driver that does most of the important things
    anyway in the device, thus hardcoding most of the variables, but
    then we expand out to A) or B)
 E) Like D, but then that device learns to do 802.3/.11 conversion.
    Oops.
 F) Like D, but then that *driver* learns to do 802.3/.11 conversion.
   
Also oops.

Maybe F) kind of has a good direction in it? If the device does enough
that we don't have to worry about most things, then - provided we
actually implement the code to allow 802.3/.11 conversion offload in
mac80211 - the driver can probably easily do that itself rather than
punting to mac80211's fast-RX/fast-TX, which would likely be used?

Or perhaps that means we should teach mac80211 fast-RX to be skb-less,
or something like that? But I think that doesn't solve the reorder
buffer issue either.


(Let's also not forget that the original use case was something around
defective HW filters for BSSIDs - IMHO that should just be *hardcoded*
into the driver anyway because all other frames are useless to you,
except perhaps if also monitor mode is active but then you need an SKB!)


Ok, this got longer than I wanted...

johannes

[1] generally speaking, no particular "you" intended
[2] btw, i40e_clean_xdp_tx_buffer() looks kinda weird? it returns first
and then DMA-unmaps, you'd think it should be done the other way around?


