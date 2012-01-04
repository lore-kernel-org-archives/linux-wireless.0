Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv10.sysproserver.de ([78.138.89.124]:33849 "EHLO
	srv10.sysproserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2ADRYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 12:24:05 -0500
Received: from [10.63.52.37] (i5E86D120.versanet.de [94.134.209.32])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv10.sysproserver.de (Postfix) with ESMTPSA id C38FC61C177
	for <linux-wireless@vger.kernel.org>; Wed,  4 Jan 2012 18:24:08 +0100 (CET)
Message-ID: <1325697866.18811.19.camel@n10051> (sfid-20120104_182410_129025_1B77447D)
Subject: minstrel falls down to 1Mbit rate
From: Andreas Braeu <ab@andi95.de>
To: linux-wireless@vger.kernel.org
Date: Wed, 04 Jan 2012 18:24:26 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

we try to compile an openwrt image for the linksys wrt54gl router. these
routers will build a mesh network and use ad-hoc-mode and olsr.

from time to time the routers will fall down to the one and only rate we
set as mcast rate), as 
"cat /sys/kernel/debug/ieee80211/phy0/netdev
\:wlan0/stations/*/rc_stats" 
tells us.

the result will look like this (in our environment mcast rate is set to
1):

rate     throughput  ewma prob   this prob  this succ/attempt   success
attempts
TtP  1         0.1       15.6        0.0          0(  0)         12
27

the only ways to correct this is to reboot the router or restart the
wifi components.

the period of time this occurs, varies from 2 minutes to some days.

Are there any suggestions how to avoid this issues?

Best,

Andreas 

