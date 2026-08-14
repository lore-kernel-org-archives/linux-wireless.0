Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139BD4457B8
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786712669; cv=none; b=cD74T3jOLMFl73/3qvIJpBs7w6PltuUtvSMxYRJzR/utvvOebrA5iKMe1cgVujAe9jtqM/T2Vxjn4zILkCtE9S13+mytHqOQecLVCvbunmBi/0/2JQs7pMop2zX99oWE2cTX9XtL5fKBW/yuQJ9+vFLljpRR+/e9YMBE6SL5ZOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786712669; c=relaxed/simple;
	bh=Maf9RgD+0IOxRF2tWwTtH1M9haqBrQ15HwCvh6ZCEjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ey+oUHDr608UslreXig+4JNESNbE8trzogNHcSLBj0VyGo+2zUlydQc6HStEo2gZ3v2+uX0Z1vK/9zD4SQIjYSYGCyAre5HH2WAoPftOhHWB0Q8fskTy9S1UDMig53j3THyJgsVsrWw+cki/4yS4C7JrWOHCeV3hDqhnSZSomuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHt6h+oA; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHt6h+oA"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ced3386430so10403565ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 06:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786712666; x=1787317466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2jGjXEZ3uQl8flfRKuMCEEr1fs+F6hETSWVmOcLFVvQ=;
        b=jHt6h+oAP825rtpETlHqMAhYTCMP+ffBTwn1awrN5V66MWyaik/NIVGyfQYruwnRpI
         MNYZMphuzaNlvqy6bVD+1644CUysQFak8a38K+nKfBAxAJpERCzSr6ifIi+beNPR+Jon
         OpIkXq0rpim1r/U0ecZEeERvY+yA1W3HEy5iPO4eB8fDDDkYaN30k2ly3a+EQBLUCUeb
         f6vnGAGj9qOzrJ2PBZf4782mnyM6W5tfR/T5UU72v15wTiF1GWBQWQRxxabh8d5bi1+h
         7qEmLfmnTAaZY5VMtQIdo4adoeIretFlJ6eUo6f2CJ7g7nusOg2A4/jWPeCTH8E3YO4f
         XBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786712666; x=1787317466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2jGjXEZ3uQl8flfRKuMCEEr1fs+F6hETSWVmOcLFVvQ=;
        b=eGoglUBHmnC/wSzXFFmGbjJbcsUrZ8jCCqYABSfDqrFs71shEkRV1dqNs40mi+GQxG
         P6RE7aL7ZIUTA61Uv/GbuXwfJYIehaMYvgV9VhI3VyygHZNiAX5LiNfgf4rebuQt06oC
         gQ1b071sPOPrZdpdQh2DkCSHJqJWP21fVgJAGcDs/VEhp3lx23jDyTJgbpJkJ8XcvSzB
         HiQKfGVz6y6QeIGLJh6uz67mmAN2VDPmxrw+Nfu2H6iQMW+ltUtowsRbzyCGJNoozVuE
         a7Rocr/p3dFvN4fPlj505zkF8g5X6uIsokwwrjpPKf4m1rL3weqTnEy76gjBPxGW6o0g
         a2Dw==
X-Gm-Message-State: AOJu0YwdbIAoWrlSe7MtTGMK5KcGox9XyJSz5+tOFnckMMhSV9iHY5nv
	k9lbLD98k32TZkZVuJfzQfO9Mq59zVycf9wz81XCqKjZl/mw8t5gk4WCGeC78PG1iEDizg==
X-Gm-Gg: AR+sD10gUMqK4i/aBif5fv7M5tvqq7EzOPmwX0Dq9OvoyqAofClQqQHDP4dDciD031u
	pmizGv93nfo4XtIEyS09ORCDyA0lz4ReQTnDjTgI1bsHvuH6k9FCnxTrubKBEHA6mGTvKIqD7Me
	jSHA/xO75N+fmkHp3HgQINQZVxou1aOKvbRbDxtCz6Lft/IZc3/jdArHUNSxSgtYx9iw8Ur9qFv
	eeh7LVFIPleUnp7JCZaHSmKJtYiwDMmAeniaW7qaGNSAc+bRIJzwUIgSiWi3VDZH96e/lIK/LrA
	T9VL91IF9ltCS3ywynABbDU1XrTyL4b0fdLeNaldgu+hVp5hurqvX4+kjxKMpOl3F+Yhfub7xPO
	8wkf5xcEjD1Wgo24tF9sgk4sH9QptV/TgvnAt1fE6bWxG4GcKyzdo9rHaiULXoFLAg1www7X4rU
	7ZB6dT9/9TQk88ic2eSNkyn3ctf/KCCJEkykEZhNrEFI2jAJDrGhhJ6A/y0odMTosz8tH3Z/seK
	uPmv0IcLLp7BTLp6jp0L7TNrkMxopPAo5DJ4jy9olafDWb9N/fNhg/LsKhtlKY=
X-Received: by 2002:a17:903:32cb:b0:2ce:93a3:c168 with SMTP id d9443c01a7336-2d3b085db2fmr65522715ad.7.1786712665532;
        Fri, 14 Aug 2026 06:04:25 -0700 (PDT)
Received: from mouri.. (cm-27-145-52-219.revip12.asianet.co.th. [27.145.52.219])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aebf17absm9099345ad.80.2026.08.14.06.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:04:25 -0700 (PDT)
From: Mouri <mourimcbusiness@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: miriam.rachel.korenblit@intel.com,
	johannes.berg@intel.com,
	Mouri <mourimcbusiness@gmail.com>
Subject: [PATCH] wifi: iwlwifi: fix spelling mistakes
Date: Fri, 14 Aug 2026 09:02:46 -0400
Message-ID: <20260814130246.25259-1-mourimcbusiness@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix several spelling mistakes in the iwlwifi driver documentation
and comments.

Signed-off-by: Mouri <mourimcbusiness@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

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
index 3e73a6195fd9..88bdff486bd4 100644
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
@@ -3617,7 +3617,7 @@ static void iwl_mvm_mei_host_associated(struct iwl_mvm *mvm,
 		break;
 	default:
 		/* auth method / AKM not supported */
-		/* TODO: All the FT vesions of these? */
+		/* TODO: All the FT versions of these? */
 		return;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 3831b3c27e0f..d0ea18c5f03b 100644
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
index d3c2fe830477..2beea10302ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
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

