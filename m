Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41179 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbXFJTzV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2007 15:55:21 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HxTV8-0004wc-Ig
	for linux-wireless@vger.kernel.org; Sun, 10 Jun 2007 21:55:02 +0200
Received: from port-83-236-56-183.dynamic.qsc.de ([83.236.56.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2007 21:55:02 +0200
Received: from thomas by port-83-236-56-183.dynamic.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2007 21:55:02 +0200
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: iwlwifi 0.0.25 on 2.6.22-rc4
Date: Sun, 10 Jun 2007 21:49:37 +0200
Message-ID: <f4hkkg$664$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I have once again tried iwl3945, but for the first time on
2.6.22-rc4, meaning on an "official" mac80211. As I still get the same
problems as with 2.6.21 and the intel mac80211 patches, I thought it was
time to report it here:

First of all, the wireless LED is all silent, but that's a minor.

Second, I have problems when I try to disconnect from an AP and connect
to another one.

Jun 10 21:20:52 artin iwl3945: REPLY_ADD_STA failed
Jun 10 21:20:52 artin wlan0: Initial auth_alg=0
Jun 10 21:20:52 artin wlan0: authenticate with AP 00:17:9a:6f:01:fd
Jun 10 21:20:52 artin wlan0: RX authentication from 00:17:9a:6f:01:fd
(alg=0 transaction=2 status=0)
Jun 10 21:20:52 artin wlan0: authenticated
Jun 10 21:20:52 artin wlan0: associate with AP 00:17:9a:6f:01:fd
Jun 10 21:20:52 artin wlan0: RX AssocResp from 00:17:9a:6f:01:fd
(capab=0x431 status=0 aid=2)
Jun 10 21:20:52 artin wlan0: associated
Jun 10 21:20:52 artin ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jun 10 21:20:53 artin autowifi[6699]: Interface 'wlan0' connected to
network 'marvin', profile 'default'
Jun 10 21:20:53 artin dhclient: wmaster0: unknown hardware address type 801
Jun 10 21:20:54 artin dhclient: wmaster0: unknown hardware address type 801
Jun 10 21:20:57 artin dhclient: DHCPREQUEST on wlan0 to 255.255.255.255
port 67
Jun 10 21:20:57 artin dhclient: DHCPACK from 192.168.1.1
Jun 10 21:20:57 artin dhclient: bound to 192.168.1.42 -- renewal in
459297 seconds.
Jun 10 21:21:01 artin eth0: no IPv6 routers present
Jun 10 21:21:02 artin wlan0: no IPv6 routers present

At this point, I can use the connection without trouble. Then I use
wpa_gui to select another network:

Jun 10 21:22:11 artin wlan0: disassociate(reason=3)
Jun 10 21:22:11 artin autowifi[7097]: Interface 'wlan0' disconnected
from network 'marvin', profile 'default'
Jun 10 21:22:13 artin wlan0: RX deauthentication from 00:17:9a:6f:01:fd
(reason=6)
Jun 10 21:22:13 artin wlan0: deauthenticated
Jun 10 21:22:13 artin wlan0: authenticate with AP 00:17:9a:6f:01:fd
Jun 10 21:22:13 artin wlan0: Initial auth_alg=0
Jun 10 21:22:13 artin wlan0: authenticate with AP 00:17:9a:6f:01:fd
Jun 10 21:22:13 artin wlan0: privacy configuration mismatch and
mixed-cell disabled - disassociate
Jun 10 21:22:13 artin wlan0: Initial auth_alg=0
Jun 10 21:22:13 artin wlan0: authenticate with AP 00:17:9a:6f:01:fd
Jun 10 21:22:13 artin wlan0: privacy configuration mismatch and
mixed-cell disabled - disassociate
Jun 10 21:22:13 artin iwl3945: REPLY_ADD_STA failed
Jun 10 21:22:13 artin wlan0: Initial auth_alg=0
Jun 10 21:22:13 artin wlan0: authenticate with AP 00:18:f8:fa:1e:c1
Jun 10 21:22:13 artin wlan0: RX authentication from 00:18:f8:fa:1e:c1
(alg=0 transaction=2 status=0)
Jun 10 21:22:13 artin wlan0: authenticated
Jun 10 21:22:13 artin wlan0: associate with AP 00:18:f8:fa:1e:c1
Jun 10 21:22:13 artin wlan0: RX AssocResp from 00:18:f8:fa:1e:c1
(capab=0x401 status=0 aid=3)
Jun 10 21:22:13 artin wlan0: associated
Jun 10 21:22:13 artin autowifi[7103]: Interface 'wlan0' connected to
network 'SomeOpenAP', profile 'default'
Jun 10 21:22:13 artin dhclient: wmaster0: unknown hardware address type 801
Jun 10 21:22:14 artin dhclient: wmaster0: unknown hardware address type 801
Jun 10 21:22:14 artin dhclient: DHCPREQUEST on wlan0 to 255.255.255.255
port 67
Jun 10 21:22:22 artin dhclient: DHCPREQUEST on wlan0 to 255.255.255.255
port 67
Jun 10 21:22:41 artin dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255
port 67 interval 5
Jun 10 21:22:43 artin dhclient: DHCPOFFER from 10.10.10.10
Jun 10 21:22:43 artin dhclient: DHCPREQUEST on wlan0 to 255.255.255.255
port 67
Jun 10 21:22:43 artin dhclient: DHCPACK from 10.10.10.10
Jun 10 21:22:43 artin iwl3945: Microcode SW error detected.  Restarting
0x82000000.
Jun 10 21:22:43 artin iwl3945: Error Reply type 0x0000003A cmd
REPLY_RXON_ASSOC (0x11) seq 0x044F ser 0x00000000
Jun 10 21:22:43 artin iwl3945: Error setting RXON_ASSOC configuration (-5).
Jun 10 21:22:43 artin iwl3945: ipw going down
Jun 10 21:22:44 artin iwl3945: Can't stop Rx DMA.
Jun 10 21:22:44 artin iwl3945: Grabbing access while already held at
line 825.
Jun 10 21:22:44 artin iwl3945: Microcode SW error detected.  Restarting
0x82000000.
Jun 10 21:22:44 artin iwl3945: Error Reply type 0x00000000 cmd
REPLY_ALIVE (0x01) seq 0x0000 ser 0x00000001
Jun 10 21:22:44 artin iwl3945: ipw going down
Jun 10 21:22:44 artin ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jun 10 21:22:45 artin iwl3945: Can't stop Rx DMA.
Jun 10 21:22:45 artin iwl3945: Grabbing access while already held at
line 825.
Jun 10 21:22:45 artin dhclient: bound to 10.10.10.97 -- renewal in 35212
seconds.
Jun 10 21:22:45 artin dhclient: receive_packet failed on wlan0: Network
is down
Jun 10 21:22:45 artin iwl3945: Microcode SW error detected.  Restarting
0x82000000.
Jun 10 21:22:45 artin iwl3945: Error Reply type 0x000004EB cmd
REPLY_TX_PWR_TABLE_CMD (0x97) seq 0x0402 ser 0x00000000
Jun 10 21:22:45 artin iwl3945: ipw going down
Jun 10 21:22:46 artin iwl3945: Can't stop Rx DMA.
Jun 10 21:22:47 artin iwl3945: Grabbing access while already held at
line 825.

At this point, I cannot ping the 10.10.10.10 gateway. And I am worried
about the messages above, so I quit wpa_supplicant.

Jun 10 21:23:34 artin wlan0: deauthenticate(reason=3)

Trying to 'rmmod iwl3945' freezes. I cannot restart the connection and
have to reboot. (In case the rmmod doesn't freeze, which sometimes
happend with older versions, I can resue the connection after rmmoding
iwl3945 and mac80211).

