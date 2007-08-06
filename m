Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62785 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762937AbXHFV0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 17:26:10 -0400
Message-ID: <46B791EF.7000105@lwfinger.net>
Date: Mon, 06 Aug 2007 16:26:07 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] bcm43xx-mac80211: Add TX power set file to debugfs
References: <46b78ac2.M4X/XQ9LXYHUe/aO%Larry.Finger@lwfinger.net> <200708062307.40590.mb@bu3sch.de>
In-Reply-To: <200708062307.40590.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> No, why do you poke with this at all.
> This completely breaks power adjustment from mac80211.
> Simply don't touch bcm43xx_dev_config :)
> 

The problem is that mac80211 never seems to do any power adjustment. The funny 0x1b value for power 
level that I wondered about earlier is coming from a value of 27 dBm that is set in 
net/mac80211/regdomain.c, and conf->power_level doesn't get any information from anywhere else that 
I see.

Do you know how to get mac80211 to change what it is sending to us?

Larry

