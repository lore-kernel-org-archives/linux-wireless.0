Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968124Ab3DSLe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 07:34:58 -0400
Date: Fri, 19 Apr 2013 06:34:49 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: iwlwifi failures
Message-ID: <20130419113449.GH4699@thinkpad-t410> (sfid-20130419_133507_859569_87C59CCC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I received a report of wireless regularly ceasing to work until
iwldvm/iwlwifi are reloaded, and when I looked at syslog I found some
nasty-looking messages about microcode errors and tx fifo flush
failures. This machine is running an Ubuntu kernel based on 3.8.6.

Below is a rather long excerpt from syslog, starting just after a resume
from S3 until the user reloaded iwldvm and iwlwifi. There's some
rapid-fire roaming between APs (the user says he was stationary at the
time), followed by the errors. This repeats several times with
successful associations intermixed.

I'm not sure if the frequent roaming actually has anything to do with
the problem, though I have seen the behavior before in other reports of
iwlwifi issues. I've been running a test using the same card, forcing it
to roam between two APs every 30 seconds, and haven't been able to
produce similar issues.

The wireless card is:

 01:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6235 [8086:088e] (rev 24)

Let me know if there's any additional information I can supply.

Thanks,
Seth


Apr 18 08:13:27 laptop NetworkManager[764]: <info> wake requested (sleeping: yes  enabled: yes)
Apr 18 08:13:27 laptop NetworkManager[764]: <info> waking up and re-enabling...
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0): bringing up device.
Apr 18 08:13:27 laptop kernel: [72551.409274] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 08:13:27 laptop kernel: [72551.416062] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
Apr 18 08:13:27 laptop kernel: [72551.650328] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0): preparing device.
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0): deactivating device (reason 'managed') [2]
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0) supports 5 scan SSIDs
Apr 18 08:13:27 laptop NetworkManager[764]: <warn> Trying to remove a non-existant call id.
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: starting -> ready
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0): device state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42]
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: ready -> inactive
Apr 18 08:13:27 laptop NetworkManager[764]: <info> (wlan0) supports 5 scan SSIDs
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Auto-activating connection 'The_Nines_Guestroom 2'.
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0) starting connection 'The_Nines_Guestroom 2'
Apr 18 08:13:30 laptop NetworkManager[764]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started...
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled...
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete.
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting...
Apr 18 08:13:30 laptop NetworkManager[764]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0]
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0/wireless): connection 'The_Nines_Guestroom 2' requires no security.  No secrets needed.
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Config: added 'ssid' value 'The_Nines_Guestroom'
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Config: added 'scan_ssid' value '1'
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Config: added 'key_mgmt' value 'NONE'
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete.
Apr 18 08:13:30 laptop NetworkManager[764]: <info> Config: set interface ap_scan to 1
Apr 18 08:13:30 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: inactive -> scanning
Apr 18 08:13:34 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:14:ab:b8 (SSID='The_Nines_Guestroom' freq=2462 MHz)
Apr 18 08:13:34 laptop kernel: [72558.368194] wlan0: authenticate with c4:01:7c:14:ab:b8
Apr 18 08:13:34 laptop kernel: [72558.375874] wlan0: send auth to c4:01:7c:14:ab:b8 (try 1/3)
Apr 18 08:13:34 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Apr 18 08:13:34 laptop kernel: [72558.576168] wlan0: send auth to c4:01:7c:14:ab:b8 (try 2/3)
Apr 18 08:13:34 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c4:01:7c:14:ab:b8 (SSID='The_Nines_Guestroom' freq=2462 MHz)
Apr 18 08:13:34 laptop kernel: [72558.580957] wlan0: authenticated
Apr 18 08:13:34 laptop kernel: [72558.584158] wlan0: associate with c4:01:7c:14:ab:b8 (try 1/3)
Apr 18 08:13:34 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:13:34 laptop kernel: [72558.589062] wlan0: RX AssocResp from c4:01:7c:14:ab:b8 (capab=0x1 status=0 aid=8)
Apr 18 08:13:34 laptop wpa_supplicant[1656]: wlan0: Associated with c4:01:7c:14:ab:b8
Apr 18 08:13:34 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c4:01:7c:14:ab:b8 completed (auth) [id=0 id_str=]
Apr 18 08:13:34 laptop kernel: [72558.593069] wlan0: associated
Apr 18 08:13:34 laptop kernel: [72558.593399] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Apr 18 08:13:34 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0/wireless) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'The_Nines_Guestroom'.
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 3 of 5 (IP Configure Start) started...
Apr 18 08:13:34 laptop NetworkManager[764]: <info> (wlan0): device state change: config -> ip-config (reason 'none') [50 70 0]
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Apr 18 08:13:34 laptop NetworkManager[764]: <info> dhclient started with pid 26484
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0) Beginning IP6 addrconf.
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 3 of 5 (IP Configure Start) complete.
Apr 18 08:13:34 laptop dhclient: Internet Systems Consortium DHCP Client 4.2.4
Apr 18 08:13:34 laptop dhclient: Copyright 2004-2012 Internet Systems Consortium.
Apr 18 08:13:34 laptop dhclient: All rights reserved.
Apr 18 08:13:34 laptop dhclient: For info, please visit https://www.isc.org/software/dhcp/
Apr 18 08:13:34 laptop dhclient: 
Apr 18 08:13:34 laptop NetworkManager[764]: <info> (wlan0): DHCPv4 state changed nbi -> preinit
Apr 18 08:13:34 laptop dhclient: Listening on LPF/wlan0/c4:85:08:86:9a:d4
Apr 18 08:13:34 laptop dhclient: Sending on   LPF/wlan0/c4:85:08:86:9a:d4
Apr 18 08:13:34 laptop dhclient: Sending on   Socket/fallback
Apr 18 08:13:34 laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 3 (xid=0x52973a4f)
Apr 18 08:13:34 laptop dhclient: DHCPREQUEST of 10.12.47.157 on wlan0 to 255.255.255.255 port 67 (xid=0x52973a4f)
Apr 18 08:13:34 laptop dhclient: DHCPOFFER of 10.12.47.157 from 10.12.40.1
Apr 18 08:13:34 laptop dhclient: DHCPACK of 10.12.47.157 from 10.12.40.1
Apr 18 08:13:34 laptop dhclient: bound to 10.12.47.157 -- renewal in 8242 seconds.
Apr 18 08:13:34 laptop NetworkManager[764]: <info> (wlan0): DHCPv4 state changed preinit -> bound
Apr 18 08:13:34 laptop NetworkManager[764]: <info>   address 10.12.47.157
Apr 18 08:13:34 laptop NetworkManager[764]: <info>   prefix 21 (255.255.248.0)
Apr 18 08:13:34 laptop NetworkManager[764]: <info>   gateway 10.12.40.1
Apr 18 08:13:34 laptop NetworkManager[764]: <info>   nameserver '172.16.2.5'
Apr 18 08:13:34 laptop NetworkManager[764]: <info>   nameserver '172.18.82.11'
Apr 18 08:13:34 laptop NetworkManager[764]: <info>   nameserver '4.2.2.2'
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Apr 18 08:13:34 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 5 of 5 (IPv4 Commit) started...
Apr 18 08:13:35 laptop NetworkManager[764]: <info> (wlan0): device state change: ip-config -> secondaries (reason 'none') [70 90 0]
Apr 18 08:13:35 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Apr 18 08:13:35 laptop NetworkManager[764]: <info> (wlan0): device state change: secondaries -> activated (reason 'none') [90 100 0]
Apr 18 08:13:35 laptop NetworkManager[764]: <info> Policy set 'The_Nines_Guestroom 2' (wlan0) as default for IPv4 routing and DNS.
Apr 18 08:13:35 laptop NetworkManager[764]: <info> Writing DNS information to /sbin/resolvconf
Apr 18 08:13:35 laptop dnsmasq[2065]: setting upstream servers from DBus
Apr 18 08:13:35 laptop dnsmasq[2065]: using nameserver 4.2.2.2#53
Apr 18 08:13:35 laptop dnsmasq[2065]: using nameserver 172.18.82.11#53
Apr 18 08:13:35 laptop dnsmasq[2065]: using nameserver 172.16.2.5#53
Apr 18 08:13:36 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C4:01:7C:15:50:3C (The_Nines_Guestroom) to C4:01:7C:14:AB:B8 (The_Nines_Guestroom)
Apr 18 08:13:36 laptop NetworkManager[764]: <info> Activation (wlan0) successful, device activated.
Apr 18 08:13:54 laptop NetworkManager[764]: <info> (wlan0): IP6 addrconf timed out or failed.
Apr 18 08:13:54 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Apr 18 08:13:54 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Apr 18 08:13:54 laptop NetworkManager[764]: <info> Activation (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Apr 18 08:13:57 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c0:8a:de:38:68:c8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:13:58 laptop kernel: [72582.393365] wlan0: authenticate with c0:8a:de:38:68:c8
Apr 18 08:13:58 laptop kernel: [72582.398999] wlan0: send auth to c0:8a:de:38:68:c8 (try 1/3)
Apr 18 08:13:58 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> authenticating
Apr 18 08:13:58 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c0:8a:de:38:68:c8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:13:58 laptop kernel: [72582.422659] wlan0: authenticated
Apr 18 08:13:58 laptop kernel: [72582.423822] wlan0: associate with c0:8a:de:38:68:c8 (try 1/3)
Apr 18 08:13:58 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:13:58 laptop kernel: [72582.428337] wlan0: RX AssocResp from c0:8a:de:38:68:c8 (capab=0x421 status=0 aid=35)
Apr 18 08:13:58 laptop wpa_supplicant[1656]: wlan0: Associated with c0:8a:de:38:68:c8
Apr 18 08:13:58 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:38:68:c8 completed (reauth) [id=0 id_str=]
Apr 18 08:13:58 laptop kernel: [72582.432678] wlan0: associated
Apr 18 08:13:58 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:13:58 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C4:01:7C:14:AB:B8 (The_Nines_Guestroom) to C0:8A:DE:38:68:C8 (The_Nines_Guestroom)
Apr 18 08:14:41 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c0:8a:de:38:60:28 (SSID='The_Nines_Guestroom' freq=2412 MHz)
Apr 18 08:14:42 laptop kernel: [72626.315854] wlan0: authenticate with c0:8a:de:38:60:28
Apr 18 08:14:42 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c0:8a:de:38:60:28 (SSID='The_Nines_Guestroom' freq=2412 MHz)
Apr 18 08:14:42 laptop kernel: [72626.317914] wlan0: send auth to c0:8a:de:38:60:28 (try 1/3)
Apr 18 08:14:42 laptop kernel: [72626.319490] wlan0: authenticated
Apr 18 08:14:42 laptop kernel: [72626.319755] wlan0: waiting for beacon from c0:8a:de:38:60:28
Apr 18 08:14:42 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> authenticating
Apr 18 08:14:42 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:14:42 laptop kernel: [72626.364416] wlan0: associate with c0:8a:de:38:60:28 (try 1/3)
Apr 18 08:14:42 laptop kernel: [72626.375145] wlan0: RX AssocResp from c0:8a:de:38:60:28 (capab=0x1 status=0 aid=18)
Apr 18 08:14:42 laptop wpa_supplicant[1656]: wlan0: Associated with c0:8a:de:38:60:28
Apr 18 08:14:42 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:38:60:28 completed (reauth) [id=0 id_str=]
Apr 18 08:14:42 laptop kernel: [72626.383598] wlan0: associated
Apr 18 08:14:42 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:14:42 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C0:8A:DE:38:68:C8 (The_Nines_Guestroom) to C0:8A:DE:38:60:28 (The_Nines_Guestroom)
Apr 18 08:15:44 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:14:ab:b8 (SSID='The_Nines_Guestroom' freq=2462 MHz)
Apr 18 08:15:44 laptop kernel: [72688.349908] wlan0: authenticate with c4:01:7c:14:ab:b8
Apr 18 08:15:44 laptop kernel: [72688.353421] wlan0: direct probe to c4:01:7c:14:ab:b8 (try 1/3)
Apr 18 08:15:44 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> authenticating
Apr 18 08:15:44 laptop kernel: [72688.554975] wlan0: direct probe to c4:01:7c:14:ab:b8 (try 2/3)
Apr 18 08:15:44 laptop kernel: [72688.758774] wlan0: direct probe to c4:01:7c:14:ab:b8 (try 3/3)
Apr 18 08:15:44 laptop kernel: [72688.962569] wlan0: authentication with c4:01:7c:14:ab:b8 timed out
Apr 18 08:15:44 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
Apr 18 08:15:45 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Apr 18 08:15:45 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c0:8a:de:38:68:c8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:15:45 laptop kernel: [72689.322396] wlan0: deauthenticating from c0:8a:de:38:60:28 by local choice (reason=2)
Apr 18 08:15:45 laptop kernel: [72689.324897] wlan0: authenticate with c0:8a:de:38:68:c8
Apr 18 08:15:45 laptop kernel: [72689.329898] wlan0: send auth to c0:8a:de:38:68:c8 (try 1/3)
Apr 18 08:15:45 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c0:8a:de:38:68:c8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:15:45 laptop kernel: [72689.333446] wlan0: authenticated
Apr 18 08:15:45 laptop kernel: [72689.334224] wlan0: associate with c0:8a:de:38:68:c8 (try 1/3)
Apr 18 08:15:45 laptop wpa_supplicant[1656]: wlan0: Associated with c0:8a:de:38:68:c8
Apr 18 08:15:45 laptop kernel: [72689.342441] wlan0: RX AssocResp from c0:8a:de:38:68:c8 (capab=0x421 status=0 aid=39)
Apr 18 08:15:45 laptop kernel: [72689.345861] wlan0: associated
Apr 18 08:15:45 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:38:68:c8 completed (reauth) [id=0 id_str=]
Apr 18 08:15:45 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Apr 18 08:15:45 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:15:45 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:15:45 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C0:8A:DE:38:60:28 (The_Nines_Guestroom) to C0:8A:DE:38:68:C8 (The_Nines_Guestroom)
Apr 18 08:17:06 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:1a:22:88 (SSID='The_Nines_Guestroom' freq=2462 MHz)
Apr 18 08:17:06 laptop kernel: [72770.879637] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
Apr 18 08:17:06 laptop kernel: [72770.879643] iwlwifi 0000:01:00.0: CSR values:
Apr 18 08:17:06 laptop kernel: [72770.879645] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Apr 18 08:17:06 laptop kernel: [72770.879674] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00484b00
Apr 18 08:17:06 laptop kernel: [72770.879701] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X00000040
Apr 18 08:17:06 laptop kernel: [72770.879726] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.879752] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.879777] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.879804] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X0000003c
Apr 18 08:17:06 laptop kernel: [72770.879829] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.879855] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
Apr 18 08:17:06 laptop kernel: [72770.879880] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X000000b0
Apr 18 08:17:06 laptop kernel: [72770.879906] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X60560ffd
Apr 18 08:17:06 laptop kernel: [72770.879932] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X90000801
Apr 18 08:17:06 laptop kernel: [72770.879957] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X00030001
Apr 18 08:17:06 laptop kernel: [72770.879983] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080042
Apr 18 08:17:06 laptop kernel: [72770.880009] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X0000f6e6
Apr 18 08:17:06 laptop kernel: [72770.880034] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.880060] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.880086] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.880111] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000078
Apr 18 08:17:06 laptop kernel: [72770.880137] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X8802b8cc
Apr 18 08:17:06 laptop kernel: [72770.880163] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
Apr 18 08:17:06 laptop kernel: [72770.880188] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.880214] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Apr 18 08:17:06 laptop kernel: [72770.880239] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
Apr 18 08:17:06 laptop kernel: [72770.880242] iwlwifi 0000:01:00.0: FH register values:
Apr 18 08:17:06 laptop kernel: [72770.880278] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X009a8200
Apr 18 08:17:06 laptop kernel: [72770.880299] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X002baa10
Apr 18 08:17:06 laptop kernel: [72770.880319] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
Apr 18 08:17:06 laptop kernel: [72770.880339] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00811114
Apr 18 08:17:06 laptop kernel: [72770.880360] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Apr 18 08:17:06 laptop kernel: [72770.880380] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Apr 18 08:17:06 laptop kernel: [72770.880406] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.880427] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Apr 18 08:17:06 laptop kernel: [72770.880448] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
Apr 18 08:17:06 laptop kernel: [72770.880451] iwlwifi 0000:01:00.0: Loaded firmware version: 18.168.6.1
Apr 18 08:17:06 laptop kernel: [72770.880597] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
Apr 18 08:17:06 laptop kernel: [72770.880600] iwlwifi 0000:01:00.0: Status: 0x0000004C, count: 6
Apr 18 08:17:06 laptop kernel: [72770.880603] iwlwifi 0000:01:00.0: 0x00000034 | NMI_INTERRUPT_WDG           
Apr 18 08:17:06 laptop kernel: [72770.880606] iwlwifi 0000:01:00.0: 0x00010564 | uPc
Apr 18 08:17:06 laptop kernel: [72770.880608] iwlwifi 0000:01:00.0: 0x0001054E | branchlink1
Apr 18 08:17:06 laptop kernel: [72770.880610] iwlwifi 0000:01:00.0: 0x00010580 | branchlink2
Apr 18 08:17:06 laptop kernel: [72770.880613] iwlwifi 0000:01:00.0: 0x0000DBEA | interruptlink1
Apr 18 08:17:06 laptop kernel: [72770.880615] iwlwifi 0000:01:00.0: 0x0000CE22 | interruptlink2
Apr 18 08:17:06 laptop kernel: [72770.880617] iwlwifi 0000:01:00.0: 0x00000002 | data1
Apr 18 08:17:06 laptop kernel: [72770.880620] iwlwifi 0000:01:00.0: 0x07030000 | data2
Apr 18 08:17:06 laptop kernel: [72770.880622] iwlwifi 0000:01:00.0: 0x0002617C | line
Apr 18 08:17:06 laptop kernel: [72770.880624] iwlwifi 0000:01:00.0: 0xC74025CA | beacon time
Apr 18 08:17:06 laptop kernel: [72770.880626] iwlwifi 0000:01:00.0: 0xEAE4AA36 | tsf low
Apr 18 08:17:06 laptop kernel: [72770.880629] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
Apr 18 08:17:06 laptop kernel: [72770.880631] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
Apr 18 08:17:06 laptop kernel: [72770.880633] iwlwifi 0000:01:00.0: 0x0D1044C3 | time gp2
Apr 18 08:17:06 laptop kernel: [72770.880636] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
Apr 18 08:17:06 laptop kernel: [72770.880638] iwlwifi 0000:01:00.0: 0x754312A8 | uCode version
Apr 18 08:17:06 laptop kernel: [72770.880640] iwlwifi 0000:01:00.0: 0x000000B0 | hw version
Apr 18 08:17:06 laptop kernel: [72770.880643] iwlwifi 0000:01:00.0: 0x00484B00 | board version
Apr 18 08:17:06 laptop kernel: [72770.880645] iwlwifi 0000:01:00.0: 0x0000001C | hcmd
Apr 18 08:17:06 laptop kernel: [72770.880647] iwlwifi 0000:01:00.0: 0x2F863048 | isr0
Apr 18 08:17:06 laptop kernel: [72770.880649] iwlwifi 0000:01:00.0: 0x11C9F800 | isr1
Apr 18 08:17:06 laptop kernel: [72770.880651] iwlwifi 0000:01:00.0: 0x00000F02 | isr2
Apr 18 08:17:06 laptop kernel: [72770.880654] iwlwifi 0000:01:00.0: 0x8547FCC3 | isr3
Apr 18 08:17:06 laptop kernel: [72770.880656] iwlwifi 0000:01:00.0: 0x00000000 | isr4
Apr 18 08:17:06 laptop kernel: [72770.880658] iwlwifi 0000:01:00.0: 0x00890110 | isr_pref
Apr 18 08:17:06 laptop kernel: [72770.880660] iwlwifi 0000:01:00.0: 0x0002617C | wait_event
Apr 18 08:17:06 laptop kernel: [72770.880663] iwlwifi 0000:01:00.0: 0x00000248 | l2p_control
Apr 18 08:17:06 laptop kernel: [72770.880665] iwlwifi 0000:01:00.0: 0x0000002C | l2p_duration
Apr 18 08:17:06 laptop kernel: [72770.880667] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
Apr 18 08:17:06 laptop kernel: [72770.880669] iwlwifi 0000:01:00.0: 0x001155F6 | l2p_addr_match
Apr 18 08:17:06 laptop kernel: [72770.880672] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
Apr 18 08:17:06 laptop kernel: [72770.880674] iwlwifi 0000:01:00.0: 0x13011136 | timestamp
Apr 18 08:17:06 laptop kernel: [72770.880676] iwlwifi 0000:01:00.0: 0x0000F808 | flow_handler
Apr 18 08:17:06 laptop kernel: [72770.880755] iwlwifi 0000:01:00.0: Start IWL Event Log Dump: display last 1 entries
Apr 18 08:17:06 laptop kernel: [72770.880796] iwlwifi 0000:01:00.0: EVT_LOGT:0219169983:0x0000010c:0123
Apr 18 08:17:08 laptop kernel: [72772.681119] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 08:17:08 laptop kernel: [72772.681494] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 08:17:08 laptop kernel: [72772.681495] ieee80211 phy3: Hardware restart was requested
Apr 18 08:17:08 laptop kernel: [72772.681499] wlan0: HW problem - can not stop rx aggregation for tid 0
Apr 18 08:17:08 laptop kernel: [72772.681503] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 08:17:08 laptop kernel: [72772.681505] wlan0: HW problem - can not stop rx aggregation for tid 1
Apr 18 08:17:08 laptop kernel: [72772.681508] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 08:17:08 laptop kernel: [72772.681509] wlan0: HW problem - can not stop rx aggregation for tid 5
Apr 18 08:17:08 laptop wpa_supplicant[1656]: wlan0: SME: Authentication request to the driver failed
Apr 18 08:17:08 laptop kernel: [72772.721074] wlan0: authenticate with c4:01:7c:1a:22:88
Apr 18 08:17:08 laptop kernel: [72772.721090] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 08:17:08 laptop kernel: [72772.721092] iwlwifi 0000:01:00.0: Adding station c4:01:7c:1a:22:88 failed.
Apr 18 08:17:08 laptop kernel: [72772.721094] iwlwifi 0000:01:00.0: Unable to add station c4:01:7c:1a:22:88 (-5)
Apr 18 08:17:08 laptop kernel: [72772.721096] wlan0: failed to insert STA entry for the AP (error -5)
Apr 18 08:17:08 laptop kernel: [72772.721303] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 08:17:08 laptop kernel: [72772.728257] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
Apr 18 08:17:09 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> disconnected
Apr 18 08:17:09 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Apr 18 08:17:09 laptop kernel: [72773.266836] wlan0: deauthenticating from c0:8a:de:38:68:c8 by local choice (reason=2)
Apr 18 08:17:09 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:13:b4:d8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:17:09 laptop kernel: [72773.269319] wlan0: authenticate with c4:01:7c:13:b4:d8
Apr 18 08:17:09 laptop kernel: [72773.273314] wlan0: send auth to c4:01:7c:13:b4:d8 (try 1/3)
Apr 18 08:17:09 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Apr 18 08:17:09 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c4:01:7c:13:b4:d8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:17:09 laptop kernel: [72773.475933] wlan0: send auth to c4:01:7c:13:b4:d8 (try 2/3)
Apr 18 08:17:09 laptop kernel: [72773.478420] wlan0: authenticated
Apr 18 08:17:09 laptop kernel: [72773.479953] wlan0: associate with c4:01:7c:13:b4:d8 (try 1/3)
Apr 18 08:17:09 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:17:09 laptop kernel: [72773.485418] wlan0: RX AssocResp from c4:01:7c:13:b4:d8 (capab=0x1 status=0 aid=95)
Apr 18 08:17:09 laptop wpa_supplicant[1656]: wlan0: Associated with c4:01:7c:13:b4:d8
Apr 18 08:17:09 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c4:01:7c:13:b4:d8 completed (reauth) [id=0 id_str=]
Apr 18 08:17:09 laptop kernel: [72773.494097] wlan0: associated
Apr 18 08:17:09 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:17:09 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C0:8A:DE:38:68:C8 (The_Nines_Guestroom) to C4:01:7C:13:B4:D8 (The_Nines_Guestroom)
Apr 18 08:17:59 laptop signond[26612]: ../../../../src/signond/signondaemon.cpp 360 init Failed to SUID root. Secure storage will not be available. 
Apr 18 08:26:53 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c0:8a:de:38:60:28 (SSID='The_Nines_Guestroom' freq=2412 MHz)
Apr 18 08:26:53 laptop kernel: [73356.344201] wlan0: authenticate with c0:8a:de:38:60:28
Apr 18 08:26:53 laptop kernel: [73356.346775] wlan0: send auth to c0:8a:de:38:60:28 (try 1/3)
Apr 18 08:26:53 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c0:8a:de:38:60:28 (SSID='The_Nines_Guestroom' freq=2412 MHz)
Apr 18 08:26:53 laptop kernel: [73356.348405] wlan0: authenticated
Apr 18 08:26:53 laptop kernel: [73356.348625] wlan0: waiting for beacon from c0:8a:de:38:60:28
Apr 18 08:26:53 laptop kernel: [73356.408189] wlan0: associate with c0:8a:de:38:60:28 (try 1/3)
Apr 18 08:26:53 laptop wpa_supplicant[1656]: wlan0: Associated with c0:8a:de:38:60:28
Apr 18 08:26:53 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:38:60:28 completed (reauth) [id=0 id_str=]
Apr 18 08:26:53 laptop kernel: [73356.412990] wlan0: RX AssocResp from c0:8a:de:38:60:28 (capab=0x1 status=0 aid=20)
Apr 18 08:26:53 laptop kernel: [73356.414598] wlan0: associated
Apr 18 08:26:53 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C4:01:7C:13:B4:D8 (The_Nines_Guestroom) to C0:8A:DE:38:60:28 (The_Nines_Guestroom)
Apr 18 08:26:53 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> authenticating
Apr 18 08:26:53 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:26:53 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:30:51 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:13:b4:d8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:30:51 laptop kernel: [73593.866322] wlan0: authenticate with c4:01:7c:13:b4:d8
Apr 18 08:30:51 laptop kernel: [73593.868884] wlan0: send auth to c4:01:7c:13:b4:d8 (try 1/3)
Apr 18 08:30:51 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> authenticating
Apr 18 08:30:51 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c4:01:7c:13:b4:d8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:30:51 laptop kernel: [73594.070425] wlan0: send auth to c4:01:7c:13:b4:d8 (try 2/3)
Apr 18 08:30:51 laptop kernel: [73594.072222] wlan0: authenticated
Apr 18 08:30:51 laptop kernel: [73594.072387] wlan0: waiting for beacon from c4:01:7c:13:b4:d8
Apr 18 08:30:51 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:30:51 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> disconnected
Apr 18 08:30:51 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Apr 18 08:30:51 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:12:61:78 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:30:51 laptop kernel: [73594.598067] wlan0: authenticate with c4:01:7c:12:61:78
Apr 18 08:30:51 laptop kernel: [73594.600552] wlan0: send auth to c4:01:7c:12:61:78 (try 1/3)
Apr 18 08:30:51 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c4:01:7c:12:61:78 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:30:51 laptop kernel: [73594.636158] wlan0: authenticated
Apr 18 08:30:51 laptop kernel: [73594.636283] wlan0: waiting for beacon from c4:01:7c:12:61:78
Apr 18 08:30:51 laptop kernel: [73594.649614] wlan0: associate with c4:01:7c:12:61:78 (try 1/3)
Apr 18 08:30:51 laptop kernel: [73594.666631] wlan0: RX AssocResp from c4:01:7c:12:61:78 (capab=0x1 status=0 aid=75)
Apr 18 08:30:51 laptop wpa_supplicant[1656]: wlan0: Associated with c4:01:7c:12:61:78
Apr 18 08:30:51 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c4:01:7c:12:61:78 completed (reauth) [id=0 id_str=]
Apr 18 08:30:51 laptop kernel: [73594.670365] wlan0: associated
Apr 18 08:30:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Apr 18 08:30:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:30:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:30:52 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C0:8A:DE:38:60:28 (The_Nines_Guestroom) to C4:01:7C:12:61:78 (The_Nines_Guestroom)
Apr 18 08:36:49 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c0:8a:de:38:68:c8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:36:49 laptop kernel: [73951.642277] wlan0: authenticate with c0:8a:de:38:68:c8
Apr 18 08:36:49 laptop kernel: [73951.642855] wlan0: direct probe to c0:8a:de:38:68:c8 (try 1/3)
Apr 18 08:36:49 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> authenticating
Apr 18 08:36:49 laptop kernel: [73951.845849] wlan0: send auth to c0:8a:de:38:68:c8 (try 2/3)
Apr 18 08:36:49 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c0:8a:de:38:68:c8 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 08:36:49 laptop kernel: [73951.849943] wlan0: authenticated
Apr 18 08:36:49 laptop kernel: [73951.853830] wlan0: associate with c0:8a:de:38:68:c8 (try 1/3)
Apr 18 08:36:49 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:36:49 laptop kernel: [73951.858271] wlan0: RX AssocResp from c0:8a:de:38:68:c8 (capab=0x421 status=0 aid=48)
Apr 18 08:36:49 laptop wpa_supplicant[1656]: wlan0: Associated with c0:8a:de:38:68:c8
Apr 18 08:36:49 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:38:68:c8 completed (reauth) [id=0 id_str=]
Apr 18 08:36:49 laptop kernel: [73951.863931] wlan0: associated
Apr 18 08:36:49 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:36:49 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C4:01:7C:12:61:78 (The_Nines_Guestroom) to C0:8A:DE:38:68:C8 (The_Nines_Guestroom)
Apr 18 08:42:50 laptop kernel: [74312.169018] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
Apr 18 08:42:50 laptop kernel: [74312.169023] iwlwifi 0000:01:00.0: CSR values:
Apr 18 08:42:50 laptop kernel: [74312.169024] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Apr 18 08:42:50 laptop kernel: [74312.169053] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00484b00
Apr 18 08:42:50 laptop kernel: [74312.169078] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X00000040
Apr 18 08:42:50 laptop kernel: [74312.169104] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169129] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169155] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169181] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X0000003c
Apr 18 08:42:50 laptop kernel: [74312.169206] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169232] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
Apr 18 08:42:50 laptop kernel: [74312.169257] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X000000b0
Apr 18 08:42:50 laptop kernel: [74312.169283] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X60560ffd
Apr 18 08:42:50 laptop kernel: [74312.169309] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X90000801
Apr 18 08:42:50 laptop kernel: [74312.169334] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X00030001
Apr 18 08:42:50 laptop kernel: [74312.169360] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080042
Apr 18 08:42:50 laptop kernel: [74312.169385] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X000073ed
Apr 18 08:42:50 laptop kernel: [74312.169411] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169436] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169470] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169499] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000078
Apr 18 08:42:50 laptop kernel: [74312.169524] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X8802b8cc
Apr 18 08:42:50 laptop kernel: [74312.169550] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
Apr 18 08:42:50 laptop kernel: [74312.169575] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169601] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Apr 18 08:42:50 laptop kernel: [74312.169626] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
Apr 18 08:42:50 laptop kernel: [74312.169628] iwlwifi 0000:01:00.0: FH register values:
Apr 18 08:42:50 laptop kernel: [74312.169663] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X009a8200
Apr 18 08:42:50 laptop kernel: [74312.169676] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X002baa10
Apr 18 08:42:50 laptop kernel: [74312.169688] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169701] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00811114
Apr 18 08:42:50 laptop kernel: [74312.169714] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Apr 18 08:42:50 laptop kernel: [74312.169727] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Apr 18 08:42:50 laptop kernel: [74312.169740] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169753] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Apr 18 08:42:50 laptop kernel: [74312.169766] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
Apr 18 08:42:50 laptop kernel: [74312.169768] iwlwifi 0000:01:00.0: Loaded firmware version: 18.168.6.1
Apr 18 08:42:50 laptop kernel: [74312.169912] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
Apr 18 08:42:50 laptop kernel: [74312.169913] iwlwifi 0000:01:00.0: Status: 0x0000004C, count: 6
Apr 18 08:42:50 laptop kernel: [74312.169915] iwlwifi 0000:01:00.0: 0x00000034 | NMI_INTERRUPT_WDG           
Apr 18 08:42:50 laptop kernel: [74312.169917] iwlwifi 0000:01:00.0: 0x00010564 | uPc
Apr 18 08:42:50 laptop kernel: [74312.169918] iwlwifi 0000:01:00.0: 0x0001054E | branchlink1
Apr 18 08:42:50 laptop kernel: [74312.169919] iwlwifi 0000:01:00.0: 0x00010580 | branchlink2
Apr 18 08:42:50 laptop kernel: [74312.169921] iwlwifi 0000:01:00.0: 0x0000DBEA | interruptlink1
Apr 18 08:42:50 laptop kernel: [74312.169922] iwlwifi 0000:01:00.0: 0x0000CE20 | interruptlink2
Apr 18 08:42:50 laptop kernel: [74312.169923] iwlwifi 0000:01:00.0: 0x00000002 | data1
Apr 18 08:42:50 laptop kernel: [74312.169925] iwlwifi 0000:01:00.0: 0x07030000 | data2
Apr 18 08:42:50 laptop kernel: [74312.169926] iwlwifi 0000:01:00.0: 0x0002617C | line
Apr 18 08:42:50 laptop kernel: [74312.169927] iwlwifi 0000:01:00.0: 0x70C021A5 | beacon time
Apr 18 08:42:50 laptop kernel: [74312.169929] iwlwifi 0000:01:00.0: 0x56187E5B | tsf low
Apr 18 08:42:50 laptop kernel: [74312.169930] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
Apr 18 08:42:50 laptop kernel: [74312.169931] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
Apr 18 08:42:50 laptop kernel: [74312.169933] iwlwifi 0000:01:00.0: 0x5BE0A874 | time gp2
Apr 18 08:42:50 laptop kernel: [74312.169934] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
Apr 18 08:42:50 laptop kernel: [74312.169935] iwlwifi 0000:01:00.0: 0x754312A8 | uCode version
Apr 18 08:42:50 laptop kernel: [74312.169937] iwlwifi 0000:01:00.0: 0x000000B0 | hw version
Apr 18 08:42:50 laptop kernel: [74312.169938] iwlwifi 0000:01:00.0: 0x00484B00 | board version
Apr 18 08:42:50 laptop kernel: [74312.169939] iwlwifi 0000:01:00.0: 0x0000001C | hcmd
Apr 18 08:42:50 laptop kernel: [74312.169941] iwlwifi 0000:01:00.0: 0x2F863048 | isr0
Apr 18 08:42:50 laptop kernel: [74312.169942] iwlwifi 0000:01:00.0: 0x11C9F800 | isr1
Apr 18 08:42:50 laptop kernel: [74312.169943] iwlwifi 0000:01:00.0: 0x00000F02 | isr2
Apr 18 08:42:50 laptop kernel: [74312.169945] iwlwifi 0000:01:00.0: 0x8547FCC3 | isr3
Apr 18 08:42:50 laptop kernel: [74312.169946] iwlwifi 0000:01:00.0: 0x00000000 | isr4
Apr 18 08:42:50 laptop kernel: [74312.169947] iwlwifi 0000:01:00.0: 0x00890110 | isr_pref
Apr 18 08:42:50 laptop kernel: [74312.169949] iwlwifi 0000:01:00.0: 0x0002617C | wait_event
Apr 18 08:42:50 laptop kernel: [74312.169950] iwlwifi 0000:01:00.0: 0x00000080 | l2p_control
Apr 18 08:42:50 laptop kernel: [74312.169951] iwlwifi 0000:01:00.0: 0x00000000 | l2p_duration
Apr 18 08:42:50 laptop kernel: [74312.169953] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
Apr 18 08:42:50 laptop kernel: [74312.169954] iwlwifi 0000:01:00.0: 0x00200200 | l2p_addr_match
Apr 18 08:42:50 laptop kernel: [74312.169955] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
Apr 18 08:42:50 laptop kernel: [74312.169957] iwlwifi 0000:01:00.0: 0x13011136 | timestamp
Apr 18 08:42:50 laptop kernel: [74312.169958] iwlwifi 0000:01:00.0: 0x00000010 | flow_handler
Apr 18 08:42:50 laptop kernel: [74312.170041] iwlwifi 0000:01:00.0: Start IWL Event Log Dump: display last 1 entries
Apr 18 08:42:50 laptop kernel: [74312.170059] iwlwifi 0000:01:00.0: EVT_LOGT:1541449840:0x0000010c:0123
Apr 18 08:42:52 laptop kernel: [74313.974786] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 08:42:52 laptop kernel: [74313.975211] ieee80211 phy3: Hardware restart was requested
Apr 18 08:42:52 laptop kernel: [74313.975395] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 08:42:52 laptop kernel: [74313.982193] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
Apr 18 08:58:50 laptop kernel: [75270.224281] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
Apr 18 08:58:50 laptop kernel: [75270.224286] iwlwifi 0000:01:00.0: CSR values:
Apr 18 08:58:50 laptop kernel: [75270.224288] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Apr 18 08:58:50 laptop kernel: [75270.224318] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00484b00
Apr 18 08:58:50 laptop kernel: [75270.224345] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X00000040
Apr 18 08:58:50 laptop kernel: [75270.224370] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224396] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224422] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224448] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X0000003c
Apr 18 08:58:50 laptop kernel: [75270.224473] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224499] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
Apr 18 08:58:50 laptop kernel: [75270.224524] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X000000b0
Apr 18 08:58:50 laptop kernel: [75270.224550] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X60560ffd
Apr 18 08:58:50 laptop kernel: [75270.224577] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X90000801
Apr 18 08:58:50 laptop kernel: [75270.224603] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X00030001
Apr 18 08:58:50 laptop kernel: [75270.224629] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080042
Apr 18 08:58:50 laptop kernel: [75270.224655] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X0000bbb4
Apr 18 08:58:50 laptop kernel: [75270.224681] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224707] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224733] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224758] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000078
Apr 18 08:58:50 laptop kernel: [75270.224784] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X8802b8cc
Apr 18 08:58:50 laptop kernel: [75270.224810] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
Apr 18 08:58:50 laptop kernel: [75270.224835] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.224861] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Apr 18 08:58:50 laptop kernel: [75270.224887] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
Apr 18 08:58:50 laptop kernel: [75270.224889] iwlwifi 0000:01:00.0: FH register values:
Apr 18 08:58:50 laptop kernel: [75270.224928] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X009a8200
Apr 18 08:58:50 laptop kernel: [75270.224948] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X002baa10
Apr 18 08:58:50 laptop kernel: [75270.224968] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000a8
Apr 18 08:58:50 laptop kernel: [75270.224989] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00811114
Apr 18 08:58:50 laptop kernel: [75270.225009] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Apr 18 08:58:50 laptop kernel: [75270.225029] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Apr 18 08:58:50 laptop kernel: [75270.225043] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.225069] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Apr 18 08:58:50 laptop kernel: [75270.225090] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
Apr 18 08:58:50 laptop kernel: [75270.225093] iwlwifi 0000:01:00.0: Loaded firmware version: 18.168.6.1
Apr 18 08:58:50 laptop kernel: [75270.225239] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
Apr 18 08:58:50 laptop kernel: [75270.225242] iwlwifi 0000:01:00.0: Status: 0x0000004C, count: 6
Apr 18 08:58:50 laptop kernel: [75270.225244] iwlwifi 0000:01:00.0: 0x00000034 | NMI_INTERRUPT_WDG           
Apr 18 08:58:50 laptop kernel: [75270.225247] iwlwifi 0000:01:00.0: 0x00010564 | uPc
Apr 18 08:58:50 laptop kernel: [75270.225249] iwlwifi 0000:01:00.0: 0x0001054E | branchlink1
Apr 18 08:58:50 laptop kernel: [75270.225251] iwlwifi 0000:01:00.0: 0x00010580 | branchlink2
Apr 18 08:58:50 laptop kernel: [75270.225253] iwlwifi 0000:01:00.0: 0x0000DBEA | interruptlink1
Apr 18 08:58:50 laptop kernel: [75270.225256] iwlwifi 0000:01:00.0: 0x0000CE20 | interruptlink2
Apr 18 08:58:50 laptop kernel: [75270.225258] iwlwifi 0000:01:00.0: 0x00000002 | data1
Apr 18 08:58:50 laptop kernel: [75270.225260] iwlwifi 0000:01:00.0: 0x07030000 | data2
Apr 18 08:58:50 laptop kernel: [75270.225262] iwlwifi 0000:01:00.0: 0x0002617C | line
Apr 18 08:58:50 laptop kernel: [75270.225264] iwlwifi 0000:01:00.0: 0x21802810 | beacon time
Apr 18 08:58:50 laptop kernel: [75270.225266] iwlwifi 0000:01:00.0: 0x8F4917F0 | tsf low
Apr 18 08:58:50 laptop kernel: [75270.225269] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
Apr 18 08:58:50 laptop kernel: [75270.225271] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
Apr 18 08:58:50 laptop kernel: [75270.225273] iwlwifi 0000:01:00.0: 0x391255C4 | time gp2
Apr 18 08:58:50 laptop kernel: [75270.225275] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
Apr 18 08:58:50 laptop kernel: [75270.225277] iwlwifi 0000:01:00.0: 0x754312A8 | uCode version
Apr 18 08:58:50 laptop kernel: [75270.225279] iwlwifi 0000:01:00.0: 0x000000B0 | hw version
Apr 18 08:58:50 laptop kernel: [75270.225282] iwlwifi 0000:01:00.0: 0x00484B00 | board version
Apr 18 08:58:50 laptop kernel: [75270.225284] iwlwifi 0000:01:00.0: 0x0000001C | hcmd
Apr 18 08:58:50 laptop kernel: [75270.225286] iwlwifi 0000:01:00.0: 0x2F863048 | isr0
Apr 18 08:58:50 laptop kernel: [75270.225288] iwlwifi 0000:01:00.0: 0x11C9F800 | isr1
Apr 18 08:58:50 laptop kernel: [75270.225291] iwlwifi 0000:01:00.0: 0x00000F02 | isr2
Apr 18 08:58:50 laptop kernel: [75270.225293] iwlwifi 0000:01:00.0: 0x8543FCC3 | isr3
Apr 18 08:58:50 laptop kernel: [75270.225295] iwlwifi 0000:01:00.0: 0x00000000 | isr4
Apr 18 08:58:50 laptop kernel: [75270.225297] iwlwifi 0000:01:00.0: 0x00890110 | isr_pref
Apr 18 08:58:50 laptop kernel: [75270.225299] iwlwifi 0000:01:00.0: 0x0002617C | wait_event
Apr 18 08:58:50 laptop kernel: [75270.225301] iwlwifi 0000:01:00.0: 0x00000148 | l2p_control
Apr 18 08:58:50 laptop kernel: [75270.225304] iwlwifi 0000:01:00.0: 0x00000030 | l2p_duration
Apr 18 08:58:50 laptop kernel: [75270.225306] iwlwifi 0000:01:00.0: 0x0000003F | l2p_mhvalid
Apr 18 08:58:50 laptop kernel: [75270.225308] iwlwifi 0000:01:00.0: 0x00010500 | l2p_addr_match
Apr 18 08:58:50 laptop kernel: [75270.225310] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
Apr 18 08:58:50 laptop kernel: [75270.225313] iwlwifi 0000:01:00.0: 0x13011136 | timestamp
Apr 18 08:58:50 laptop kernel: [75270.225315] iwlwifi 0000:01:00.0: 0x0000A8B0 | flow_handler
Apr 18 08:58:50 laptop kernel: [75270.225393] iwlwifi 0000:01:00.0: Start IWL Event Log Dump: display last 1 entries
Apr 18 08:58:50 laptop kernel: [75270.225441] iwlwifi 0000:01:00.0: EVT_LOGT:0957502912:0x0000010c:0123
Apr 18 08:58:51 laptop kernel: [75272.032652] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 08:58:51 laptop kernel: [75272.032790] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 08:58:51 laptop kernel: [75272.032793] wlan0: HW problem - can not stop rx aggregation for tid 0
Apr 18 08:58:51 laptop kernel: [75272.032796] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 08:58:51 laptop kernel: [75272.032798] wlan0: HW problem - can not stop rx aggregation for tid 1
Apr 18 08:58:51 laptop kernel: [75272.033224] ieee80211 phy3: Hardware restart was requested
Apr 18 08:58:51 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:38:68:c8 reason=4
Apr 18 08:58:51 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> disconnected
Apr 18 08:58:51 laptop kernel: [75272.040943] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 08:58:51 laptop kernel: [75272.047758] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
Apr 18 08:58:51 laptop kernel: [75272.048428] cfg80211: Calling CRDA to update world regulatory domain
Apr 18 08:58:51 laptop kernel: [75272.052109] cfg80211: World regulatory domain updated:
Apr 18 08:58:51 laptop kernel: [75272.052112] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 18 08:58:51 laptop kernel: [75272.052115] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 08:58:51 laptop kernel: [75272.052117] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 08:58:51 laptop kernel: [75272.052119] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 08:58:51 laptop kernel: [75272.052121] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 08:58:51 laptop kernel: [75272.052123] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 08:58:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Apr 18 08:58:52 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c0:8a:de:38:60:28 (SSID='The_Nines_Guestroom' freq=2412 MHz)
Apr 18 08:58:52 laptop kernel: [75272.575292] wlan0: authenticate with c0:8a:de:38:60:28
Apr 18 08:58:52 laptop kernel: [75272.585022] wlan0: send auth to c0:8a:de:38:60:28 (try 1/3)
Apr 18 08:58:52 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c0:8a:de:38:60:28 (SSID='The_Nines_Guestroom' freq=2412 MHz)
Apr 18 08:58:52 laptop kernel: [75272.633140] wlan0: authenticated
Apr 18 08:58:52 laptop kernel: [75272.633311] wlan0: waiting for beacon from c0:8a:de:38:60:28
Apr 18 08:58:52 laptop kernel: [75272.671693] wlan0: associate with c0:8a:de:38:60:28 (try 1/3)
Apr 18 08:58:52 laptop wpa_supplicant[1656]: wlan0: Associated with c0:8a:de:38:60:28
Apr 18 08:58:52 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:38:60:28 completed (reauth) [id=0 id_str=]
Apr 18 08:58:52 laptop kernel: [75272.680111] wlan0: RX AssocResp from c0:8a:de:38:60:28 (capab=0x1 status=0 aid=30)
Apr 18 08:58:52 laptop kernel: [75272.683004] wlan0: associated
Apr 18 08:58:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Apr 18 08:58:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 08:58:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 08:58:52 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C0:8A:DE:38:68:C8 (The_Nines_Guestroom) to C0:8A:DE:38:60:28 (The_Nines_Guestroom)
Apr 18 09:02:50 laptop kernel: [75510.688472] iwlwifi 0000:01:00.0: Microcode SW error detected.  Restarting 0x2000000.
Apr 18 09:02:50 laptop kernel: [75510.688478] iwlwifi 0000:01:00.0: CSR values:
Apr 18 09:02:50 laptop kernel: [75510.688481] iwlwifi 0000:01:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Apr 18 09:02:50 laptop kernel: [75510.688509] iwlwifi 0000:01:00.0:        CSR_HW_IF_CONFIG_REG: 0X00484b00
Apr 18 09:02:50 laptop kernel: [75510.688536] iwlwifi 0000:01:00.0:          CSR_INT_COALESCING: 0X00000040
Apr 18 09:02:50 laptop kernel: [75510.688562] iwlwifi 0000:01:00.0:                     CSR_INT: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.688588] iwlwifi 0000:01:00.0:                CSR_INT_MASK: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.688614] iwlwifi 0000:01:00.0:           CSR_FH_INT_STATUS: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.688639] iwlwifi 0000:01:00.0:                 CSR_GPIO_IN: 0X0000003c
Apr 18 09:02:50 laptop kernel: [75510.688665] iwlwifi 0000:01:00.0:                   CSR_RESET: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.688690] iwlwifi 0000:01:00.0:                CSR_GP_CNTRL: 0X080403c5
Apr 18 09:02:50 laptop kernel: [75510.688716] iwlwifi 0000:01:00.0:                  CSR_HW_REV: 0X000000b0
Apr 18 09:02:50 laptop kernel: [75510.688742] iwlwifi 0000:01:00.0:              CSR_EEPROM_REG: 0X60560ffd
Apr 18 09:02:50 laptop kernel: [75510.688768] iwlwifi 0000:01:00.0:               CSR_EEPROM_GP: 0X90000801
Apr 18 09:02:50 laptop kernel: [75510.688794] iwlwifi 0000:01:00.0:              CSR_OTP_GP_REG: 0X00030001
Apr 18 09:02:50 laptop kernel: [75510.688819] iwlwifi 0000:01:00.0:                 CSR_GIO_REG: 0X00080042
Apr 18 09:02:50 laptop kernel: [75510.688845] iwlwifi 0000:01:00.0:            CSR_GP_UCODE_REG: 0X0000acc8
Apr 18 09:02:50 laptop kernel: [75510.688870] iwlwifi 0000:01:00.0:           CSR_GP_DRIVER_REG: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.688896] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.688923] iwlwifi 0000:01:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.688949] iwlwifi 0000:01:00.0:                 CSR_LED_REG: 0X00000078
Apr 18 09:02:50 laptop kernel: [75510.688975] iwlwifi 0000:01:00.0:        CSR_DRAM_INT_TBL_REG: 0X8802b8cc
Apr 18 09:02:50 laptop kernel: [75510.689000] iwlwifi 0000:01:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
Apr 18 09:02:50 laptop kernel: [75510.689026] iwlwifi 0000:01:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.689052] iwlwifi 0000:01:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Apr 18 09:02:50 laptop kernel: [75510.689078] iwlwifi 0000:01:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
Apr 18 09:02:50 laptop kernel: [75510.689080] iwlwifi 0000:01:00.0: FH register values:
Apr 18 09:02:50 laptop kernel: [75510.689116] iwlwifi 0000:01:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X009a8200
Apr 18 09:02:50 laptop kernel: [75510.689137] iwlwifi 0000:01:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X002baa10
Apr 18 09:02:50 laptop kernel: [75510.689157] iwlwifi 0000:01:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.689178] iwlwifi 0000:01:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00811114
Apr 18 09:02:50 laptop kernel: [75510.689198] iwlwifi 0000:01:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Apr 18 09:02:50 laptop kernel: [75510.689234] iwlwifi 0000:01:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Apr 18 09:02:50 laptop kernel: [75510.689254] iwlwifi 0000:01:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.689280] iwlwifi 0000:01:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Apr 18 09:02:50 laptop kernel: [75510.689300] iwlwifi 0000:01:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
Apr 18 09:02:50 laptop kernel: [75510.689303] iwlwifi 0000:01:00.0: Loaded firmware version: 18.168.6.1
Apr 18 09:02:50 laptop kernel: [75510.689460] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
Apr 18 09:02:50 laptop kernel: [75510.689463] iwlwifi 0000:01:00.0: Status: 0x0000004C, count: 6
Apr 18 09:02:50 laptop kernel: [75510.689466] iwlwifi 0000:01:00.0: 0x00000034 | NMI_INTERRUPT_WDG           
Apr 18 09:02:50 laptop kernel: [75510.689468] iwlwifi 0000:01:00.0: 0x00010564 | uPc
Apr 18 09:02:50 laptop kernel: [75510.689470] iwlwifi 0000:01:00.0: 0x0001054E | branchlink1
Apr 18 09:02:50 laptop kernel: [75510.689472] iwlwifi 0000:01:00.0: 0x00010580 | branchlink2
Apr 18 09:02:50 laptop kernel: [75510.689475] iwlwifi 0000:01:00.0: 0x0000DBEA | interruptlink1
Apr 18 09:02:50 laptop kernel: [75510.689477] iwlwifi 0000:01:00.0: 0x0000CE22 | interruptlink2
Apr 18 09:02:50 laptop kernel: [75510.689479] iwlwifi 0000:01:00.0: 0x00000002 | data1
Apr 18 09:02:50 laptop kernel: [75510.689482] iwlwifi 0000:01:00.0: 0x07030000 | data2
Apr 18 09:02:50 laptop kernel: [75510.689484] iwlwifi 0000:01:00.0: 0x0002617C | line
Apr 18 09:02:50 laptop kernel: [75510.689487] iwlwifi 0000:01:00.0: 0x46002857 | beacon time
Apr 18 09:02:50 laptop kernel: [75510.689489] iwlwifi 0000:01:00.0: 0x5D4467A9 | tsf low
Apr 18 09:02:50 laptop kernel: [75510.689491] iwlwifi 0000:01:00.0: 0x00000000 | tsf hi
Apr 18 09:02:50 laptop kernel: [75510.689493] iwlwifi 0000:01:00.0: 0x00000000 | time gp1
Apr 18 09:02:50 laptop kernel: [75510.689496] iwlwifi 0000:01:00.0: 0x0E3CAAEA | time gp2
Apr 18 09:02:50 laptop kernel: [75510.689498] iwlwifi 0000:01:00.0: 0x00000000 | time gp3
Apr 18 09:02:50 laptop kernel: [75510.689500] iwlwifi 0000:01:00.0: 0x754312A8 | uCode version
Apr 18 09:02:50 laptop kernel: [75510.689503] iwlwifi 0000:01:00.0: 0x000000B0 | hw version
Apr 18 09:02:50 laptop kernel: [75510.689505] iwlwifi 0000:01:00.0: 0x00484B00 | board version
Apr 18 09:02:50 laptop kernel: [75510.689507] iwlwifi 0000:01:00.0: 0x0000001C | hcmd
Apr 18 09:02:50 laptop kernel: [75510.689510] iwlwifi 0000:01:00.0: 0x2F863048 | isr0
Apr 18 09:02:50 laptop kernel: [75510.689512] iwlwifi 0000:01:00.0: 0x11C9F800 | isr1
Apr 18 09:02:50 laptop kernel: [75510.689514] iwlwifi 0000:01:00.0: 0x00000F02 | isr2
Apr 18 09:02:50 laptop kernel: [75510.689516] iwlwifi 0000:01:00.0: 0x8543FCC3 | isr3
Apr 18 09:02:50 laptop kernel: [75510.689519] iwlwifi 0000:01:00.0: 0x00000000 | isr4
Apr 18 09:02:50 laptop kernel: [75510.689521] iwlwifi 0000:01:00.0: 0x00890110 | isr_pref
Apr 18 09:02:50 laptop kernel: [75510.689523] iwlwifi 0000:01:00.0: 0x0002617C | wait_event
Apr 18 09:02:50 laptop kernel: [75510.689525] iwlwifi 0000:01:00.0: 0x000000D4 | l2p_control
Apr 18 09:02:50 laptop kernel: [75510.689528] iwlwifi 0000:01:00.0: 0x00000000 | l2p_duration
Apr 18 09:02:50 laptop kernel: [75510.689530] iwlwifi 0000:01:00.0: 0x00000007 | l2p_mhvalid
Apr 18 09:02:50 laptop kernel: [75510.689532] iwlwifi 0000:01:00.0: 0x00101042 | l2p_addr_match
Apr 18 09:02:50 laptop kernel: [75510.689535] iwlwifi 0000:01:00.0: 0x00000005 | lmpm_pmg_sel
Apr 18 09:02:50 laptop kernel: [75510.689537] iwlwifi 0000:01:00.0: 0x13011136 | timestamp
Apr 18 09:02:50 laptop kernel: [75510.689539] iwlwifi 0000:01:00.0: 0x00000010 | flow_handler
Apr 18 09:02:50 laptop kernel: [75510.689620] iwlwifi 0000:01:00.0: Start IWL Event Log Dump: display last 1 entries
Apr 18 09:02:50 laptop kernel: [75510.689660] iwlwifi 0000:01:00.0: EVT_LOGT:0238856934:0x0000010c:0123
Apr 18 09:02:52 laptop kernel: [75512.498704] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:02:52 laptop kernel: [75512.499085] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 09:02:52 laptop kernel: [75512.499088] ieee80211 phy3: Hardware restart was requested
Apr 18 09:02:52 laptop kernel: [75512.499091] wlan0: HW problem - can not stop rx aggregation for tid 0
Apr 18 09:02:52 laptop kernel: [75512.499093] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 09:02:52 laptop kernel: [75512.499094] wlan0: HW problem - can not stop rx aggregation for tid 1
Apr 18 09:02:52 laptop kernel: [75512.499096] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 09:02:52 laptop kernel: [75512.499097] wlan0: HW problem - can not stop rx aggregation for tid 5
Apr 18 09:02:52 laptop kernel: [75512.499099] iwlwifi 0000:01:00.0: Fw not loaded - dropping CMD: 18
Apr 18 09:02:52 laptop kernel: [75512.499100] wlan0: HW problem - can not stop rx aggregation for tid 6
Apr 18 09:02:52 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-DISCONNECTED bssid=c0:8a:de:38:60:28 reason=4
Apr 18 09:02:52 laptop kernel: [75512.506752] cfg80211: Calling CRDA to update world regulatory domain
Apr 18 09:02:52 laptop kernel: [75512.506816] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 09:02:52 laptop kernel: [75512.509498] cfg80211: World regulatory domain updated:
Apr 18 09:02:52 laptop kernel: [75512.509501] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 18 09:02:52 laptop kernel: [75512.509502] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:52 laptop kernel: [75512.509504] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:52 laptop kernel: [75512.509505] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:52 laptop kernel: [75512.509506] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:52 laptop kernel: [75512.509507] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:52 laptop kernel: [75512.513631] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
Apr 18 09:02:52 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> scanning
Apr 18 09:02:53 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:14:ab:bc (SSID='The_Nines_Guestroom' freq=5180 MHz)
Apr 18 09:02:53 laptop kernel: [75513.005684] wlan0: authenticate with c4:01:7c:14:ab:bc
Apr 18 09:02:53 laptop kernel: [75513.010390] wlan0: send auth to c4:01:7c:14:ab:bc (try 1/3)
Apr 18 09:02:53 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Apr 18 09:02:53 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c4:01:7c:14:ab:bc (SSID='The_Nines_Guestroom' freq=5180 MHz)
Apr 18 09:02:53 laptop kernel: [75513.213661] wlan0: send auth to c4:01:7c:14:ab:bc (try 2/3)
Apr 18 09:02:53 laptop kernel: [75513.214146] wlan0: authenticated
Apr 18 09:02:53 laptop kernel: [75513.214324] wlan0: waiting for beacon from c4:01:7c:14:ab:bc
Apr 18 09:02:53 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 09:02:53 laptop kernel: [75513.305492] wlan0: associate with c4:01:7c:14:ab:bc (try 1/3)
Apr 18 09:02:53 laptop kernel: [75513.307964] wlan0: RX AssocResp from c4:01:7c:14:ab:bc (capab=0x401 status=0 aid=73)
Apr 18 09:02:53 laptop wpa_supplicant[1656]: wlan0: Associated with c4:01:7c:14:ab:bc
Apr 18 09:02:53 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c4:01:7c:14:ab:bc completed (reauth) [id=0 id_str=]
Apr 18 09:02:53 laptop kernel: [75513.310273] wlan0: associated
Apr 18 09:02:53 laptop kernel: [75513.310372] cfg80211: Calling CRDA for country: US
Apr 18 09:02:53 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 09:02:53 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C0:8A:DE:38:60:28 (The_Nines_Guestroom) to C4:01:7C:14:AB:BC (The_Nines_Guestroom)
Apr 18 09:02:53 laptop kernel: [75513.315079] cfg80211: Regulatory domain changed to country: US
Apr 18 09:02:53 laptop kernel: [75513.315083] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 18 09:02:53 laptop kernel: [75513.315086] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Apr 18 09:02:53 laptop kernel: [75513.315088] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Apr 18 09:02:53 laptop kernel: [75513.315090] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:53 laptop kernel: [75513.315091] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:53 laptop kernel: [75513.315093] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:02:53 laptop kernel: [75513.315095] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Apr 18 09:04:02 laptop kernel: [75582.526459] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:04:04 laptop kernel: [75584.531482] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:04:04 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-DISCONNECTED bssid=c4:01:7c:14:ab:bc reason=4
Apr 18 09:04:04 laptop kernel: [75584.565724] cfg80211: Calling CRDA to update world regulatory domain
Apr 18 09:04:04 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> disconnected
Apr 18 09:04:04 laptop kernel: [75584.568458] cfg80211: World regulatory domain updated:
Apr 18 09:04:04 laptop kernel: [75584.568461] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 18 09:04:04 laptop kernel: [75584.568462] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:04:04 laptop kernel: [75584.568464] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:04:04 laptop kernel: [75584.568465] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:04:04 laptop kernel: [75584.568466] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:04:04 laptop kernel: [75584.568467] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:04:04 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Apr 18 09:04:05 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c0:8a:de:36:87:28 (SSID='The_Nines_Guestroom' freq=2462 MHz)
Apr 18 09:04:05 laptop kernel: [75585.088637] wlan0: authenticate with c0:8a:de:36:87:28
Apr 18 09:04:05 laptop kernel: [75585.092427] wlan0: send auth to c0:8a:de:36:87:28 (try 1/3)
Apr 18 09:04:05 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Apr 18 09:04:05 laptop kernel: [75585.294329] wlan0: send auth to c0:8a:de:36:87:28 (try 2/3)
Apr 18 09:04:05 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c0:8a:de:36:87:28 (SSID='The_Nines_Guestroom' freq=2462 MHz)
Apr 18 09:04:05 laptop kernel: [75585.498030] wlan0: send auth to c0:8a:de:36:87:28 (try 3/3)
Apr 18 09:04:05 laptop kernel: [75585.499693] wlan0: authenticated
Apr 18 09:04:05 laptop kernel: [75585.499848] wlan0: waiting for beacon from c0:8a:de:36:87:28
Apr 18 09:04:05 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 09:04:05 laptop kernel: [75585.589890] wlan0: associate with c0:8a:de:36:87:28 (try 1/3)
Apr 18 09:04:05 laptop kernel: [75585.595612] wlan0: RX AssocResp from c0:8a:de:36:87:28 (capab=0x1 status=0 aid=51)
Apr 18 09:04:05 laptop wpa_supplicant[1656]: wlan0: Associated with c0:8a:de:36:87:28
Apr 18 09:04:05 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c0:8a:de:36:87:28 completed (reauth) [id=0 id_str=]
Apr 18 09:04:05 laptop kernel: [75585.601351] wlan0: associated
Apr 18 09:04:05 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 09:04:05 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C4:01:7C:14:AB:BC (The_Nines_Guestroom) to C0:8A:DE:36:87:28 (The_Nines_Guestroom)
Apr 18 09:04:50 laptop wpa_supplicant[1656]: wlan0: SME: Trying to authenticate with c4:01:7c:12:61:78 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 09:04:50 laptop kernel: [75629.961176] wlan0: authenticate with c4:01:7c:12:61:78
Apr 18 09:04:50 laptop wpa_supplicant[1656]: wlan0: Trying to associate with c4:01:7c:12:61:78 (SSID='The_Nines_Guestroom' freq=2437 MHz)
Apr 18 09:04:50 laptop kernel: [75629.964167] wlan0: send auth to c4:01:7c:12:61:78 (try 1/3)
Apr 18 09:04:50 laptop kernel: [75629.966179] wlan0: authenticated
Apr 18 09:04:50 laptop kernel: [75629.966284] wlan0: waiting for beacon from c4:01:7c:12:61:78
Apr 18 09:04:50 laptop kernel: [75629.967927] wlan0: associate with c4:01:7c:12:61:78 (try 1/3)
Apr 18 09:04:50 laptop kernel: [75629.981960] wlan0: RX AssocResp from c4:01:7c:12:61:78 (capab=0x1 status=0 aid=77)
Apr 18 09:04:50 laptop wpa_supplicant[1656]: wlan0: Associated with c4:01:7c:12:61:78
Apr 18 09:04:50 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-CONNECTED - Connection to c4:01:7c:12:61:78 completed (reauth) [id=0 id_str=]
Apr 18 09:04:50 laptop kernel: [75629.983903] wlan0: associated
Apr 18 09:04:50 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C0:8A:DE:36:87:28 (The_Nines_Guestroom) to C4:01:7C:12:61:78 (The_Nines_Guestroom)
Apr 18 09:04:50 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: completed -> authenticating
Apr 18 09:04:50 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: authenticating -> associating
Apr 18 09:04:50 laptop NetworkManager[764]: <info> (wlan0): supplicant interface state: associating -> completed
Apr 18 09:06:53 laptop kernel: [75752.513417] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:08:57 laptop kernel: [75876.436960] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:09:22 laptop kernel: [75902.053264] wlan0: deauthenticating from c4:01:7c:12:61:78 by local choice (reason=3)
Apr 18 09:09:24 laptop kernel: [75904.055845] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:09:26 laptop kernel: [75906.060861] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:09:28 laptop wpa_supplicant[1656]: wlan0: CTRL-EVENT-DISCONNECTED bssid=c4:01:7c:12:61:78 reason=3
Apr 18 09:09:28 laptop kernel: [75908.073856] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Apr 18 09:09:28 laptop kernel: [75908.074050] cfg80211: Calling CRDA to update world regulatory domain
Apr 18 09:09:28 laptop avahi-daemon[9411]: Interface wlan0.IPv6 no longer relevant for mDNS.
Apr 18 09:09:28 laptop avahi-daemon[9411]: Leaving mDNS multicast group on interface wlan0.IPv6 with address fe80::c685:8ff:fe86:9ad4.
Apr 18 09:09:28 laptop avahi-daemon[9411]: Interface wlan0.IPv4 no longer relevant for mDNS.
Apr 18 09:09:28 laptop avahi-daemon[9411]: Leaving mDNS multicast group on interface wlan0.IPv4 with address 10.12.47.157.
Apr 18 09:09:28 laptop dhclient: receive_packet failed on wlan0: Network is down
Apr 18 09:09:28 laptop NetworkManager[764]: <info> (wlan0): roamed from BSSID C4:01:7C:12:61:78 (The_Nines_Guestroom) to (none) ((none))
Apr 18 09:09:28 laptop NetworkManager[764]:    SCPlugin-Ifupdown: devices removed (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net/wlan0, iface: wlan0)
Apr 18 09:09:28 laptop NetworkManager[764]: <info> radio killswitch /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ieee80211/phy3/rfkill9 disappeared
Apr 18 09:09:28 laptop NetworkManager[764]: <info> (wlan0): device state change: activated -> unmanaged (reason 'removed') [100 10 36]
Apr 18 09:09:28 laptop NetworkManager[764]: <info> (wlan0): deactivating device (reason 'removed') [36]
Apr 18 09:09:28 laptop kernel: [75908.162569] cfg80211: World regulatory domain updated:
Apr 18 09:09:28 laptop kernel: [75908.162573] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 18 09:09:28 laptop kernel: [75908.162576] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:09:28 laptop kernel: [75908.162578] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:09:28 laptop kernel: [75908.162580] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:09:28 laptop kernel: [75908.162582] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:09:28 laptop kernel: [75908.162584] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): canceled DHCP transaction, DHCP client pid 26484
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> sysctl: failed to open '/proc/sys/net/ipv6/conf/wlan0/accept_ra': (2) No such file or directory
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> sysctl: failed to open '/proc/sys/net/ipv6/conf/wlan0/use_tempaddr': (2) No such file or directory
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> (6) failed to find interface name for index
Apr 18 09:09:29 laptop NetworkManager[764]: (nm-system.c:766):nm_system_iface_get_flags: runtime check failed: (iface != NULL)
Apr 18 09:09:29 laptop NetworkManager[764]: <error> [1366301369.113673] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to get interface link object
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> (6) failed to find interface name for index
Apr 18 09:09:29 laptop NetworkManager[764]: (nm-system.c:766):nm_system_iface_get_flags: runtime check failed: (iface != NULL)
Apr 18 09:09:29 laptop NetworkManager[764]: <error> [1366301369.113764] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to get interface link object
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): bringing up device.
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> (6) failed to find interface name for index
Apr 18 09:09:29 laptop NetworkManager[764]: nm_system_iface_flush_routes: assertion `iface != NULL' failed
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> (6) failed to find interface name for index
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> DNS: plugin dnsmasq update failed
Apr 18 09:09:29 laptop NetworkManager[764]: <info> Removing DNS information from /sbin/resolvconf
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): cleaning up...
Apr 18 09:09:29 laptop NetworkManager[764]: <warn> (6) failed to find interface name for index
Apr 18 09:09:29 laptop NetworkManager[764]: (nm-system.c:766):nm_system_iface_get_flags: runtime check failed: (iface != NULL)
Apr 18 09:09:29 laptop NetworkManager[764]: <error> [1366301369.167004] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to get interface link object
Apr 18 09:09:29 laptop NetworkManager[764]: <info> Unmanaged Device found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/191889)
Apr 18 09:09:29 laptop wpa_supplicant[1656]: Could not read interface wlan0 flags: No such device
Apr 18 09:09:29 laptop kernel: [75908.987916] Intel(R) Wireless WiFi driver for Linux, in-tree:
Apr 18 09:09:29 laptop kernel: [75908.987920] Copyright(c) 2003-2012 Intel Corporation
Apr 18 09:09:29 laptop kernel: [75908.988179] iwlwifi 0000:01:00.0: irq 44 for MSI/MSI-X
Apr 18 09:09:29 laptop kernel: [75908.988458] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1
Apr 18 09:09:29 laptop kernel: [75909.004542] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG disabled
Apr 18 09:09:29 laptop kernel: [75909.004547] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
Apr 18 09:09:29 laptop kernel: [75909.004549] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
Apr 18 09:09:29 laptop kernel: [75909.004552] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
Apr 18 09:09:29 laptop kernel: [75909.004554] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P disabled
Apr 18 09:09:29 laptop kernel: [75909.004557] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6235 AGN, REV=0xB0
Apr 18 09:09:29 laptop kernel: [75909.004672] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 09:09:29 laptop kernel: [75909.020745] ieee80211 phy4: Selected rate control algorithm 'iwl-agn-rs'
Apr 18 09:09:29 laptop NetworkManager[764]: <info> rfkill21: found WiFi radio killswitch (at /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ieee80211/phy4/rfkill21) (driver iwlwifi)
Apr 18 09:09:29 laptop NetworkManager[764]:    SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net/wlan0, iface: wlan0)
Apr 18 09:09:29 laptop NetworkManager[764]:    SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net/wlan0, iface: wlan0): no ifupdown configuration found.
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): using nl80211 for WiFi device control
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): driver supports Access Point (AP) mode
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): new 802.11 WiFi device (driver: 'iwlwifi' ifindex: 8)
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): exported as /org/freedesktop/NetworkManager/Devices/6
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Apr 18 09:09:29 laptop NetworkManager[764]: <info> (wlan0): bringing up device.
Apr 18 09:09:29 laptop kernel: [75909.029172] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 09:09:29 laptop kernel: [75909.035993] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
Apr 18 09:09:30 laptop kernel: [75909.426870] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
Apr 18 09:09:30 laptop kernel: [75909.433781] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
