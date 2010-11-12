Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50422 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab0KLXXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 18:23:30 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oACNNUCE014804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 15:23:30 -0800
Message-ID: <4CDDCC72.6070006@candelatech.com>
Date: Fri, 12 Nov 2010 15:23:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Scanning improvements for multiple VIFS.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I am using lots of virtual stations, each of them will attempt
to scan when started.  Most of them get EBUSY
until finally everyone is associated.  This can take a long time.

I was considering trying something a bit different.

In nl80211_trigger_scan, if rdev->scan_req is != NULL,
instead of returning EBUSY, what if we set a flag in
the VIF that said "I want scan results too."

Then, when whatever is scanning is finished, it would send
scan results to all interested vifs.

Does that sound like something that could work?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

