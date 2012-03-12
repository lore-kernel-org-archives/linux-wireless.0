Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41209 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab2CLVwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 17:52:50 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q2CLqnIe032213
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 14:52:49 -0700
Message-ID: <4F5E7031.4000401@candelatech.com> (sfid-20120312_225254_930303_F3662791)
Date: Mon, 12 Mar 2012 14:52:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Hacking PCI-ids to allow Atheros NIC into Lenovo laptop.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems we bought a Lenovo laptop that has a BIOS lock where it will only
support certain wifi NICs based on the pci-id.  It came with an Intel
NIC, so at least that ID must work...

One way around this might be to over-write the pci-id of an Atheros NIC
in it's non-volatile storage to make it look like an Intel, at least until
the kernel boots.

Then maybe add some sort of ugly code to force the Atheros driver
to manage this Intel pci-id (and probably disable the same pci-id in
the Intel driver).

Has anyone tried doing anything like this?  Any suggestions for a cleaner
way to go about this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

