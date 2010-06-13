Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63410 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0FMRIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 13:08:55 -0400
Received: by wyb40 with SMTP id 40so3014521wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 10:08:54 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 13 Jun 2010 13:08:53 -0400
Message-ID: <AANLkTincbrPV9DTY0qIM1iBZ6byvsSV1t84OVoFNZ2Bq@mail.gmail.com>
Subject: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 19
From: sundar mahadevan <sundarmahadevan82@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
Greetings. I am on Oracle Enterprise Linux (OEL 5.5 x86_64) same as
Redhat 5.5. I must use OEL5.5 because of my software installation
requirements. NetworkManager detects my ssid but its just not getting
ip from my router assigned. I use a Belkin 54g router with WPA/WPA2
encryption. The other options available on my router are WPA2 only,
WEP and Disabled. I have spent more than 20 hours trying to get wifi
working but no luck. Your help is highly appreciated.

[root@localhost ~]$uname -a
Linux localhost.localdomain 2.6.18-194.el5 #1 SMP Mon Mar 29 22:10:29
EDT 2010 x86_64 x86_64 x86_64 GNU/Linux

[root@localhost /etc/wpa_supplicant]$lspci | grep -i ath
04:00.0 Network controller: Atheros Communications Inc. AR928X
Wireless Network Adapter (PCI-Express) (rev 01)

[root@localhost /etc/wpa_supplicant]$cat wpa_supplicant.conf
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=wheel

network={
        ssid="any"
        key_mgmt=NONE
}

[root@localhost ~]$service network restart
Shutting down interface wlan0:                             [  OK  ]
Shutting down loopback interface:                          [  OK  ]
Bringing up loopback interface:                            [  OK  ]
Bringing up interface eth0:
Determining IP information for eth0...dhclient(5038) is already
running - exiting.
exiting.
 failed.
                                                           [FAILED]
Bringing up interface wlan0:  Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

Determining IP information for wlan0... failed.
                                                           [FAILED]

[root@localhost /etc/sysconfig/network-scripts]$cat ifcfg-wlan0
# Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express)
DEVICE=wlan0
BOOTPROTO=dhcp
ONBOOT=yes
HWADDR=90:4c:e5:56:ce:14
NETMASK=
DHCP_HOSTNAME=
IPADDR=
BONDING_OPTS=
DOMAIN=
MASTER=
TYPE=Wireless
USERCTL=no
IPV6INIT=no
PEERDNS=yes
ESSID=suma
CHANNEL=9
MODE=Auto
SECURITYMODE=off
RATE=auto

[root@localhost ~]$tail -f /var/log/messages
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
starting connection 'Auto suma'
Jun 12 23:37:36 localhost NetworkManager: (info)  (wlan0): device
state change: 3 -> 4
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 1 of 5 (Device Prepare) scheduled...
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 1 of 5 (Device Prepare) started...
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 2 of 5 (Device Configure) scheduled...
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 1 of 5 (Device Prepare) complete.
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 2 of 5 (Device Configure) starting...
Jun 12 23:37:36 localhost NetworkManager: (info)  (wlan0): device
state change: 4 -> 5
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation
(wlan0/wireless): access point 'Auto suma' has security, but secrets
are required.
Jun 12 23:37:36 localhost NetworkManager: (info)  (wlan0): device
state change: 5 -> 6
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 2 of 5 (Device Configure) complete.
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 1 of 5 (Device Prepare) scheduled...
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 1 of 5 (Device Prepare) started...
Jun 12 23:37:36 localhost NetworkManager: (info)  (wlan0): device
state change: 6 -> 4
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 2 of 5 (Device Configure) scheduled...
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 1 of 5 (Device Prepare) complete.
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 2 of 5 (Device Configure) starting...
Jun 12 23:37:36 localhost NetworkManager: (info)  (wlan0): device
state change: 4 -> 5
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation
(wlan0/wireless): connection 'Auto suma' has security, and secrets
exist.  No new secrets needed.
Jun 12 23:37:36 localhost NetworkManager: (info)  Config: added 'ssid'
value 'suma'
Jun 12 23:37:36 localhost NetworkManager: (info)  Config: added
'scan_ssid' value '1'
Jun 12 23:37:36 localhost NetworkManager: (info)  Config: added
'key_mgmt' value 'WPA-PSK'
Jun 12 23:37:36 localhost NetworkManager: (info)  Config: added 'psk'
value '(omitted)'
Jun 12 23:37:36 localhost NetworkManager: (info)  Activation (wlan0)
Stage 2 of 5 (Device Configure) complete.
Jun 12 23:37:36 localhost NetworkManager: (info)  Config: set
interface ap_scan to 1
Jun 12 23:37:36 localhost NetworkManager: (info)  (wlan0): supplicant
connection state:  disconnected -> scanning
Jun 12 23:37:37 localhost NetworkManager: (info)  (wlan0): supplicant
connection state:  scanning -> associating
Jun 12 23:37:38 localhost NetworkManager: (info)  (wlan0): supplicant
connection state:  associating -> associated
Jun 12 23:37:40 localhost NetworkManager: (info)  (wlan0): supplicant
connection state:  associated -> 4-way handshake
Jun 12 23:37:40 localhost NetworkManager: (info)  (wlan0): supplicant
connection state:  4-way handshake -> group handshake
Jun 12 23:37:40 localhost NetworkManager: (info)  (wlan0): supplicant
connection state:  group handshake -> completed
Jun 12 23:37:40 localhost NetworkManager: (info)  Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'suma'.
Jun 12 23:37:40 localhost NetworkManager: (info)  Activation (wlan0)
Stage 3 of 5 (IP Configure Start) scheduled.
Jun 12 23:37:40 localhost NetworkManager: (info)  Activation (wlan0)
Stage 3 of 5 (IP Configure Start) started...
Jun 12 23:37:40 localhost NetworkManager: (info)  (wlan0): device
state change: 5 -> 7
Jun 12 23:37:40 localhost NetworkManager: (info)  Activation (wlan0)
Beginning DHCP transaction.
Jun 12 23:37:40 localhost NetworkManager: (info)  dhclient started with pid 4713
Jun 12 23:37:40 localhost NetworkManager: (info)  Activation (wlan0)
Stage 3 of 5 (IP Configure Start) complete.
Jun 12 23:37:40 localhost dhclient: Internet Systems Consortium DHCP
Client V3.0.5-RedHat
Jun 12 23:37:40 localhost dhclient: Copyright 2004-2006 Internet
Systems Consortium.
Jun 12 23:37:40 localhost dhclient: All rights reserved.
Jun 12 23:37:40 localhost dhclient: For info, please visit
http://www.isc.org/sw/dhcp/
Jun 12 23:37:40 localhost dhclient:
Jun 12 23:37:40 localhost NetworkManager: (info)  DHCP: device wlan0
state changed normal exit -> preinit
Jun 12 23:37:40 localhost dhclient: Listening on LPF/wlan0/90:4c:e5:56:ce:14
Jun 12 23:37:40 localhost dhclient: Sending on   LPF/wlan0/90:4c:e5:56:ce:14
Jun 12 23:37:40 localhost dhclient: Sending on   Socket/fallback
Jun 12 23:37:40 localhost dhclient: DHCPDISCOVER on wlan0 to
255.255.255.255 port 67 interval 3
Jun 12 23:37:43 localhost dhclient: DHCPDISCOVER on wlan0 to
255.255.255.255 port 67 interval 7
Jun 12 23:37:49 localhost dhclient: DHCPDISCOVER on wlan0 to
255.255.255.255 port 67 interval 20
Jun 12 23:38:10 localhost dhclient: DHCPDISCOVER on wlan0 to
255.255.255.255 port 67 interval 19
Jun 12 23:38:25 localhost NetworkManager: (info)  Device 'wlan0' DHCP
transaction took too long (>45s), stopping it.
Jun 12 23:38:25 localhost NetworkManager: (info)  wlan0: canceled DHCP
transaction, dhcp client pid 4713
Jun 12 23:38:25 localhost NetworkManager: (info)  Activation (wlan0)
Stage 4 of 5 (IP Configure Timeout) scheduled...
Jun 12 23:38:25 localhost NetworkManager: (info)  Activation (wlan0)
Stage 4 of 5 (IP Configure Timeout) started...
Jun 12 23:38:25 localhost NetworkManager: (info)  (wlan0): device
state change: 7 -> 9
Jun 12 23:38:25 localhost NetworkManager: (info)  Activation (wlan0)
failed for access point (suma)
Jun 12 23:38:25 localhost NetworkManager: (info)  Marking connection
'Auto suma' invalid.
Jun 12 23:38:25 localhost NetworkManager: (info)  Activation (wlan0) failed.
Jun 12 23:38:25 localhost NetworkManager: (info)  Activation (wlan0)
Stage 4 of 5 (IP Configure Timeout) complete.
Jun 12 23:38:25 localhost NetworkManager: (info)  (wlan0): device
state change: 9 -> 3
Jun 12 23:38:25 localhost NetworkManager: (info)  (wlan0):
deactivating device (reason: 0).
