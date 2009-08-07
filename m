Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.highlandsun.com ([70.87.222.79]:58575 "EHLO
	mail.highlandsun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbZHGD4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 23:56:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.highlandsun.com (Postfix) with ESMTP id 88D7983EFA
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2009 23:56:23 -0400 (EDT)
Message-ID: <4A7BA5E6.7050808@highlandsun.com>
Date: Thu, 06 Aug 2009 20:56:22 -0700
From: Howard Chu <hyc@highlandsun.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k ath_ani_calibrate
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was seeing this function showing up consistently while running powertop. It 
seems that ANI is always enabled by default, and I didn't see any ioctl or 
config option to disable it. It sets a timer to wakeup every 100ms and do 
whatever calibration it's trying to do. I changed the ANI_POLLINTERVAL to 
1000ms and recompiled, and haven't noticed any ill effect yet. Is there any 
reason why this calibration needs to happen 10 times a second? Will it still 
be useful if it were toned down, to 250ms, or 500ms? (Note - because the 
driver takes the minimum of the active calibration intervals, and 
ANI_POLLINTERVAL is the smallest, it is always the one that wins...)

With this changed to 1sec, I still see the ath9k driver waking up 10-12 
times/second but I presume that's in response to random packets from the AP.
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
