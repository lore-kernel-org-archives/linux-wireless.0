Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA2631716D;
	Sun,  4 Oct 2026 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791113155; cv=none; b=h/fQPoIfyMUWyh1xUI9kB5MBulFjftY0XAo5QuKDtDm4zXChHqf0IGvF/Ca3P5xX87oQmqayGgbbmuQQyvN/xoc8Ntf5ONRZc0NJOP7SLnHTOE15pUFLIZiFE0JyV1fDiJczg0KypCx6P2+A63iMmG1bzXAHjVrSJOHNYzagpbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791113155; c=relaxed/simple;
	bh=4wNlrvHWB+tg5ATrpMN3QVQLWBs2aPSRd6dkMAHoGMU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GhTGic+5IDGWH0ODdcUYN2ibFG1D/k27Ksvz8KIvEDR+7Xt142fwqqcuU5va9b+4Q61wjsxErTJI/ugTbRMLPNK1VlW/tJbCw8qqZDkrlPdlyHv6u5fvLd+e3gpoA1UJMgnDt0QGw6M/bxUGE5gvotS15S/y4qemTMoOVF9L8FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=RRLvaxZ5; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="RRLvaxZ5"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id C2A6E1042A;
	Sun, 04 Oct 2026 14:25:51 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=NfFZZPXElHk5e+VeQkvF
	/5n9+of+dfO/5KvSX64jhyo=; b=RRLvaxZ5+aCrd583VD7lYdcvtfMmqzuOwQQn
	74DazyMeFOP4SgtH///jz7kSJLIEUBogWKJvbRF+oeHRsQsCJ5GY8FXlL1xX/NZ6
	Rgb/YapK13lwWjonEmE2znHtvtc06fHu2G98WEvOcbaUQEr8QoG0SVbRUd7oku1a
	5Gpkg2d8tNo3p36j8P8xsbtg/ws7pa32ciXrjeaBAXBxuudHz4pZqHjCGs06StFZ
	Fm2haQUeSroIEwU0pRlnG+HK/71Y2JeUI6cWoVtrZOjMut3km0xl8RsNOwSe3Cy0
	3GAG0EsegDiUsLhSz3rbozpa8QCxuVymAwZV/0YcApHIv0VvCw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id D00F1103CF;
	Sun, 04 Oct 2026 14:25:50 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:25:50 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH ath-next 1/2] wifi: ath11k: support firmware airtime fairness
Date: Sun, 4 Oct 2026 14:24:39 +0300
Message-ID: <fb53d997ec1f2c65e85e22fda14da4327fdabcf6.1791111136.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791111135.3.git.me@andrei-z.com>
References: <cover.1791111135.3.git.me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

Firmware with WMI_TLV_SERVICE_ATF schedules airtime between stations
itself, in proportion to per-station shares the host gives it in parts
per thousand. Enable it at init (resource config flag) and on each
radio, advertise NL80211_EXT_FEATURE_AIRTIME_FAIRNESS, and send the
shares of all AP stations of the radio, derived from their airtime
weights (sta_set_airtime_weight), whenever a station associates or
leaves or user space changes a weight. A radio whose firmware refuses
to enable it keeps working, without ATF.

The firmware schedules a station only within the share of its ATF group,
so group 0, which every station belongs to, first gets the whole radio
(WMI_ATF_SSID_GROUPING_REQUEST_CMDID, fair policy). Without the group,
the firmware passes no data at all to a station that has a share.

Both are needed: without the resource config flag the firmware takes the
shares but does not enforce them. With them, in a test that also set the
firmware's strict scheduling for the station (which this patch does not
do), a station capped at 100/1000 fell from 885 to 122 Mbit/s downlink
and recovered once uncapped; at its fair share a lone station runs at
full rate.

This matters most where the data path does not pass mac80211's queues,
such as NSS offload, where mac80211's own airtime scheduler never sees
the frames.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/core.h |   1 +
 drivers/net/wireless/ath/ath11k/mac.c  | 104 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/wmi.c  |  97 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/wmi.h  |  51 ++++++++++++
 4 files changed, 253 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923e..079376986d 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -541,6 +541,7 @@ struct ath11k_per_peer_cfr_capture {
 
 struct ath11k_sta {
 	struct ath11k_vif *arvif;
+	u16 airtime_weight;
 
 	/* the following are protected by ar->data_lock */
 	u32 changed; /* IEEE80211_RC_* */
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c1fa42edd3..183796ce1c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6685,6 +6685,15 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 		goto err;
 	}
 
+	if (test_bit(WMI_TLV_SERVICE_ATF, ab->wmi_ab.svc_map)) {
+		ret = ath11k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_ATF_DYNAMIC_ENABLE,
+						1, pdev->pdev_id);
+		/* Without it the radio still works, just without ATF */
+		if (ret)
+			ath11k_warn(ab, "failed to enable airtime fairness: %d\n",
+				    ret);
+	}
+
 	ret = ath11k_wmi_send_dfs_phyerr_offload_enable_cmd(ar, pdev->pdev_id);
 	if (ret) {
 		ath11k_err(ab, "failed to offload radar detection: %d\n",
@@ -9938,6 +9947,90 @@ static int ath11k_mac_station_remove(struct ath11k *ar,
 	return ret;
 }
 
+#define ATH11K_ATF_PEERS_PER_CMD 32
+
+struct ath11k_mac_atf_iter {
+	struct ath11k_wmi_atf_peer_arg *peers;
+	u16 *weights;
+	u32 num, max, total;
+};
+
+static void ath11k_mac_atf_iter(void *data, struct ieee80211_sta *sta)
+{
+	struct ath11k_mac_atf_iter *it = data;
+	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
+
+	if (it->num == it->max || !arsta->arvif ||
+	    arsta->arvif->vdev_type != WMI_VDEV_TYPE_AP)
+		return;
+
+	ether_addr_copy(it->peers[it->num].addr, sta->addr);
+	it->peers[it->num].vdev_id = arsta->arvif->vdev_id;
+	it->weights[it->num] = arsta->airtime_weight;
+	it->total += arsta->airtime_weight;
+	it->num++;
+}
+
+/* Firmware airtime fairness: give every station of the radio its share of
+ * the airtime, in proportion to its airtime weight. The firmware schedules
+ * a station only by the share of its group, so group 0 (every station's)
+ * gets the whole radio first.
+ */
+static int ath11k_mac_atf_update(struct ath11k *ar)
+{
+	struct ath11k_mac_atf_iter it = { .max = ar->max_num_stations };
+	u32 i, n;
+	int ret = 0;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (!test_bit(WMI_TLV_SERVICE_ATF, ar->ab->wmi_ab.svc_map))
+		return 0;
+
+	it.peers = kcalloc(it.max, sizeof(*it.peers), GFP_KERNEL);
+	it.weights = kcalloc(it.max, sizeof(*it.weights), GFP_KERNEL);
+	if (!it.peers || !it.weights) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ieee80211_iterate_stations_atomic(ar->hw, ath11k_mac_atf_iter, &it);
+
+	for (i = 0; i < it.num; i++)
+		it.peers[i].units = max_t(u32, 1, div_u64((u64)WMI_ATF_DENOMINATION *
+							  it.weights[i], it.total));
+
+	ret = ath11k_wmi_send_atf_group(ar, 0, WMI_ATF_DENOMINATION);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < it.num; i += n) {
+		n = min_t(u32, it.num - i, ATH11K_ATF_PEERS_PER_CMD);
+		ret = ath11k_wmi_send_peer_atf_request(ar, &it.peers[i], n,
+						       i + n < it.num);
+		if (ret)
+			break;
+	}
+
+out:
+	kfree(it.weights);
+	kfree(it.peers);
+	return ret;
+}
+
+static void ath11k_mac_op_sta_set_airtime_weight(struct ieee80211_hw *hw,
+						 struct ieee80211_vif *vif,
+						 struct ieee80211_sta *sta, u16 weight)
+{
+	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
+	struct ath11k *ar = hw->priv;
+
+	mutex_lock(&ar->conf_mutex);
+	arsta->airtime_weight = weight;
+	ath11k_mac_atf_update(ar);
+	mutex_unlock(&ar->conf_mutex);
+}
+
 static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
@@ -9965,6 +10058,7 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 	    new_state == IEEE80211_STA_NONE) {
 		memset(arsta, 0, sizeof(*arsta));
 		arsta->arvif = arvif;
+		arsta->airtime_weight = IEEE80211_DEFAULT_AIRTIME_WEIGHT;
 		arsta->peer_ps_state = WMI_PEER_PS_STATE_DISABLED;
 		INIT_WORK(&arsta->update_wk, ath11k_sta_rc_update_wk);
 		INIT_WORK(&arsta->set_4addr_wk, ath11k_sta_set_4addr_wk);
@@ -9996,6 +10090,9 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 		mutex_unlock(&ar->ab->tbl_mtx_lock);
 
 		ath11k_cfr_decrement_peer_count(ar, arsta);
+
+		if (vif->type == NL80211_IFTYPE_AP)
+			ath11k_mac_atf_update(ar);
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC &&
 		   (vif->type == NL80211_IFTYPE_AP ||
@@ -10005,6 +10102,8 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 		if (ret)
 			ath11k_warn(ar->ab, "Failed to associate station: %pM\n",
 				    sta->addr);
+		else if (vif->type == NL80211_IFTYPE_AP)
+			ath11k_mac_atf_update(ar);
 
 		spin_lock_bh(&ar->data_lock);
 		/* Set arsta bw and prev bw */
@@ -10096,6 +10195,7 @@ static const struct ieee80211_ops ath11k_ops = {
 	.sta_state                      = ath11k_mac_op_sta_state,
 	.sta_set_4addr                  = ath11k_mac_op_sta_set_4addr,
 	.sta_set_txpwr			= ath11k_mac_op_sta_set_txpwr,
+	.sta_set_airtime_weight		= ath11k_mac_op_sta_set_airtime_weight,
 	.link_sta_rc_update		= ath11k_mac_op_sta_rc_update,
 	.conf_tx                        = ath11k_mac_op_conf_tx,
 	.set_antenna			= ath11k_mac_op_set_antenna,
@@ -10633,6 +10733,10 @@ static int __ath11k_mac_register(struct ath11k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
 
+	if (test_bit(WMI_TLV_SERVICE_ATF, ar->ab->wmi_ab.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
+
 	ar->hw->wiphy->mbssid_max_interfaces = TARGET_NUM_VDEVS(ab);
 	ar->hw->wiphy->ema_max_profile_periodicity = TARGET_EMA_MAX_PROFILE_PERIOD;
 
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 08fd6795ed..ce793962b7 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4466,6 +4466,100 @@ int ath11k_wmi_set_hw_mode(struct ath11k_base *ab,
 	return 0;
 }
 
+int ath11k_wmi_send_atf_group(struct ath11k *ar, u32 group_id, u32 units)
+{
+	struct ath11k_pdev_wmi *wmi = ar->wmi;
+	struct wmi_atf_ssid_grp_request_cmd *cmd;
+	struct wmi_atf_group_info *grp;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = ath11k_wmi_alloc_skb(wmi->wmi_ab, sizeof(*cmd) + TLV_HDR_SIZE + sizeof(*grp));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_atf_ssid_grp_request_cmd *)skb->data;
+	cmd->tlv_header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ATF_SSID_GRP_REQUEST) |
+			  FIELD_PREP(WMI_TLV_LEN, sizeof(*cmd) - TLV_HDR_SIZE);
+	cmd->pdev_id = ar->pdev->pdev_id;
+
+	tlv = (struct wmi_tlv *)(skb->data + sizeof(*cmd));
+	tlv->header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ARRAY_STRUCT) |
+		      FIELD_PREP(WMI_TLV_LEN, sizeof(*grp));
+	grp = (struct wmi_atf_group_info *)tlv->value;
+	grp->tlv_header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ATF_GROUP_INFO) |
+			  FIELD_PREP(WMI_TLV_LEN, sizeof(*grp) - TLV_HDR_SIZE);
+	grp->atf_group_id = group_id;
+	grp->atf_group_units = units;
+	grp->atf_group_flags = WMI_ATF_GROUP_POLICY_FAIR;
+
+	ret = ath11k_wmi_cmd_send(wmi, skb, WMI_ATF_SSID_GROUPING_REQUEST_CMDID);
+	if (ret) {
+		ath11k_warn(ar->ab, "failed to send atf group request: %d\n", ret);
+		dev_kfree_skb(skb);
+		return ret;
+	}
+
+	ath11k_dbg(ar->ab, ATH11K_DBG_WMI, "cmd atf group %u units %u\n", group_id, units);
+
+	return 0;
+}
+
+int ath11k_wmi_send_peer_atf_request(struct ath11k *ar,
+				     const struct ath11k_wmi_atf_peer_arg *peers,
+				     u32 num_peers, bool more)
+{
+	struct ath11k_pdev_wmi *wmi = ar->wmi;
+	struct wmi_peer_atf_request_cmd *cmd;
+	struct wmi_atf_peer_info *info;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	u32 i, pdev_id = ar->pdev->pdev_id;
+	int ret, len;
+
+	len = sizeof(*cmd) + TLV_HDR_SIZE + num_peers * sizeof(*info);
+	skb = ath11k_wmi_alloc_skb(wmi->wmi_ab, len);
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_peer_atf_request_cmd *)skb->data;
+	cmd->tlv_header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_PEER_ATF_REQUEST) |
+			  FIELD_PREP(WMI_TLV_LEN, sizeof(*cmd) - TLV_HDR_SIZE);
+	cmd->num_peers = num_peers;
+	cmd->pdev_id = pdev_id;
+	cmd->atf_flags = WMI_PEER_ATF_REQ_FLAG_FULL_UPDATE |
+			 WMI_PEER_ATF_REQ_FLAG_PDEV_ID_VALID;
+	if (more)
+		cmd->atf_flags |= WMI_PEER_ATF_REQ_FLAG_PENDING_CMDS;
+
+	tlv = (struct wmi_tlv *)(skb->data + sizeof(*cmd));
+	tlv->header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ARRAY_STRUCT) |
+		      FIELD_PREP(WMI_TLV_LEN, num_peers * sizeof(*info));
+	info = (struct wmi_atf_peer_info *)tlv->value;
+
+	for (i = 0; i < num_peers; i++, info++) {
+		info->tlv_header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ATF_PEER_INFO) |
+				   FIELD_PREP(WMI_TLV_LEN, sizeof(*info) - TLV_HDR_SIZE);
+		ether_addr_copy(info->peer_macaddr.addr, peers[i].addr);
+		info->atf_units = peers[i].units;
+		info->vdev_id = peers[i].vdev_id;
+		info->pdev_id = pdev_id;
+	}
+
+	ret = ath11k_wmi_cmd_send(wmi, skb, WMI_PEER_ATF_REQUEST_CMDID);
+	if (ret) {
+		ath11k_warn(ar->ab, "failed to send peer atf request: %d\n", ret);
+		dev_kfree_skb(skb);
+		return ret;
+	}
+
+	ath11k_dbg(ar->ab, ATH11K_DBG_WMI, "cmd peer atf request pdev %u peers %u%s\n",
+		   pdev_id, num_peers, more ? " (more)" : "");
+
+	return 0;
+}
+
 int ath11k_wmi_cmd_init(struct ath11k_base *ab)
 {
 	struct ath11k_wmi_base *wmi_ab = &ab->wmi_ab;
@@ -4481,6 +4575,9 @@ int ath11k_wmi_cmd_init(struct ath11k_base *ab)
 		     ab->wmi_ab.svc_map))
 		config.is_reg_cc_ext_event_supported = 1;
 
+	if (test_bit(WMI_TLV_SERVICE_ATF, ab->wmi_ab.svc_map))
+		config.flag1 |= WMI_RSRC_CFG_FLAG1_ATF_CONFIG_ENABLE;
+
 	memcpy(&wmi_ab->wlan_resource_config, &config, sizeof(config));
 
 	init_param.res_cfg = &wmi_ab->wlan_resource_config;
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index b2dade0516..df7fd22048 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -212,6 +212,7 @@ enum wmi_cmd_group {
 	WMI_GRP_TWT            = 0x3e,
 	WMI_GRP_MOTION_DET     = 0x3f,
 	WMI_GRP_SPATIAL_REUSE  = 0x40,
+	WMI_GRP_ATM            = 0x45,
 };
 
 #define WMI_CMD_GRP(grp_id) (((grp_id) << 12) | 0x1)
@@ -625,6 +626,7 @@ enum wmi_tlv_cmd_id {
 	WMI_PDEV_OBSS_PD_SPATIAL_REUSE_CMDID =
 				WMI_TLV_CMD(WMI_GRP_SPATIAL_REUSE),
 	WMI_PDEV_OBSS_PD_SPATIAL_REUSE_SET_DEF_OBSS_THRESH_CMDID,
+	WMI_ATF_SSID_GROUPING_REQUEST_CMDID = WMI_TLV_CMD(WMI_GRP_ATM),
 };
 
 enum wmi_tlv_event_id {
@@ -1892,6 +1894,8 @@ enum wmi_tlv_tag {
 	WMI_TAG_PEER_CFR_CAPTURE_EVENT = 0x317,
 	WMI_TAG_CFR_CAPTURE_PHASE_PARAM = 0x33b,
 	WMI_TAG_FILS_DISCOVERY_TMPL_CMD = 0x344,
+	WMI_TAG_ATF_SSID_GRP_REQUEST = 0x346,
+	WMI_TAG_ATF_GROUP_INFO,
 	WMI_TAG_PDEV_SRG_BSS_COLOR_BITMAP_CMD = 0x37b,
 	WMI_TAG_PDEV_SRG_PARTIAL_BSSID_BITMAP_CMD,
 	WMI_TAG_PDEV_SRG_OBSS_COLOR_ENABLE_BITMAP_CMD = 0x381,
@@ -2353,6 +2357,7 @@ struct wmi_init_cmd {
 } __packed;
 
 #define WMI_RSRC_CFG_FLAG1_BSS_CHANNEL_INFO_64 BIT(5)
+#define WMI_RSRC_CFG_FLAG1_ATF_CONFIG_ENABLE BIT(6)
 #define WMI_RSRC_CFG_FLAG2_CALC_NEXT_DTIM_COUNT_SET BIT(9)
 #define WMI_RSRC_CFG_FLAG1_ACK_RSSI BIT(18)
 
@@ -3628,6 +3633,48 @@ struct ath11k_wmi_p2p_noa_info {
 #define WMI_EMA_FIRST_TMPL_SHIFT          16
 #define WMI_EMA_LAST_TMPL_SHIFT           24
 
+/* Airtime fairness: a share is in parts per thousand of the radio's airtime */
+#define WMI_ATF_DENOMINATION			1000
+#define WMI_PEER_ATF_REQ_FLAG_FULL_UPDATE	BIT(0)
+#define WMI_PEER_ATF_REQ_FLAG_PENDING_CMDS	BIT(1)
+#define WMI_PEER_ATF_REQ_FLAG_PDEV_ID_VALID	BIT(2)
+#define WMI_ATF_GROUP_POLICY_FAIR		0
+
+struct wmi_atf_ssid_grp_request_cmd {
+	u32 tlv_header;
+	u32 pdev_id;
+} __packed;
+
+struct wmi_atf_group_info {
+	u32 tlv_header;
+	u32 atf_group_id;
+	u32 atf_group_units;
+	u32 atf_group_flags;
+} __packed;
+
+struct wmi_peer_atf_request_cmd {
+	u32 tlv_header;
+	u32 num_peers;
+	u32 pdev_id;
+	u32 atf_flags;
+} __packed;
+
+struct wmi_atf_peer_info {
+	u32 tlv_header;
+	struct wmi_mac_addr peer_macaddr;
+	u32 atf_units;
+	u32 atf_groupid;
+	u32 atf_units_reserved;
+	u32 vdev_id;
+	u32 pdev_id;
+} __packed;
+
+struct ath11k_wmi_atf_peer_arg {
+	u8 addr[ETH_ALEN];
+	u32 vdev_id;
+	u32 units;
+};
+
 struct wmi_bcn_tmpl_cmd {
 	u32 tlv_header;
 	u32 vdev_id;
@@ -6450,6 +6497,10 @@ int ath11k_wmi_vdev_start(struct ath11k *ar, struct wmi_vdev_start_req_arg *arg,
 			  bool restart);
 int ath11k_wmi_set_peer_param(struct ath11k *ar, const u8 *peer_addr,
 			      u32 vdev_id, u32 param_id, u32 param_val);
+int ath11k_wmi_send_atf_group(struct ath11k *ar, u32 group_id, u32 units);
+int ath11k_wmi_send_peer_atf_request(struct ath11k *ar,
+				     const struct ath11k_wmi_atf_peer_arg *peers,
+				     u32 num_peers, bool more);
 int ath11k_wmi_pdev_set_param(struct ath11k *ar, u32 param_id,
 			      u32 param_value, u8 pdev_id);
 int ath11k_wmi_pdev_set_ps_mode(struct ath11k *ar, int vdev_id,
-- 
2.47.3


