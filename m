Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52348 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966288Ab2JZUDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 16:03:30 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9QK3T5b015475
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2012 13:03:29 -0700
Message-ID: <508AEC91.5090901@candelatech.com> (sfid-20121026_220334_505306_386A2A42)
Date: Fri, 26 Oct 2012 13:03:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wireless testing working with ath9k?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a few small patches...and wireless-testing is failing to
register it's hardware:

	/* Register with mac80211 */
	error = ieee80211_register_hw(hw);
	if (error) {
		ath_err(common, "Unable to register hw: %i\n", error);
		goto error_register;
	}

[  764.193028] ath: country maps to regdmn code: 0x3a
[  764.193042] ath: Country alpha2 being used: US
[  764.193052] ath: Regpair used: 0x3a
[  764.195415] ath: phy0: Unable to register hw: -22
[  764.200949] ath9k 0000:03:00.0: Failed to initialize device
[  764.206811] ath9k: probe of 0000:03:00.0 failed with error -22

Just wondering if this is a known problem before start digging into it...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

