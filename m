Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14890 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbYE1Iqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 04:46:43 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 3] libertas: fix compact flash interrupt handling
Date: Wed, 28 May 2008 10:46:35 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200805261250.23580.hs4233@mail.mn-solutions.de> <1211919275.555.25.camel@localhost.localdomain>
In-Reply-To: <1211919275.555.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805281046.35897.hs4233@mail.mn-solutions.de> (sfid-20080528_104657_875646_9A6C6010)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But again; if the patch works better for you, I'll ack it
> because it doesn't work any worse for me.  Logs with
> libertas_debug=0x443af available if you want to see them.

Yes, I'd like this. You can send me this as a .bz2 file.

For me, the problem with the old approach was in the "tx done" 
part. With take1+take2 of my patch, an error showed up when, 
while I was executing if_cs_send_data(), an interrupt could 
happen and my code did touch other chip registers, while it just 
should continue to send the data. Take 3 fixed this for me.


> I really don't know what to do to trace it further.  Is there a
> way to reset the CF card and kick the firmware in the head that
> I can try from the TX handler, like a USB port reset or
> something?  I also might be able to set this machine up for
> remote access so you can play with it if you like.

On CF, there's always one way to kick the firmware into the 
head: "pcmciactrl eject; pcmciactrl insert". You can be quite 
pretty sure that after this every state in the card, the 
firmware, the driver and the networking subsystem has been 
cleared :-)

However, maybe there are better ways, less sledge-hammer-like 
ones. I'll dig more into this.


One reason for my digging is this error that I had:

libertas_cs: card not ready for commands
libertas: DNLD_CMD: hw_host_to_card failed: -1
libertas: command 0x001f timed out
libertas: requeueing command 0x001f due to timeout (#1)
libertas_cs: card not ready for commands
libertas: DNLD_CMD: hw_host_to_card failed: -1
libertas: command 0x001f timed out
libertas: requeueing command 0x001f due to timeout (#2)
libertas_cs: card not ready for commands
libertas: DNLD_CMD: hw_host_to_card failed: -1
libertas: command 0x001f timed out
libertas: requeueing command 0x001f due to timeout (#3)
libertas_cs: card not ready for commands
libertas: DNLD_CMD: hw_host_to_card failed: -1
libertas: command 0x001f timed out
libertas: Excessive timeouts submitting command 0x001f
libertas_cs: no cmd response in card
libertas: PREP_CMD: command 0x0006 failed: -2
libertas: SCAN_CMD failed


However, I'm not yet sure if I can say (in this case) "the 
firmware is hosed" and I'm also not sure if it's wise to just 
send a CMD_802_11_RSSI command down as the driver currently 
does.
