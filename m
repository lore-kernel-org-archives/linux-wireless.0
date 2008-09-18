Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58735 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756140AbYIRTXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:23:30 -0400
Date: Thu, 18 Sep 2008 16:23:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918192323.GP1583@khazad-dum.debian.net> (sfid-20080918_212349_352078_DBF7FF33)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809182017.12685.mb@bu3sch.de> <200809182023.21751.IvDoorn@gmail.com> <200809182034.00801.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809182034.00801.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Michael Buesch wrote:
> Nono. I will try to explain it once again. It's really easy.

It is also a textbook design for rfkill input lines, and handled in the
obvious way by rfkill.  If it is not, I don't get what Ivo means either.

> Think of b43 having two independent registers for rfkill. (the actual hardware
> is different, but that doesn't matter. It's a driver internal implementation detail).

> One of these registers is readonly and it does indicate the physical rfkill button state.
> If that register indicates BLOCK, we can't do anything about it. The radio is blocked.
> However, we can still write to the second register and turn the radio off through
> that, too. We can also write to the second register to turn the radio on, _but_ it won't
> physically turn on until the physical button is pressed and the first register changes
> to Unblocked.

Then you use the standard function I posted elsewhere in this thread:

if (any_of_the_hw_rfkill_lines_is_active_RIGHT_NOW)
	return RFKILL_STATE_HARD_BLOCKED;
else if (any_of_the_sw_rfkill_lines_is_active_RIGHT_NOW)
	return RFKILL_STATE_SOFT_BLOCKED;
else
	return RFKILL_STATE_UNBLOCKED;

You can use that as your rfkill->get_state() if you need it, and it is what
you should send to rfkill_force_state when
"any_of_the_hw_rfkill_lines_is_active_RIGHT_NOW" or
"any_of_the_sw_rfkill_lines_is_active_RIGHT_NOW" could have changed.

The devil is in the details of how you get
any_of_the_hw_rfkill_lines_is_active_RIGHT_NOW, and
any_of_the_sw_rfkill_lines_is_active_RIGHT_NOW.

You have to make sure "set txpower off" and such non-rfkill stuff doesn't
interfere with them, and Ivo will be happy :-)   You should also query the
hardware to make sure nothing poked it while you were looking elsewhere, but
that is impossible if the hardware is write-only.

I posted a sample code fragment to do that too, for drivers that implement
txpower off and rfkill SOFT_BLOCKED through the same hardware register.

> So you say that rfkill should only be notified about changes in the first read-only
> hardware intication bit? If that's the case, it would be possible to turn the radio off

Well, it only needs to be notified of changes due to the SW bit, if they can
happen because of external factors (such as laptop firmware).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
