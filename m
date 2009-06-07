Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:52560 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbZFGM6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:58:45 -0400
Message-ID: <4A2BB985.4020403@lwfinger.net>
Date: Sun, 07 Jun 2009 07:58:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] b43/legacy: port to cfg80211 rfkill
References: <1244311473.17485.20.camel@johannes.local>
In-Reply-To: <1244311473.17485.20.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This ports the b43/legacy rfkill code to the new API offered
> by cfg80211 and thus removes a lot of useless stuff.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Michael Buesch <mb@bu3sch.de>
> ---
> 
> V1 - Original by Johannes.
> V2 - Modified in testing by Larry.
>      The rfkill polling routine brings the interface back to the initialized
>      state if it is found to be uninitialized. This way the rfkill switch
>      may be interpreted. In addition, the radio LED is not turned on in the
>      initialization routine unless the rfkill switch is on.
> V3 - turn the device off again too
> 
> 
> This is quite heavyweight and can probably be improved by not bringing
> up the PHY, radio, etc. just to poll the bit. We probably don't even
> need firmware, just MMIO accesses, but I can't test anything like that
> and this should work.
> 
> Please don't merge before anyone has tested it at least once though :)

This one works, but so does the lightweight method proposed by
Michael. It saves both time and power. With your permission, I would
like to submit that one as V4 of the RFC/RFT (V2 of the patch).

Larry
