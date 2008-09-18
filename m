Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41872 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbYIRRUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:20:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:20:10 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918162440.GL1583@khazad-dum.debian.net> <48D2867D.6010501@lwfinger.net>
In-Reply-To: <48D2867D.6010501@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181920.10416.mb@bu3sch.de> (sfid-20080918_192037_484503_A1A5059B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 18:49:01 Larry Finger wrote:
> Henrique de Moraes Holschuh wrote:
> > 
> > The problem is in the "should".
> > 
> > Maybe something else than b43 (like firmware) changed the radio software
> > rfkill bit, and it does not match what mac80211 and userland requested
> > anymore.
> > 
> > What you need to pass to rfkill_force_state() is what the radio is currently
> > doing.  So, the state you need to send to rfkill_force_state has to be based
> > on the real state of the hardware's "soft switch bit".
> 
> The hardware does not have such a bit. Once it is initialized and
> mac80211 sends it a packet, it will try to send it. That is true even
> if the hardware switch is off. It just will not succeed.

Right, b43 does have two "bits". One read-only bit that tells the hardware
block state. This state can only be changed by physically pressing rfkill
button. The other "bit" is a read/write "bit" to turn off the radio in software.
If _either_ one bit is blocking the radio, it will be physically blocked.

-- 
Greetings Michael.
