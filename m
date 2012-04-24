Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38913 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab2DXWum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 18:50:42 -0400
Message-ID: <4F972E3F.4020609@candelatech.com> (sfid-20120425_005055_768092_CA5F20E9)
Date: Tue, 24 Apr 2012 15:50:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Strange problem with ath9k and ASUS N66U AP.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying some ath9k virtual clients against an ASUS N66U.

Kernel is 3.3.3+, but we've been seeing weird things since at
least 3.0 kernel with another Asus AP, but haven't looked at
the problem in detail on older kernels yet.

The issue seems to be that the ath9k side thinks all is well,
but the N66U shows it as not authenticated.

If anyone has any ideas on how to go about debugging
this, please let me know.

sta11 is :0C, and is not working properly
sta12 is :0D, and is working fine.

Here is part of the N66U wifi log showing that it
thinks sta11 is not authorized:

00:95:95:00:00:0C  associated
00:95:95:00:00:0D  associated authorized


Here's the supplicant logs:

[root@lanner-i7 wifi]# grep sta12 wpa_supplicant_log_wiphy0.txt
1335305195.312287: sta12: Failed to initiate AP scan
1335305195.313249: sta12: Failed to initiate AP scan
1335305196.317750: sta12: Failed to initiate AP scan
1335305197.318436: sta12: Failed to initiate AP scan
1335305198.320208: sta12: Failed to initiate AP scan
1335305198.860472: sta12: SME: Trying to authenticate with c8:60:00:e8:88:b0 (SSID='n66-2.4g' freq=2462 MHz)
1335305198.866465: sta12: Trying to associate with c8:60:00:e8:88:b0 (SSID='n66-2.4g' freq=2462 MHz)
1335305199.074988: sta12: Associated with c8:60:00:e8:88:b0
1335305199.185713: sta12: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP]
1335305199.185740: sta12: CTRL-EVENT-CONNECTED - Connection to c8:60:00:e8:88:b0 completed (auth) [id=0 id_str=]

[root@lanner-i7 wifi]# grep sta11 wpa_supplicant_log_wiphy0.txt
1335305195.289391: sta11: Failed to initiate AP scan
1335305195.290317: sta11: Failed to initiate AP scan
1335305196.297866: sta11: Failed to initiate AP scan
1335305197.298550: sta11: Failed to initiate AP scan
1335305198.298661: sta11: Failed to initiate AP scan
1335305198.860719: sta11: SME: Trying to authenticate with c8:60:00:e8:88:b0 (SSID='n66-2.4g' freq=2462 MHz)
1335305198.871241: sta11: Trying to associate with c8:60:00:e8:88:b0 (SSID='n66-2.4g' freq=2462 MHz)
1335305199.086967: sta11: Associated with c8:60:00:e8:88:b0
1335305199.191947: sta11: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP]
1335305199.191968: sta11: CTRL-EVENT-CONNECTED - Connection to c8:60:00:e8:88:b0 completed (auth) [id=0 id_str=]
1335305199.266207: sta11: WPA: Key negotiation completed with c8:60:00:e8:88:b0 [PTK=CCMP GTK=TKIP]

Only thing I notice above is that the key negotiation completed after the connection completed,
and appears duplicated???


[root@lanner-i7 wifi]# iwconfig sta11
sta11     IEEE 802.11abgn  ESSID:"n66-2.4g"
           Mode:Managed  Frequency:2.462 GHz  Access Point: C8:60:00:E8:88:B0
           Bit Rate:216.7 Mb/s   Tx-Power=22 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=119/70
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:1  Invalid misc:2364   Missed beacon:0

[root@lanner-i7 wifi]# iwconfig sta12
sta12     IEEE 802.11abgn  ESSID:"n66-2.4g"
           Mode:Managed  Frequency:2.462 GHz  Access Point: C8:60:00:E8:88:B0
           Bit Rate:1 Mb/s   Tx-Power=22 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=10/70
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:51   Missed beacon:0


[root@lanner-i7 wifi]# iw dev sta11 station dump
Station c8:60:00:e8:88:b0 (on sta11)
	inactive time:	25 ms
	rx bytes:	6160759
	rx packets:	58821
	tx bytes:	64751
	tx packets:	194
	tx retries:	357
	tx failed:	1
	signal:  	-20 dBm
	signal avg:	-21 dBm
	tx bitrate:	216.7 MBit/s MCS 23 short GI
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:		no

[root@lanner-i7 wifi]# iw dev sta12 station dump
Station c8:60:00:e8:88:b0 (on sta12)
	inactive time:	12332 ms
	rx bytes:	6182842
	rx packets:	45350
	tx bytes:	11089
	tx packets:	81
	tx retries:	139
	tx failed:	0
	signal:  	-23 dBm
	signal avg:	-22 dBm
	tx bitrate:	1.0 MBit/s
	authorized:	yes
	authenticated:	yes
	preamble:	long
	WMM/WME:	yes
	MFP:		no
	TDLS peer:		no
[root@lanner-i7 wifi]#

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

