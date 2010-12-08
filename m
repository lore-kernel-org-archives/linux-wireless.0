Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33842 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0LHDhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 22:37:34 -0500
Received: by vws16 with SMTP id 16so560715vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 19:37:33 -0800 (PST)
Message-ID: <4CFEFD8D.1080808@lwfinger.net>
Date: Tue, 07 Dec 2010 21:37:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/4] Make N-PHY support experimental
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com> <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
In-Reply-To: <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070303030105080308010205"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070303030105080308010205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I have a bit more info regarding the problem with WPA2 encryption on an N PHY.
As shown in the NetworkManager log attached, Authentication is successful, but
DHCP fails. Either the transmit data is improperly encrypted, or the decryption
fails. I will use wireshark to sort that out. Note: Using software encryption
makes no difference.

Larry


--------------070303030105080308010205
Content-Type: text/x-log;
 name="nm.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nm.log"

Dec  7 21:13:37 larrylap NetworkManager: <info>  (wlan5): device state change: 8 -> 3 (reason 0)
Dec  7 21:13:37 larrylap NetworkManager: <info>  (wlan5): deactivating device (reason: 0).
Dec  7 21:13:37 larrylap NetworkManager: <info>  (wlan5): canceled DHCP transaction, dhcp client pid 5982
Dec  7 21:13:37 larrylap NetworkManager: <WARN>  check_one_route(): (wlan5) error -34 returned from rtnl_route_del(): Sucess#012
Dec  7 21:13:37 larrylap NetworkManager: <debug> [1291778017.386964] run_netconfig(): Spawning '/sbin/netconfig modify --service NetworkManager'
Dec  7 21:13:37 larrylap NetworkManager: <debug> [1291778017.403700] write_to_netconfig(): Writing to netconfig: INTERFACE='wlan5'#012
Dec  7 21:13:37 larrylap NetworkManager: <info>  Clearing nscd hosts cache.
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5) starting connection 'lwfdjf_rad'
Dec  7 21:13:37 larrylap NetworkManager: <info>  (wlan5): device state change: 3 -> 4 (reason 0)
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) scheduled...
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) started...
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) scheduled...
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) complete.
Dec  7 21:13:37 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  completed -> disconnected
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) starting...
Dec  7 21:13:37 larrylap NetworkManager: <info>  (wlan5): device state change: 4 -> 5 (reason 0)
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5/wireless): connection 'lwfdjf_rad' has security, and secrets exist.  No new secrets needed
.
Dec  7 21:13:37 larrylap NetworkManager: <info>  Config: added 'ssid' value 'lwfdjf_rad'
Dec  7 21:13:37 larrylap NetworkManager: <info>  Config: added 'scan_ssid' value '1'
Dec  7 21:13:37 larrylap NetworkManager: <info>  Config: added 'key_mgmt' value 'WPA-PSK'
Dec  7 21:13:37 larrylap NetworkManager: <info>  Config: added 'psk' value '<omitted>'
Dec  7 21:13:37 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) complete.
Dec  7 21:13:37 larrylap NetworkManager: <info>  Config: set interface ap_scan to 1
Dec  7 21:13:37 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  disconnected -> scanning
Dec  7 21:13:37 larrylap nm-dispatcher.action: Script '/etc/NetworkManager/dispatcher.d/autofs' exited with error status 1.
Dec  7 21:13:38 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  scanning -> associating
Dec  7 21:13:38 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  associating -> associated
Dec  7 21:13:38 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  associated -> 4-way handshake
Dec  7 21:13:38 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  4-way handshake -> group handshake
Dec  7 21:13:38 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  group handshake -> completed
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'lwfdjf_rad'.
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) scheduled.
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) started...
Dec  7 21:13:38 larrylap NetworkManager: <info>  (wlan5): device state change: 5 -> 7 (reason 0)
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5) Beginning DHCP transaction (timeout in 45 seconds)
Dec  7 21:13:38 larrylap NetworkManager: <info>  dhclient started with pid 7150
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) scheduled...
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) complete.
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) started...
Dec  7 21:13:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) complete.
Dec  7 21:13:38 larrylap NetworkManager: <info>  DHCP: device wlan5 state changed normal exit -> preinit
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): device state change: 7 -> 3 (reason 0)
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): deactivating device (reason: 0).
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): canceled DHCP transaction, dhcp client pid 7150
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5) starting connection 'Larry_wep'
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): device state change: 3 -> 4 (reason 0)
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) scheduled...
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) started...
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) scheduled...
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) complete.
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) starting...
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): device state change: 4 -> 5 (reason 0)
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5/wireless): access point 'Larry_wep' has security, but secrets are required.
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): device state change: 5 -> 6 (reason 0)
Dec  7 21:14:19 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) complete.
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  completed -> disconnected
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): device state change: 6 -> 3 (reason 38)
Dec  7 21:14:19 larrylap NetworkManager: <info>  (wlan5): deactivating device (reason: 38).
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) starting connection 'lwfdjf_rad'
Dec  7 21:14:23 larrylap NetworkManager: <info>  (wlan5): device state change: 3 -> 4 (reason 0)
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) scheduled...
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) started...
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) scheduled...
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) complete.
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) starting...
Dec  7 21:14:23 larrylap NetworkManager: <info>  (wlan5): device state change: 4 -> 5 (reason 0)
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5/wireless): access point 'lwfdjf_rad' has security, but secrets are required.
Dec  7 21:14:23 larrylap NetworkManager: <info>  (wlan5): device state change: 5 -> 6 (reason 0)
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) complete.
Dec  7 21:14:23 larrylap NetworkManager: <WARN>  secrets_update_setting(): Failed to update connection secrets: 1 802-1x
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) scheduled...
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) started...
Dec  7 21:14:23 larrylap NetworkManager: <info>  (wlan5): device state change: 6 -> 4 (reason 0)
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) scheduled...
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) complete.
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) starting...
Dec  7 21:14:23 larrylap NetworkManager: <info>  (wlan5): device state change: 4 -> 5 (reason 0)
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5/wireless): connection 'lwfdjf_rad' has security, and secrets exist.  No new secrets needed.
Dec  7 21:14:23 larrylap NetworkManager: <info>  Config: added 'ssid' value 'lwfdjf_rad'
Dec  7 21:14:23 larrylap NetworkManager: <info>  Config: added 'scan_ssid' value '1'
Dec  7 21:14:23 larrylap NetworkManager: <info>  Config: added 'key_mgmt' value 'WPA-PSK'
Dec  7 21:14:23 larrylap NetworkManager: <info>  Config: added 'psk' value '<omitted>'
Dec  7 21:14:23 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) complete.
Dec  7 21:14:23 larrylap NetworkManager: <info>  Config: set interface ap_scan to 1
Dec  7 21:14:23 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  disconnected -> scanning
Dec  7 21:14:24 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  scanning -> associating
Dec  7 21:14:24 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  associating -> associated
Dec  7 21:14:24 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  associated -> 4-way handshake
Dec  7 21:14:24 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  4-way handshake -> group handshake
Dec  7 21:14:24 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  group handshake -> completed
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'lwfdjf_rad'.
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) scheduled.
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) started...
Dec  7 21:14:24 larrylap NetworkManager: <info>  (wlan5): device state change: 5 -> 7 (reason 0)
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5) Beginning DHCP transaction (timeout in 45 seconds)
Dec  7 21:14:24 larrylap NetworkManager: <info>  dhclient started with pid 7177
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) scheduled...
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) complete.
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) started...
Dec  7 21:14:24 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) complete.
Dec  7 21:14:24 larrylap NetworkManager: <info>  DHCP: device wlan5 state changed normal exit -> preinit
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): device state change: 7 -> 3 (reason 0)
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): deactivating device (reason: 0).
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): canceled DHCP transaction, dhcp client pid 7177
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) starting connection 'Larry_wep'
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): device state change: 3 -> 4 (reason 0)
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) scheduled...
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) started...
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) scheduled...
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) complete.
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  completed -> disconnected
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) starting...
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): device state change: 4 -> 5 (reason 0)
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5/wireless): access point 'Larry_wep' has security, but secrets are required.
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): device state change: 5 -> 6 (reason 0)
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) complete.
Dec  7 21:14:32 larrylap NetworkManager: <WARN>  secrets_update_setting(): Failed to update connection secrets: 1 802-1x
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) scheduled...
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) started...
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): device state change: 6 -> 4 (reason 0)
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) scheduled...
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 1 of 5 (Device Prepare) complete.
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) starting...
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): device state change: 4 -> 5 (reason 0)
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5/wireless): connection 'Larry_wep' has security, and secrets exist.  No new secrets needed.
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'ssid' value 'Larry_wep'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'scan_ssid' value '1'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'key_mgmt' value 'NONE'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'wep_key0' value '<omitted>'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'wep_key1' value '<omitted>'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'wep_key2' value '<omitted>'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'wep_key3' value '<omitted>'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: added 'wep_tx_keyidx' value '0'
Dec  7 21:14:32 larrylap NetworkManager: <info>  Activation (wlan5) Stage 2 of 5 (Device Configure) complete.
Dec  7 21:14:32 larrylap NetworkManager: <info>  Config: set interface ap_scan to 1
Dec  7 21:14:32 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  disconnected -> scanning
Dec  7 21:14:34 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  scanning -> associating
Dec  7 21:14:34 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  associating -> associated
Dec  7 21:14:34 larrylap NetworkManager: <info>  (wlan5): supplicant connection state:  associated -> completed
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'Larry_wep'.
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) scheduled.
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) started...
Dec  7 21:14:34 larrylap NetworkManager: <info>  (wlan5): device state change: 5 -> 7 (reason 0)
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5) Beginning DHCP transaction (timeout in 45 seconds)
Dec  7 21:14:34 larrylap NetworkManager: <info>  dhclient started with pid 7187
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) scheduled...
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5) Stage 3 of 5 (IP Configure Start) complete.
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) started...
Dec  7 21:14:34 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP6 Configure Get) complete.
Dec  7 21:14:34 larrylap NetworkManager: <info>  DHCP: device wlan5 state changed normal exit -> preinit
Dec  7 21:14:38 larrylap NetworkManager: <info>  DHCP: device wlan5 state changed preinit -> reboot
Dec  7 21:14:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP4 Configure Get) scheduled...
Dec  7 21:14:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP4 Configure Get) started...
Dec  7 21:14:38 larrylap NetworkManager: <info>    address 192.168.3.102
Dec  7 21:14:38 larrylap NetworkManager: <info>    prefix 24 (255.255.255.0)
Dec  7 21:14:38 larrylap NetworkManager: <info>    gateway 192.168.3.1
Dec  7 21:14:38 larrylap NetworkManager: <info>    nameserver '192.168.2.1'
Dec  7 21:14:38 larrylap NetworkManager: <info>    domain name 'lan'
Dec  7 21:14:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 5 of 5 (IP Configure Commit) scheduled...
Dec  7 21:14:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 4 of 5 (IP4 Configure Get) complete.
Dec  7 21:14:38 larrylap NetworkManager: <info>  Activation (wlan5) Stage 5 of 5 (IP Configure Commit) started...
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.043901] run_netconfig(): Spawning '/sbin/netconfig modify --service NetworkManager'
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.056161] write_to_netconfig(): Writing to netconfig: INTERFACE='wlan5'#012
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.056433] write_to_netconfig(): Writing to netconfig: DNSSEARCH='lan lan'#012
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.056500] write_to_netconfig(): Writing to netconfig: DNSSERVERS='192.168.2.1'#012
Dec  7 21:14:39 larrylap NetworkManager: <info>  Clearing nscd hosts cache.
Dec  7 21:14:39 larrylap NetworkManager: <info>  (wlan5): device state change: 7 -> 8 (reason 0)
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.088730] run_netconfig(): Spawning '/sbin/netconfig modify --service NetworkManager'
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.119134] write_to_netconfig(): Writing to netconfig: INTERFACE='wlan5'#012
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.119375] write_to_netconfig(): Writing to netconfig: DNSSEARCH='lan lan'#012
Dec  7 21:14:39 larrylap NetworkManager: <debug> [1291778079.119435] write_to_netconfig(): Writing to netconfig: DNSSERVERS='192.168.2.1'#012
Dec  7 21:14:39 larrylap NetworkManager: <info>  Clearing nscd hosts cache.
Dec  7 21:14:39 larrylap NetworkManager: <info>  Policy set 'Larry_wep' (wlan5) as default for routing and DNS.
Dec  7 21:14:39 larrylap NetworkManager: <info>  Activation (wlan5) successful, device activated.
Dec  7 21:14:39 larrylap NetworkManager: <info>  Activation (wlan5) Stage 5 of 5 (IP Configure Commit) complete.
Dec  7 21:14:39 larrylap nm-dispatcher.action: Script '/etc/NetworkManager/dispatcher.d/autofs' exited with error status 1.


--------------070303030105080308010205--
