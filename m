Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:38593 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbYIRNrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 09:47:43 -0400
Message-ID: <48D25BFE.6020708@lwfinger.net> (sfid-20080918_154748_651187_3B0B74F8)
Date: Thu, 18 Sep 2008 08:47:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181519.12366.IvDoorn@gmail.com>
In-Reply-To: <200809181519.12366.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:

> Is dev->phy.radio_on set when mac80211 has send an instruction
> to the driver to enable the radio (start() or config() callback)
> or does it represent the key state in the hardware?
> 
> If it is something coming from mac80211, then you do not want
> to send a SOFT_BLOCKED event since that will cause all other radios
> to be switched off simply because the b43 interface has not been
> enabled.
> 
> Off course when it represents the key state in the hardware then the
> code would be fine...

The state comes from mac80211 and is set in the config() callback.

What state should be sent at the point when the hardware block is
removed? It seems to me that forcing an UNBLOCKED state gives the
wrong result. Perhaps RFKILL does need to have 4 states so that an
RFKILL_STATE_HW_UNBLOCKED state can be transmitted.

Larry
