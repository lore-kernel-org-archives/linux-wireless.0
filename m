Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:62658 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaIBSZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 14:25:13 -0400
Received: by mail-ig0-f172.google.com with SMTP id h15so14681746igd.17
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 11:25:13 -0700 (PDT)
MIME-Version: 1.0
From: Robb <rbarr138@gmail.com>
Date: Tue, 2 Sep 2014 13:24:52 -0500
Message-ID: <CAOHJ0jTHtVvJ43y7m-=UqHeMJfNiMYU2Peg9buxXU+wBigwu5g@mail.gmail.com> (sfid-20140902_202518_919738_CDE67725)
Subject: Cannot get ACS to work with hostapd-2.2 "Unknown event 49"
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to get ACS to work for me but so far have not had
any luck.  I have tried on both the following kernels:
2.6.32-431.20.3.el6.x86_64
3.16.1-1.el6.elrepo.x86_64
on a CentOS 6.5 installation using htc_9271.fw v1.3.
I would prefer to get it working on the former.

Where should I be looking to determine the source of the
"Unknown event 49" errors?

Any suggestions or troubleshooting advice would be greatly
appreciated.

Thanks.  Info about problem follows:


$ lsusb | grep Atheros
Bus 002 Device 007: ID 0cf3:9271 Atheros Communications, Inc. AR9271 802.11n

$ hostapd -v
hostapd v2.2

$ cat /etc/hostapd/hostapd.conf
interface=wlan0
bridge=br0
driver=nl80211

logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2

ctrl_interface=/var/run/hostapd
ctrl_interface_group=0

ssid=test
country_code=US
hw_mode=g

channel=0

$ sudo hostapd -d /etc/hostapd/hostapd.conf
random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:6
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: interface wlan0 in phy phy1
nl80211: Set mode ifindex 6 iftype 3 (AP)
nl80211: Failed to set interface 6 to mode 3: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 6 iftype 3 (AP)
nl80211: Mode change succeeded while interface is down
nl80211: Setup AP(wlan0) - device_ap_sme=0 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x141f2a0
nl80211: Register frame type=0xb0 nl_handle=0x141f2a0 match=
nl80211: Register frame type=0x0 nl_handle=0x141f2a0 match=
nl80211: Register frame type=0x20 nl_handle=0x141f2a0 match=
nl80211: Register frame type=0xa0 nl_handle=0x141f2a0 match=
nl80211: Register frame type=0xc0 nl_handle=0x141f2a0 match=
nl80211: Register frame type=0xd0 nl_handle=0x141f2a0 match=
nl80211: Register frame type=0x40 nl_handle=0x141f2a0 match=
nl80211: Add own interface ifindex 4
nl80211: if_indices[16]: 4
nl80211: Add own interface ifindex 6
nl80211: if_indices[16]: 4 6
nl80211: Adding interface wlan0 into bridge br0
phy: phy1
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
wlan0: interface state UNINITIALIZED->COUNTRY_UPDATE
Previous country code 98, new country code US
Continue interface setup after channel list update
ctrl_iface not configured!
random: Got 20/20 bytes from /dev/random
RTM_NEWLINK: ifi_index=6 ifname=wlan0 operstate=2 linkmode=0 ifi_flags=0x1002 ()
nl80211: Ignore interface down event since interface wlan0 is up
RTM_NEWLINK: ifi_index=6 ifname=wlan0 operstate=2 linkmode=0
ifi_flags=0x1003 ([UP])
RTM_NEWLINK: ifi_index=6 ifname=wlan0 operstate=2 linkmode=0 master=4
ifi_flags=0x1003 ([UP])
RTM_NEWLINK: ifi_index=6 ifname=wlan0 operstate=2 linkmode=0 master=4
ifi_flags=0x1003 ([UP])
RTM_NEWLINK: ifi_index=6 ifname=wlan0 master=4 operstate=2
ifi_flags=0x1003 ([UP])
nl80211: Add ifindex 4 for bridge br0
nl80211: Add own interface ifindex 4
nl80211: ifindex 4 already in the list
Channel list update timeout - try to continue anyway
nl80211: Regulatory information - country=98
nl80211: 2402-2472 @ 40 MHz 20 mBm
nl80211: 5170-5250 @ 80 MHz 17 mBm
nl80211: 5250-5330 @ 80 MHz 23 mBm (DFS)
nl80211: 5735-5835 @ 80 MHz 30 mBm
nl80211: 57240-59400 @ 2160 MHz 28 mBm
nl80211: 59400-63720 @ 2160 MHz 40 mBm
nl80211: Added 802.11b mode based on 802.11g information
ACS: Automatic channel selection started, this may take a bit
ACS: Scanning 1 / 5
wlan0: nl80211: scan request
Scan requested (ret=0) - scan timeout 10 seconds
wlan0: interface state COUNTRY_UPDATE->ACS
wlan0: ACS-STARTED
Interface initialization will be completed in a callback (ACS)
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for wlan0
wlan0: nl80211: Scan trigger
wlan0: Event SCAN_STARTED (49) received
Unknown event 49
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for wlan0
wlan0: nl80211: New scan results available
nl80211: Scan included frequencies: 2412 2417 2422 2427 2432 2437 2442
2447 2452 2457 2462 2467 2472
wlan0: Event SCAN_RESULTS (3) received
ACS: Using survey based algorithm (acs_num_scans=5)
nl80211: Fetch survey data
wlan0: Event SURVEY (48) received
No survey data received
ACS: Scanning 2 / 5
wlan0: nl80211: scan request
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: ifi_index=6 ifname=wlan0 wext ifi_flags=0x1003 ([UP])
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for wlan0
wlan0: nl80211: Scan trigger
wlan0: Event SCAN_STARTED (49) received
Unknown event 49
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for wlan0
wlan0: nl80211: New scan results available
nl80211: Scan included frequencies: 2412 2417 2422 2427 2432 2437 2442
2447 2452 2457 2462 2467 2472
wlan0: Event SCAN_RESULTS (3) received
ACS: Using survey based algorithm (acs_num_scans=5)
nl80211: Fetch survey data
wlan0: Event SURVEY (48) received
No survey data received
ACS: Scanning 3 / 5
wlan0: nl80211: scan request
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: ifi_index=6 ifname=wlan0 wext ifi_flags=0x1003 ([UP])
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for wlan0
wlan0: nl80211: Scan trigger
wlan0: Event SCAN_STARTED (49) received
Unknown event 49
RTM_NEWLINK: ifi_index=6 ifname=wlan0 wext ifi_flags=0x1003 ([UP])
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for wlan0
wlan0: nl80211: New scan results available
nl80211: Scan included frequencies: 2412 2417 2422 2427 2432 2437 2442
2447 2452 2457 2462 2467 2472
wlan0: Event SCAN_RESULTS (3) received
ACS: Using survey based algorithm (acs_num_scans=5)
nl80211: Fetch survey data
wlan0: Event SURVEY (48) received
No survey data received
ACS: Scanning 4 / 5
wlan0: nl80211: scan request
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for wlan0
wlan0: nl80211: Scan trigger
wlan0: Event SCAN_STARTED (49) received
Unknown event 49
RTM_NEWLINK: ifi_index=6 ifname=wlan0 wext ifi_flags=0x1003 ([UP])
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for wlan0
wlan0: nl80211: New scan results available
nl80211: Scan included frequencies: 2412 2417 2422 2427 2432 2437 2442
2447 2452 2457 2462 2467 2472
wlan0: Event SCAN_RESULTS (3) received
ACS: Using survey based algorithm (acs_num_scans=5)
nl80211: Fetch survey data
wlan0: Event SURVEY (48) received
No survey data received
ACS: Scanning 5 / 5
wlan0: nl80211: scan request
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Drv Event 33 (NL80211_CMD_TRIGGER_SCAN) received for wlan0
wlan0: nl80211: Scan trigger
wlan0: Event SCAN_STARTED (49) received
Unknown event 49
RTM_NEWLINK: ifi_index=6 ifname=wlan0 wext ifi_flags=0x1003 ([UP])
nl80211: Drv Event 34 (NL80211_CMD_NEW_SCAN_RESULTS) received for wlan0
wlan0: nl80211: New scan results available
nl80211: Scan included frequencies: 2412 2417 2422 2427 2432 2437 2442
2447 2452 2457 2462 2467 2472
wlan0: Event SCAN_RESULTS (3) received
ACS: Using survey based algorithm (acs_num_scans=5)
nl80211: Fetch survey data
wlan0: Event SURVEY (48) received
No survey data received
ACS: Trying survey-based ACS
ACS: Unable to collect survey data
ACS: All study options have failed
Interface initialization failed
wlan0: interface state ACS->DISABLED
wlan0: AP-DISABLED
ACS: Possibly channel configuration is invalid, please report this
along with your config file.
ACS: Failed to start
wlan0: AP-DISABLED
wlan0: Deauthenticate all stations
nl80211: send_mlme - noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0
fc=0xc0 nlmode=3
nl80211: send_mlme -> send_frame
nl80211: send_frame - Use bss->freq=0
nl80211: send_frame -> send_frame_cmd
nl80211: Frame command failed: ret=-22 (Invalid argument) (freq=0 wait=0)
hostapd_free_hapd_data: Interface wlan0 wasn't started
hostapd_deinit_driver: driver=0x47ef60 drv_priv=0x1421a10 -> hapd_deinit
nl80211: Remove monitor interface: refcount=0
nl80211: Remove beacon (ifindex=6)
netlink: Operstate: ifindex=6 linkmode=0 (kernel-control), operstate=6
(IF_OPER_UP)
nl80211: Set mode ifindex 6 iftype 2 (STATION)
nl80211: Failed to set interface 6 to mode 2: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 6 iftype 2 (STATION)
nl80211: Mode change succeeded while interface is down
nl80211: Teardown AP(wlan0) - device_ap_sme=0 use_monitor=0
nl80211: Unsubscribe mgmt frames handle 0x8888888889c97a29 (AP teardown)
hostapd_deinit_driver:bss[0]->drv_priv=0x1421a10
hostapd_cleanup_iface_partial(0x141e7f0)
Interface wlan0 disabled
wlan0: interface state DISABLED->DISABLED
hostapd_interface_deinit_free(0x141e7f0)
hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
hostapd_interface_deinit(0x141e7f0)
hostapd_bss_deinit: deinit bss wlan0
hostapd_cleanup(hapd=0x1420cc0 (wlan0))
hostapd_free_hapd_data: Interface wlan0 wasn't started
hostapd_interface_deinit_free: driver=0x47ef60 drv_priv=(nil) -> hapd_deinit
hostapd_interface_free(0x141e7f0)
hostapd_interface_free: free hapd 0x1420cc0
hostapd_cleanup_iface(0x141e7f0)
hostapd_cleanup_iface_partial(0x141e7f0)
hostapd_cleanup_iface: free iface=0x141e7f0
