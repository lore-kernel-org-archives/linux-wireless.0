Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:38614 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaBFSTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 13:19:44 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Felix Fietkau'" <nbd@openwrt.org>,
	<linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A3190173371A@sbs2003.acksys.local> <52F39F41.2010300@openwrt.org> <009301cf2359$e35f0330$aa1d0990$@acksys.fr> <52F3BEA6.1080502@openwrt.org>
In-Reply-To: <52F3BEA6.1080502@openwrt.org>
Subject: RE: ATH9K software retry
Date: Thu, 6 Feb 2014 18:59:12 +0100
Message-ID: <00a101cf2365$24a0f0f0$6de2d2d0$@acksys.fr> (sfid-20140206_191947_354104_B4FC8C93)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >>
> > Is it possible to only applied software retrying for A-MPDU frame with
> > more one frame?
> > If I correctly understood the code, the function ath_tx_count_frames
> > return the number of frame in the A-MPDU. If nframes == 1 we don't use
> > the software retry.
> Software retry should be applied to any frame that is part of a BlockAck
> session, because any failed frame that is not retried requires the sender
to
> notify the receiver with a BlockAckRequest, which is expensive. I would
> suggest keeping the current behavior, unless you have a good reason to
> change it and understand the implications.
> 
Thanks for your answers. 

I think I am not on the good way. I would like to reduce the software
retries when we lost the AP (turn off). In this case, no BlockAck are
received. 
Is it possible to reduce the software retries in this case? If yes, could
you give me some pointer?

Is it possible to reduce the ATH_MAX_SW_RETRIES value (for example reduces
to 10) without damage?

Cedric voncken

