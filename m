Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:48369 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYIUER3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 00:17:29 -0400
Received: from [76.91.220.157] (helo=[192.168.1.21])
	by lirone.symas.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <hyc@symas.com>)
	id 1KhGO0-0007p5-6J
	for linux-wireless@vger.kernel.org; Sat, 20 Sep 2008 21:17:28 -0700
Message-ID: <48D5CAD0.1080909@symas.com> (sfid-20080921_061734_989343_523BC46A)
Date: Sat, 20 Sep 2008 21:17:20 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This may be related to this other thread
http://marc.info/?l=linux-wireless&m=122187323506092&w=2

With the 2.6.27-rc6 kernel I find that my wireless connection dies after a few 
minutes. Using nm-applet I have to disable wireless and re-enable it before I 
can re-establish a session (using WPA).

I tried pulling the wireless-testing branch and found it behaved strangely as 
well - within about 30 seconds of idle time it would die. But, it would 
usually immediately begin to reconnect (and succeed). My logs were full of 
"ForceXPAon: 0" messages which I found were from ath9_hw_reset(), which were 
all being called from set_channel, during the scan that took place when the 
card was not associated with the AP. It typically occurred every 30-35 seconds.

I also found that if I kept a ping session to my wifi router running, then the 
wireless connection would not die, it would operate normally.

It seems that it all worked fine in 2.6.27-rc4...
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
