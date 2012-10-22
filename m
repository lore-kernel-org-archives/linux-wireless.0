Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33935 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2JVUUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:20:09 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9MKK85N018285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 13:20:08 -0700
Message-ID: <5085AA78.1080809@candelatech.com> (sfid-20121022_222014_307124_26665BD5)
Date: Mon, 22 Oct 2012 13:20:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Cannot bring up second VAP on recent kernels?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone successfully using more than one virtual AP on
3.3 or higher kernels?  It works fine for me on 3.0.32,
but my 3.3.8 and 3.5.7 kernels (and a few similar ones)
all fail with errors like this below:

Hardware is ath9k 3x3 9380 NIC.

[root@lec2010-ath9k-1 wifi]# cat hostapd_log_vap1.txt
1350936424.890962: random: Trying to read entropy from /dev/random
1350936424.891172: Configuration file: wifi/hostapd_vap1.conf
1350936424.892827: ctrl_interface_group=0
1350936424.895084: nl80211: interface vap1 in phy wiphy0
1350936424.895175: rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
1350936424.895456: nl80211: Using driver-based off-channel TX
1350936424.895483: nl80211: TDLS supported
1350936424.895500: nl80211: TDLS external setup
1350936424.895612: nl80211: Add own interface ifindex 26
1350936424.896560: nl80211: Set mode ifindex 26 iftype 3 (AP)
1350936424.896919: nl80211: Setup AP - device_ap_sme=0 use_monitor=0
1350936424.896992: nl80211: Subscribe to mgmt frames with AP handle 0x81e8910
1350936424.897018: nl80211: Register frame type=0xb0 nl_handle=0x81e8910
1350936424.897036: nl80211: Register frame match - hexdump(len=0): [NULL]
1350936424.897107: nl80211: Register frame type=0x0 nl_handle=0x81e8910
1350936424.897127: nl80211: Register frame match - hexdump(len=0): [NULL]
1350936424.897174: nl80211: Register frame type=0x20 nl_handle=0x81e8910
1350936424.897195: nl80211: Register frame match - hexdump(len=0): [NULL]
1350936424.897240: nl80211: Register frame type=0xa0 nl_handle=0x81e8910
1350936424.897261: nl80211: Register frame match - hexdump(len=0): [NULL]
1350936424.897306: nl80211: Register frame type=0xc0 nl_handle=0x81e8910
1350936424.897326: nl80211: Register frame match - hexdump(len=0): [NULL]
1350936424.897372: nl80211: Register frame type=0xd0 nl_handle=0x81e8910
1350936424.897392: nl80211: Register frame match - hexdump(len=0): [NULL]
1350936424.897438: nl80211: Register frame type=0x40 nl_handle=0x81e8910
1350936424.897458: nl80211: Register frame match - hexdump(len=0): [NULL]
1350936424.897681: nl80211: Register beacons command failed: ret=-16 (Device or resource busy)
1350936424.897830: nl80211: Failed to set interface vap1 into AP mode
1350936424.901888: netlink: Operstate: linkmode=0, operstate=6
1350936424.901996: nl80211: Set mode ifindex 26 iftype 2 (STATION)
1350936424.902197: nl80211 driver initialization failed.


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

