Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38290 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbYIFSwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:52:55 -0400
Message-ID: <48C2D185.4000003@lwfinger.net> (sfid-20080906_205259_160788_7DE05075)
Date: Sat, 06 Sep 2008 13:52:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net> <200809062041.06035.mb@bu3sch.de>
In-Reply-To: <200809062041.06035.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 06 September 2008 20:34:02 Larry Finger wrote:
>> A coding error present since b43legacy was incorporated into the
>> kernel has prevented the driver from using the rate-setting mechanism
>> of mac80211. The driver has been forced to remain at a 1 Mb/s rate.
> 
> Does version3 firmware have a different bitlayout for the status?

It seems so. I found this because I was not getting any acks back to 
net/mac80211/rc80211_pid_algo.c. I then reviewed the V3 specs, found 
that bit 0, not bit 1, contained the ack. Test prints confirmed that 
result. With this patch, both my BCM4306/2 and BCM4303 reach the 
maximum rate. With the current code, 54 Mb/s is not as fast as 36 
Mb/s, but at least the algorithm is working.

Larry

