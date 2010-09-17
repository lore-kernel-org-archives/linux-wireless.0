Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62356 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0IQRjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 13:39:22 -0400
Received: by bwz11 with SMTP id 11so2849956bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 10:39:21 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: interrupts
Date: Fri, 17 Sep 2010 19:39:17 +0200
Cc: Chuck Crisler <ccrisler@vgocom.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
References: <D6CF33887D864426B02D21261537559B@ChuckPC> <20100917164223.GC2008@tux>
In-Reply-To: <20100917164223.GC2008@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009171939.17574.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 September 2010 18:42:23 Luis R. Rodriguez wrote:
> On Fri, Sep 17, 2010 at 07:10:42AM -0700, Chuck Crisler wrote:
> > Luis, our gizmo uses an IR interface that is poorly implemented but needs
> > timely interrupts. It works well unless an AR9170 is plugged in. The
> > hardware guy has put a scope on the board and claims that the interrupts
> > are not being passed to the device. Where in the kernel or AR driver would
> > I start looking for this problem?
> > 
ar9170usb (and otus) are processing (unaggregate rx-stream, alloc an skb for
each mpdu/frame in the stream, memcpy the data into each skb, push the finished
skb to the network stack) all incoming frames in the urb callback routine,
which has to run with IRQs disabled.

This "could" explain why you are getting such a bad irq-latency.

ath9k_htc and carl9170 do things differently. Both have
tasklets(related to bottom-halves if you aren't familiar
with the term) which take care of the rx stream processing
and the latency should be better. (don't have a scope
to test that claim but I can't see why it should be worse)

> > I got my problems with the 9170 fixed. Now roaming looks
> > rock solid, though it is slow (~6 seconds, mainly for the scan).
> >
> > The problem was in the wpa_supplicant.
Hmm, I'm curious: what was the problem in wpa_supplicant?

Best regards,
	Chr
