Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:27740 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752633AbdATO3x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 09:29:53 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [RFC 2/2] ath9k: Add frame corruption simulator
Date: Fri, 20 Jan 2017 15:29:30 +0100
Message-Id: <1484922570-23659-3-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20170120_153007_015038_01E09AFE)
In-Reply-To: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add debugfs entries to corrupt specified frame types
by invering fcs field upon transmissionm with given probability.

Select frames to be corrupted.
<ath9k_debugs>/corrupt_fcs_fram_mask:
 Bit 16 - Null function
 Bit 15 - QoS Null function
 Bit 14 - EAPOL
 Bit 13 - Action
 Bit 12 - Deauthentication
 Bit 11 - Authentication
 Bit 10 - Disassociation
 Bit 9  - ATIM
 Bit 8  - Beacon
 Bit 5  - Probe response
 Bit 4  - Probe request
 Bit 3  - Reassociation response
 Bit 2  - Reassociation request
 Bit 1  - Association response
 Bit 0  - Association request

Select corruption probability:
<ath9k_debugs>/corrupt_fcs_prob: 0(0%) to 255(100%)

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |  15 +++++
 drivers/net/wireless/ath/ath9k/ath9k.h |   7 ++
 drivers/net/wireless/ath/ath9k/debug.c |  51 ++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  | 117 +++++++++++++++++++++++++++++++++
 4 files changed, 190 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 8f231c6..ca50f0f 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -95,6 +95,21 @@ config ATH9K_TX99
 	  be evaluated to meet the RF exposure limits set forth in the
 	  governmental SAR regulations.
 
+config ATH9K_FRAME_LOSS_SIMULATOR
+	bool "Atheros ath9k frame loss simulator"
+	depends on ATH9K && ATH9K_DEBUGFS && DEBUG_FS
+	default n
+	---help---
+	  Say N. This option should be used only to test fail paths
+          and timeouts by inverting fcs field of selected frames to
+	  be transmitted.
+	  Which frames are corrupted is marked by bitfield in
+	  corrupt_fcs_frame_mask debug entry and probability of
+	  of corruption in corrupt_fcs_prob (0-255). Zero means
+	  disabled and writing 255 makes all selected frames fail.
+	  Management, EAPOL, and Null function frames are
+	  supported.
+
 config ATH9K_DFS_CERTIFIED
 	bool "Atheros DFS support for certified platforms"
 	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 331947b..e5ae8f2 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -183,6 +183,9 @@ struct ath_frame_info {
 	u8 baw_tracked : 1;
 	u8 tx_power;
 	enum ath9k_key_type keytype:2;
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+	u8 corrupt_fcs : 1;
+#endif
 };
 
 struct ath_rxbuf {
@@ -1087,6 +1090,10 @@ struct ath_softc {
 	u32 rng_last;
 	struct task_struct *rng_task;
 #endif
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+	u16 corrupt_fcs_prob;
+	u32 corrupt_fcs_frame_mask;
+#endif
 };
 
 /********/
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 43930c3..15ccf52 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1315,6 +1315,50 @@ void ath9k_deinit_debug(struct ath_softc *sc)
 	ath9k_cmn_spectral_deinit_debug(&sc->spec_priv);
 }
 
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+static ssize_t read_file_corrupt_fcs_frame_mask(struct file *file,
+						char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[4];
+	unsigned int len;
+
+	len = sprintf(buf, "0x%08x\n", sc->corrupt_fcs_frame_mask);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_corrupt_fcs_frame_mask(struct file *file,
+						 const char __user *user_buf,
+						 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long corrupt_fcs_frame_mask;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &corrupt_fcs_frame_mask))
+		return -EINVAL;
+
+	sc->corrupt_fcs_frame_mask = corrupt_fcs_frame_mask;
+
+	return count;
+}
+
+static const struct file_operations fops_corrupt_fcs_frame_mask = {
+	.read = read_file_corrupt_fcs_frame_mask,
+	.write = write_file_corrupt_fcs_frame_mask,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+#endif
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1402,5 +1446,12 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_u16("airtime_flags", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->airtime_flags);
 
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+	debugfs_create_u16("corrupt_fcs_prob", S_IRUSR | S_IWUSR,
+			   sc->debug.debugfs_phy, &sc->corrupt_fcs_prob);
+	debugfs_create_file("corrupt_fcs_frame_mask", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc,
+			    &fops_corrupt_fcs_frame_mask);
+#endif
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c35a192..86a7e31 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1443,6 +1443,10 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 			if (bf->bf_state.bfs_paprd)
 				info.flags |= (u32) bf->bf_state.bfs_paprd <<
 					      ATH9K_TXDESC_PAPRD_S;
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+			if (fi->corrupt_fcs)
+				info.flags |= ATH9K_TXDESC_CORRUPT_FCS;
+#endif
 
 			/*
 			 * mac80211 doesn't handle RTS threshold for HT because
@@ -2345,6 +2349,112 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 	return 0;
 }
 
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+static bool corrupt_frame_fcs(struct ath_softc *sc, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	/* Frame loss enable mask */
+	/* Bit 16 - Null function*/
+	/* Bit 15 - QoS Null function*/
+	/* Bit 14 - EAPOL */
+	/* Bit 13 - Action */
+	/* Bit 12 - Deauthentication */
+	/* Bit 11 - Authentication */
+	/* Bit 10 - Disassociation */
+	/* Bit 9  - ATIM */
+	/* Bit 8  - Beacon */
+	/* Bit 5  - Probe response */
+	/* Bit 4  - Probe request */
+	/* Bit 3  - Reassociation response */
+	/* Bit 2  - Reassociation request */
+	/* Bit 1  - Association response */
+	/* Bit 0  - Association request */
+
+	/* Frame loss probability is 0(0%) to 255(100%) */
+	if (sc->corrupt_fcs_prob &&
+	    get_random_int() % 256 <= sc->corrupt_fcs_prob) {
+		u16 fctl_stype =
+			le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_STYPE;
+
+		if (((1 << 16) & sc->corrupt_fcs_frame_mask) &&
+		    ieee80211_is_nullfunc(hdr->frame_control)) {
+			ath_info(common, "Null function frame corrupted\n");
+			return true;
+		}
+		if (((1 << 15) & sc->corrupt_fcs_frame_mask) &&
+		    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+			ath_info(common, "QOS Null function frame corrupted\n");
+			return true;
+		}
+		if (((1 << 14) & sc->corrupt_fcs_frame_mask) &&
+		    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)) {
+			ath_info(common, "EAPOL frame corrupted\n");
+			return true;
+		}
+		if (ieee80211_is_mgmt(hdr->frame_control) &&
+		    ((1 << (fctl_stype >> 4)) & sc->corrupt_fcs_frame_mask)) {
+			switch (fctl_stype) {
+			case IEEE80211_STYPE_ASSOC_REQ:
+				ath_info(common,
+					 "Association request corrupted\n");
+				break;
+			case IEEE80211_STYPE_ASSOC_RESP:
+				ath_info(common,
+					 "Association response corrupted\n");
+				break;
+			case IEEE80211_STYPE_REASSOC_REQ:
+				ath_info(common,
+					 "Re-association request corrupted\n");
+				break;
+			case IEEE80211_STYPE_REASSOC_RESP:
+				ath_info(common,
+					 "Re-association response corrupted\n");
+				break;
+			case IEEE80211_STYPE_PROBE_REQ:
+				ath_info(common,
+					 "Probe request corrupted\n");
+				break;
+			case IEEE80211_STYPE_PROBE_RESP:
+				ath_info(common,
+					 "Probe response corrupted\n");
+				break;
+			case IEEE80211_STYPE_BEACON:
+				ath_info(common,
+					 "Beacon corrupted\n");
+				break;
+			case IEEE80211_STYPE_ATIM:
+				ath_info(common,
+					 "ATIM frame corrupted\n");
+				break;
+			case IEEE80211_STYPE_DISASSOC:
+				ath_info(common,
+					 "Disassociation frame corrupted\n");
+				break;
+			case IEEE80211_STYPE_AUTH:
+				ath_info(common,
+					 "Authentication frame corrupted\n");
+				break;
+			case IEEE80211_STYPE_DEAUTH:
+				ath_info(common,
+					 "Deauthentication frame corrupted\n");
+				break;
+			case IEEE80211_STYPE_ACTION:
+				ath_info(common,
+					 "Action frame corrupted\n");
+				break;
+
+			default:
+				return false;
+			}
+			return true;
+		}
+	}
+	return false;
+}
+#endif
 
 /* Upon failure caller should free skb */
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -2363,6 +2473,9 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ath_buf *bf;
 	bool ps_resp;
 	int q, ret;
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+	bool corrupt_fcs = corrupt_frame_fcs(sc, skb);
+#endif
 
 	if (vif)
 		avp = (void *)vif->drv_priv;
@@ -2373,6 +2486,10 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (ret)
 	    return ret;
 
+#ifdef CONFIG_ATH9K_FRAME_LOSS_SIMULATOR
+	fi->corrupt_fcs = corrupt_fcs;
+#endif
+
 	hdr = (struct ieee80211_hdr *) skb->data;
 	/*
 	 * At this point, the vif, hw_key and sta pointers in the tx control
-- 
2.7.4
