Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:46263 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbXKSEIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 23:08:35 -0500
Date: Sun, 18 Nov 2007 20:08:20 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Li YanBo <dreamfly281@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	linux-wireless@vger.kernel.org,
	Jose Ignacio Naranjo Hernandez
	<joseignacio.naranjo@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: Suspend/Resume support
Message-ID: <20071119040820.GK8672@jm.kir.nu> (sfid-20071119_040845_239386_E29A7119)
References: <1195087905.3814.11.camel@mercury> <1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com> <1195171869.8147.79.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195171869.8147.79.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2007 at 01:11:09AM +0100, Johannes Berg wrote:

> On the other hand, if you've suspended for a longer period of time, your
> AP will have kicked you off for not responding. This means you need to
> associate again (not even reassociate [1]) if the AP you were associated
> to is even still around.

> [1] the IEEE 802.11 specs define "reassociation" but that requires the
> AP keeping state about you which typically they won't do long

I would use reassociation whenever trying to get back to the same ESS
(when SSID does not change) and the previous BSSID is known. There
cannot be any requirement on the non-AP STA to somehow magically figure
out whether the APs have or have not state from the previous
association.

> I guess the way to handle it would be to send a probe request to the AP
> we're associated with first to see if it's still in range. If it is, we
> need to determine whether we were suspended long enough for it to kick
> us off. It might be possible to do this by sending a null function frame
> to the AP and see if it replies with a deauth notification, I think it
> should if we're not associated [3]. But then again I'm not sure whether
> we should rely on this.

This is perfectly valid way of validating whether the STA is still
associated (see rules on Class 2 and 3 frames in auth/assoc state in
Clause 5.5). In addition, there is no need for the probe request before
sending nullfunc data frame. If the nullfunc data frame is acknowledged,
the AP is still in range. If deauth or disassoc frame is received from
the AP, the association was not valid anymore. This should trigger
re-association.

> Another option would be to send it a reassociate
> request, it should simply respond with an OK, otherwise it sends a
> disassociate so we automatically restart the state machine and send
> appropriate notifications to userspace.

Reassociation will fail unless the STA in in authenticated state, i.e.,
this will need to start with 802.11 authentication. Though, if the
nullfunc data test is used, there is no need for this and it should be
possible to avoid the full cost of running whatever authentication
methods are required in the network (e.g., EAP).

-- 
Jouni Malinen                                            PGP id EFC895FA
