Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:50374 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754009Ab1LIOuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 09:50:22 -0500
Message-ID: <4EE2202A.4080303@gmx.net> (sfid-20111209_155026_272581_C336F412)
Date: Fri, 09 Dec 2011 15:50:18 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iwlwifi havoc on some APs (rekeying?)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I recently upgraded my HP 2540p Laptop with Intel 6200 AGN to Fedora 16 and
suddenly had big troubles keeping the machine stable. After a while I
nailed it down to iwlagn in all available kernels for F16. 3.1.0 - 3.1.4.

Meanwhile I'm running wireless-compat iwlwifi from today (with the
regression patch from Nikolay) but the troubles are still there. Kernel is
the latest from F16 (3.1.4).

Cards PCI-Id: 8086:4239 (rev 35)
dmesg from iwlwifi:
> [   11.091363] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
> [   11.091366] Copyright(c) 2003-2011 Intel Corporation
> [   11.091429] iwlwifi 0000:43:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [   11.091438] iwlwifi 0000:43:00.0: setting latency timer to 64
> [   11.091459] iwlwifi 0000:43:00.0: pci_resource_len = 0x00002000
> [   11.091461] iwlwifi 0000:43:00.0: pci_resource_base = fb444000
> [   11.091464] iwlwifi 0000:43:00.0: HW Revision ID = 0x35
> [   11.091537] iwlwifi 0000:43:00.0: irq 49 for MSI/MSI-X
> [   11.091592] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   11.091594] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   11.091596] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [   11.091598] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEVICE_SVTOOL enabled
> [   11.091605] iwlwifi 0000:43:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
> [   11.091724] iwlwifi 0000:43:00.0: L1 Disabled; Enabling L0S
> [   11.107567] iwlwifi 0000:43:00.0: device EEPROM VER=0x436, CALIB=0x6
> [   11.107570] iwlwifi 0000:43:00.0: Device SKU: 0X1f0
> [   11.107596] iwlwifi 0000:43:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [   11.116014] iwlwifi 0000:43:00.0: loaded firmware version 9.221.4.1 build 25532
> [   11.116327] Registered led device: phy0-led

wpa_supplicant is: wpa_supplicant-0.7.3-11.fc16.i686
driven by NetworkManager: NetworkManager-0.9.2-1.fc16.i686
via wext.

I've two APs for tests. One is a Ubiquiti UniFi bgn (also Atheros/hostapd
based). No problems with this one so far. Works like a charm.

The other one is my Soekris 4801 equipped with an
00:0e.0 168c:001a Ethernet controller: Atheros Communications Inc. AR2413
802.11bg NIC (rev 01)
running on openwrt 10.x with hostapd.

If I connect to this one and start eg. videostreaming it takes only a few
minutes and my machine gets completly unstable. Various applications crash,
sounds starts crackling, video gets artefacts. Also doing large downloads
helps to kill various components. gnome-shell, firefox, ... looks like
iwlwifi writes random memory.

Scanresults from "iw wlan0 scan" for this AP:
BSS 00:80:48:xx:xx:xx (on wlan0)
	TSF: 58415136285 usec (0d, 16:13:35)
	freq: 2437
	beacon interval: 100
	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
	signal: -45.00 dBm
	last seen: 4490 ms ago
	SSID: xxxx
	Supported rates: 1.0* 2.0* 5.5* 6.0 9.0 11.0* 12.0 18.0
	DS Parameter set: channel 6
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0
	WMM:	 * Parameter version 1
		 * BE: CW 7-1023, AIFSN 2, TXOP 2048 usec
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
	RSN:	 * Version: 1
		 * Group cipher: TKIP
		 * Pairwise ciphers: CCMP TKIP
		 * Authentication suites: PSK
		 * Capabilities: (0x0000)

Usually I use CCMP only, but activated TKIP for testing purposes. But it
makes no difference at all.

I activated debug output from iwlwifi and besides the recurring
> Dec  9 14:42:17 hpwb kernel: [  616.473854] iwlwifi 0000:43:00.0: U iwlagn_request_scan Scanning while associated...
> Dec  9 14:42:17 hpwb kernel: [  616.473866] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_SCAN_CMD
> Dec  9 14:42:17 hpwb kernel: [  616.473869] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
> Dec  9 14:42:17 hpwb kernel: [  616.476081] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
... I very often see stuff like...
> Dec  9 14:42:07 hpwb kernel: [  606.751372] iwlwifi 0000:43:00.0: I iwl_force_reset force reset rejected
> Dec  9 14:42:13 hpwb kernel: [  612.907705] iwlwifi 0000:43:00.0: I is_lq_table_valid Channel 6 is not an HT channel
> Dec  9 14:42:13 hpwb kernel: [  612.932685] iwlwifi 0000:43:00.0: I is_lq_table_valid Channel 6 is not an HT channel
> Dec  9 14:42:17 hpwb kernel: [  616.473816] iwlwifi 0000:43:00.0: I iwl_force_reset perform force reset (0)
> Dec  9 14:42:17 hpwb kernel: [  616.473825] iwlwifi 0000:43:00.0: I iwl_force_rf_reset perform radio reset.

Another difference between the two APs is that my soekris uses rekeying. I
don't have proof yet that it's the cause, but troubles often start after I
see....
> Dec  9 14:47:23 hpwb kernel: [  922.682961] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
> Dec  9 14:47:23 hpwb kernel: [  922.885333] iwlwifi 0000:43:00.0: I iwl_force_reset force reset rejected
> Dec  9 14:47:27 hpwb kernel: [  926.672222] iwlwifi 0000:43:00.0: I iwl_force_reset perform force reset (0)
> Dec  9 14:47:27 hpwb kernel: [  926.672233] iwlwifi 0000:43:00.0: I iwl_force_rf_reset perform radio reset.
> Dec  9 14:47:27 hpwb kernel: [  926.672254] iwlwifi 0000:43:00.0: U iwlagn_request_scan Scanning while associated...
> Dec  9 14:47:27 hpwb kernel: [  926.672265] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_SCAN_CMD
> Dec  9 14:47:27 hpwb kernel: [  926.672271] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
> Dec  9 14:47:27 hpwb kernel: [  926.674473] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
> Dec  9 14:47:33 hpwb kernel: [  932.686199] iwlwifi 0000:43:00.0: U iwl_send_add_sta Adding sta 0 (00:80:48:xx:xx:xx) synchronously
> Dec  9 14:47:33 hpwb kernel: [  932.686209] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> Dec  9 14:47:33 hpwb kernel: [  932.686214] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> Dec  9 14:47:33 hpwb kernel: [  932.686271] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Processing response for adding station 0
> Dec  9 14:47:33 hpwb kernel: [  932.686278] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> Dec  9 14:47:33 hpwb kernel: [  932.686285] iwlwifi 0000:43:00.0: I iwl_sta_ucode_activate STA id 0 addr 00:80:48:xx:xx:xx already present in uCode (according to driver)
> Dec  9 14:47:33 hpwb kernel: [  932.686294] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station id 0 addr 00:80:48:xx:xx:xx
> Dec  9 14:47:33 hpwb kernel: [  932.686302] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer 00:80:48:xx:xx:xx
> Dec  9 14:47:33 hpwb kernel: [  932.686313] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> Dec  9 14:47:33 hpwb kernel: [  932.686423] iwlwifi 0000:43:00.0: U iwl_send_add_sta Adding sta 0 (00:80:48:xx:xx:xx) synchronously
> Dec  9 14:47:33 hpwb kernel: [  932.686430] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> Dec  9 14:47:33 hpwb kernel: [  932.686437] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> Dec  9 14:47:33 hpwb kernel: [  932.686487] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Processing response for adding station 0
> Dec  9 14:47:33 hpwb kernel: [  932.686499] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> Dec  9 14:47:33 hpwb kernel: [  932.686509] iwlwifi 0000:43:00.0: I iwl_sta_ucode_activate STA id 0 addr 00:80:48:xx:xx:xx already present in uCode (according to driver)
> Dec  9 14:47:33 hpwb kernel: [  932.686522] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station id 0 addr 00:80:48:xx:xx:xx
> Dec  9 14:47:33 hpwb kernel: [  932.686533] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer 00:80:48:xx:xx:xx
> Dec  9 14:47:33 hpwb kernel: [  932.686546] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> Dec  9 14:47:34 hpwb kernel: [  933.835898] iwlwifi 0000:43:00.0: I iwl_force_reset perform force reset (0)
> Dec  9 14:47:34 hpwb kernel: [  933.835908] iwlwifi 0000:43:00.0: I iwl_force_rf_reset perform radio reset.

wpa_supplicant said:
WPA: Group rekeying completed with 00:80:48:xx:xx:xx [GTK=TKIP]
at that time.

There're no crashdumps in dmesg!

If you need more information or debug output please let me know.

With kind regards,
Wolfgang Breyha
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria
