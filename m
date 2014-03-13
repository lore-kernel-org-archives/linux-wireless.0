Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57714 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbaCMXpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 19:45:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WOFJ9-000415-My
	for linux-wireless@vger.kernel.org; Fri, 14 Mar 2014 00:45:04 +0100
Received: from 67.211.18.200 ([67.211.18.200])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 00:45:03 +0100
Received: from drew.wurfel by 67.211.18.200 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 00:45:03 +0100
To: linux-wireless@vger.kernel.org
From: Drew Wurfel <drew.wurfel@ncr.com>
Subject: Intel 6235 wireless driver flakiness on Android
Date: Thu, 13 Mar 2014 23:36:53 +0000 (UTC)
Message-ID: <loom.20140314T001708-346@post.gmane.org> (sfid-20140314_004548_050504_42C3107D)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

  I've been tracking down an issue with an Intel 6235 wireless card 
integrated into an Android platform. 

Version Info
--------------
Android Version: Jellybean 4.2.2
Driver Version: Compat v3.10.4-1-0-g31beead
Firmware Version: iwlwifi-6000g2b-6.ucode

What happens is that occasionally (say after 12-24 hours of operation) the 
driver gets into a bad state where it disconnects from whatever access point 
it connects to and fails all requests to it. For example I see the following 
message when a scan is requested

"<4>iwlwifi 0000:01:00.0: Request scan called when driver not ready."

Reseating the driver fixes the problem.

Not that I thought this was related but I've already attempted to disable 
802.11n based on a few suggestions I found when google'ing around. This had 
no affect on the failure.

In addition, this is a combo card but I have never enabled bluetooth.

any guidance is appreciated.
thanks.

