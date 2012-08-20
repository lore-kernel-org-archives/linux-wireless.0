Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59426 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2HTUYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 16:24:50 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q7KKOnP2006902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2012 13:24:49 -0700
Message-ID: <50329D11.9030405@candelatech.com> (sfid-20120820_222455_020257_42082CDF)
Date: Mon, 20 Aug 2012 13:24:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Issue with ath9k and tx/rx chainmask:  3x3 doesn't work with mask
 of 0x1.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to test out an attenuator.  For now, I have only a single attenuator,
so I set tx and rx chainmask to 0x1 on both AP and Station machine.

I then connected channel 0 on the two machines together through the
attenuator.

I have two station interfaces on the station machine.  They both
seem to associate OK, but they cannot receive dhcp responses.

It *seems* that broadcast packets may go through fine.

If I force the rate down to 1x1 or 2x2 MIMO (or force disable /n
and just use /a), then it appears to work fine.

Nics are WPEA-127n (AR9380).  Kernel is 3.5.1+ on AP, 3.5.2+ on station
machine.

I can see why forcing it down to 1x1 might work around some issue,
but I find it funny that 2x2 works while 3x3 does not.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

