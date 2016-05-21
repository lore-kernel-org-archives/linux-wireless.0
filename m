Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36809 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbcEUKj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2016 06:39:26 -0400
Received: by mail-wm0-f47.google.com with SMTP id n129so14683324wmn.1
        for <linux-wireless@vger.kernel.org>; Sat, 21 May 2016 03:39:25 -0700 (PDT)
Subject: Re: Concurrent AP and STA mode issues with power mgt on BCM43438
To: Barry Reinhold <BarryReinhold@lnihealth.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <CY1PR19MB0614F5F5B4CE8B540CE589AAA7770@CY1PR19MB0614.namprd19.prod.outlook.com>
Cc: Tom Harada <TomHarada@lnihealth.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57403AD9.7040306@broadcom.com> (sfid-20160521_130000_086241_C023E5A1)
Date: Sat, 21 May 2016 12:39:21 +0200
MIME-Version: 1.0
In-Reply-To: <CY1PR19MB0614F5F5B4CE8B540CE589AAA7770@CY1PR19MB0614.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-05-16 02:56, Barry Reinhold wrote:
> 
> Hi,
> 
> [This is a follow on to the thread entitled Limit rate of BCM34348 on Raspberry PI-3 via brcmfmac, but since our understanding of the issue has changed we are starting a new thread.]
> 
> We have been attempting to get a Raspberry PI-3 (RPI3) to operate concurrently  as both a STA and an AP. When we associate a Nexus-6  with the RPI3's AP ing the Nexus-6 from the RPI3 we see no ping loss. We then connect the RPI3 as a station with a Cisco Linksys E1200. As soon as we do this the over 90% of the ping messages are dropped between the RPI3 and the Nexus-6.  If we then kill the wpa_supplicant on the RPI-3, the pings again operate with loss.

How did you setup STA and AP, ie. what commands/tools did you use?

> In debugging this problem we see:
> 1. The Nexus-6 lose it association with the RPI3. This generally recovers and does not seem to be the cause of the delay/loss of the pings.
> 2. A tcpdump taken on the RPI3 will shows the expected number of ICMP echo requests, but will not show the expected number of ICMP echo responses.
> 3. When captured "in the air" from a third device using a WiFi adapter (Aircrack-ng using monitor mode) we do not see the expected number of ICMP echo requests. A trace is attached.
> 
> We noticed that not all devices when acting as clients of the RPI3's AP had this problem. After some investigation we discovered that if we disabled wifi power management on these devices that we not see the loss of the pings.
> 
> We then disabled (Blacklisted the brcmfmac) and added an external dongle (TP-LINK TL-WN722N) and repeated the tests. When this dongle was used we did not see the associated packet loss on the RPI3's AP.

So TP-LINK dongle is inserted on RPi3 and acting as AP and STA same as
the bcm43438.

> Throughout the testing all communications have been in channel 1 to ensure that the AP and the STA can work together and Bluetooth was disabled.

So both Cisco AP and RPi3 AP beacons are seen on channel 1? I am asking
because the attached capture only shows 1 beacon from RPi3. Could you
also run the test without WPA. The data packets in the capture are
encrypted hence no ICMP messages are shown.

Regards,
Arend

> At this point we are a bit lost as what to do next. We need a solution that does not require us to configure the client device which is being used to connect to the AP. We are also not able to use an external Wifi dongle.
> 
> We would appreciate guidance in terms of what we could try, as well as insight into the nature of the issue.
> 
> Below are some configuration details:
> 
> 
> Components in the test system:
> 
> 1. Cisco Linksys E1200 which is connected to the ethernet and provides the AP to which the RPI-3 connects
> 2. A RPI-3 (Raspian 8.0, with Kernel 4.4.10-v7+, brcfmac 7.45.41.23 firmware 01-cc4eda9c)
> 3. A Google Nexus-6 running Android 6.0.1, and JuiceSSH 2.1.2
> 
> Configuration of the RPI3:
> 
> cat /etc/os-release 
> PRETTY_NAME="Raspbian GNU/Linux 8 (jessie)"
> NAME="Raspbian GNU/Linux"
> VERSION_ID="8"
> VERSION="8 (jessie)"
> ID=raspbian
> ID_LIKE=debian
> HOME_URL="http://www.raspbian.org/"
> SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
> BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"
> root@raspberrypi:/home/pi# uname -a
> Linux raspberrypi 4.4.10-v7+ #885 SMP Fri May 13 15:44:27 BST 2016 armv7l GNU/Linux
> 
> host apd configuration
> root@raspberrypi:/home/pi# cat /etc/hostapd/hostapd.conf 
> ctrl_interface=/var/run/hostapd
> interface=uap0
> ssid=Health@Home Hub b827ebeb46b2
> hw_mode=g
> channel=1
> auth_algs=1
> wpa=2
> wpa_passphrase=juniperbranch
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP
> rsn_pairwise=CCMP
> 
> wpa_supplicant configuration:
> root@raspberrypi:/home/pi# cat cisco.wpa 
> network={
> 	ssid="CISCO-Linksys-E1200"
> 	#psk="---------?"
> 	psk=2e06fdb031cfc0e0c58e56d61657bd9a7912769e1d7a6bead31f0db99455c071
> }
> 
> startup log:
> root@raspberrypi:/home/pi# May 16 22:02:58 raspberrypi hostapd[512]: uap0: STA 00:21:6a:67:b1:9a IEEE 802.11: associated
> May 16 22:02:58 raspberrypi hostapd[512]: uap0: STA 00:21:6a:67:b1:9a RADIUS: starting accounting session 573A40EE-00000000
> May 16 22:02:58 raspberrypi hostapd[512]: uap0: STA 00:21:6a:67:b1:9a WPA: pairwise key handshake completed (RSN)
> May 16 22:03:01 raspberrypi dnsmasq-dhcp[446]: DHCPDISCOVER(uap0) 00:21:6a:67:b1:9a
> May 16 22:03:01 raspberrypi dnsmasq-dhcp[446]: DHCPOFFER(uap0) 192.168.2.78 00:21:6a:67:b1:9a
> May 16 22:03:01 raspberrypi dnsmasq-dhcp[446]: DHCPREQUEST(uap0) 192.168.2.78 00:21:6a:67:b1:9a
> May 16 22:03:01 raspberrypi dnsmasq-dhcp[446]: DHCPACK(uap0) 192.168.2.78 00:21:6a:67:b1:9a
> £[K
> root@raspberrypi:/home/pi# May 16 22:05:59 raspberrypi hostapd[512]: uap0: STA 9c:d9:17:6b:5e:20 IEEE 802.11: associated
> May 16 22:05:59 raspberrypi hostapd[512]: uap0: STA 9c:d9:17:6b:5e:20 RADIUS: starting accounting session 573A40EE-00000001
> May 16 22:05:59 raspberrypi hostapd[512]: uap0: STA 9c:d9:17:6b:5e:20 WPA: pairwise key handshake completed (RSN)
> May 16 22:06:02 raspberrypi dnsmasq-dhcp[446]: DHCPDISCOVER(uap0) 9c:d9:17:6b:5e:20
> May 16 22:06:02 raspberrypi dnsmasq-dhcp[446]: DHCPOFFER(uap0) 192.168.2.52 9c:d9:17:6b:5e:20
> May 16 22:06:02 raspberrypi dnsmasq-dhcp[446]: DHCPREQUEST(uap0) 192.168.2.52 9c:d9:17:6b:5e:20
> May 16 22:06:02 raspberrypi dnsmasq-dhcp[446]: DHCPACK(uap0) 192.168.2.52 9c:d9:17:6b:5e:20 android-72ac23268335f965
> wpa_supplicant -i wlan0 -c cisco.wpa -d -t
> 1463436647.471216: wpa_supplicant v2.3
> 1463436647.478375: random: Trying to read entropy from /dev/random
> 1463436647.478484: Successfully initialized wpa_supplicant
> 1463436647.478524: Initializing interface 'wlan0' conf 'cisco.wpa' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
> 1463436647.478590: Configuration file 'cisco.wpa' -> '/home/pi/cisco.wpa'
> 1463436647.478724: Reading configuration file '/home/pi/cisco.wpa'
> 1463436647.478921: Priority group 0
> 1463436647.478946:    id=0 ssid='CISCO-Linksys-E1200'
> 1463436647.486093: rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
> 1463436647.486139: rfkill: initial event: idx=1 type=2 op=0 soft=0 hard=0
> 1463436647.490290: nl80211: Using driver-based roaming
> 1463436647.490322: nl80211: TDLS supported
> 1463436647.490367: nl80211: Supported cipher 00-0f-ac:1
> 1463436647.490393: nl80211: Supported cipher 00-0f-ac:5
> 1463436647.490414: nl80211: Supported cipher 00-0f-ac:2
> 1463436647.490435: nl80211: Supported cipher 00-0f-ac:4
> 1463436647.490455: nl80211: Supported cipher 00-0f-ac:6
> 1463436647.490579: nl80211: Using driver-based off-channel TX
> 1463436647.490638: nl80211: Supported vendor command: vendor_id=0x1018 subcmd=1
> 1463436647.490687: nl80211: Use separate P2P group interface (driver advertised support)
> 1463436647.490709: nl80211: Enable multi-channel concurrent (driver advertised support)
> 1463436647.490730: nl80211: interface wlan0 in phy phy0
> 1463436647.491199: nl80211: Set mode ifindex 3 iftype 2 (STATION)
> 1463436647.491304: nl80211: Subscribe to mgmt frames with non-AP handle 0x564c5c08
> 1463436647.491347: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040a
> 1463436647.491427: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040b
> 1463436647.491503: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040c
> 1463436647.491578: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040d
> 1463436647.491651: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090a
> 1463436647.491725: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090b
> 1463436647.491799: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090c
> 1463436647.491872: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090d
> 1463436647.491951: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0409506f9a09
> 1463436647.492030: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=7f506f9a09
> 1463436647.492234: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0801
> 1463436647.492313: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040e
> 1463436647.492403: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=06
> 1463436647.492478: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0a07
> 1463436647.492552: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0a11
> 1463436647.493066: netlink: Operstate: ifindex=3 linkmode=1 (userspace-control), operstate=5 (IF_OPER_DORMANT)
> 1463436647.493610: nl80211: driver param='(null)'
> 1463436647.493644: Add interface wlan0 to a new radio phy0
> 1463436647.494422: nl80211: Regulatory information - country=00
> 1463436647.494458: nl80211: 2402-2472 @ 40 MHz 20 mBm
> 1463436647.494489: nl80211: 2457-2482 @ 40 MHz 20 mBm (no IR)
> 1463436647.494518: nl80211: 2474-2494 @ 20 MHz 20 mBm (no OFDM) (no IR)
> 1463436647.494547: nl80211: 5170-5250 @ 80 MHz 20 mBm (no IR)
> 1463436647.494574: nl80211: 5250-5330 @ 80 MHz 20 mBm (DFS) (no IR)
> 1463436647.494602: nl80211: 5490-5730 @ 160 MHz 20 mBm (DFS) (no IR)
> 1463436647.494631: nl80211: 5735-5835 @ 80 MHz 20 mBm (no IR)
> 1463436647.494658: nl80211: 57240-63720 @ 2160 MHz 0 mBm
> 1463436647.494737: nl80211: Added 802.11b mode based on 802.11g information
> 1463436647.494763: nl80211: Do not indicate P2P_DEVICE support (p2p_device=1 driver param not specified)
> 1463436647.602146: wlan0: Own MAC address: b8:27:eb:eb:46:b2
> 1463436647.602230: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=0 set_tx=0 seq_len=0 key_len=0
> 1463436647.602367: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
> 1463436647.602421: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
> 1463436647.602473: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
> 1463436647.602524: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=4 set_tx=0 seq_len=0 key_len=0
> 1463436647.602575: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=0 addr=(nil) key_idx=5 set_tx=0 seq_len=0 key_len=0
> 1463436647.602617: wlan0: RSN: flushing PMKID list in the driver
> 1463436647.602629: nl80211: Flush PMKIDs
> 1463436647.672105: TDLS: TDLS operation supported by driver
> 1463436647.672126: TDLS: Driver uses internal link setup
> 1463436647.672261: wlan0: WPS: UUID based on MAC address: f2d05241-a083-5270-873a-ee5fec1c466e
> 1463436647.679074: EAPOL: SUPP_PAE entering state DISCONNECTED
> 1463436647.679100: EAPOL: Supplicant port status: Unauthorized
> 1463436647.679111: nl80211: Skip set_supp_port(unauthorized) while not associated
> 1463436647.679123: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
> 1463436647.679134: EAPOL: SUPP_BE entering state INITIALIZE
> 1463436647.679145: EAP: EAP entering state DISABLED
> 1463436647.679286: P2P: Add operating class 81
> 1463436647.679303: P2P: Channels - hexdump(len=11): 01 02 03 04 05 06 07 08 09 0a 0b
> 1463436647.680368: P2P: Own listen channel: 81:11
> 1463436647.681256: P2P: Random operating channel: 81:6
> 1463436647.682278: P2P: initialized
> 1463436647.682306: P2P: channels: 81:1,2,3,4,5,6,7,8,9,10,11
> 1463436647.682320: P2P: cli_channels:
> 1463436647.682362: wlan0: Added interface wlan0
> 1463436647.682380: wlan0: State: DISCONNECTED -> DISCONNECTED
> 1463436647.682392: nl80211: Set wlan0 operstate 0->0 (DORMANT)
> 1463436647.682405: netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=5 (IF_OPER_DORMANT)
> 1463436647.682490: random: Got 20/20 bytes from /dev/random
> 1463436647.682550: RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=2 linkmode=1 ifi_family=0 ifi_flags=0x1003 ([UP])
> 1463436647.706342: wlan0: Starting delayed sched scan
> 1463436647.706369: wlan0: Use normal scan instead of sched_scan for initial scans (normal_scans=0)
> 1463436647.706387: wlan0: Setting scan request: 0.000000 sec
> 1463436647.706423: wlan0: State: DISCONNECTED -> SCANNING
> 1463436647.706443: wlan0: Starting AP scan for wildcard SSID
> 1463436647.706455: WPS: Building WPS IE for Probe Request
> 1463436647.706468: WPS:  * Version (hardcoded 0x10)
> 1463436647.706478: WPS:  * Request Type
> 1463436647.706487: WPS:  * Config Methods (2148)
> 1463436647.706497: WPS:  * UUID-E
> 1463436647.706506: WPS:  * Primary Device Type
> 1463436647.706515: WPS:  * RF Bands (1)
> 1463436647.706525: WPS:  * Association State
> 1463436647.706534: WPS:  * Configuration Error (0)
> 1463436647.706543: WPS:  * Device Password ID (0)
> 1463436647.706555: WPS:  * Manufacturer
> 1463436647.706563: WPS:  * Model Name
> 1463436647.706573: WPS:  * Model Number
> 1463436647.706581: WPS:  * Device Name
> 1463436647.706592: WPS:  * Version2 (0x20)
> 1463436647.706610: P2P: * P2P IE header
> 1463436647.706619: P2P: * Capability dev=25 group=00
> 1463436647.706630: P2P: * Listen Channel: Regulatory Class 81 Channel 11
> 1463436647.706649: wlan0: Add radio work 'scan'@0x564d5290
> 1463436647.706663: wlan0: First radio work item in the queue - schedule start immediately
> 1463436647.706692: wlan0: Starting radio work 'scan'@0x564d5290 after 0.000024 second wait
> 1463436647.706707: wlan0: nl80211: scan request
> 1463436647.711431: Scan requested (ret=0) - scan timeout 10 seconds
> 1463436647.711482: nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for wlan0
> 1463436647.711502: wlan0: nl80211: Scan trigger
> 1463436647.711539: wlan0: Event SCAN_STARTED (49) received
> 1463436647.711557: wlan0: Own scan request started a scan in 0.000099 seconds
> 1463436648.389070: nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for wlan0
> 1463436648.389120: wlan0: nl80211: New scan results available
> 1463436648.389138: nl80211: Scan probed for SSID ''
> 1463436648.389158: nl80211: Scan included frequencies: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462
> 1463436648.389175: wlan0: Event SCAN_RESULTS (3) received
> 1463436648.389191: wlan0: Scan completed in 0.677635 seconds
> 1463436648.389491: nl80211: Received scan results (18 BSSes)
> 1463436648.389587: wlan0: BSS: Start scan result update 1
> 1463436648.389614: wlan0: BSS: Add new id 0 BSSID 58:6d:8f:b3:b8:23 SSID 'CISCO-Linksys-E1200'
> 1463436648.389640: wlan0: BSS: Add new id 1 BSSID 60:02:92:cd:d9:30 SSID 'LNIWireless'
> 1463436648.389662: wlan0: BSS: Add new id 2 BSSID d8:97:ba:28:a2:40 SSID 'HOME-30CB-2.4'
> 1463436648.389685: wlan0: BSS: Add new id 3 BSSID 74:85:2a:db:22:68 SSID 'ThreeOhZoo-2.4'
> 1463436648.389706: wlan0: BSS: Add new id 4 BSSID d8:97:ba:28:a2:41 SSID ''
> 1463436648.389726: wlan0: BSS: Add new id 5 BSSID 6c:b0:ce:9f:d7:df SSID 'NETGEAR61'
> 1463436648.389748: wlan0: BSS: Add new id 6 BSSID 44:94:fc:80:40:73 SSID 'NETGEAR92'
> 1463436648.389768: wlan0: BSS: Add new id 7 BSSID 02:ac:e0:e8:11:20 SSID ''
> 1463436648.389789: wlan0: BSS: Add new id 8 BSSID 00:ac:e0:e8:11:20 SSID 'HOME-1122'
> 1463436648.389809: wlan0: BSS: Add new id 9 BSSID 5e:8f:e0:93:fb:ba SSID ''
> 1463436648.389830: wlan0: BSS: Add new id 10 BSSID 00:23:97:1c:51:3d SSID '09FX01020604'
> 1463436648.389852: wlan0: BSS: Add new id 11 BSSID 58:6d:8f:b3:b8:24 SSID 'CISCO-Linksys-E1200-guest'
> 1463436648.389874: wlan0: BSS: Add new id 12 BSSID 60:02:92:cd:d9:32 SSID 'xfinitywifi'
> 1463436648.389895: wlan0: BSS: Add new id 13 BSSID d8:97:ba:28:a2:42 SSID 'xfinitywifi'
> 1463436648.389917: wlan0: BSS: Add new id 14 BSSID 74:85:2a:db:22:6a SSID 'xfinitywifi'
> 1463436648.389939: wlan0: BSS: Add new id 15 BSSID 48:0f:cf:fa:ec:54 SSID 'HP-Print-54-Officejet Pro 8610'
> 1463436648.389961: wlan0: BSS: Add new id 16 BSSID 06:ac:e0:e8:11:20 SSID 'xfinitywifi'
> 1463436648.389983: wlan0: BSS: Add new id 17 BSSID e6:89:2c:fd:11:00 SSID 'xfinitywifi'
> 1463436648.389999: BSS: last_scan_res_used=18/32
> 1463436648.390027: wlan0: New scan results available (own=1 ext=0)
> 1463436648.390091: WPS: AP 58:6d:8f:b3:b8:23 type 0 added
> 1463436648.390108: WPS: AP 60:02:92:cd:d9:30 type 0 added
> 1463436648.390125: WPS: AP d8:97:ba:28:a2:40 type 0 added
> 1463436648.390141: WPS: AP 74:85:2a:db:22:68 type 0 added
> 1463436648.390157: WPS: AP 6c:b0:ce:9f:d7:df type 0 added
> 1463436648.390174: WPS: AP 44:94:fc:80:40:73 type 0 added
> 1463436648.390190: WPS: AP 00:ac:e0:e8:11:20 type 0 added
> 1463436648.390206: WPS: AP[0] 58:6d:8f:b3:b8:23 type=0 tries=0 last_attempt=-1 sec ago blacklist=0
> 1463436648.390221: WPS: AP[1] 60:02:92:cd:d9:30 type=0 tries=0 last_attempt=-1 sec ago blacklist=0
> 1463436648.390236: WPS: AP[2] d8:97:ba:28:a2:40 type=0 tries=0 last_attempt=-1 sec ago blacklist=0
> 1463436648.390250: WPS: AP[3] 74:85:2a:db:22:68 type=0 tries=0 last_attempt=-1 sec ago blacklist=0
> 1463436648.390265: WPS: AP[4] 6c:b0:ce:9f:d7:df type=0 tries=0 last_attempt=-1 sec ago blacklist=0
> 1463436648.390279: WPS: AP[5] 44:94:fc:80:40:73 type=0 tries=0 last_attempt=-1 sec ago blacklist=0
> 1463436648.390294: WPS: AP[6] 00:ac:e0:e8:11:20 type=0 tries=0 last_attempt=-1 sec ago blacklist=0
> 1463436648.390320: wlan0: Radio work 'scan'@0x564d5290 done in 0.683629 seconds
> 1463436648.390362: wlan0: Selecting BSS from priority group 0
> 1463436648.390390: wlan0: 0: 58:6d:8f:b3:b8:23 ssid='CISCO-Linksys-E1200' wpa_ie_len=28 rsn_ie_len=24 caps=0x411 level=-46 wps
> 1463436648.390411: wlan0:    selected based on RSN IE
> 1463436648.390432: wlan0:    selected BSS 58:6d:8f:b3:b8:23 ssid='CISCO-Linksys-E1200'
> 1463436648.390483: wlan0: Considering connect request: reassociate: 0  selected: 58:6d:8f:b3:b8:23  bssid: 00:00:00:00:00:00  pending: 00:00:00:00:00:00  wpa_state: SCANNING  ssid=0x564c5548  current_ssid=(nil)
> 1463436648.390506: wlan0: Request association with 58:6d:8f:b3:b8:23
> 1463436648.390519: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=21): 00 13 43 49 53 43 4f 2d 4c 69 6e 6b 73 79 73 2d 45 31 32 30 30
> 1463436648.390549: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=3): 03 01 01
> 1463436648.390562: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=3): 2a 01 00
> 1463436648.390575: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=3): 2f 01 00
> 1463436648.390589: WPA: RSN IE in EAPOL-Key - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
> 1463436648.390624: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=24): 3d 16 01 08 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436648.390656: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=16): 4a 0e 14 00 0a 00 2c 01 c8 00 14 00 05 00 19 00
> 1463436648.390683: WPA: WPA IE in EAPOL-Key - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
> 1463436648.390721: WPA: WMM Parameter Element - hexdump(len=24): 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
> 1463436648.390752: TDLS: TDLS is allowed in the target BSS
> 1463436648.390768: wlan0: Add radio work 'connect'@0x564d5290
> 1463436648.390782: wlan0: First radio work item in the queue - schedule start immediately
> 1463436648.390822: wlan0: Starting radio work 'connect'@0x564d5290 after 0.000036 second wait
> 1463436648.390839: wlan0: Trying to associate with SSID 'CISCO-Linksys-E1200'
> 1463436648.390853: wlan0: Cancelling scan request
> 1463436648.390865: wlan0: WPA: clearing own WPA/RSN IE
> 1463436648.390878: wlan0: Automatic auth_alg selection: 0x1
> 1463436648.390888: RSN: PMKSA cache search - network_ctx=0x564c5548 try_opportunistic=0
> 1463436648.390900: RSN: Search for BSSID 58:6d:8f:b3:b8:23
> 1463436648.390912: RSN: No PMKSA cache entry found
> 1463436648.390925: wlan0: RSN: using IEEE 802.11i/D9.0
> 1463436648.390940: wlan0: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
> 1463436648.390954: wlan0: WPA: Selected mgmt group cipher 32
> 1463436648.390965: WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
> 1463436648.391004: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
> 1463436648.391042: wlan0: WPA: using GTK TKIP
> 1463436648.391055: wlan0: WPA: using PTK CCMP
> 1463436648.391066: wlan0: WPA: using KEY_MGMT WPA-PSK
> 1463436648.391079: wlan0: WPA: not using MGMT group cipher
> 1463436648.391091: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1463436648.391134: wlan0: State: SCANNING -> ASSOCIATING
> 1463436648.391145: nl80211: Set wlan0 operstate 0->0 (DORMANT)
> 1463436648.391158: netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=5 (IF_OPER_DORMANT)
> 1463436648.391191: wlan0: set_disable_max_amsdu: -1
> 1463436648.391204: wlan0: set_ampdu_factor: -1
> 1463436648.391216: wlan0: set_ampdu_density: -1
> 1463436648.391228: wlan0: set_disable_ht40: 0
> 1463436648.391241: wlan0: set_disable_sgi: 0
> 1463436648.391252: wlan0: set_disable_ldpc: 0
> 1463436648.391263: nl80211: Set mode ifindex 3 iftype 2 (STATION)
> 1463436648.391303: nl80211: Unsubscribe mgmt frames handle 0xdec4d481 (mode change)
> 1463436648.391431: nl80211: Subscribe to mgmt frames with non-AP handle 0x564c5c08
> 1463436648.391453: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040a
> 1463436648.391496: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040b
> 1463436648.391537: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040c
> 1463436648.391576: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040d
> 1463436648.391615: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090a
> 1463436648.391656: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090b
> 1463436648.391696: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090c
> 1463436648.391734: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=090d
> 1463436648.391775: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0409506f9a09
> 1463436648.391815: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=7f506f9a09
> 1463436648.391855: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0801
> 1463436648.391895: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=040e
> 1463436648.391933: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=06
> 1463436648.391971: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0a07
> 1463436648.392012: nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x564c5c08 match=0a11
> 1463436648.392122: nl80211: Connect (ifindex=3)
> 1463436648.392136:   * bssid_hint=58:6d:8f:b3:b8:23
> 1463436648.392149:   * freq_hint=2412
> 1463436648.392160:   * SSID - hexdump_ascii(len=19):
>      43 49 53 43 4f 2d 4c 69 6e 6b 73 79 73 2d 45 31   CISCO-Linksys-E1
>      32 30 30                                          200             
> 1463436648.392213:   * IEs - hexdump(len=28): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 7f 04 00 00 0a 02
> 1463436648.392250:   * WPA Versions 0x2
> 1463436648.392260:   * pairwise=0xfac04
> 1463436648.392269:   * group=0xfac02
> 1463436648.392279:   * akm=0xfac02
> 1463436648.392289:   * htcaps - hexdump(len=26): 63 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436648.392336:   * htcaps_mask - hexdump(len=26): 63 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436648.392378:   * vhtcaps - hexdump(len=12): 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436648.392401:   * vhtcaps_mask - hexdump(len=12): 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436648.392423:   * Auth Type 0
> 1463436648.396283: nl80211: Connect request send successfully
> 1463436648.396306: wlan0: Setting authentication timeout: 10 sec 0 usec
> 1463436648.396333: EAPOL: External notification - EAP success=0
> 1463436648.396351: EAPOL: External notification - EAP fail=0
> 1463436648.396362: EAPOL: External notification - portControl=Auto
> 1463436648.396386: RTM_NEWLINK: ifi_index=3 ifname=wlan0 wext ifi_family=0 ifi_flags=0x1003 ([UP])
> 1463436648.679477: EAPOL: disable timer tick
> 1463436649.109776: wlan0: RX EAPOL from 58:6d:8f:b3:b8:23
> 1463436649.109822: wlan0: Not associated - Delay processing of received EAPOL frame (state=ASSOCIATING bssid=00:00:00:00:00:00)
> 1463436649.206958: RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=5 linkmode=1 ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1463436649.209634: nl80211: Drv Event 46 (NL80211_CMD_CONNECT) received for wlan0
> 1463436649.209678: nl80211: Connect event
> 1463436649.209837: nl80211: Associated on 2412 MHz
> 1463436649.209849: nl80211: Associated with 58:6d:8f:b3:b8:23
> 1463436649.209915: nl80211: Operating frequency for the associated BSS from scan results: 2412 MHz
> 1463436649.209935: wlan0: Event ASSOC (0) received
> 1463436649.209947: wlan0: Association info event
> 1463436649.209956: req_ies - hexdump(len=151): 00 13 43 49 53 43 4f 2d 4c 69 6e 6b 73 79 73 2d 45 31 32 30 30 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 21 02 03 15 24 02 01 0b 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 2d 1a 21 00 1f ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1e 00 90 4c 33 21 00 1f ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 00 10 00 00 00 dd 07 00 50 f2 02 00 01 00 00 00 00 00
> 1463436649.210104: resp_ies - hexdump(len=130): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a fc 18 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 01 08 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 4a 0e 14 00 0a 00 2c 01 c8 00 14 00 05 00 19 00 dd 09 00 10 18 02 00 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 00 00 00 00 00 00
> 1463436649.210232: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=24): 3d 16 01 08 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436649.210264: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=16): 4a 0e 14 00 0a 00 2c 01 c8 00 14 00 05 00 19 00
> 1463436649.210288: WPA: WMM Parameter Element - hexdump(len=24): 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
> 1463436649.210319: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=2): 00 00
> 1463436649.210330: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=2): 00 00
> 1463436649.210341: WPA: Unrecognized EAPOL-Key Key Data IE - hexdump(len=2): 00 00
> 1463436649.210358: wlan0: freq=2412 MHz
> 1463436649.210366: WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1463436649.210403: FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
> 1463436649.210418: wlan0: State: ASSOCIATING -> ASSOCIATED
> 1463436649.210428: nl80211: Set wlan0 operstate 0->0 (DORMANT)
> 1463436649.210452: netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=5 (IF_OPER_DORMANT)
> 1463436649.210491: wlan0: Associated to a new BSS: BSSID=58:6d:8f:b3:b8:23
> 1463436649.210509: WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
> 1463436649.210547: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
> 1463436649.210596: wlan0: Associated with 58:6d:8f:b3:b8:23
> 1463436649.210607: wlan0: WPA: Association event - clear replay counter
> 1463436649.210618: wlan0: WPA: Clear old PTK
> 1463436649.210627: TDLS: Remove peers on association
> 1463436649.210636: EAPOL: External notification - portEnabled=0
> 1463436649.210652: EAPOL: External notification - portValid=0
> 1463436649.210661: EAPOL: External notification - EAP success=0
> 1463436649.210669: EAPOL: External notification - portEnabled=1
> 1463436649.210678: EAPOL: SUPP_PAE entering state CONNECTING
> 1463436649.210686: EAPOL: enable timer tick
> 1463436649.210695: EAPOL: SUPP_BE entering state IDLE
> 1463436649.210709: wlan0: Setting authentication timeout: 10 sec 0 usec
> 1463436649.210723: wlan0: Cancelling scan request
> 1463436649.210939: RTM_NEWLINK: ifi_index=3 ifname=wlan0 wext ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1463436649.211025: RTM_NEWLINK: ifi_index=3 ifname=wlan0 wext ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1463436649.211056: RTM_NEWLINK: ifi_index=3 ifname=wlan0 wext ifi_family=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1463436650.098273: wlan0: RX EAPOL from 58:6d:8f:b3:b8:23
> 1463436650.098335: wlan0: Setting authentication timeout: 10 sec 0 usec
> 1463436650.098380: wlan0: IEEE 802.1X RX: version=2 type=3 length=117
> 1463436650.098407: wlan0:   EAPOL-Key type=2
> 1463436650.098442: wlan0:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
> 1463436650.098467: wlan0:   key_length=16 key_data_length=22
> 1463436650.098484:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
> 1463436650.098517:   key_nonce - hexdump(len=32): ce 97 b7 53 b5 61 0b 2b 21 76 55 16 91 28 33 23 ed cc fe 84 7e 01 2a 21 a9 22 fb e8 85 a7 c9 9b
> 1463436650.098607:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436650.098653:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
> 1463436650.098684:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
> 1463436650.098729:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1463436650.098798: wlan0: State: ASSOCIATED -> 4WAY_HANDSHAKE
> 1463436650.098837: wlan0: WPA: RX message 1 of 4-Way Handshake from 58:6d:8f:b3:b8:23 (ver=2)
> 1463436650.098859: RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 c2 8d 52 51 c1 dd c2 2b 53 02 7a 7a 9e 74 77 e5
> 1463436650.098918: WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 c2 8d 52 51 c1 dd c2 2b 53 02 7a 7a 9e 74 77 e5
> 1463436650.098975: RSN: PMKID from Authenticator - hexdump(len=16): c2 8d 52 51 c1 dd c2 2b 53 02 7a 7a 9e 74 77 e5
> 1463436650.099025: wlan0: RSN: no matching PMKID found
> 1463436650.101071: WPA: Renewed SNonce - hexdump(len=32): 92 89 a8 f2 e7 75 4d 31 2e dc 86 98 3f d6 5d d3 ab be 42 7d 29 45 de 98 67 03 1c c5 73 48 7a d3
> 1463436650.101218: WPA: PTK derivation - A1=b8:27:eb:eb:46:b2 A2=58:6d:8f:b3:b8:23
> 1463436650.101247: WPA: Nonce1 - hexdump(len=32): 92 89 a8 f2 e7 75 4d 31 2e dc 86 98 3f d6 5d d3 ab be 42 7d 29 45 de 98 67 03 1c c5 73 48 7a d3
> 1463436650.101320: WPA: Nonce2 - hexdump(len=32): ce 97 b7 53 b5 61 0b 2b 21 76 55 16 91 28 33 23 ed cc fe 84 7e 01 2a 21 a9 22 fb e8 85 a7 c9 9b
> 1463436650.101393: WPA: PMK - hexdump(len=32): [REMOVED]
> 1463436650.101410: WPA: PTK - hexdump(len=48): [REMOVED]
> 1463436650.101428: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1463436650.101488: WPA: Replay Counter - hexdump(len=8): 00 00 00 00 00 00 00 01
> 1463436650.101525: wlan0: WPA: Sending EAPOL-Key 2/4
> 1463436650.101566: WPA: KCK - hexdump(len=16): [REMOVED]
> 1463436650.101584: WPA: Derived Key MIC - hexdump(len=16): 47 c2 9d 30 c4 f6 0f 11 5f e8 97 54 72 12 b3 62
> 1463436650.133710: wlan0: RX EAPOL from 58:6d:8f:b3:b8:23
> 1463436650.133789: wlan0: IEEE 802.1X RX: version=2 type=3 length=175
> 1463436650.133820: wlan0:   EAPOL-Key type=2
> 1463436650.133858: wlan0:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
> 1463436650.133885: wlan0:   key_length=16 key_data_length=80
> 1463436650.133901:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
> 1463436650.133934:   key_nonce - hexdump(len=32): ce 97 b7 53 b5 61 0b 2b 21 76 55 16 91 28 33 23 ed cc fe 84 7e 01 2a 21 a9 22 fb e8 85 a7 c9 9b
> 1463436650.134006:   key_iv - hexdump(len=16): ed cc fe 84 7e 01 2a 21 a9 22 fb e8 85 a7 c9 9c
> 1463436650.134049:   key_rsc - hexdump(len=8): fb 0a 00 00 00 00 00 00
> 1463436650.134079:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
> 1463436650.134110:   key_mic - hexdump(len=16): 82 c3 ca ff 55 95 17 a4 9b cc ed b9 4a 3c 82 4e
> 1463436650.134197: RSN: encrypted key data - hexdump(len=80): 2b f1 3e 38 9a db d5 95 ad 72 01 7f 20 4b a3 d5 fd b1 79 39 5e ed db 5f e4 25 72 d0 dc 84 4f 49 08 8a 8d 1b f7 ec c1 14 1d 53 ea ac 44 78 c7 23 3a 74 53 be 68 30 be 21 b0 d4 f4 0e b3 87 b0 a9 29 73 a3 f9 11 33 19 da 3f 30 32 cf 9d 42 c5 fa
> 1463436650.134522: WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
> 1463436650.134554: wlan0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
> 1463436650.134612: wlan0: WPA: RX message 3 of 4-Way Handshake from 58:6d:8f:b3:b8:23 (ver=2)
> 1463436650.134632: WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00 dd 26 00 0f ac 01 01 00 fe 53 ed 3d d3 ea ad 63 08 87 a2 80 3b 69 0f 47 ca 90 5d f4 e3 17 4d c5 b2 25 05 b8 81 2c b5 03 dd 00 00 00 00 00
> 1463436650.134801: WPA: RSN IE in EAPOL-Key - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
> 1463436650.134869: WPA: GTK in EAPOL-Key - hexdump(len=40): [REMOVED]
> 1463436650.134898: wlan0: WPA: Sending EAPOL-Key 4/4
> 1463436650.134938: WPA: KCK - hexdump(len=16): [REMOVED]
> 1463436650.134957: WPA: Derived Key MIC - hexdump(len=16): 97 60 a8 59 27 89 c4 7d da a9 37 cf 04 8e 7b 95
> 1463436650.135034: wlan0: WPA: Installing PTK to the driver
> 1463436650.135134: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=3 addr=0x564c5e38 key_idx=0 set_tx=1 seq_len=6 key_len=16
> 1463436650.135187: nl80211: KEY_DATA - hexdump(len=16): [REMOVED]
> 1463436650.135210: nl80211: KEY_SEQ - hexdump(len=6): 00 00 00 00 00 00
> 1463436650.135239:    addr=58:6d:8f:b3:b8:23
> 1463436650.136838: EAPOL: External notification - portValid=1
> 1463436650.136915: wlan0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
> 1463436650.136973: RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
> 1463436650.137030: WPA: Group Key - hexdump(len=32): [REMOVED]
> 1463436650.137094: wlan0: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32)
> 1463436650.137145: WPA: RSC - hexdump(len=6): fb 0a 00 00 00 00
> 1463436650.137255: wpa_driver_nl80211_set_key: ifindex=3 (wlan0) alg=2 addr=0x54bf3cc8 key_idx=1 set_tx=0 seq_len=6 key_len=32
> 1463436650.137332: nl80211: KEY_DATA - hexdump(len=32): [REMOVED]
> 1463436650.137388: nl80211: KEY_SEQ - hexdump(len=6): fb 0a 00 00 00 00
> 1463436650.137450:    broadcast key
> 1463436650.139490: wlan0: WPA: Key negotiation completed with 58:6d:8f:b3:b8:23 [PTK=CCMP GTK=TKIP]
> 1463436650.139557: wlan0: Cancelling authentication timeout
> 1463436650.139618: wlan0: State: GROUP_HANDSHAKE -> COMPLETED
> 1463436650.139687: wlan0: Radio work 'connect'@0x564d5290 done in 1.748856 seconds
> 1463436650.139760: wlan0: CTRL-EVENT-CONNECTED - Connection to 58:6d:8f:b3:b8:23 completed [id=0 id_str=]
> 1463436650.139814: nl80211: Set wlan0 operstate 0->1 (UP)
> 1463436650.139868: netlink: Operstate: ifindex=3 linkmode=-1 (no change), operstate=6 (IF_OPER_UP)
> 1463436650.140165: EAPOL: External notification - portValid=1
> 1463436650.140228: EAPOL: External notification - EAP success=1
> 1463436650.140281: EAPOL: SUPP_PAE entering state AUTHENTICATING
> 1463436650.140331: EAPOL: SUPP_BE entering state SUCCESS
> 1463436650.140380: EAP: EAP entering state DISABLED
> 1463436650.140427: EAPOL: SUPP_PAE entering state AUTHENTICATED
> 1463436650.140475: EAPOL: Supplicant port status: Authorized
> 1463436650.140525: nl80211: Set supplicant port authorized for 58:6d:8f:b3:b8:23
> 1463436650.143065: EAPOL: SUPP_BE entering state IDLE
> 1463436650.143162: EAPOL authentication completed - result=SUCCESS
> 1463436650.143433: RTM_NEWLINK: ifi_index=3 ifname=wlan0 operstate=6 linkmode=1 ifi_family=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> May 16 22:10:50 raspberrypi systemd-networkd[411]: wlan0           : gained carrier
> 1463436651.210914: EAPOL: startWhen --> 0
> 1463436651.210951: EAPOL: disable timer tick
> May 16 22:10:52 raspberrypi systemd-networkd[411]: wlan0           : DHCPv4 address 192.168.1.102/24 via 192.168.1.1
> May 16 22:10:52 raspberrypi systemd-networkd[411]: wlan0           : link configured
> 
> 
> Barry Reinhold
> 
>       
> 
