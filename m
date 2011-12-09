Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40601 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab1LIRAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 12:00:55 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE2202A.4080303@gmx.net>
References: <4EE2202A.4080303@gmx.net>
Content-Type: multipart/mixed; boundary="=-3oDAIVtTUOCmWPACs5GJ"
Date: Fri, 09 Dec 2011 08:02:14 -0800
Message-ID: <1323446534.13074.96.camel@wwguy-huron> (sfid-20111209_180058_373107_03DA576C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3oDAIVtTUOCmWPACs5GJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Wolfgang,

I don't have the similar AP here for testing. by looking at the log,
looks like there is a issue while you scan.

Could you please try this patch and see if make any different? it is a
long shot, but I just like to see if it make any different at all

once you apply the patch, please make sure P2P is disabled in .config

Thanks
Wey
 
On Fri, 2011-12-09 at 06:50 -0800, Wolfgang Breyha wrote:
> Hi!
> 
> I recently upgraded my HP 2540p Laptop with Intel 6200 AGN to Fedora 16 and
> suddenly had big troubles keeping the machine stable. After a while I
> nailed it down to iwlagn in all available kernels for F16. 3.1.0 - 3.1.4.
> 
> Meanwhile I'm running wireless-compat iwlwifi from today (with the
> regression patch from Nikolay) but the troubles are still there. Kernel is
> the latest from F16 (3.1.4).
> 
> Cards PCI-Id: 8086:4239 (rev 35)
> dmesg from iwlwifi:
> > [   11.091363] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
> > [   11.091366] Copyright(c) 2003-2011 Intel Corporation
> > [   11.091429] iwlwifi 0000:43:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > [   11.091438] iwlwifi 0000:43:00.0: setting latency timer to 64
> > [   11.091459] iwlwifi 0000:43:00.0: pci_resource_len = 0x00002000
> > [   11.091461] iwlwifi 0000:43:00.0: pci_resource_base = fb444000
> > [   11.091464] iwlwifi 0000:43:00.0: HW Revision ID = 0x35
> > [   11.091537] iwlwifi 0000:43:00.0: irq 49 for MSI/MSI-X
> > [   11.091592] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEBUG enabled
> > [   11.091594] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> > [   11.091596] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> > [   11.091598] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEVICE_SVTOOL enabled
> > [   11.091605] iwlwifi 0000:43:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
> > [   11.091724] iwlwifi 0000:43:00.0: L1 Disabled; Enabling L0S
> > [   11.107567] iwlwifi 0000:43:00.0: device EEPROM VER=0x436, CALIB=0x6
> > [   11.107570] iwlwifi 0000:43:00.0: Device SKU: 0X1f0
> > [   11.107596] iwlwifi 0000:43:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> > [   11.116014] iwlwifi 0000:43:00.0: loaded firmware version 9.221.4.1 build 25532
> > [   11.116327] Registered led device: phy0-led
> 
> wpa_supplicant is: wpa_supplicant-0.7.3-11.fc16.i686
> driven by NetworkManager: NetworkManager-0.9.2-1.fc16.i686
> via wext.
> 
> I've two APs for tests. One is a Ubiquiti UniFi bgn (also Atheros/hostapd
> based). No problems with this one so far. Works like a charm.
> 
> The other one is my Soekris 4801 equipped with an
> 00:0e.0 168c:001a Ethernet controller: Atheros Communications Inc. AR2413
> 802.11bg NIC (rev 01)
> running on openwrt 10.x with hostapd.
> 
> If I connect to this one and start eg. videostreaming it takes only a few
> minutes and my machine gets completly unstable. Various applications crash,
> sounds starts crackling, video gets artefacts. Also doing large downloads
> helps to kill various components. gnome-shell, firefox, ... looks like
> iwlwifi writes random memory.
> 
> Scanresults from "iw wlan0 scan" for this AP:
> BSS 00:80:48:xx:xx:xx (on wlan0)
> 	TSF: 58415136285 usec (0d, 16:13:35)
> 	freq: 2437
> 	beacon interval: 100
> 	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
> 	signal: -45.00 dBm
> 	last seen: 4490 ms ago
> 	SSID: xxxx
> 	Supported rates: 1.0* 2.0* 5.5* 6.0 9.0 11.0* 12.0 18.0
> 	DS Parameter set: channel 6
> 	ERP: <no flags>
> 	Extended supported rates: 24.0 36.0 48.0 54.0
> 	WMM:	 * Parameter version 1
> 		 * BE: CW 7-1023, AIFSN 2, TXOP 2048 usec
> 		 * BK: CW 15-1023, AIFSN 7
> 		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
> 		 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
> 	RSN:	 * Version: 1
> 		 * Group cipher: TKIP
> 		 * Pairwise ciphers: CCMP TKIP
> 		 * Authentication suites: PSK
> 		 * Capabilities: (0x0000)
> 
> Usually I use CCMP only, but activated TKIP for testing purposes. But it
> makes no difference at all.
> 
> I activated debug output from iwlwifi and besides the recurring
> > Dec  9 14:42:17 hpwb kernel: [  616.473854] iwlwifi 0000:43:00.0: U iwlagn_request_scan Scanning while associated...
> > Dec  9 14:42:17 hpwb kernel: [  616.473866] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_SCAN_CMD
> > Dec  9 14:42:17 hpwb kernel: [  616.473869] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
> > Dec  9 14:42:17 hpwb kernel: [  616.476081] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
> ... I very often see stuff like...
> > Dec  9 14:42:07 hpwb kernel: [  606.751372] iwlwifi 0000:43:00.0: I iwl_force_reset force reset rejected
> > Dec  9 14:42:13 hpwb kernel: [  612.907705] iwlwifi 0000:43:00.0: I is_lq_table_valid Channel 6 is not an HT channel
> > Dec  9 14:42:13 hpwb kernel: [  612.932685] iwlwifi 0000:43:00.0: I is_lq_table_valid Channel 6 is not an HT channel
> > Dec  9 14:42:17 hpwb kernel: [  616.473816] iwlwifi 0000:43:00.0: I iwl_force_reset perform force reset (0)
> > Dec  9 14:42:17 hpwb kernel: [  616.473825] iwlwifi 0000:43:00.0: I iwl_force_rf_reset perform radio reset.
> 
> Another difference between the two APs is that my soekris uses rekeying. I
> don't have proof yet that it's the cause, but troubles often start after I
> see....
> > Dec  9 14:47:23 hpwb kernel: [  922.682961] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
> > Dec  9 14:47:23 hpwb kernel: [  922.885333] iwlwifi 0000:43:00.0: I iwl_force_reset force reset rejected
> > Dec  9 14:47:27 hpwb kernel: [  926.672222] iwlwifi 0000:43:00.0: I iwl_force_reset perform force reset (0)
> > Dec  9 14:47:27 hpwb kernel: [  926.672233] iwlwifi 0000:43:00.0: I iwl_force_rf_reset perform radio reset.
> > Dec  9 14:47:27 hpwb kernel: [  926.672254] iwlwifi 0000:43:00.0: U iwlagn_request_scan Scanning while associated...
> > Dec  9 14:47:27 hpwb kernel: [  926.672265] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_SCAN_CMD
> > Dec  9 14:47:27 hpwb kernel: [  926.672271] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_SCAN_CMD
> > Dec  9 14:47:27 hpwb kernel: [  926.674473] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_SCAN_CMD
> > Dec  9 14:47:33 hpwb kernel: [  932.686199] iwlwifi 0000:43:00.0: U iwl_send_add_sta Adding sta 0 (00:80:48:xx:xx:xx) synchronously
> > Dec  9 14:47:33 hpwb kernel: [  932.686209] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> > Dec  9 14:47:33 hpwb kernel: [  932.686214] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> > Dec  9 14:47:33 hpwb kernel: [  932.686271] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Processing response for adding station 0
> > Dec  9 14:47:33 hpwb kernel: [  932.686278] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> > Dec  9 14:47:33 hpwb kernel: [  932.686285] iwlwifi 0000:43:00.0: I iwl_sta_ucode_activate STA id 0 addr 00:80:48:xx:xx:xx already present in uCode (according to driver)
> > Dec  9 14:47:33 hpwb kernel: [  932.686294] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station id 0 addr 00:80:48:xx:xx:xx
> > Dec  9 14:47:33 hpwb kernel: [  932.686302] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer 00:80:48:xx:xx:xx
> > Dec  9 14:47:33 hpwb kernel: [  932.686313] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> > Dec  9 14:47:33 hpwb kernel: [  932.686423] iwlwifi 0000:43:00.0: U iwl_send_add_sta Adding sta 0 (00:80:48:xx:xx:xx) synchronously
> > Dec  9 14:47:33 hpwb kernel: [  932.686430] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
> > Dec  9 14:47:33 hpwb kernel: [  932.686437] iwlwifi 0000:43:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
> > Dec  9 14:47:33 hpwb kernel: [  932.686487] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Processing response for adding station 0
> > Dec  9 14:47:33 hpwb kernel: [  932.686499] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp REPLY_ADD_STA PASSED
> > Dec  9 14:47:33 hpwb kernel: [  932.686509] iwlwifi 0000:43:00.0: I iwl_sta_ucode_activate STA id 0 addr 00:80:48:xx:xx:xx already present in uCode (according to driver)
> > Dec  9 14:47:33 hpwb kernel: [  932.686522] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station id 0 addr 00:80:48:xx:xx:xx
> > Dec  9 14:47:33 hpwb kernel: [  932.686533] iwlwifi 0000:43:00.0: I iwl_process_add_sta_resp Added station according to cmd buffer 00:80:48:xx:xx:xx
> > Dec  9 14:47:33 hpwb kernel: [  932.686546] iwlwifi 0000:43:00.0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
> > Dec  9 14:47:34 hpwb kernel: [  933.835898] iwlwifi 0000:43:00.0: I iwl_force_reset perform force reset (0)
> > Dec  9 14:47:34 hpwb kernel: [  933.835908] iwlwifi 0000:43:00.0: I iwl_force_rf_reset perform radio reset.
> 
> wpa_supplicant said:
> WPA: Group rekeying completed with 00:80:48:xx:xx:xx [GTK=TKIP]
> at that time.
> 
> There're no crashdumps in dmesg!
> 
> If you need more information or debug output please let me know.
> 
> With kind regards,
> Wolfgang Breyha


--=-3oDAIVtTUOCmWPACs5GJ
Content-Disposition: attachment; filename="0008-iwlwifi-P2P-is-not-enabled-by-default.patch"
Content-Type: text/x-patch; name="0008-iwlwifi-P2P-is-not-enabled-by-default.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 0cb38d65efa0304e9a948fd7aef9c7d38ad8cbb9 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Fri, 2 Dec 2011 07:33:57 -0800
Subject: [PATCH 08/15] iwlwifi: P2P is not enabled by default

P2P still under development. it will not enabled by default, but user
always can enable it manually for testing.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 +++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 82c8cca..ae08498 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -111,3 +111,19 @@ config IWLWIFI_DEVICE_TESTMODE
 	  NL80211_TESTMODE. This provide the capabilities of enable user space
 	  validation applications to interacts with the device through the
 	  generic netlink message via NL80211_TESTMODE channel.
+
+config IWLWIFI_P2P
+       bool "iwlwifi experimental P2P support"
+       depends on IWLWIFI
+       help
+         This option enables experimental P2P support for some devices
+         based on microcode support. Since P2P support is still under
+         development, this option may even enable it for some devices
+         now that turn out to not support it in the future due to
+         microcode restrictions.
+
+         To determine if your microcode supports the experimental P2P
+         offered by this option, check if the driver advertises AP
+         support when it is loaded.
+
+         Say Y only if you want to experiment with P2P.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5021cc9..6dd1e10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1036,6 +1036,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->inst_evtlog_size =
 			priv->cfg->base_params->max_event_log_size;
 	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
+#ifndef CONFIG_IWLWIFI_P2P
+	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+#endif
 
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
@@ -1057,7 +1060,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 	}
-
 	/*
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
@@ -1709,6 +1711,12 @@ static void iwl_debug_config(struct iwl_priv *priv)
 #else
 		"disabled\n");
 #endif
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_P2P "
+#ifdef CONFIG_IWLWIFI_P2P
+		"enabled\n");
+#else
+		"disabled\n");
+#endif
 }
 
 int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
-- 
1.7.0.4


--=-3oDAIVtTUOCmWPACs5GJ--

