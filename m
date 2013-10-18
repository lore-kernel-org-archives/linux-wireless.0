Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49124 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab3JRMaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VX9Bq-0004xP-QF
	for linux-wireless@vger.kernel.org; Fri, 18 Oct 2013 14:30:03 +0200
Received: from 178.90.155.11.megaline.telecom.kz ([178.90.155.11.megaline.telecom.kz])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 14:30:02 +0200
Received: from dev.wmark by 178.90.155.11.megaline.telecom.kz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 14:30:02 +0200
To: linux-wireless@vger.kernel.org
From: Mark Wu <dev.wmark@gmail.com>
Subject: Bug with monitor mode on Intel 7260 AC
Date: Fri, 18 Oct 2013 12:23:00 +0000 (UTC)
Message-ID: <loom.20131018T142140-263@post.gmane.org> (sfid-20131018_143009_594538_6B9B52EE)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using Intel 7260 AC with this driver: 
https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.11-rc3/ , 
with  the "iwlwifi-7260-7.ucode" firmware. I'm using it in monitor mode to 
capture 802.11ac packets on channel 36. It works well, I can capture VHT 
packets without problems, but only as long as the number of packets per second 
being captured is relatively low, e.g. 10 or 20 packets per second. As soon as 
the traffic gets heavier, e.g. 100 packets per second, the card stops 
capturing *all* VHT packets within a second from the moment the traffic volume 
got higher. The interesting part is that it doesn't stop capturing altogether: 
it keeps on capturing 802.11n HT and legacy 802.11a packets, it just 
completely ignores  802.11ac VHT packets. Is there any way to fix this problem 
and ensure stable VHT capture? 

