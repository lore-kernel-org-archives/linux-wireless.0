Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:35765 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbZFGMzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:55:24 -0400
Message-ID: <4A2BB8BC.4000809@lwfinger.net>
Date: Sun, 07 Jun 2009 07:55:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net> <200906052101.47168.mb@bu3sch.de> <4A298C37.9030503@lwfinger.net> <200906062000.31602.mb@bu3sch.de>
In-Reply-To: <200906062000.31602.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Larry, wouldn't it work to do
> 
> mutex_lock();
> ...
> if (!initialized) {
> 	ssb_bus_powerup();
> 	ssb_device_enable();
> 	poll_the_bit;
> 	ssb_device_disable();
> 	ssb_bus_may_powerdown();
> }
> ...
> mutex_unlock();
> 
> That would be a _lot_ less heavyweight (at the order of 300 milliseconds less).
> And from a power point of view, the PHY and Radio would stay turned off.

Thanks for the suggestion. The method works well and should be a part
of the final patch.

Larry
