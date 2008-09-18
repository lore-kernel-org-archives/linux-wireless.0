Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51362 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbYIRQtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 12:49:13 -0400
Message-ID: <48D2867D.6010501@lwfinger.net> (sfid-20080918_184917_002673_18C2BE3D)
Date: Thu, 18 Sep 2008 11:49:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Ivo van Doorn <ivdoorn@gmail.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918142405.GG1583@khazad-dum.debian.net> <200809181628.22544.IvDoorn@gmail.com> <20080918144836.GI1583@khazad-dum.debian.net> <48D27103.1050709@lwfinger.net> <20080918162440.GL1583@khazad-dum.debian.net>
In-Reply-To: <20080918162440.GL1583@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> 
> The problem is in the "should".
> 
> Maybe something else than b43 (like firmware) changed the radio software
> rfkill bit, and it does not match what mac80211 and userland requested
> anymore.
> 
> What you need to pass to rfkill_force_state() is what the radio is currently
> doing.  So, the state you need to send to rfkill_force_state has to be based
> on the real state of the hardware's "soft switch bit".

The hardware does not have such a bit. Once it is initialized and
mac80211 sends it a packet, it will try to send it. That is true even
if the hardware switch is off. It just will not succeed.

> If the hardware "soft switch" bit is write-only, you have no choice but to
> use the mac80211 value like your V2 patch does, BTW.

Since we have only a read-only hardware switch bit, I think you are
saying that V2 is correct.

Larry

