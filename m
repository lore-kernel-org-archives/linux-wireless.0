Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45543 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0INKTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 06:19:01 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OvSbL-00086B-Sv
	for linux-wireless@vger.kernel.org; Tue, 14 Sep 2010 12:18:59 +0200
Received: from artipc9.vub.ac.be ([134.184.26.59])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 12:18:59 +0200
Received: from fhimpe by artipc9.vub.ac.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 12:18:59 +0200
To: linux-wireless@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Connection dropped when roaming
Date: Tue, 14 Sep 2010 10:18:51 +0000 (UTC)
Message-ID: <i6ni6b$uak$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using Debian Squeeze kernel 2.6.32-21 (iwlagn 1.3.27ks) with an Intel
Corporation Ultimate N WiFi Link 5300 [8086:4235].

Whenever I use my laptop in a place where different APs provide roaming 
for a wifi network, my system seems to suddenly (without moving) roam to 
another AP, after which the connection stops working completely (cannot 
ping anymore, etc) while NetworkManager shows I'm still connected.

I can easily reproduce this, on two different roaming networks.

I also tried kernel 2.6.35-1~experimental.3, but it has the same 
problematic behaviour.

Log extract, when the problem starts:
Sep 14 09:14:43 defected wpa_supplicant[1827]: Trying to associate with 06:12:cf:cc:5b:15 (SSID='IG-Airlines-2' freq=2432 MHz)
Sep 14 09:14:43 defected NetworkManager[1808]: <info> (wlan0): supplicant connection state:  completed -> associating
Sep 14 09:14:43 defected kernel: [14679.365347] wlan0: deauthenticating from 06:12:cf:ca:f8:c1 by local choice (reason=3)
Sep 14 09:14:43 defected wpa_supplicant[1827]: Association request to the driver failed
Sep 14 09:14:43 defected wpa_supplicant[1827]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Sep 14 09:14:43 defected kernel: [14679.383301] wlan0: direct probe to AP 06:12:cf:cc:5b:15 (try 1)
Sep 14 09:14:43 defected NetworkManager[1808]: <info> (wlan0): supplicant connection state:  associating -> disconnected
Sep 14 09:14:43 defected kernel: [14679.390399] wlan0: direct probe responded
Sep 14 09:14:43 defected kernel: [14679.390409] wlan0: authenticate with AP 06:12:cf:cc:5b:15 (try 1)
Sep 14 09:14:43 defected kernel: [14679.395009] wlan0: authenticated
Sep 14 09:14:43 defected kernel: [14679.395048] wlan0: associate with AP 06:12:cf:cc:5b:15 (try 1)
Sep 14 09:14:43 defected kernel: [14679.406477] wlan0: RX AssocResp from 06:12:cf:cc:5b:15 (capab=0x421 status=0 aid=1)
Sep 14 09:14:43 defected kernel: [14679.406487] wlan0: associated
Sep 14 09:14:43 defected wpa_supplicant[1827]: Associated with 06:12:cf:cc:5b:15
Sep 14 09:14:43 defected wpa_supplicant[1827]: CTRL-EVENT-CONNECTED - Connection to 06:12:cf:cc:5b:15 completed (reauth) [id=0 id_str=]
Sep 14 09:14:43 defected NetworkManager[1808]: <info> (wlan0): supplicant connection state:  disconnected -> associated
Sep 14 09:14:43 defected NetworkManager[1808]: <info> (wlan0): supplicant connection state:  associated -> completed
Sep 14 09:14:44 defected NetworkManager[1808]: <info> (wlan0): roamed from BSSID 06:12:CF:CA:F8:C1 (IG-Airlines-2) to 06:12:CF:CC:5B:15 (IG-Airlines-2)
Sep 14 09:17:17 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:17:22 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:17:33 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:17:47 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:18:08 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:18:16 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:18:30 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:18:48 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:19:08 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:19:26 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:19:47 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:20:05 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:20:24 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:20:34 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:20:43 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:20:52 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:21:12 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:21:26 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:21:40 defected dhclient: DHCPREQUEST on wlan0 to 101.248.192.1 port 67
Sep 14 09:21:48 defected dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 port 67
Sep 14 09:22:09 defected dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 port 67
Sep 14 09:22:09 defected NetworkManager[1808]: <info> (wlan0): DHCPv4 state changed renew -> expire
Sep 14 09:22:09 defected NetworkManager[1808]: <info> (wlan0): device state change: 8 -> 9 (reason 6)
Sep 14 09:22:09 defected NetworkManager[1808]: <warn> Activation (wlan0) failed for access point (IG-Airlines-2)
Sep 14 09:22:09 defected NetworkManager[1808]: <info> Marking connection 'Auto IG-Airlines-2' invalid because IP configuration expired.
Sep 14 09:22:09 defected NetworkManager[1808]: <warn> Activation (wlan0) failed.
Sep 14 09:22:09 defected NetworkManager[1808]: <info> (wlan0): device state change: 9 -> 3 (reason 0)
Sep 14 09:22:09 defected NetworkManager[1808]: <info> (wlan0): deactivating device (reason: 0).
Sep 14 09:22:09 defected NetworkManager[1808]: <info> (wlan0): canceled DHCP transaction, DHCP client pid 24398
Sep 14 09:22:09 defected NetworkManager[1808]: <error> [1284448929.249467] [nm-system.c:1229] check_one_route(): (wlan0): error -34 returned from rtnl_route_del(): Netlink Error (errno = Numerical result out of range)
Sep 14 09:22:09 defected kernel: [15124.737062] wlan0: deauthenticating from 06:12:cf:cc:5b:15 by local choice (reason=3)
Sep 14 09:22:09 defected wpa_supplicant[1827]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys

Would this be a kernel problem, or rather a problem in wpa_supplicant or
networkmanager?

-- 
Frederik Himpe

