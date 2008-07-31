Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46064 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbYGaOWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 10:22:47 -0400
Date: Thu, 31 Jul 2008 11:22:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH] rfkill: query EV_SW states when rfkill-input
	(re)?connects to a input device
Message-ID: <20080731142242.GE19665@khazad-dum.debian.net> (sfid-20080731_162250_213207_AFF22797)
References: <20080730013024.GB22649@anvil.corenet.prv> <1217512437-20890-1-git-send-email-hmh@hmh.eng.br> <200807311638.10270.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807311638.10270.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 31 Jul 2008, Ivo van Doorn wrote:
> On Thursday 31 July 2008, Henrique de Moraes Holschuh wrote:
> > Every time a new input device that is capable of one of the rfkill EV_SW events
> > (currently only SW_RFKILL_ALL) is connected to rfkill-input, we must check the
> > states of the input EV_SW switches and take action.  Otherwise, we will ignore
> > the initial switch state.
> > 
> > We also need to re-check the states of the EV_SW switches after a device that
> > was under an exclusive grab is released back to us, since we got no input
> > events from that device while it was grabbed.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > Cc: Dmitry Torokhov <dtor@mail.ru>
> 
> Sounds sane enough for me.
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Thanks. For reference, this is the same old patch, but with Dmitry's fix to
my &array error that John's gcc complained about.

Not that I have found how to get gcc to give me these warnings yet. Maybe I
haven't tried hard enough :(

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
