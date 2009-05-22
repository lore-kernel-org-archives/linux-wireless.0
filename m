Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:39547 "EHLO
	spunkymail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753320AbZEVLZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 07:25:13 -0400
Message-ID: <4A168B8A.4070609@hiramoto.org>
Date: Fri, 22 May 2009 13:24:58 +0200
From: Karl Hiramoto <karl@hiramoto.org>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: hostapd not sending beacons, and no traffic. 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Using hostapd from git.   I have the same thing happening with both 
wirelees-testing and linux-2.6.30-rc6


Scenario 1:   
eth0 bridged to wlan0_0.    all traffic works with no problems.   Ping 
and Lots of traffic between interfaces works fine.


Scenario 2:   
eth0 bridged to wlan0_0 in one subnet.   Then en eth1 I have another 
subnet, i route between subnets.  I can ping between subnets to for a 
while.  I can not copy a large file,  iperf also fails.   At some point 
hostapd stops sending beacons and ther is no traffic.  It seems to 
respond to probe requests.

STA 00:90:4b:69:0f:55 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:0e:35:f0:76:42 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:0e:35:f0:76:42 sent probe request for broadcast SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
Checking STA 00:1c:bf:51:63:34 inactivity:
  Station has been active
Checking STA 00:1c:bf:51:63:34 inactivity:
  Polling STA with data frame
Checking STA 00:1c:bf:51:63:34 inactivity:
Sending disassociation info to STA 00:1c:bf:51:63:34
nl_set_encr: ifindex=6 alg=0 addr=0x5c298 key_idx=0 set_tx=1 seq_len=0 
key_len=0
   addr=00:1c:bf:51:63:34
Sending deauthentication info to STA 00:1c:bf:51:63:34
nl_set_encr: ifindex=6 alg=0 addr=0x5c298 key_idx=0 set_tx=1 seq_len=0 
key_len=0
   addr=00:1c:bf:51:63:34
nl80211: Set beacon (beacon_set=1)
WPA: group state machine entering state SETKEYS (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=32): [REMOVED]
wpa_group_setkeys: GKeyDoneStations=0
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
nl_set_encr: ifindex=6 alg=2 addr=(nil) key_idx=2 set_tx=1 seq_len=0 
key_len=32



Senario 3:   
Same as senario 2 but NAT instead of route.
eth0 bridged to wlan0_0 in one subnet.   Then en eth1 I have another 
subnet, I NAT/ MASQUERADE  between subnets.  I can ping between subnets 
to for a while.  I can not copy a large file,  iperf also fails.   At 
some point hostapd stops sending beacons and there is no traffic.  It 
seems to respond to probe requests.



Hostapd configuration:

interface=wlan0_0
bridge=br0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=0
logger_stdout_level=2
dump_file=/tmp/hostapd/hostapd.0.dump
ssid=karl
channel=1
hw_mode=g
auth_algs=1
macaddr_acl=0
accept_mac_file=/tmp/hostapd/hostapd.wlan0_0.accept
deny_mac_file=/tmp/hostapd/hostapd.wlan0_0.deny
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=hiramoto
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
ieee8021x=0
eap_server=0



Any ideas on where the problem could be?

Thanks.
--
Karl.
