Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51435 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761892Ab3EBTuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 15:50:37 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r42Joai6030494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 2 May 2013 12:50:36 -0700
Message-ID: <5182C38B.7060107@candelatech.com> (sfid-20130502_215043_578677_76592D19)
Date: Thu, 02 May 2013 12:50:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211:  3.9.0+:  Invalid WDS/flush state and non-connecting station.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel is hacked 3.9.0+

I've been seeing this problem for a while (and posted about it previously).  The problem
is that a station appears to associate fine, but never actually 'connects'.  This problem
is not easy to reproduce...

I added printouts in the connect logic to help debug this..for instance, here is an
interface that worked:


May  2 12:03:37 localhost kernel: [88122.116646] wiphy0: start_sw_scan: running-other-vifs: 1  running-station-vifs: 21, associated-stations: 20 scanning 
current channel: 2437 MHz
May  2 12:03:37 localhost kernel: [88122.149736] wiphy0: start_sw_scan: running-other-vifs: 2  running-station-vifs: 42, associated-stations: 40 scanning 
current channel: 2437 MHz
May  2 12:03:38 localhost kernel: [88122.218702] sta17: authenticate with 80:01:02:03:04:05
May  2 12:03:38 localhost kernel: [88122.246420] sta17: send auth to 80:01:02:03:04:05 (try 1/3)
May  2 12:03:38 localhost kernel: [88122.315220] sta17: authenticated
May  2 12:03:38 localhost kernel: [88122.329509] sta17: associate with 80:01:02:03:04:05 (try 1/3)
May  2 12:03:38 localhost kernel: [88122.350295] sta17: RX AssocResp from 80:01:02:03:04:05 (capab=0x401 status=0 aid=21)
May  2 12:03:38 localhost kernel: [88122.364322] IPv6: ADDRCONF(NETDEV_CHANGE): sta17: link becomes ready
May  2 12:03:38 localhost kernel: [88122.376190] sta17: associated
May  2 12:03:38 localhost kernel: [88122.388795] nl80211_send_connect_result, dev: sta17  status: 0
May  2 12:03:38 localhost kernel: [88122.400701] nl80211_send_connect_result, dev: sta17  sending msg...

Here is the stuck one (sta4).  What may be of interest is that the Invalid WDS/flush state shows up in
these logs.  Any idea if this could somehow cause the 'connect' logic to not be
called?

May  2 12:36:37 localhost kernel: [90101.873677] sta4: authenticated
May  2 12:36:37 localhost kernel: [90101.891233] sta4: associate with 80:01:02:03:04:05 (try 1/3)
May  2 12:36:37 localhost kernel: [90101.908620] sta4: RX AssocResp from 80:01:02:03:04:05 (capab=0x401 status=0 aid=19)
May  2 12:36:37 localhost kernel: [90101.922494] IPv6: ADDRCONF(NETDEV_CHANGE): sta4: link becomes ready
May  2 12:36:37 localhost kernel: [90101.935228] sta4: associated
May  2 12:36:42 localhost ntpd[1243]: Listen normally on 935 sta4 fe80::2ab:cdff:feef:105 UDP 123
May  2 12:37:50 localhost kernel: [90174.724370] sta4: Invalid WDS/flush state, type: 2  WDS: 5  flushed: 1
May  2 12:37:51 localhost ntpd[1243]: Deleting interface #935 sta4, fe80::2ab:cdff:feef:105#123, interface stats: received=0, sent=0, dropped=0, active_time=69 secs
May  2 12:37:55 localhost kernel: [90179.828649] IPv6: ADDRCONF(NETDEV_UP): sta4: link is not ready
May  2 12:37:55 localhost kernel: [90179.844669] wiphy0: start_sw_scan: running-other-vifs: 1  running-station-vifs: 21, associated-stations: 20 scanning 
current channel: 2437 MHz
May  2 12:37:55 localhost kernel: [90179.870926] wiphy0: start_sw_scan: running-other-vifs: 2  running-station-vifs: 42, associated-stations: 40 scanning 
current channel: 2437 MHz
May  2 12:37:55 localhost kernel: [90180.012706] IPv6: ADDRCONF(NETDEV_UP): sta4: link is not ready
May  2 12:37:55 localhost kernel: [90180.098460] sta4: authenticate with 80:01:02:03:04:05
May  2 12:37:55 localhost kernel: [90180.116506] sta4: send auth to 80:01:02:03:04:05 (try 1/3)
May  2 12:37:55 localhost kernel: [90180.144183] sta4: authenticated
May  2 12:37:55 localhost kernel: [90180.155081] sta4: associate with 80:01:02:03:04:05 (try 1/3)
May  2 12:37:55 localhost kernel: [90180.171836] sta4: RX AssocResp from 80:01:02:03:04:05 (capab=0x401 status=0 aid=19)
May  2 12:37:56 localhost kernel: [90180.192507] IPv6: ADDRCONF(NETDEV_CHANGE): sta4: link becomes ready
May  2 12:37:56 localhost kernel: [90180.196250] sta4: associated
May  2 12:38:00 localhost ntpd[1243]: Listen normally on 936 sta4 fe80::2ab:cdff:feef:105 UDP 123
May  2 12:38:38 localhost kernel: [90222.695314] sta4: Invalid WDS/flush state, type: 2  WDS: 5  flushed: 1
May  2 12:38:38 localhost kernel: [90222.728069] IPv6: ADDRCONF(NETDEV_UP): sta4: link is not ready
May  2 12:38:38 localhost kernel: [90222.746386] wiphy0: start_sw_scan: running-other-vifs: 1  running-station-vifs: 21, associated-stations: 20 scanning 
current channel: 2437 MHz
May  2 12:38:38 localhost kernel: [90222.772198] wiphy0: start_sw_scan: running-other-vifs: 2  running-station-vifs: 42, associated-stations: 40 scanning 
current channel: 2437 MHz
May  2 12:38:38 localhost kernel: [90222.862226] sta4: authenticate with 80:01:02:03:04:05
May  2 12:38:38 localhost kernel: [90222.880675] sta4: send auth to 80:01:02:03:04:05 (try 1/3)
May  2 12:38:38 localhost kernel: [90222.898643] sta4: deauthenticating from 80:01:02:03:04:05 by local choice (reason=3)
May  2 12:38:38 localhost kernel: [90222.943259] sta4: authenticate with 80:01:02:03:04:05
May  2 12:38:38 localhost kernel: [90222.956498] sta4: send auth to 80:01:02:03:04:05 (try 1/3)
May  2 12:38:38 localhost kernel: [90222.994180] sta4: authenticated
May  2 12:38:38 localhost kernel: [90223.004165] sta4: associate with 80:01:02:03:04:05 (try 1/3)
May  2 12:38:38 localhost kernel: [90223.022441] sta4: RX AssocResp from 80:01:02:03:04:05 (capab=0x401 status=0 aid=19)
May  2 12:38:38 localhost kernel: [90223.041723] IPv6: ADDRCONF(NETDEV_CHANGE): sta4: link becomes ready
May  2 12:38:38 localhost kernel: [90223.060054] sta4: associated
May  2 12:38:39 localhost ntpd[1243]: Deleting interface #936 sta4, fe80::2ab:cdff:feef:105#123, interface stats: received=0, sent=0, dropped=0, active_time=39 secs
May  2 12:38:43 localhost ntpd[1243]: Listen normally on 937 sta4 fe80::2ab:cdff:feef:105 UDP 123


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

