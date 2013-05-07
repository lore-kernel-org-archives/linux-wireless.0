Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39117 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3EGRCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 13:02:24 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r47H2Nls009105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 7 May 2013 10:02:23 -0700
Message-ID: <5189339E.7090502@candelatech.com> (sfid-20130507_190242_020907_DD70AF69)
Date: Tue, 07 May 2013 10:02:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Cannot set frequency on phy device in 3.9.0+ ??
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems like this used to work.  NIC is ath9k_htc driver, configured with one
VAP and one station.  Both are admin down, but still get EBUSY when trying
to set the frequency.  Seems like this used to work (on ath9k driver, at least).

[root@lec2010-ath9k-1 lanforge]# ifconfig wlan1
wlan1     Link encap:Ethernet  HWaddr A0:F3:C1:24:61:2B
           inet addr:11.97.2.5  Bcast:11.97.255.255  Mask:255.255.0.0
           BROADCAST MULTICAST  MTU:1500  Metric:1
           RX packets:761 errors:0 dropped:0 overruns:0 frame:0
           TX packets:402 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:129222 (126.1 KiB)  TX bytes:74364 (72.6 KiB)

[root@lec2010-ath9k-1 lanforge]# ifconfig vap1
vap1      Link encap:Ethernet  HWaddr 00:A0:00:00:00:90
           inet addr:10.99.1.1  Bcast:10.99.255.255  Mask:255.255.0.0
           BROADCAST MULTICAST  MTU:1500  Metric:1
           RX packets:16435018 errors:0 dropped:0 overruns:0 frame:0
           TX packets:9082445 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:2204413501 (2.0 GiB)  TX bytes:1451899217 (1.3 GiB)

[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy1 set freq 2437
command failed: Device or resource busy (-16)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

