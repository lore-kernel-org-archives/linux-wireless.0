Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:47635 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaEWGeU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 02:34:20 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <m3k39fmyqg.fsf@t19.piap.pl>
	<CANUX_P0CyqhFU5fpTMa=q=du2ZkEPkyuvE32VBmFPUejgn0xOA@mail.gmail.com>
Date: Fri, 23 May 2014 08:29:48 +0200
In-Reply-To: <CANUX_P0CyqhFU5fpTMa=q=du2ZkEPkyuvE32VBmFPUejgn0xOA@mail.gmail.com>
	(Emmanuel Grumbach's message of "Wed, 21 May 2014 10:38:36 +0300")
MIME-Version: 1.0
Message-ID: <m3fvk1m2hv.fsf@t19.piap.pl> (sfid-20140523_083426_320866_72A76CC4)
Content-Type: text/plain
Subject: Re: iwlwifi Microcode SW error and subsequent WARNINGs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@gmail.com> writes:

> Please use iw instead of iwconfig. If it reproduces with iw, please
> reprdoduce with debug=0xf.

This problem doesn't show up with iw:

# iw wlan0 set type ibss
# ip link set up wlan0
# iw wlan0 set bitrates legacy-2.4 6
# iw wlan0 ibss join XXX 2462

However, the card doesn't join the ad hoc network. It creates a new IBSS
instead.

Repeating:
# iw wlan0 ibss leave
# iw wlan0 ibss join XXX 2462
doesn't fix it, the card comes with a new IBSS (almost) each time.

# ip link set wlan0 down
# ip link set wlan0 up
# iw wlan0 ibss join XXX 2462
doesn't fix it either.

It seems that after some time (scan interval?) the join command starts
to work - it manages to see the old existing IBSS. It doesn't
automatically join, though - I have to re-issue the join command.

I did:
insmod iwlwifi debug=65535
and the initial dmesg differences between "bad" (new IBSS) and "good"
(joining existing IBSS) are:

--- bad
+++ good
 I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command POWER_TABLE_CMD
 U iwl_mvm_up RT uCode started.
 I iwl_mvm_prepare_multicast mcast addr (0): 01:00:5e:00:00:01

The bad case: too early to scan for other BSSIDs (net/mac80211/ibss.c):
-wlan0: Creating new IBSS network, BSSID 7e:16:f5:00:11:d2
-U iwl_mvm_add_chanctx Add channel context
-U iwl_pcie_send_hcmd_sync Attempting to send sync command PHY_CONTEXT_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command PHY_CONTEXT_CMD
-I iwl_pcie_enqueue_hcmd Sending command PHY_CONTEXT_CMD (#8), seq: 0x091A, 40 bytes at 26[26]:9
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command PHY_CONTEXT_CMD
-U iwl_pcie_send_hcmd_sync Attempting to send sync command PHY_CONTEXT_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command PHY_CONTEXT_CMD
-I iwl_pcie_enqueue_hcmd Sending command PHY_CONTEXT_CMD (#8), seq: 0x091B, 40 bytes at 27[27]:9
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command PHY_CONTEXT_CMD
-U iwl_mvm_bt_udpate_ctrl_kill_msk Update kill_msk: 0 - SCO inactive A2DP inactive SNIFF inactive
-I iwl_pcie_enqueue_hcmd Sending command BEACON_TEMPLATE_CMD (#91), seq: 0x091C, 149 bytes at 28[28]:9
-U iwl_pcie_send_hcmd_sync Attempting to send sync command MAC_CONTEXT_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command MAC_CONTEXT_CMD
-I iwl_pcie_enqueue_hcmd Sending command MAC_CONTEXT_CMD (#28), seq: 0x091D, 152 bytes at 29[29]:9
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command MAC_CONTEXT_CMD
-I iwl_pcie_enqueue_hcmd Sending command REPLY_SF_CFG_CMD (#d1), seq: 0x091E, 96 bytes at 30[30]:9
-U iwl_pcie_send_hcmd_sync Attempting to send sync command BINDING_CONTEXT_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command BINDING_CONTEXT_CMD
-I iwl_pcie_enqueue_hcmd Sending command BINDING_CONTEXT_CMD (#2b), seq: 0x091F, 28 bytes at 31[31]:9
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command BINDING_CONTEXT_CMD
-U iwl_pcie_send_hcmd_sync Attempting to send sync command ADD_STA
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command ADD_STA
-I iwl_pcie_enqueue_hcmd Sending command ADD_STA (#18), seq: 0x0920, 48 bytes at 32[0]:9
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command ADD_STA
-U iwl_mvm_add_int_sta_common Internal station added.
-U iwl_pcie_send_hcmd_sync Attempting to send sync command TIME_QUOTA_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command TIME_QUOTA_CMD
-I iwl_pcie_enqueue_hcmd Sending command TIME_QUOTA_CMD (#2c), seq: 0x0921, 52 bytes at 33[1]:9
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command TIME_QUOTA_CMD
-U iwl_mvm_bt_udpate_ctrl_kill_msk Update kill_msk: 0 - SCO inactive A2DP inactive SNIFF inactive
-U iwl_pcie_send_hcmd_sync Attempting to send sync command MAC_CONTEXT_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command MAC_CONTEXT_CMD
-I iwl_pcie_enqueue_hcmd Sending command MAC_CONTEXT_CMD (#28), seq: 0x0922, 152 bytes at 34[2]:9
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command MAC_CONTEXT_CMD
-I iwl_pcie_enqueue_hcmd Sending command BEACON_TEMPLATE_CMD (#91), seq: 0x0923, 149 bytes at 35[3]:9

The good case:
+wlan0: Trigger new scan to find an IBSS to join
 U iwl_mvm_scan_request Handling mac80211 scan request
 U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
 U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD

I think the problems is somewhere here - multiple scans don't find our
existing IBSS:
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x0924, 1054 bytes at 36[4]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=13
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x0925, 1254 bytes at 37[5]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=25
-wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x0926, 1029 bytes at 38[6]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=11
-wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x0927, 1029 bytes at 39[7]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=11
-wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x0928, 1029 bytes at 40[8]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=11
-wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x0929, 1029 bytes at 41[9]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=11
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x092A, 1054 bytes at 42[10]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=13
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x092B, 1254 bytes at 43[11]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=25
-wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x092C, 1029 bytes at 44[12]:9
-U iwl_mvm_rx_scan_response Scan response received. status 0x1
-I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
-U iwl_mvm_scan_request Scan request was sent successfully
-U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=11
-wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
-U iwl_mvm_scan_request Handling mac80211 scan request
-U iwl_pcie_send_hcmd_sync Attempting to send sync command SCAN_REQUEST_CMD
-U iwl_pcie_send_hcmd_sync Setting HCMD_ACTIVE for command SCAN_REQUEST_CMD
-I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x092D, 1029 bytes at 45[13]:9
+I iwl_pcie_enqueue_hcmd Sending command SCAN_REQUEST_CMD (#80), seq: 0x091A, 1029 bytes at 26[26]:9
 U iwl_mvm_rx_scan_response Scan response received. status 0x1
 I iwl_pcie_hcmd_complete Clearing HCMD_ACTIVE for command SCAN_REQUEST_CMD
 U iwl_mvm_scan_request Scan request was sent successfully
 U iwl_mvm_rx_scan_complete Scan complete: status=0x1 scanned channels=11

When it works:
+wlan0: Selected IBSS BSSID 82:3c:82:2a:c2:90 based on configured SSID


Another issue I found in the logs today:
wlan0: Creating new IBSS network, BSSID ce:bd:57:f4:48:73
------------[ cut here ]------------
WARNING: CPU: 1 PID: 683 at net/mac80211/rate.c:249 __rate_control_send_low+0x105/0x110()
CPU: 1 PID: 683 Comm: kworker/u8:3 Not tainted 3.15.0-rc5+ #42
Hardware name: GETAC            F110/F110, BIOS R1.04.070520 01/02/2014
Workqueue: phy0 ieee80211_iface_work
 00000000 00000000 f2d9fbd8 c13e04c0 00000000 f2d9fc08 c1034e64 c149c288
 00000001 000002ab c14ed3d4 000000f9 c13baa35 c13baa35 00000000 00000010
 00000001 f2d9fc18 c1034efd 00000009 00000000 f2d9fc3c c13baa35 cb178360
Call Trace:
 [<c13e04c0>] dump_stack+0x41/0x52
 [<c1034e64>] warn_slowpath_common+0x74/0x90
 [<c13baa35>] ? __rate_control_send_low+0x105/0x110
 [<c13baa35>] ? __rate_control_send_low+0x105/0x110
 [<c1034efd>] warn_slowpath_null+0x1d/0x20
 [<c13baa35>] __rate_control_send_low+0x105/0x110
 [<c13bab77>] rate_control_send_low+0x47/0x110
 [<f8588771>] rs_get_rate+0x41/0xd0 [iwlmvm]
 [<c13bb525>] rate_control_get_rate+0xa5/0xe0
 [<c13c66a4>] invoke_tx_handlers+0x724/0x1380
 [<c13e4ae3>] ? _raw_spin_unlock_bh+0x13/0x20
 [<c138c226>] ? cfg80211_put_bss+0x36/0x60
 [<c13b0332>] ? ieee80211_rx_bss_put+0x12/0x20
 [<c13b5e01>] ? ieee80211_rx_mgmt_probe_beacon+0x261/0x6b0
 [<c13c7b9e>] ieee80211_tx+0x5e/0xd0
 [<c13c81e1>] ieee80211_xmit+0x81/0xb0
 [<c13c8fc5>] __ieee80211_tx_skb_tid_band+0x55/0x70
 [<c13cc34a>] ieee80211_send_auth+0x12a/0x190
 [<c13b6c57>] ieee80211_ibss_rx_queued_mgmt+0x3a7/0x3f0
 [<c10592c4>] ? sched_clock_cpu+0x104/0x110
 [<c105e464>] ? pick_next_task_fair+0x234/0x3d0
 [<c1305b90>] ? skb_dequeue+0x40/0x60
 [<c13b864a>] ieee80211_iface_work+0x22a/0x300
 [<c1047691>] process_one_work+0xd1/0x2f0
 [<c1048159>] worker_thread+0xf9/0x330
 [<c1048060>] ? manage_workers.isra.30+0x250/0x250
 [<c104c9cc>] kthread+0x9c/0xb0
 [<c13e55c1>] ret_from_kernel_thread+0x21/0x30
 [<c104c930>] ? kthread_create_on_node+0x100/0x100
---[ end trace a3876c6586762df6 ]---
wlan0: Selected IBSS BSSID 6e:f7:6f:75:67:57 based on configured SSID

Thanks for looking at this.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
