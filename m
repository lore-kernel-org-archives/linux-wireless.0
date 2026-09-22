Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A164A1DDF0
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077688; cv=none; b=EbrCnBbWYhskpA96TwC+xMP00ZwKjwokK+CnSzwd0Crpgko1y4vM2yPozH9zAtmP9IBiX/K4Jeldt4CW7hLwZdLDq15jQ3luHktF20QMkSyCqkDSMFgXsYU8uZHAzMtOQpRhIfVTL3Hk+/iUg0+lEwdDJ5kfElqPm+1sTYj6u0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077688; c=relaxed/simple;
	bh=iIkgD29DK6nPwEKIVPEyAgAEbM973yeJ1LTsuYRa0A8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KqoJxCGBWAykcWNaE7lQX/o6ExEWaVm6rUVKZRpTj4mmkNjVlF9DXz2Q7IwVRAxXdWnKibny+Zf2lnWdbOgVo+q6E2r+V1y29ZRlBI1pDRQRn1E5LI70/od27MT9rCMkv1HPXIi4GEV11pEbIQMryIZsjhfj7KvprYt5S+Fv14c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iGYFcyFv; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iGYFcyFv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077686; x=1821613686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iIkgD29DK6nPwEKIVPEyAgAEbM973yeJ1LTsuYRa0A8=;
  b=iGYFcyFvLvhYvCPIUDMQJDAaBeZiC2D4wzDYN/w0L7GGiQNZBK4zzxnk
   SY4qITSKW2XlVpF+stV8zDTX4iTQTBi+r0UsAQ4afYRwqT1T3bgZ3P2px
   xxp4GhzMaoNkn5VEkCu+s9+nhJCGkO8lBagpC8bObQnhc6DomY/Y48R+y
   ZM0YVOzJXfHESufsGBf1t6FzWCqgictOfeTfE7bkx/D5YNulyYrgm5ye6
   NZr+2uki8IRXYV1efcqLKy0NJpFJZuT4Db44XmJ6V2ykJA6zQeCnTxsKI
   ehjaRscfrpdFFiWhQ2U6Qvsu8PWkRHIOwiVpl4z2CbpHCmdxBDU6yfX4h
   A==;
X-CSE-ConnectionGUID: 1/mwt4CJSIC9qaBDg5feCw==
X-CSE-MsgGUID: /eocv2y9TgCUWORQblH8vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170496"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170496"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:05 -0700
X-CSE-ConnectionGUID: MwEe4QqdToaPyVLzDJ29Mw==
X-CSE-MsgGUID: gX64mYJ8SY2C1W/iTbZKAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275316"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:04 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 01/15] wifi: iwlwifi: mld: support operational statistics notif ver 5
Date: Tue, 22 Sep 2026 14:49:48 +0300
Message-Id: <20260922144819.971d1a747698.I0792723d62dca7cf68056f13c8f733084ce6445f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add STATISTICS_FW_NTFY_OPERATIONAL_API_S_VER_5, which uses a new
per-PHY struct (VER_3) that appends the NPCA channel load fields.

Assisted-by: GitHubCopilot:claude-opus-4.8
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/stats.h | 58 ++++++++++++++++++-
 .../net/wireless/intel/iwlwifi/mld/notif.c    |  3 +-
 .../net/wireless/intel/iwlwifi/mld/stats.c    | 35 +++++++++--
 3 files changed, 88 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h b/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h
index 8d16782a129c..e3bf5d08c7e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h
@@ -615,6 +615,37 @@ struct iwl_stats_ntfy_coex {
 	__le16 reserved;
 } __packed; /* STATISTICS_FW_NTFY_COEX_TELEMETRY_API_S_VER_1 */
 
+/**
+ * struct iwl_stats_ntfy_per_phy_v2 - per PHY statistics
+ * @channel_load: channel load
+ * @channel_load_by_us: device contribution to MCLM
+ * @channel_load_not_by_us: other devices' contribution to MCLM
+ * @clt: CLT HW timer (TIM_CH_LOAD2)
+ * @act: active accumulator SW
+ * @elp: elapsed time accumulator SW
+ * @rx_detected_per_ch_width: number of deferred TX per channel width,
+ *	0 - 20, 1/2/3 - 40/80/160
+ * @success_per_ch_width: number of frames that got ACK/BACK/CTS
+ *	per channel BW. note, BACK counted as 1
+ * @fail_per_ch_width: number of frames that didn't get ACK/BACK/CTS
+ *	per channel BW. note BACK counted as 1
+ * @last_tx_ch_width_indx: last txed frame channel width index
+ * @coex: coex related data
+ */
+struct iwl_stats_ntfy_per_phy_v2 {
+	__le32 channel_load;
+	__le32 channel_load_by_us;
+	__le32 channel_load_not_by_us;
+	__le32 clt;
+	__le32 act;
+	__le32 elp;
+	__le32 rx_detected_per_ch_width[IWL_STATS_MAX_BW_INDEX];
+	__le32 success_per_ch_width[IWL_STATS_MAX_BW_INDEX];
+	__le32 fail_per_ch_width[IWL_STATS_MAX_BW_INDEX];
+	__le32 last_tx_ch_width_indx;
+	struct iwl_stats_ntfy_coex coex;
+} __packed; /* STATISTICS_NTFY_PER_PHY_API_S_VER_2 */
+
 /**
  * struct iwl_stats_ntfy_per_phy - per PHY statistics
  * @channel_load: channel load
@@ -631,6 +662,10 @@ struct iwl_stats_ntfy_coex {
  *	per channel BW. note BACK counted as 1
  * @last_tx_ch_width_indx: last txed frame channel width index
  * @coex: coex related data
+ * @channel_load_npca_by_us: device NPCA contribution to MCLM
+ * @channel_load_npca_obss: the time FW identified for NPCA, not necessarily
+ *	entered to NPCA state, but can be used as an indication for NPCA
+ *	opportunities in the environment
  */
 struct iwl_stats_ntfy_per_phy {
 	__le32 channel_load;
@@ -644,7 +679,9 @@ struct iwl_stats_ntfy_per_phy {
 	__le32 fail_per_ch_width[IWL_STATS_MAX_BW_INDEX];
 	__le32 last_tx_ch_width_indx;
 	struct iwl_stats_ntfy_coex coex;
-} __packed; /* STATISTICS_NTFY_PER_PHY_API_S_VER_2 */
+	__le32 channel_load_npca_by_us;
+	__le32 channel_load_npca_obss;
+} __packed; /* STATISTICS_NTFY_PER_PHY_API_S_VER_3 */
 
 /* unknown channel load (due to not being active on channel) */
 #define IWL_STATS_UNKNOWN_CHANNEL_LOAD	0xffffffff
@@ -675,12 +712,27 @@ struct iwl_system_statistics_notif_oper_v3 {
 	struct iwl_stats_ntfy_per_sta per_sta[IWL_STATION_COUNT_MAX];
 } __packed; /* STATISTICS_FW_NTFY_OPERATIONAL_API_S_VER_3 */
 
+/**
+ * struct iwl_system_statistics_notif_oper_v4 - statistics notification
+ *
+ * @time_stamp: time when the notification is sent from firmware
+ * @per_link: per link statistics, &struct iwl_stats_ntfy_per_link
+ * @per_phy: per phy statistics, &struct iwl_stats_ntfy_per_phy_v2
+ * @per_sta: per sta statistics, &struct iwl_stats_ntfy_per_sta
+ */
+struct iwl_system_statistics_notif_oper_v4 {
+	__le32 time_stamp;
+	struct iwl_stats_ntfy_per_link per_link[IWL_FW_MAX_LINKS];
+	struct iwl_stats_ntfy_per_phy_v2 per_phy[IWL_STATS_MAX_PHY_OPERATIONAL];
+	struct iwl_stats_ntfy_per_sta per_sta[IWL_STATION_COUNT_MAX];
+} __packed; /* STATISTICS_FW_NTFY_OPERATIONAL_API_S_VER_4 */
+
 /**
  * struct iwl_system_statistics_notif_oper - statistics notification
  *
  * @time_stamp: time when the notification is sent from firmware
  * @per_link: per link statistics, &struct iwl_stats_ntfy_per_link
- * @per_phy: per phy statistics, &struct iwl_stats_ntfy_per_phy_v1
+ * @per_phy: per phy statistics, &struct iwl_stats_ntfy_per_phy
  * @per_sta: per sta statistics, &struct iwl_stats_ntfy_per_sta
  */
 struct iwl_system_statistics_notif_oper {
@@ -688,7 +740,7 @@ struct iwl_system_statistics_notif_oper {
 	struct iwl_stats_ntfy_per_link per_link[IWL_FW_MAX_LINKS];
 	struct iwl_stats_ntfy_per_phy per_phy[IWL_STATS_MAX_PHY_OPERATIONAL];
 	struct iwl_stats_ntfy_per_sta per_sta[IWL_STATION_COUNT_MAX];
-} __packed; /* STATISTICS_FW_NTFY_OPERATIONAL_API_S_VER_4 */
+} __packed; /* STATISTICS_FW_NTFY_OPERATIONAL_API_S_VER_5 */
 
 /**
  * struct iwl_system_statistics_part1_notif_oper - part1 stats notification
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index 90733bbaf733..d0b85adf7417 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -329,7 +329,8 @@ CMD_VERSIONS(datapath_monitor_notif,
 	     CMD_VER_ENTRY(1, iwl_datapath_monitor_notif))
 CMD_VERSIONS(stats_oper_notif,
 	     CMD_VER_ENTRY(3, iwl_system_statistics_notif_oper_v3)
-	     CMD_VER_ENTRY(4, iwl_system_statistics_notif_oper))
+	     CMD_VER_ENTRY(4, iwl_system_statistics_notif_oper_v4)
+	     CMD_VER_ENTRY(5, iwl_system_statistics_notif_oper))
 CMD_VERSIONS(stats_oper_part1_notif,
 	     CMD_VER_ENTRY(4, iwl_system_statistics_part1_notif_oper))
 CMD_VERSIONS(bt_coex_notif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/stats.c b/drivers/net/wireless/intel/iwlwifi/mld/stats.c
index e7b283cbe199..3b6cd4f382f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/stats.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/stats.c
@@ -43,12 +43,17 @@ iwl_mld_fill_stats_from_oper_notif(struct iwl_mld *mld,
 	const struct iwl_stats_ntfy_per_sta *per_sta;
 	struct ieee80211_link_sta *link_sta;
 	struct iwl_mld_link_sta *mld_link_sta;
+	u8 notif_ver = iwl_fw_lookup_notif_ver(mld->fw, STATISTICS_GROUP,
+					       STATISTICS_OPER_NOTIF, 3);
 
-	if (iwl_fw_lookup_notif_ver(mld->fw, STATISTICS_GROUP,
-				    STATISTICS_OPER_NOTIF, 3) >= 4) {
+	if (notif_ver >= 5) {
 		const struct iwl_system_statistics_notif_oper *notif =
 			(void *)&pkt->data;
 		per_sta = &notif->per_sta[fw_sta_id];
+	} else if (notif_ver == 4) {
+		const struct iwl_system_statistics_notif_oper_v4 *notif =
+			(void *)&pkt->data;
+		per_sta = &notif->per_sta[fw_sta_id];
 	} else {
 		const struct iwl_system_statistics_notif_oper_v3 *notif =
 			(void *)&pkt->data;
@@ -581,17 +586,39 @@ void iwl_mld_handle_stats_oper_notif(struct iwl_mld *mld,
 	struct iwl_system_statistics_notif_oper *_notif __free(kfree) = NULL;
 	const struct iwl_system_statistics_notif_oper *notif =
 		(void *)&pkt->data;
+	u8 notif_ver = iwl_fw_lookup_notif_ver(mld->fw, STATISTICS_GROUP,
+					       STATISTICS_OPER_NOTIF, 3);
 
 	BUILD_BUG_ON(ARRAY_SIZE(notif->per_sta) != IWL_STATION_COUNT_MAX);
 	BUILD_BUG_ON(ARRAY_SIZE(notif->per_link) <
 		     ARRAY_SIZE(mld->fw_id_to_bss_conf));
 
-	if (iwl_fw_lookup_notif_ver(mld->fw, STATISTICS_GROUP,
-				    STATISTICS_OPER_NOTIF, 3) == 3) {
+	if (notif_ver == 3) {
 		const struct iwl_system_statistics_notif_oper_v3 *stats =
 			(void *)&pkt->data;
 		_notif = kzalloc_obj(*_notif);
 
+		if (!_notif)
+			return;
+
+		_notif->time_stamp = stats->time_stamp;
+		for (int i = 0; i < ARRAY_SIZE(_notif->per_link); i++)
+			_notif->per_link[i] = stats->per_link[i];
+
+		BUILD_BUG_ON(sizeof(_notif->per_phy[0]) <
+			     sizeof(stats->per_phy[0]));
+		for (int i = 0; i < ARRAY_SIZE(_notif->per_phy); i++)
+			memcpy(&_notif->per_phy[i], &stats->per_phy[i],
+			       sizeof(stats->per_phy[i]));
+		for (int i = 0; i < ARRAY_SIZE(_notif->per_sta); i++)
+			_notif->per_sta[i] = stats->per_sta[i];
+
+		notif = _notif;
+	} else if (notif_ver == 4) {
+		const struct iwl_system_statistics_notif_oper_v4 *stats =
+			(void *)&pkt->data;
+		_notif = kzalloc_obj(*_notif);
+
 		if (!_notif)
 			return;
 
-- 
2.34.1

