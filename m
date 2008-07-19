Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44894 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbYGSNmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 09:42:35 -0400
Date: Sat, 19 Jul 2008 10:42:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] rfkill: document rfkill_force_state as required
Message-ID: <20080719134230.GA11269@khazad-dum.debian.net> (sfid-20080719_154240_314023_CF2EB096)
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-2-git-send-email-hmh@hmh.eng.br> <200807191434.30815.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807191434.30815.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 19 Jul 2008, Ivo van Doorn wrote:
> >  Every time the driver gets a notification from the card that one of its rfkill
> >  lines changed state (polling might be needed on badly designed cards that don't
> > @@ -422,13 +423,24 @@ of the hardware is unknown), or read-write (where the hardware can be queried
> >  about its current state).
> >  
> >  The rfkill class will call the get_state hook of a device every time it needs
> > -to know the *real* current state of the hardware.  This can happen often.
> > +to know the *real* current state of the hardware.  This can happen often, but
> > +it does not do any pooling, so it is not enough on hardware that is subject
> > +to state changes outside of the rfkill subsystem.
> 
> pooling -> polling
> 
> With that typo fixed, you can add my:
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Done, will send v2 soon.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
