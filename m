Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:59947 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757470AbYLLE2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 23:28:23 -0500
Message-ID: <4941E863.50703@lwfinger.net> (sfid-20081212_052846_040732_869E9D61)
Date: Thu, 11 Dec 2008 22:28:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
Subject: Re: [RFC] b43: rework rfkill code
References: <20081210150935.GA10927@srcf.ucam.org>
In-Reply-To: <20081210150935.GA10927@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Garrett wrote:
> I've reworked the rfkill code in b43. This ought to be more consistent 
> with the other drivers and it seems to work on the machines I've tested 
> it on here, but it'd be good to get some feedback.
> 
> Firstly, I've replaced the polled input device. It's just some delayed 
> work now. It polls the hardware every second to determine whether the 
> radio has been hardware killed or not. If it has, it sets the rfkill 
> state to HARD_BLOCKED. If the radio is enabled and the previous state 
> was HARD_BLOCKED, it resets the state to UNBLOCKED. If the radio is 
> enabled and the previous state was SOFT_BLOCKED, it leaves the state as 
> is.
> 
> I also removed some of the complexity from the rfkill toggle function, 
> since the rfkill core will handle the case of the user requesting a 
> change from HARD_BLOCKED without the driver needing to care.
> 
> The final change is that I removed the code for changing the wireless 
> state in response to the txpower configuration in mac80211. Right now, I 
> can't see any way for this to work correctly - if the user disables the 
> radio via rfkill, mac80211 doesn't flag the radio as disabled. As a 
> result, the next time the configuration callback is called, b43 
> reenables the radio again, even though the user has explicitly disabled 
> it. I don't think any of the other drivers handle this case, so I'm not 
> really sure what the best way to handle this in future is. The current 
> situation certainly seems broken.
> 
> How does this look to people?

All this discussion about hard vs soft rfkill makes my head hurt and I have
stopped reading those posts.

Correction to my earlier post. If the system is booted with the RF switch off,
the LED is on, whereas it should be off. The original code works correctly.

Larry




