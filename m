Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39907 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYIRRPb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:15:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:14:58 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>, ivdoorn@gmail.com,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918142405.GG1583@khazad-dum.debian.net>
In-Reply-To: <20080918142405.GG1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181914.58417.mb@bu3sch.de> (sfid-20080918_191535_893294_ABC7E4FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 16:24:05 Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Larry Finger wrote:
> > The changes below, along with Henriques patch "[PATCH] rfkill: update
> > LEDs for all state changes", and the reversion of commit bc19d6e make
> > the wireless LED toggle correctly.
> > 
> > This version passes UNBLOCKED to rfkill when the hardware switch enables the radio.
> 
> As I said in an email I just sent (unfortunately, after you already sent
> this patch), whatever goes to rfkill_force_state must be the CURRENT state
> of the hardware.
> 
> So, depending on what happens to b43 hardware when the hardware switch
> enables it (i.e. does it enable for real, ignoring the software rfkill input
> lines?), this patch might or might not be correct.

It does enable it, but software might still be blocking it.
sw and hw rfkill are two unrelated things in b43.

-- 
Greetings Michael.
