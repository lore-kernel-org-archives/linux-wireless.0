Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5A243DEBC;
	Sat,  3 Oct 2026 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791042972; cv=none; b=dxHxHwXnEjT+7tmU2uhCkPLirEY+QjchncwRhxIXIL7oLsNFFcIaUvaKNQk5yWHmgw9RXEcGBxkTXowMLj4QDyCBg2hUnjUW2d6QOu+x9oJDrCaiwP2gMb40DbyxENgCwVI8ajRK6RTWUP8KhyzzuNIPyxUDMKd5avpJC3TAN64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791042972; c=relaxed/simple;
	bh=S2q74c0q4X9Z5FRid+rd08Z3LyuVw69JtpNCYQ2QmQU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wd075TpUFTD+MiJwq10ham79BuVPCg2vE8gwHf7clJoI4fC4F8KvpxOty49sldS7ACPoXtaCdBgbVIZieN/tV1XjhL6PMSC0hJdQ64Mq8nRUZ/XoB+k1YnOXHSycUTYtu1rjDd9qfesWxZJntxDcduTi1zyjVJK2PBFTkGUheIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=fmnXSeWS; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="fmnXSeWS"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 0F02FE83B;
	Sat, 03 Oct 2026 18:55:50 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=wbLJu/N2OQZWzMUCpZsG
	C2a6p7BIw5fHdNfe+gpkMNM=; b=fmnXSeWS4rXLDSellhYa8Jv00MY+LUshnixU
	G9LhF2SKKn8TH8pkc1mICQ1DbgMfFqx8V1t1BjoK8DWlZ1jMX7ltpiiiv5aXSxtY
	ysaBwP3JwPtGYHC47zonFo5gVY5O7fHK3KuKYizSpoNw91ONFSzIfgJ9wvsGFmke
	7m2mTk7CUjsLDjW8B5xVpId0VQNDZlUgc7HXfIr7UNnw7anjdn5uKxB34Pvw2iJT
	7fE6ru8zeiEEn2giuPOR88OmEN/4hehqJunM1eNR3cV/sn/jD2S1zts/I0p2Hxd6
	1iSyADK+sjbr025G9PP9nsqJZTKNmKvkjDazmfZMFYx1oT58Xw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 3612CE83A;
	Sat, 03 Oct 2026 18:55:48 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sat, 3 Oct 2026 18:55:47 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 2/4] wifi: ath11k: support beacon protection
Date: Sat, 3 Oct 2026 18:55:40 +0300
Message-ID: <20261003155542.96363-3-me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261003155542.96363-1-me@andrei-z.com>
References: <20261003155542.96363-1-me@andrei-z.com>
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

Firmware with WMI_TLV_SERVICE_BEACON_PROTECTION_SUPPORT protects the
beacons it transmits with the BIGTK. Advertise
NL80211_EXT_FEATURE_BEACON_PROTECTION when the service is present,
install the BIGTK (key index 6/7) in hardware with the BIP ciphers, and
set the beacon protection bit of the beacon template command when the
beacon's Extended Capabilities, or those of a nontransmitted BSSID
profile in it, enable it. The IGTK (index 4/5) stays in software, which
protects the management frames mac80211 sends.

This follows the ath12k change that added the same support, commit
"wifi: ath12k: allow beacon protection keys to be installed in hardware".

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 drivers/net/wireless/ath/ath11k/core.h |  1 +
 drivers/net/wireless/ath/ath11k/mac.c  | 61 +++++++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/wmi.c  |  2 +
 drivers/net/wireless/ath/ath11k/wmi.h  |  5 ++-
 4 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923..31eee25c0 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -408,6 +408,7 @@ struct ath11k_vif {
 	int txpower;
 	bool rsnie_present;
 	bool wpaie_present;
+	bool beacon_prot;
 	bool bcca_zero_sent;
 	bool do_not_send_tmpl;
 	struct ath11k_arp_ns_offload arp_ns_offload;
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index c1fa42edd..57cc6dbdd 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1495,6 +1495,44 @@ static int ath11k_mac_remove_vendor_ie(struct sk_buff *skb, unsigned int oui,
 	return 0;
 }
 
+static bool ath11k_mac_ext_capa_bcn_prot(const struct element *ext_capa)
+{
+	return ext_capa && ext_capa->datalen >= 11 &&
+	       (ext_capa->data[10] & WLAN_EXT_CAPA11_BCN_PROTECT);
+}
+
+/* Beacon protection covers the whole beacon, so enable it when the
+ * transmitted BSS or any nontransmitted profile in it advertises it.
+ */
+static bool ath11k_mac_bcn_prot_enabled(struct sk_buff *bcn)
+{
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)bcn->data;
+	const u8 *ies = mgmt->u.beacon.variable;
+	int ies_len = skb_tail_pointer(bcn) - ies;
+	const struct element *elem, *profile;
+
+	if (ath11k_mac_ext_capa_bcn_prot(cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY,
+							    ies, ies_len)))
+		return true;
+
+	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, ies, ies_len) {
+		if (elem->datalen < 1)
+			continue;
+
+		for_each_element(profile, elem->data + 1, elem->datalen - 1) {
+			if (profile->id != 0)
+				continue;
+
+			if (ath11k_mac_ext_capa_bcn_prot(cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY,
+									    profile->data,
+									    profile->datalen)))
+				return true;
+		}
+	}
+
+	return false;
+}
+
 static int ath11k_mac_set_vif_params(struct ath11k_vif *arvif,
 				     struct sk_buff *bcn)
 {
@@ -1598,6 +1636,7 @@ static int ath11k_mac_setup_bcn_tmpl_ema(struct ath11k_vif *arvif,
 		params |= ((!i ? 1 : 0) << WMI_EMA_FIRST_TMPL_SHIFT);
 		params |= ((i + 1 == beacons->cnt ? 1 : 0) << WMI_EMA_LAST_TMPL_SHIFT);
 
+		tx_arvif->beacon_prot = ath11k_mac_bcn_prot_enabled(beacons->bcn[i].skb);
 		ret = ath11k_wmi_bcn_tmpl(tx_arvif->ar, tx_arvif->vdev_id,
 					  &beacons->bcn[i].offs,
 					  beacons->bcn[i].skb, params);
@@ -1651,6 +1690,7 @@ static int ath11k_mac_setup_bcn_tmpl_mbssid(struct ath11k_vif *arvif,
 		goto free;
 	}
 
+	arvif->beacon_prot = ath11k_mac_bcn_prot_enabled(bcn);
 	ret = ath11k_wmi_bcn_tmpl(ar, arvif->vdev_id, &offs, bcn, 0);
 	if (ret)
 		ath11k_warn(ab, "failed to submit beacon template command: %d\n",
@@ -4412,6 +4452,14 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
 		arg.key_cipher = WMI_CIPHER_AES_GCM;
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
 		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		arg.key_cipher = WMI_CIPHER_AES_CMAC;
+		break;
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		arg.key_cipher = WMI_CIPHER_AES_GMAC;
+		break;
 	default:
 		ath11k_warn(ar->ab, "cipher %d is not supported\n", key->cipher);
 		return -EOPNOTSUPP;
@@ -4523,11 +4571,10 @@ static int ath11k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	int ret = 0;
 	u32 flags = 0;
 
-	/* BIP needs to be done in software */
-	if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
-	    key->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
-	    key->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256 ||
-	    key->cipher == WLAN_CIPHER_SUITE_BIP_CMAC_256)
+	/* The IGTK protects management frames, which are done in software;
+	 * only the BIGTK (index 6/7) goes to the firmware, which signs beacons.
+	 */
+	if (key->keyidx == 4 || key->keyidx == 5)
 		return 1;
 
 	if (test_bit(ATH11K_FLAG_HW_CRYPTO_DISABLED, &ar->ab->dev_flags))
@@ -10633,6 +10680,10 @@ static int __ath11k_mac_register(struct ath11k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
 
+	if (test_bit(WMI_TLV_SERVICE_BEACON_PROTECTION_SUPPORT, ar->ab->wmi_ab.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_BEACON_PROTECTION);
+
 	ar->hw->wiphy->mbssid_max_interfaces = TARGET_NUM_VDEVS(ab);
 	ar->hw->wiphy->ema_max_profile_periodicity = TARGET_EMA_MAX_PROFILE_PERIOD;
 
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 08fd6795e..2c3e14a65 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1811,6 +1811,8 @@ int ath11k_wmi_bcn_tmpl(struct ath11k *ar, u32 vdev_id,
 	cmd->buf_len = bcn->len;
 	cmd->mbssid_ie_offset = offs->mbssid_off;
 	cmd->ema_params = ema_params;
+	if (arvif->beacon_prot)
+		cmd->feature_enable_bitmap |= WMI_BCN_TMPL_BEACON_PROTECTION_EN;
 
 	ptr = skb->data + sizeof(*cmd);
 
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index b2dade051..ae8b4cc08 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -2128,6 +2128,7 @@ enum wmi_tlv_service {
 	WMI_TLV_SERVICE_PER_PEER_HTT_STATS_RESET = 213,
 	WMI_TLV_SERVICE_FREQINFO_IN_METADATA = 219,
 	WMI_TLV_SERVICE_EXT2_MSG = 220,
+	WMI_TLV_SERVICE_BEACON_PROTECTION_SUPPORT = 244,
 	WMI_TLV_SERVICE_PEER_POWER_SAVE_DURATION_SUPPORT = 246,
 	WMI_TLV_SERVICE_SRG_SRP_SPATIAL_REUSE_SUPPORT = 249,
 	WMI_TLV_SERVICE_MBSS_PARAM_IN_VDEV_START_SUPPORT = 253,
@@ -3628,6 +3629,8 @@ struct ath11k_wmi_p2p_noa_info {
 #define WMI_EMA_FIRST_TMPL_SHIFT          16
 #define WMI_EMA_LAST_TMPL_SHIFT           24
 
+#define WMI_BCN_TMPL_BEACON_PROTECTION_EN BIT(0)
+
 struct wmi_bcn_tmpl_cmd {
 	u32 tlv_header;
 	u32 vdev_id;
@@ -5237,7 +5240,7 @@ enum wmi_ap_ps_peer_param {
 
 #define DISABLE_SIFS_RESPONSE_TRIGGER 0
 
-#define WMI_MAX_KEY_INDEX   3
+#define WMI_MAX_KEY_INDEX   7
 #define WMI_MAX_KEY_LEN     32
 
 #define WMI_KEY_PAIRWISE 0x00

