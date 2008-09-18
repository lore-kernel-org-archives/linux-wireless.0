Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59832 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbYIROYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:24:12 -0400
Date: Thu, 18 Sep 2008 11:24:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: ivdoorn@gmail.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918142405.GG1583@khazad-dum.debian.net> (sfid-20080918_162415_713581_2953EEF2)
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Larry Finger wrote:
> The changes below, along with Henriques patch "[PATCH] rfkill: update
> LEDs for all state changes", and the reversion of commit bc19d6e make
> the wireless LED toggle correctly.
> 
> This version passes UNBLOCKED to rfkill when the hardware switch enables the radio.

As I said in an email I just sent (unfortunately, after you already sent
this patch), whatever goes to rfkill_force_state must be the CURRENT state
of the hardware.

So, depending on what happens to b43 hardware when the hardware switch
enables it (i.e. does it enable for real, ignoring the software rfkill input
lines?), this patch might or might not be correct.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
