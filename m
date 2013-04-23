Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51367 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab3DWTMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 15:12:52 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r3NJCpgZ005893
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2013 12:12:51 -0700
Message-ID: <5176DD33.9000100@candelatech.com> (sfid-20130423_233115_840840_D02CAECE)
Date: Tue, 23 Apr 2013 12:12:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on ieee80211_tx_status
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It appears that ieee80211_tx_status also scales poorly
when using large numbers of virtual stations connected
to a single AP, due to for_each_sta_info(local, hdr->addr1, sta, tmp)...

I'm going to try using the vif-hashing to make this faster,
but first a question:

Since it matches on MAC addresses, should it
just return at the bottom of the loop since it has
found a match, and MACs are supposed to be unique?

	for_each_sta_info(local, hdr->addr1, sta, tmp) {
		/* skip wrong virtual interface */
		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
			continue;
...


If so, that would be a good improvement since the hash can easily
be turned into a linear search even in AP mode (without all of
my virtual-station scenarios)...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

