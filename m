Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0987F37187E
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786853794; cv=none; b=R7F5klY6WHSv2kU9xQQpoZZYo+VKjZ9urtJHWhQv1G7NYGyeHVLpCslOmz/MMHRLA5S4DBEj5wUuent43LBBW15o0EwmTVWShjRiWcCfeGt1uyi+O5dZ0zfso+GEaF8u3VAj2G+eVAOepgTcUrw9p5sGEuG3zhihMn0WycylD0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786853794; c=relaxed/simple;
	bh=4LaYiLkDP2aXmEkannttRkqIwiLf76AhQXAio4+A28I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hdsYyxFZgHv3r15L1CETmHoNhHhd/fjIn0aA7JRzgv4DXDfRB1DHIWOjWUkbvAaQsX/Mbao5UR+yFsj9px4NtURfcbW+xgTB0K7Z/D+AlnB9QE/zk2SvXe02aSUVrea6yHrfp61SDl5usIkkd5n1KIugybeib0EUsTmsc0sa9Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W8XkwF95; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8XkwF95"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-384930ca5e2so2553985a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 21:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786853792; x=1787458592; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x4AoVOMsMK3rMZOZOWllsqcg2u1mx3uVn8qKNNd+UFs=;
        b=W8XkwF95TjgPx2i+2CWVAqCgJTpPMX3SCtIPdIH66BvtxitG+E285Q+Ej47L0Tv6wa
         5IlG2Awd1B/owwnAa3OWiNN7ZsXb0tXAFaTe3kbUlN110tR6EeLFHbEKyONp8JNtUrVd
         ctG49yoJC214hUTVB3Y0Lue18et95wvMBC/0LZYWdUhegT479+Dzkapv/KktLkO4FPbD
         BS1BFXUWRGTO3MbZny0FsCz2DSBOQUOvQk+t1RlbbrqO1+wCRnfOGwoRfuL/IbrNrGE4
         0Iy7ydFyJbxgjJwt1R/vBlgIdP2ARaVpu0142duY9zBGyPCttdvHKxesZqFzQOeACcVA
         fjcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786853792; x=1787458592;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x4AoVOMsMK3rMZOZOWllsqcg2u1mx3uVn8qKNNd+UFs=;
        b=ZryepPICkfS2D35UWr8GgFgydojfCz1csmdKygKo9FZhNreyWS1KXnIgFkjn5nTNFq
         ssXw2TfXHOVbp6JHqaCE0H5OvZuM6UvJM6mf/U1SB4C1fWeJ7daRvBqlZSbNriwRcQRY
         eRPi51F6Cdmf0FUSfqFYDtx9ya9joyWpH6mummQgdh5U/fxlh/qnRImvooJanP9VlMh2
         yu2iOcdLdXnyRWNA9GgzEqbeyZf1H4RXgM6zMWv/oCwUI/W6vwZslb2ydc0fiby9u53l
         /5/aaplBh1xCqKR4dEkbjQGvif/ahbj8AlMQT39TmxxhC6tEdusCZHab+OwnVK1Q8T4e
         lR8A==
X-Gm-Message-State: AOJu0Yzh3K1pPN+9Yg+6QZECG+VF+oRMnqjXkWFCeTE4Pz7HBCDS49pv
	qnQOM6C/415+eMYjyT4c4Z+bs/qjws7RZROS+Ji3A20SF9RiiC4XJ4UB
X-Gm-Gg: AR+sD10V48NAUXTMqjHbiH7TBthW0EPpf1jGap0hdfy8K4qf1TlSwlgzIVEh8eI+0Cu
	GwrdWP4nmNwYfdVCxJNInDrH39KTYJkICu0wf1EAJUif4g5yXYn0x9G9AxauXWAD/bviPyUACyq
	O8GPJPvVY+iCsnhfPjEdjPnD2qqzWeEME9zeO/FBhpRWai14ShQoB6XlWDwCQZbyfCfKurJYpJx
	3l8JXVvRv9XxkavBdLpSOWom3BexEKD2vbCrXqBaVS2IewkRmH39dkLFqf67Bubga6UYVpokqGx
	XUs7h6bmHVx6PUv+rAswNAyfdS1Utwx9qaTdZsu33SzJ4XM9miyWMMtGA33ik190DvVcoZWy5ZR
	qnrHNf/dMxNfPGITbT3s1quMv7LaDnAi9sioNLYDBBgqLxT6Uv6RjyWLzTaPUOapvPp7W8eW+Tg
	v8H1s6htfARoD1vTuhpzEwK+zDftu7+rsnOohBWnMri24QZZwfXgwQgatyZRYo5gTfG5RUDEgQB
	cyQQWQYMZ5lyBFx7zuHcmblvlc6Q2+8UZnf9twWDXc+EZs3YaHHeqw5H183v3dRO3HqYQ/b
X-Received: by 2002:a17:90b:590d:b0:38f:23d6:b4a9 with SMTP id 98e67ed59e1d1-3933ed66651mr20360162a91.21.1786853792215;
        Sat, 15 Aug 2026 21:16:32 -0700 (PDT)
Received: from mourii21.. (cm-27-145-52-219.revip12.asianet.co.th. [27.145.52.219])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141387af4adsm24416232c88.1.2026.08.15.21.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 21:16:31 -0700 (PDT)
From: Mouri Vance <mourimcbusiness@gmail.com>
To: hannelotta@gmail.com
Cc: linux-wireless@vger.kernel.org,
	johannes.berg@intel.com,
	miriam.rachel.korenblit@intel.com,
	Mouri Vance <mourimcbusiness@gmail.com>
Subject: [PATCH v2] wifi: iwlwifi: fix spelling mistakes
Date: Sun, 16 Aug 2026 00:15:36 -0400
Message-ID: <20260816041536.16475-1-mourimcbusiness@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix several spelling mistakes in the iwlwifi driver documentation
and comments.

Reviewed-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Signed-off-by: Mouri Vance <mourimcbusiness@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

Changes in v2:
- Fix additional spelling/grammar issues suggested during review.
- Add Reviewed-by tag and use full name in Signed-off-by.

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 07f1240df866..692bb17dfc33 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -352,7 +352,7 @@ struct iwl_fw_ini_error_dump_register {
  * struct iwl_fw_ini_dump_cfg_name - configuration name
  * @image_type: image type the configuration is related to
  * @cfg_name_len: length of the configuration name
- * @cfg_name: name of the configuraiton
+ * @cfg_name: name of the configuration
  */
 struct iwl_fw_ini_dump_cfg_name {
 	__le32 image_type;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3e73a6195fd9..730c07d22964 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2302,7 +2302,7 @@ int iwl_mvm_set_sta_pkt_ext(struct iwl_mvm *mvm,
 			iwl_mvm_parse_ppe(mvm, pkt_ext, nss, ru_index_bitmap,
 					  ppe, ppe_pos_bit, true);
 		/* EHT PPE Thresholds doesn't exist - set the API according to
-		 * HE PPE Tresholds
+		 * HE PPE Thresholds
 		 */
 		} else if (link_sta->he_cap.he_cap_elem.phy_cap_info[6] &
 			   IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT) {
@@ -2364,7 +2364,7 @@ int iwl_mvm_set_sta_pkt_ext(struct iwl_mvm *mvm,
 }
 
 /*
- * This function sets the MU EDCA parameters ans returns whether MU EDCA
+ * This function sets the MU EDCA parameters and returns whether MU EDCA
  * is enabled or not
  */
 bool iwl_mvm_set_fw_mu_edca_params(struct iwl_mvm *mvm,
@@ -2897,7 +2897,7 @@ bool iwl_mvm_start_ap_ibss_common(struct ieee80211_hw *hw,
 		iwl_mvm_send_low_latency_cmd(mvm, true, mvmvif->id);
 	}
 
-	/* power updated needs to be done before quotas */
+	/* power update needs to be done before quotas */
 	iwl_mvm_power_update_mac(mvm);
 
 	return false;
@@ -3617,7 +3617,7 @@ static void iwl_mvm_mei_host_associated(struct iwl_mvm *mvm,
 		break;
 	default:
 		/* auth method / AKM not supported */
-		/* TODO: All the FT vesions of these? */
+		/* TODO: All the FT versions of these? */
 		return;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 3831b3c27e0f..99d4dea4aec3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2226,7 +2226,7 @@ static u16 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 
 	/*
 	 * Extended dwell is relevant only for low band to start with, as it is
-	 * being used for social channles only (1, 6, 11), so we can check
+	 * being used for social channels only (1, 6, 11), so we can check
 	 * only scan type on low band also for CDB.
 	 */
 	if (iwl_mvm_is_regular_scan(params) &&
@@ -3441,7 +3441,7 @@ size_t iwl_mvm_scan_size(struct iwl_mvm *mvm)
 
 /*
  * This function is used in nic restart flow, to inform mac80211 about scans
- * that was aborted by restart flow or by an assert.
+ * that were aborted by restart flow or by an assert.
  */
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index ff099aec7886..1cc0f703d675 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -75,7 +75,7 @@ struct iwl_mvm_vif;
 /**
  * DOC: station table - introduction
  *
- * The station table is a list of data structure that reprensent the stations.
+ * The station table is a list of data structure that represent the stations.
  * In STA/P2P client mode, the driver will hold one station for the AP/ GO.
  * In GO/AP mode, the driver will have as many stations as associated clients.
  * All these stations are reflected in the fw's station table. The driver
@@ -292,7 +292,7 @@ enum iwl_mvm_rxq_notif_type {
 /**
  * struct iwl_mvm_internal_rxq_notif - Internal representation of the data sent
  * in &iwl_rxq_sync_cmd. Should be DWORD aligned.
- * FW is agnostic to the payload, so there are no endianity requirements.
+ * FW is agnostic to the payload, so there are no endianness requirements.
  *
  * @type: value from &iwl_mvm_rxq_notif_type
  * @sync: ctrl path is waiting for all notifications to be received
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d3c2fe830477..eb563b6e1233 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -497,7 +497,7 @@ static void iwl_mvm_set_tx_cmd_crypto(struct iwl_mvm *mvm,
 		fallthrough;
 	case WLAN_CIPHER_SUITE_CCMP_256:
 		/* TODO: Taking the key from the table might introduce a race
-		 * when PTK rekeying is done, having an old packets with a PN
+		 * when PTK rekeying is done, having an old packet with a PN
 		 * based on the old key but the message encrypted with a new
 		 * one.
 		 * Need to handle this.
@@ -530,7 +530,7 @@ static bool iwl_mvm_use_host_rate(struct iwl_mvm *mvm,
 	 * Not a data frame, use host rate if on an old device that
 	 * can't possibly be doing MLO (firmware may be selecting a
 	 * bad rate), if we might be doing MLO we need to let FW pick
-	 * (since we don't necesarily know the link), but FW rate
+	 * (since we don't necessarily know the link), but FW rate
 	 * selection was fixed.
 	 */
 	return mvm->trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_BZ;
@@ -914,7 +914,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	/*
 	 * Do not build AMSDU for IPv6 with extension headers.
-	 * ask stack to segment and checkum the generated MPDUs for us.
+	 * ask stack to segment and checksum the generated MPDUs for us.
 	 */
 	if (skb->protocol == htons(ETH_P_IPV6) &&
 	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
@@ -1664,7 +1664,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			 * its sequence control is 0. Note that for that same
 			 * reason, NDPs are never sent to A-MPDU'able queues
 			 * so that we can never have more than one freed frame
-			 * for a single Tx resonse (see WARN_ON below).
+			 * for a single Tx response (see WARN_ON below).
 			 */
 			if (ieee80211_is_qos_nullfunc(hdr->frame_control))
 				is_ndp = true;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 2e12f93ad32b..9398c9e3193a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -135,7 +135,7 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 }
 
 /*
- * We assume that the caller set the status to the sucess value
+ * We assume that the caller set the status to the success value
  */
 int iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id, u16 len,
 				const void *data, u32 *status)
@@ -284,7 +284,7 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq)
  * @smps_request: The request to change the SMPS mode.
  * @link_id: for MLO link_id, otherwise 0 (deflink)
  *
- * Get a requst to change the SMPS mode,
+ * Get a request to change the SMPS mode,
  * and change it according to all other requests in the driver.
  */
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-- 
2.43.0

