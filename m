Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50132 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYIRRmK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:42:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:41:45 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181553.29140.IvDoorn@gmail.com> <20080918142133.GF1583@khazad-dum.debian.net>
In-Reply-To: <20080918142133.GF1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181941.45301.mb@bu3sch.de> (sfid-20080918_194214_365838_D8F35E35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 16:21:33 Henrique de Moraes Holschuh wrote:
> The problem is that it really boils down to something like this:
> 
> static inline enum rfkill_state translate_to_rfkill_state(
> 		const bool is_any_hw_rfkill_line_active_RIGHT_NOW,
> 		const bool is_any_sw_rfkill_line_active_RIGHT_NOW) {
> 
> 	if (is_any_hw_rfkill_line_active_RIGHT_NOW)
> 		return RFKILL_STATE_HARD_BLOCKED;
> 	else if (is_any_sw_rfkill_line_active_RIGHT_NOW)
> 		return RFKILL_STATE_SOFT_BLOCKED;
> 	else
> 		return RFKILL_STATE_UNBLOCKED;
> }
> 
> and send that to rfkill_force_state().

I agree with that. We must call that from the paths that change the software
state of the b43 radio and the hardware rfkill state notifiers in the b43 driver.

-- 
Greetings Michael.
