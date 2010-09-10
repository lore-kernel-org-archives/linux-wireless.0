Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41354 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0IJWnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 18:43:08 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o8AMh7Od022460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 15:43:07 -0700
Message-ID: <4C8AB47B.7090801@candelatech.com>
Date: Fri, 10 Sep 2010 15:43:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: question on scanning and multiple VIFs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm now debugging virtual stations with WPA.  It's not working, and at
least part of the problem appears to be that scanning on one STA
causes others to think they are going offchannel, though in reality,
I'm not sure the channel is actually being changed.

I think the proper action would be to have scan happen only
on the single channel if any of the VIFS are associated.
In this case, nothing would go offchannel and a secondary
STA wouldn't overly conflict with the others.

Any ideas on a proper way to go about doing this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

