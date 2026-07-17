Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1053FB7DE
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298698; cv=none; b=RdLiAd22KB/KFxKDyhdR+Zvhy6bdVhOuiGm+g7azMIx00sCWZ0Prca9hgfUgKknEpWUgzyZ6Vnyhr8iCK2TDSZNagr0D721pofcZY0lhpDsJIUohM22TXj4yEUEqCqx+MHwAJTQIw86lVDZUZ+82iyCYGLPKMgeaFXOPqYopisw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298698; c=relaxed/simple;
	bh=YBmhfsm/68l7zae9Bu5Uj8zsSHFVR+ekghxG7eQJIys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cXTQwEwFuRO7owTlg/QJFRlzW+VhztKWx99e3xgYE0+WZC4M6LadNlu+J+hwchei8r/HOCbY3vrjmdFnPz9caDAdA2/gAuMeIVAdmw9ah+dkzQRN3/Gy98bHWppQBZGGMxPPofAciAYnyDGXqJF7OmGQwQ736cdY1IsbKVoe+/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QXBLRtBN; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QXBLRtBN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298697; x=1815834697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YBmhfsm/68l7zae9Bu5Uj8zsSHFVR+ekghxG7eQJIys=;
  b=QXBLRtBNSyTUQS3bze0Uxikurz/9sdTXxAPt8R65s3LS6L46L+m2Z5rH
   3y2Nep5IoYFcul4LMD1fkq1YxoBG/wZJf6W8jB2A77ni2juBUydosMFem
   P58iAeh1OUjoaxIsK4evuRHGrfoaVh/f+TINCsNxJZJXB9xRu+MIoGIFZ
   fLRjVrD/p9HGFLpa029RK8Z8ZXFHQKiNivwTYXVk1aGttt5VxmFnVz8cb
   ipw9a98gRzv3jUh+mFV0h23dz3rjm5teF3SEZ9vUjCglJXtQD19WcdGXV
   0TrdNX2as4TG/v+jLSU54vGkSRdS7EPr1itA7G+f5hQzvYhPY1XMAGHep
   Q==;
X-CSE-ConnectionGUID: HHlRsgluRJWhVYVphezCxQ==
X-CSE-MsgGUID: p+Wl4XHVTnWoVccmBjTf5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84925977"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84925977"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:36 -0700
X-CSE-ConnectionGUID: y5BBCEarTlC3lMPZbmGi9g==
X-CSE-MsgGUID: M8Xsux+XQFql3EHpS5MqJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885718"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:35 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 1/8] wifi: iwlwifi: mld: validate wake packet crypto overhead
Date: Fri, 17 Jul 2026 17:31:05 +0300
Message-Id: <20260717172958.e06595623533.Ie09494b7e34e5872b750fd90e325648ee469d0da@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
References: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Wake packet parsing only accounted for FCS and missed per-key
IV/ICV overhead for protected data frames.

Prevent size underflow and bad packet trimming when
notifications are malformed or truncated.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 63 +++++++++++++++++++--
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 3b785c53948f..301983428a63 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -59,6 +59,30 @@ struct iwl_mld_suspend_key_iter_data {
 	__le32 bigtk_cipher;
 };
 
+struct iwl_mld_wake_pkt_iter_data {
+	bool multicast;
+	u32 ivlen;
+	u32 icvlen;
+};
+
+static void
+iwl_mld_wake_pkt_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key, void *_data)
+{
+	struct iwl_mld_wake_pkt_iter_data *data = _data;
+	bool is_group_key = !sta;
+
+	/* ignore anything that is not a PTK / GTK */
+	if (key->keyidx > 3)
+		return;
+	if (is_group_key != data->multicast)
+		return;
+
+	data->ivlen = key->iv_len;
+	data->icvlen = key->icv_len;
+}
+
 struct iwl_mld_mcast_key_data {
 	u8 key[WOWLAN_KEY_MAX_SIZE];
 	u8 len;
@@ -743,11 +767,17 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			struct cfg80211_wowlan_wakeup *wakeup,
 			struct sk_buff **_pkt)
 {
-	int pkt_bufsize = wowlan_status->wake_packet_bufsize;
-	int expected_pktlen = wowlan_status->wake_packet_length;
+	u32 pkt_bufsize = wowlan_status->wake_packet_bufsize;
+	u32 expected_pktlen = wowlan_status->wake_packet_length;
 	const u8 *pktdata = wowlan_status->wake_packet;
 	const struct ieee80211_hdr *hdr = (const void *)pktdata;
-	int truncated = expected_pktlen - pkt_bufsize;
+	u32 truncated;
+
+	if (IWL_FW_CHECK(mld, pkt_bufsize < sizeof(*hdr),
+			 "pkt_bufsize is too short: %u\n", pkt_bufsize))
+		return;
+
+	truncated = expected_pktlen - pkt_bufsize;
 
 	if (ieee80211_is_data(hdr->frame_control)) {
 		int hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -758,9 +788,18 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 		if (!pkt)
 			return;
 
-		skb_put_data(pkt, pktdata, hdrlen);
-		pktdata += hdrlen;
-		pkt_bufsize -= hdrlen;
+		if (ieee80211_has_protected(hdr->frame_control)) {
+			struct iwl_mld_wake_pkt_iter_data iter_data = {
+				.multicast =
+					is_multicast_ether_addr(hdr->addr1),
+			};
+
+			ieee80211_iter_keys(mld->hw, vif,
+					    iwl_mld_wake_pkt_key_iter,
+					    &iter_data);
+			ivlen = iter_data.ivlen;
+			icvlen += iter_data.icvlen;
+		}
 
 		/* if truncated, FCS/ICV is (partially) gone */
 		if (truncated >= icvlen) {
@@ -771,6 +810,13 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			truncated = 0;
 		}
 
+		if (IWL_FW_CHECK(mld, pkt_bufsize <= hdrlen + ivlen + icvlen,
+				 "pkt_bufsize is too small %u\n", pkt_bufsize))
+			return;
+
+		skb_put_data(pkt, pktdata, hdrlen);
+		pktdata += hdrlen;
+		pkt_bufsize -= hdrlen;
 		pkt_bufsize -= ivlen + icvlen;
 		pktdata += ivlen;
 
@@ -792,6 +838,11 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			fcslen -= truncated;
 			truncated = 0;
 		}
+
+		if (IWL_FW_CHECK(mld, pkt_bufsize <= fcslen,
+				 "pkt_bufsize is too small %u\n", pkt_bufsize))
+			return;
+
 		pkt_bufsize -= fcslen;
 		wakeup->packet = wowlan_status->wake_packet;
 		wakeup->packet_present_len = pkt_bufsize;
-- 
2.34.1

