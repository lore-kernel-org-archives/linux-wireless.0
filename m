Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.3eti.com ([65.220.88.141]:61949 "EHLO webmail.3eti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab1AGRoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 12:44:17 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: hostapd hangs on quit, multi-BSSID scenario
Date: Fri, 7 Jan 2011 17:44:30 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gentlemen,

 When I run hostapd with 8+1 BSSID over one radio (ath9160), it runs well. All 9 BSS accepts clients.
But when I "Ctrl + C" or "killall hostapd", hostapd daemon can NOT gracefully shut down. It hangs forever. I have to "Ctrl + C" again. Then it quits and print message like "

I am running latest (as of 01/06/2011) hostapd, latest stable kernel (2.6.37) with one number change in ath9k to allow more than 12 virtual BSS over one radio.

Below is my hostapd-conf and console screenshot. If someone can fix this bug, please help.

Thanks


============================hostapd.conf begin ==============================

interface=wlan0

#bridge=brg0

driver=nl80211

logger_syslog=-1

logger_syslog_level=0

logger_stdout=-1

logger_stdout_level=0

dump_file=/tmp/hostapd.dump

ctrl_interface=/var/run/hostapd

ctrl_interface_group=0

 

##### IEEE 802.11 related configuration #######################################

ssid=bypass

country_code=US

ieee80211d=1

hw_mode=a

channel=36

beacon_int=20

dtim_period=2

max_num_sta=255

rts_threshold=2347

fragm_threshold=2346

macaddr_acl=0

auth_algs=1

ignore_broadcast_ssid=0

 

 

bss=vlan2

ssid=ath9160_2

bssid=02:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_2

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

 

bss=vlan6

ssid=ath9160_6

bssid=06:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_6

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

 

bss=vlana

ssid=ath9160_a

bssid=0a:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_a

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

 

bss=vlane

ssid=ath9160_e

bssid=0e:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_e

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

 

bss=vlan12

ssid=ath9160_12

bssid=12:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_12

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

 

bss=vlan16

ssid=ath9160_16

bssid=16:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_16

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

 

bss=vlan1a

ssid=ath9160_1a

bssid=1a:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_1a

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

 

bss=vlan1e

ssid=ath9160_1e

bssid=1e:06:6b:b1:b3:08

wpa=2

wpa_passphrase=helloworld_1e

wpa_key_mgmt=WPA-PSK

rsn_pairwise=CCMP

wpa_group_rekey=600

wpa_gmk_rekey=86400

wpa_ptk_rekey=600

============================hostapd.conf end ==============================

 

---------------console screenshot-------------------------------------------------------------

root@mini-dell:~/hostapd-conf# hostapd 9VLANs

Configuration file: 9VLANs

Using interface wlan0 with hwaddr 00:0b:6b:b1:b3:08 and ssid 'bypass'

Using interface vlan2 with hwaddr 02:06:6b:b1:b3:08 and ssid 'ath9160_2'

Using interface vlan6 with hwaddr 06:06:6b:b1:b3:08 and ssid 'ath9160_6'

Using interface vlana with hwaddr 0a:06:6b:b1:b3:08 and ssid 'ath9160_a'

Using interface vlane with hwaddr 0e:06:6b:b1:b3:08 and ssid 'ath9160_e'

Using interface vlan12 with hwaddr 12:06:6b:b1:b3:08 and ssid 'ath9160_12'

Using interface vlan16 with hwaddr 16:06:6b:b1:b3:08 and ssid 'ath9160_16'

Using interface vlan1a with hwaddr 1a:06:6b:b1:b3:08 and ssid 'ath9160_1a'

Using interface vlan1e with hwaddr 1e:06:6b:b1:b3:08 and ssid 'ath9160_1e'

AP-STA-DISCONNECTED 00:24:d7:1f:e4:fc

vlan2: STA 00:24:d7:1f:e4:fc IEEE 802.11: did not acknowledge authentication response

vlan2: STA 00:24:d7:1f:e4:fc IEEE 802.11: authenticated

vlan2: STA 00:24:d7:1f:e4:fc IEEE 802.11: associated (aid 1)

AP-STA-CONNECTED 00:24:d7:1f:e4:fc

vlan2: STA 00:24:d7:1f:e4:fc RADIUS: starting accounting session 4D26599C-00000000

vlan2: STA 00:24:d7:1f:e4:fc WPA: pairwise key handshake completed (RSN)

 

 

^Cwlan0: STA 00:0b:6b:0a:4e:43 MLME: MLME-DEAUTHENTICATE.indication(00:0b:6b:0a:4e:43, 1)

wlan0: STA 00:0b:6b:0a:4e:43 MLME: MLME-DELETEKEYS.request(00:0b:6b:0a:4e:43)

^Celoop: could not process SIGINT or SIGTERM in two seconds. Looks like there

is a bug that ends up in a busy loop that prevents clean shutdown.

Killing program forcefully.

 

 

 


