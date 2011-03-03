Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33610 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab1CCTaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 14:30:14 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p23JUBS5010621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 3 Mar 2011 11:30:12 -0800
Message-ID: <4D6FEC43.4040200@candelatech.com>
Date: Thu, 03 Mar 2011 11:30:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Ath5k has trouble receiving pkts with multiple vifs on multiple APs.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We recently hit a problem with ath5k VIFs:

32 station VIFS
3 APs (on other systems)
All APs have same password and SSID.

Configure wpa_supplicant to force the 32 VIFS to associate with
specific APs with the 'bssid' keyword.

The association seems to work fine, but ARPs are only received by
the VIFs on _one_ of the APs.  The others will not work until you
make the STA promisc (by sniffing it, for example).

We cannot reproduce the problem on ath9k, so it seems an
ath5k driver bug.

I'm assuming that there is some issue where the NIC is filtering
based on bssid or similar.  I'm going to go dig through the code,
but if anyone has any suggestions, they are welcome.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

