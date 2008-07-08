Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46910 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbYGHTxQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 15:53:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Linux capable PDA with WLAN NIC that supports access point mode?
Date: Tue, 8 Jul 2008 21:52:48 +0200
Cc: pommnitz@yahoo.com, linux-wireless@vger.kernel.org
References: <899764.45398.qm@web51401.mail.re2.yahoo.com> <1215544570.3670.7.camel@johannes.berg>
In-Reply-To: <1215544570.3670.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807082152.48856.mb@bu3sch.de> (sfid-20080708_215334_010227_55E8E5E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 July 2008 21:16:10 Johannes Berg wrote:
> > Is there a CompactFlash based WLAN NIC with an AP capable Linux driver?
> 
> There's a Broadcom CF card. I have one, but it's not DMA capable in
> Linux because of the PCMCIA subsystem (IIRC).

Well, there are several issues. One is that DMA on PCMCIA is damn ugly.
It was derived from ISA-DMA, so it is ugly by definition. Second thing is
that linux-pcmcia doesn't support it, as it doesn't fit into any way linux
does DMA. It could possibly get implemented with the old ISA DMA API, but
I don't think anybody is going to make that crufty code portable and usable.
Third thing is that not all PCMCIA host controllers capable of
driving the card can do DMA in hardware. The third point actually is the major
point for me to not try to implement it. The PCMCIA bridge chip in my laptop
does not support DMA.
I guess a PDA with a CF slot can do DMA, however. (Otherwise the designer has
to get kicked ass). So it would theoretically be possible to get DMA working
with some ugly hacks. Probably even without touching the damn ugly linux-pcmcia
code a lot.

-- 
Greetings Michael.
