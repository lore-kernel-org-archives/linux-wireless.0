Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47643 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0GZTtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 15:49:11 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o6QJnAir023061
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 12:49:10 -0700
Message-ID: <4C4DE6B5.5080307@candelatech.com>
Date: Mon, 26 Jul 2010 12:49:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k:  /proc/net/wireless always shows status of 0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is with today's wireless-testing (with no extra hacks)

[root@a230-ath9k ~]# cat /proc/net/wireless
Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
  face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
  wlan0: 0000   67.  -43.  -256        0      0      0      0      0        0

The interface is running WPA and is passing traffic, so I'd expect some sort of
useful status.  Is this a known issue?

[root@a230-ath9k ~]# iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:"candela-n"
           Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:D1:C6:D2:54
           Bit Rate=117 Mb/s   Tx-Power=27 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=66/70  Signal level=-44 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

