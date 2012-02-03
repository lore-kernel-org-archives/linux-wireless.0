Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:38751 "HELO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754427Ab2BCEuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 23:50:55 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: update correct dtim_period in dump_station()
Date: Thu,  2 Feb 2012 20:48:58 -0800
Message-Id: <1328244538-23963-2-git-send-email-bzhao@marvell.com> (sfid-20120203_055058_223983_DB957F82)
In-Reply-To: <1328244538-23963-1-git-send-email-bzhao@marvell.com>
References: <1328244538-23963-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Earlier we were using dtim period extracted from scan response
buffer provided by FW in scan operation. But it is observed that
sometimes the buffer doesn't contain dtim period tlv, and wrong
value (0) was sent to user space.

After association FW will start listening to beacon frames of
connected AP and store dtim period. Therefore we can get it from
FW in dump_station() instead of using wrong value obtained in
scanning.

Redundant code after adapting new approach for dtim period is
also removed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |    8 ++++++--
 drivers/net/wireless/mwifiex/main.h        |    2 +-
 drivers/net/wireless/mwifiex/scan.c        |    6 ------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    3 +++
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 54e45c8..478d2f1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -539,6 +539,11 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 		ret = -EFAULT;
 	}
 
+	/* Get DTIM period information from firmware */
+	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			      HostCmd_ACT_GEN_GET, DTIM_PERIOD_I,
+			      &priv->dtim_period);
+
 	/*
 	 * Bit 0 in tx_htinfo indicates that current Tx rate is 11n rate. Valid
 	 * MCS index values for us are 0 to 7.
@@ -573,8 +578,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 						WLAN_CAPABILITY_SHORT_SLOT_TIME)
 			sinfo->bss_param.flags |=
 					BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-		sinfo->bss_param.dtim_period =
-			priv->curr_bss_params.bss_descriptor.dtim_period;
+		sinfo->bss_param.dtim_period = priv->dtim_period;
 		sinfo->bss_param.beacon_interval =
 			priv->curr_bss_params.bss_descriptor.beacon_period;
 	}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3dc0f72..52810b1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -249,7 +249,6 @@ struct mwifiex_bssdescriptor {
 	u32 channel;
 	u32 freq;
 	u16 beacon_period;
-	u8 dtim_period;
 	u8 erp_flags;
 	u32 bss_mode;
 	u8 supported_rates[MWIFIEX_SUPPORTED_RATES];
@@ -392,6 +391,7 @@ struct mwifiex_private {
 	u8 prev_bssid[ETH_ALEN];
 	struct mwifiex_current_bss_params curr_bss_params;
 	u16 beacon_period;
+	u8 dtim_period;
 	u16 listen_interval;
 	u16 atim_window;
 	u8 adhoc_channel;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 1352085..98f1ca9 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1086,7 +1086,6 @@ mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	struct ieee_types_vendor_specific *vendor_ie;
 	const u8 wpa_oui[4] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wmm_oui[4] = { 0x00, 0x50, 0xf2, 0x02 };
-	struct ieee80211_tim_ie *tim_ie;
 
 	found_data_rate_ie = false;
 	rate_size = 0;
@@ -1259,11 +1258,6 @@ mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
 			break;
-		case WLAN_EID_TIM:
-			tim_ie = (void *) (current_ptr +
-					 sizeof(struct ieee_types_header));
-			bss_entry->dtim_period = tim_ie->dtim_period;
-			break;
 		default:
 			break;
 		}
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index e812db8..0d8618a 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -210,6 +210,9 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 			dev_dbg(priv->adapter->dev,
 				"info: SNMP_RESP: TxRetryCount=%u\n", ul_temp);
 			break;
+		case DTIM_PERIOD_I:
+			dev_dbg(priv->adapter->dev,
+				"info: SNMP_RESP: DTIM period=%u\n", ul_temp);
 		default:
 			break;
 		}
-- 
1.7.0.2

