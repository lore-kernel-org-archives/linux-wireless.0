Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:56796 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYIRO21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:28:27 -0400
Received: by fg-out-1718.google.com with SMTP id 19so239355fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 07:28:25 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 16:28:22 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918142405.GG1583@khazad-dum.debian.net>
In-Reply-To: <20080918142405.GG1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181628.22544.IvDoorn@gmail.com> (sfid-20080918_162830_050021_3467202E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
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

As far as I can see the v2 patch is correct, it sends the BLOCK event when the
rfkill key was pressed to block the radio and the UNBLOCK event when the rfkill
key was pressed to unblock the radio.

The change compared to v1 was needed to prevent BLOCK events to be send
when user has manually disabled the radio for the interface through another
interface then rfkill (and thus wasn't a rfkill event).

Ivo
