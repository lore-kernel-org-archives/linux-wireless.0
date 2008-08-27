Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44512 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbYH0XBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 19:01:19 -0400
Date: Wed, 27 Aug 2008 20:01:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Message-ID: <20080827230111.GA18081@khazad-dum.debian.net> (sfid-20080828_010125_813123_88C29BA5)
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <1219762681-26911-6-git-send-email-hmh@hmh.eng.br> <200808261813.56050.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808261813.56050.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Aug 2008, Ivo van Doorn wrote:
> > 	drivers/net/wireless/rt2x00/* (USB might need it?)
> 
> rt2x00 doesn't have rfkill support for the USB drivers, only the PCI drivers,
> (because only those cards could have an actual rfkill switch.

Well, rfkill support is not related only to input devices, but also to
transmitters.  And EVERY transmitter MUST have one (and a single one) rfkill
class attached to it, unless the hardware is completely and utterly unable
to block its transmitter(s).  I hope no rt2x00 device is like that...

> Other then that no changes are required in rt2x00 with this patch.

Which I will take to mean that all rt2x00 drivers, be them USB or PCI, will
do whatever is needed (including shutting down transmitters explicitly, when
the hardware doesn't do it implicitly because of something else the driver
is doing) on their own suspend() methods.

Is that correct?  Because that's all patch 5 of 5 is concerned with.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
