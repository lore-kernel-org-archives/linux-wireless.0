Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from unixcube.org ([174.136.111.132]:40500 "EHLO unixcube.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbbBPHmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 02:42:16 -0500
Message-ID: <54E19DD6.9050704@unixcube.org> (sfid-20150216_084220_363286_710139E7)
Date: Sun, 15 Feb 2015 23:35:50 -0800
From: Alan Fisher <acf@unixcube.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	linville@tuxdriver.com
Subject: PROBLEM: rtlwifi drops most IPv6 packets
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I have a machine with a Realtek RTL8188 wireless card. This card is 
handled by the rtl8192 driver. The driver in kernel 3.16.0-4 causes most 
sent ARP packets to be dropped. ARP packets appear to get through with 
the driver in kernel 3.19, but IPv6 packets suffer instead. I have 
reproduced this when connected to multiple access points.

I think I have traced this issue to some code in the rtlwifi driver that 
does special handling on "special" packets. The function 
rtl_is_special_data() in base.c determines whether a packet is 
considered special. In the 3.16 kernel, this includes ARP packets, 
wireless encryption packets, and DHCP/BOOTP packets. IPv6 appears to 
have been added to this list as of kernel 3.19.

It seems the idea is that certain important packets should be 
transmitted at the lowest possible 802.11 rate. The 
rtl_is_special_data() function is used to determine which packets to 
handle this way. Not treating any packets as special, by adding a 
"return false;" at the beginning of rtl_is_special_data(), seems to fix 
the problems with lost packets with both kernels.

I would guess that some good reason exists for this special handling, 
but I can't determine what it is. I couldn't find anything similar in 
iwlwifi. Either way, it seems like a bug to send all IPv6 traffic at the 
lowest possible rate, successful or not.

-Alan
