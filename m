Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41311 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbYDCUKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 16:10:23 -0400
Message-ID: <47F539A8.6060105@lwfinger.net> (sfid-20080403_211025_267206_781F3BEC)
Date: Thu, 03 Apr 2008 15:10:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	KURT PETERS <peterskurt@msn.com>
Subject: Re: [PATCH] b43legacy: Partial Fix for Range issue
References: <BAY103-F373BE8D28C2F2A21BC15E0D8F70@phx.gbl> <200804031719.44026.mb@bu3sch.de> <47F5242D.80404@lwfinger.net> <200804032050.38774.mb@bu3sch.de>
In-Reply-To: <200804032050.38774.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> In b43 I set this value to 30.
> I dunno what the real HW upper limit is, so I set it so something
> that's way above the actual value mac80211 will ever try anyway (because
> mac80211 won't try illegal rates, if implemented correctly).
> 

I used 20 (0x14) because 20 dBm is the regulatory maximum for almost 
all regions. In fact, the value of desired_pwr (in Q5.2) that results 
is 37, or 9.25 dBm. My guess is that this value is too low; however, 
changing the initialization value to 30 as it is in b43 did not change 
anything.

Larry


