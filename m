Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57261 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbXIUPyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 11:54:10 -0400
Message-ID: <46F3E930.1050007@lwfinger.net>
Date: Fri, 21 Sep 2007 10:54:24 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Change the hardware radio enable logic and  cleanup code
References: <46f319ef.8UBDQAjFjjfCblr5%Larry.Finger@lwfinger.net> <200709211522.01273.mb@bu3sch.de>
In-Reply-To: <200709211522.01273.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> Just that you are aware of it:
> This is a racy access to the radio_hw_enable variable, as we don't take
> the mutex here (we can't and we don't want). But it's OK, since nobody
> cares if the LED is racing for a second and displays the wrong state
> for a second.
> Same goes for the phy->radio_on access.
> 
> The patch is ACKed by me.
> 

Thanks for the heads-up on the raciness of the access. I'm still learning what can and cannot be done.

Larry

