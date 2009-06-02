Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:44622 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZFBU7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:59:49 -0400
Message-ID: <4A2592C5.10803@lwfinger.net>
Date: Tue, 02 Jun 2009 15:59:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
References: <20090602111027.460530075@sipsolutions.net>	 <200906021641.11019.mb@bu3sch.de> <1243973079.6461.3.camel@johannes.local>	 <200906022208.46288.mb@bu3sch.de> <1243973487.7176.1.camel@johannes.local>
In-Reply-To: <1243973487.7176.1.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Me neither, so I really need somebody to test this... I suspect there
> will be problems when the device is set down because of rfkill, and then
> we can no longer poll the rfkill hw state? But that might have been a
> problem before too, since if my suspicion is right we could never do:
>  * hw rfkill
>  * set if down
>  * hw un-rfkill
>  * set if up
> 
> and have it show the events to userspace as expected, or something...

I'm trying to test, but I get an oops on boot. I'm still tracking it
and I lose the reason off the top of the screen, but the trace is:

queue_work + 0x1a
schedule_work + 0x16
rfkill_resume_polling + 0x23
wiphy_rfkill_start_polling + 0x35 (Line 452 of net/wireless/core.c)
b43_op_start + 0x172  (Line 4336 of drivers/net/wireless/b43/main.c)

The offsets are appropriate for wireless-testing and x86_64. The line
in b43_op_start is the one just before the mutex_unlock.

Is it possible that we reached this point without hw->wiphy being set?

Larry

