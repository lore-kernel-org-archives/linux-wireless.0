Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:38331 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3HFI7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:59:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 06 Aug 2013 10:52:45 +0200
From: Michael Braun <michael.braun@fem.tu-ilmenau.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: projekt-wlan@fem.tu-ilmenau.de
Subject: ath9k AR9380 packets take long to be sent
Reply-To: projekt-wlan@fem.tu-ilmenau.de
Message-ID: <e86f61ba4c0540d1d22be989362cbeb1@fami-braun.de> (sfid-20130806_105923_135795_5ABF1AAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've upgraded my OpenWRT based AP firmware from kernel 3.8 to kernel 
3.10.5 with compat-wireless 2013-06-27.
Since then I started to notice that some packets take very long to be 
actually sent from AP to STA.

Setting:
The AP serves multiple BSSID which each have one of OPEN/WPA-PSK/WPA-EAP 
configured. In the WPA-BSSIDs, stations get split into VLANs and the 
VLAN interfaces get bridged into a VPN tap device.
During this test, there were two stations connected to this AP and two 
APs served the ESSID locally on different frequencies, although the STA 
did not roam. 802.11n was disabled for this test, although the problem 
seem to be present with 802.11n too.

Observation:
The client sends a SYN. This is immediately forwarded to the destination 
by the AP and a SYN ACK can be seen on the wifi interface on the AP.
Then the client sends another SYN to the same destination. This is also 
immediately forwarded and ACKed by the server and the SYN ACK is seen on 
the wifi interface on the AP. Now the STA receives both SYN ACKs. Now 
the server resends the second ACK which is received by the STA 
immediately.

Expected result:
The client receives the first SYN ACK in a timely manner so that neither 
the STA nor the Server need to resend.

Output:
tcpdump on the AP wifi vlan interface:

10:30:39.068205 4c:0b:3a:84:06:73 > 00:1b:0d:62:b0:00, ethertype IPv4 
(0x0800), length 74: 141.24.44.59.57314 > 141.24.52.243.80: Flags [S], 
seq 365111110, win 29200, options [mss 1460,sackOK,TS val 8811670 ecr 
0,nop,wscale 6], length 0
10:30:39.069654 00:1b:0d:62:b0:00 > 4c:0b:3a:84:06:73, ethertype IPv4 
(0x0800), length 74: 141.24.52.243.80 > 141.24.44.59.57314: Flags [S.], 
seq 2849317894, ack 365111111, win 14480, options [mss 1409,sackOK,TS 
val 20154381 ecr 8811670,nop,wscale 2], length 0
10:30:39.148863 4c:0b:3a:84:06:73 > 00:1b:0d:62:b0:00, ethertype IPv4 
(0x0800), length 74: 141.24.44.59.57315 > 141.24.52.243.80: Flags [S], 
seq 614845630, win 29200, options [mss 1460,sackOK,TS val 8811678 ecr 
0,nop,wscale 6], length 0
10:30:39.150213 00:1b:0d:62:b0:00 > 4c:0b:3a:84:06:73, ethertype IPv4 
(0x0800), length 74: 141.24.52.243.80 > 141.24.44.59.57315: Flags [S.], 
seq 1428894719, ack 614845631, win 14480, options [mss 1409,sackOK,TS 
val 20154401 ecr 8811678,nop,wscale 2], length 0
10:30:40.666887 00:1b:0d:62:b0:00 > 4c:0b:3a:84:06:73, ethertype IPv4 
(0x0800), length 74: 141.24.52.243.80 > 141.24.44.59.57315: Flags [S.], 
seq 1428894719, ack 614845631, win 14480, options [mss 1409,sackOK,TS 
val 20154781 ecr 8811695,nop,wscale 2], length 0

wireshark sniffing wifi.
No.     Time               Source                Destination           
Protocol Length Info
   64740 10:30:39.069004000 141.24.44.59          141.24.52.243         
TCP      130    57314 > 80 [SYN] Seq=0 Win=29200 Len=0 MSS=1460 
SACK_PERM=1 TSval=8811670 TSecr=0 WS=64
   64757 10:30:39.149760000 141.24.44.59          141.24.52.243         
TCP      130    57315 > 80 [SYN] Seq=0 Win=29200 Len=0 MSS=1460 
SACK_PERM=1 TSval=8811678 TSecr=0 WS=64
   64780 10:30:39.280128000 141.24.52.243         141.24.44.59          
TCP      130    80 > 57314 [SYN, ACK] Seq=0 Ack=1 Win=14480 Len=0 
MSS=1409 SACK_PERM=1 TSval=20154381 TSecr=8811670 WS=4
   64781 10:30:39.280636000 141.24.52.243         141.24.44.59          
TCP      130    80 > 57315 [SYN, ACK] Seq=0 Ack=1 Win=14480 Len=0 
MSS=1409 SACK_PERM=1 TSval=20154401 TSecr=8811678 WS=4
   65083 10:30:40.668228000 141.24.52.243         141.24.44.59          
TCP      130    [TCP Retransmission] 80 > 57315 [SYN, ACK] Seq=0 Ack=1 
Win=14480 Len=0 MSS=1409 SACK_PERM=1 TSval=20154781 TSecr=8811695 WS=4

Does anybody have a clue?

Regards,
  M. Braun
