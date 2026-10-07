Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3143D45F4
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 05:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349224; cv=none; b=A7gcRkLA5ESt/RZfm3BJWlkV9ssCFflqfj8Nuy2HWZ+ykFVTPCfwEiog7Ry9JkMnEHjQGOrNHsAhoXmXGJCZT50NuDmaaaWkNtRxtwRIT/5/chKQa+SlEaQNxTbF9Ftvg9wN4AO1TWbP0IP2Lz9NJ9TfLEV3pIzyUK9EmmhuzAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349224; c=relaxed/simple;
	bh=2RvWfC+pNAIlopAjHpXhKxrxNXP5Vjbi5YqzCY7ROQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtXjCZMgB7MwaMr7H5YgjvvXHHoTGkXVV7JzqFfElm2ZzJb8AUy3XfdGApQk8faAQYVUxFH9n8t+PoYCZrUA8Tfscm43l/LIoMdAsYGeFU/B47HE/qBXVs4r94lCpiSUyMWWc1BZ6JiyENMQCcMn11W/dQdut5brDqWVy5aeQBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=dkRqTWYe; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="dkRqTWYe"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-398a5aad413so2827222a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 22:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791349214; x=1791954014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RJ76adT9tVpCaH67lNk2Aijw0FiEescRScNn+5HEtEc=;
        b=dkRqTWYedEBg/MMYYVMnSPxvvv/1gHrSx04mTS2io8KI6P4MKWBJKf5cxf59ZqFcEM
         9Hs/frjEongOJr2MiDN+AF6Icj/sbwriJoEeiFbpkQ63qYmX/gEQIyZ/FxiZD2Apc9Hu
         DFoSnng3ux4452I+4HYFD38YYUlxMFAc+jAuWymxPug2lofZFg20R8JPFJLNs8WcXIch
         zP4XCErxdOdjLsix56DOgksXSiig0hoPgbDjHXp3zGr4F+O5RlxoeYy0CVl4W2LDIhCY
         nzkCcD8F947sAVMevkwD/ousOnLJ4aQhtI0zG9HadNY+gaUUDnZt6Vwuj2525TNvsd00
         DgdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791349214; x=1791954014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RJ76adT9tVpCaH67lNk2Aijw0FiEescRScNn+5HEtEc=;
        b=zwnqZmBFSXUt/CCV2p36bSemCoCTiR8bKExxiJLTGQEWYbOc6i0bJXvNxD07XEHSSk
         CraaIPhOpN4yp/ZosaMAX8QPLvE46XPs3MuD0WRZpLdNY1DeRdiyOYROhovW5KM2JeMR
         shuEzkmaPcVmFd3xl5149f1CSSKlMWWleuqSZGwCw0KL6ZdqFDjyPPTRo+pG5XyQsP10
         ndYOHgjJqlhsWVYWw7AufWUF4DXeA5Tt7npkz8U8Lbsg77hLfBibnhI7IMDwLKyiwdkl
         KSzWDV6TwmirQi590V8oKnP9jAbWKczaTZQp0DnqV1S7g3mCEJiC/WcRX46fwYS3XqfN
         VuoQ==
X-Forwarded-Encrypted: i=1; AKwUvBzPiPD/se2zJKL6tA3xQZjPUiYhiu4qham9Gsqnac+k6ve2eWG4dP4W4Z4gR7vMB7PyXpnCcT4kUXjiKRJD5g==@vger.kernel.org
X-Gm-Message-State: AFq9FYKr3qCRhp7dFwusvoBSsz2Vch+aXByUrXcyAaqZnwLgzTlQYhrT
	MF228zZ8DXtW96Hv5cB0/KFi/Dz9JFH0Jp9qK//sNUB7O2qhe7hF+Fck49FtYl/3SG4=
X-Gm-Gg: AYBFou1eyu7u9fbnD4tim2QHLtc9Sp7w532AlgPHh7jQPtLSEgoJg3fR3Br2+QG7FSp
	3omsF9PvLLfp/CGUwKakrrV0msDmswbPpgowhHixkq17eJh7dJm2e7t1/XGu/gFvTyQNEKKXzUg
	XAsIExQpLHtx/o8sBXD2uayobfsjWkxsFoDwz1gudpOMuDHviAgP4ieH9u7t8h25BuWjm6u5vyn
	q3Vz9fZzOFJ8K31URuH/m8rIAW5c7uQi8wh0i2yenBz+UioXhT2zRrhIUADuTssbg3XD5MzEcNK
	JQQfMoCLc+Z5DipUGEIZIPltzKi+cdlpfovaMPFStzR9feDOEic8L9OrObvODpL4e726JYrnXKY
	uOI4Dy21Wl3PMM1LO6C9imK4zEIH+CVPeaSzNPw8UAoxWApfrMAxgEMUO2/bi1rt3I2WpqJCf/B
	rzsTVy0aB+Rdhirxch3ewDYOacMtb3iXRJGUcACe7WessTE08h8MaBcB8PKvqZc41PazWEWdngp
	yU1uBXpASe6u6W14UveLCuxRdm+gMJ9q5ZRL3j0Gs3L2CO402v4kVYV688AiHD0vJk8TNVoPqIJ
	Zu1CtUCgVK5bgrNR
X-Received: by 2002:a17:90b:17c2:b0:3a8:9751:14de with SMTP id 98e67ed59e1d1-3a8a1b59356mr922807a91.10.1791349213301;
        Tue, 06 Oct 2026 22:00:13 -0700 (PDT)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a4b1abbfsm696011a91.4.2026.10.06.22.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 22:00:12 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 2/3] wifi: mm81x: add monitor mode support
Date: Wed,  7 Oct 2026 15:59:59 +1100
Message-ID: <20261007050000.127009-3-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007050000.127009-1-lachlan.hodges@morsemicro.com>
References: <20261007050000.127009-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce monitor mode support by extending the command to add a
monitor interface to the firmware and inserting the S1G radiotap TLV.
Also rework the .configure_filter() callback to better handle frame
filtering when we are in monitor mode. This implementation works best
as a standalone sniffer currently, as support is yet to be added in
mac80211 to handle building the radiotap for tx frames (i.e if you
bind a monitor interface to an existing station or AP).

Right now the S1G radiotap header is not really complete and lacks
the ability to convey the frequency offset and correct NDP reporting.
The process to amend the S1G TLV will begin after this initial
support is complete.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 .../net/wireless/morsemicro/mm81x/command.c   |   5 +-
 drivers/net/wireless/morsemicro/mm81x/core.h  |  16 +-
 drivers/net/wireless/morsemicro/mm81x/mac.c   | 208 +++++++++++++++---
 3 files changed, 195 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/command.c b/drivers/net/wireless/morsemicro/mm81x/command.c
index afb7ee9bb236..56dd338321f0 100644
--- a/drivers/net/wireless/morsemicro/mm81x/command.c
+++ b/drivers/net/wireless/morsemicro/mm81x/command.c
@@ -262,6 +262,9 @@ int mm81x_cmd_add_if(struct mm81x *mors, u16 *vif_id, const u8 *addr,
 	case NL80211_IFTYPE_AP:
 		req.interface_type = cpu_to_le32(HOST_CMD_INTERFACE_TYPE_AP);
 		break;
+	case NL80211_IFTYPE_MONITOR:
+		req.interface_type = cpu_to_le32(HOST_CMD_INTERFACE_TYPE_MON);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -458,7 +461,7 @@ int mm81x_cmd_cfg_multicast_filter(struct mm81x *mors,
 				   struct mm81x_vif *mors_vif)
 {
 	struct host_cmd_req_mcast_filter *req;
-	struct mcast_filter *filter = mors->mcast_filter;
+	struct mm81x_mcast_filter *filter = mors->mcast_filter;
 	u16 filter_list_len = sizeof(filter->addr_list[0]) * filter->count;
 	u16 alloc_len = filter_list_len + sizeof(*req);
 	int ret = 0;
diff --git a/drivers/net/wireless/morsemicro/mm81x/core.h b/drivers/net/wireless/morsemicro/mm81x/core.h
index 75e998e8e324..d46323815304 100644
--- a/drivers/net/wireless/morsemicro/mm81x/core.h
+++ b/drivers/net/wireless/morsemicro/mm81x/core.h
@@ -225,7 +225,7 @@ struct mm81x_stale_tx_status {
 	struct timer_list timer;
 };
 
-struct mcast_filter {
+struct mm81x_mcast_filter {
 	u8 count;
 	/*
 	 * Integer representation of the last four bytes of a multicast MAC
@@ -335,6 +335,18 @@ struct mm81x {
 
 	struct ieee80211_vif __rcu *vifs[MM81X_MAX_IF];
 
+	/*
+	 * Groups A-MPDU subframes for monitor reporting. The firmware stamps
+	 * every subframe of an A-MPDU with the same receive timestamp, so a
+	 * change in timestamp starts a new reference.
+	 */
+	struct {
+		u64 timestamp;
+		u32 reference;
+	} rx_ampdu;
+
+	bool monitor_en;
+
 	/* @mm81x_state_flags */
 	unsigned long state_flags;
 
@@ -377,7 +389,7 @@ struct mm81x {
 	wait_queue_head_t tx_empty_waitq;
 
 	struct cfg80211_chan_def chandef;
-	struct mcast_filter *mcast_filter;
+	struct mm81x_mcast_filter *mcast_filter;
 	atomic_t num_bcn_vifs;
 	unsigned long beacon_irqs_enabled;
 	u8 drv_priv[] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index ab6a33a27935..2f1e03c9312b 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -7,6 +7,7 @@
 #include <linux/jiffies.h>
 #include <linux/crc32.h>
 #include <net/mac80211.h>
+#include <net/ieee80211_radiotap.h>
 #include <asm/div64.h>
 #include <linux/kernel.h>
 #include "hif.h"
@@ -1396,6 +1397,9 @@ static void mm81x_mac_ops_remove_interface(struct ieee80211_hw *hw,
 		dev_err(mors->dev, "mm81x_cmd_rm_if failed %d", ret);
 
 	RCU_INIT_POINTER(mors->vifs[mors_vif->id], NULL);
+
+	if (vif->type == NL80211_IFTYPE_MONITOR)
+		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, hw->flags);
 }
 
 static s32 mm81x_mac_get_max_txpower(struct mm81x *mors)
@@ -1510,6 +1514,9 @@ static int mm81x_mac_ops_config(struct ieee80211_hw *hw, int radio_idx,
 			return ret;
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
+		mors->monitor_en = conf->flags & IEEE80211_CONF_MONITOR;
+
 	if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
 	    !(changed & IEEE80211_CONF_CHANGE_CHANNEL) &&
 	    !(conf->flags & IEEE80211_CONF_MONITOR)) {
@@ -1599,7 +1606,7 @@ static u64 mm81x_mac_ops_prepare_multicast(struct ieee80211_hw *hw,
 					   struct netdev_hw_addr_list *mc_list)
 {
 	struct mm81x *mors = hw->priv;
-	struct mcast_filter *filter;
+	struct mm81x_mcast_filter *filter;
 	struct netdev_hw_addr *addr;
 	u16 addr_count = netdev_hw_addr_list_count(mc_list);
 	u16 len = sizeof(*filter) + addr_count * sizeof(filter->addr_list[0]);
@@ -1626,17 +1633,38 @@ static u64 mm81x_mac_ops_prepare_multicast(struct ieee80211_hw *hw,
 	return (u64)(unsigned long)filter;
 }
 
+static void mm81x_mc_iface_iterator(void *data, u8 *mac,
+				    struct ieee80211_vif *vif)
+{
+	struct mm81x_vif *mors_vif = ieee80211_vif_to_mors_vif(vif);
+	struct mm81x *mors = data;
+	int ret;
+
+	if (vif->type == NL80211_IFTYPE_MONITOR)
+		return;
+
+	ret = mm81x_cmd_cfg_multicast_filter(mors, mors_vif);
+	if (ret)
+		dev_err(mors->dev, "Multicast filtering failed - rc=%d", ret);
+}
+
+#define MM81X_MONITOR_FILTERS		\
+	(FIF_ALLMULTI |			\
+	FIF_BCN_PRBRESP_PROMISC |	\
+	FIF_CONTROL |			\
+	FIF_FCSFAIL |			\
+	FIF_OTHER_BSS |			\
+	FIF_PSPOLL |			\
+	FIF_PROBE_REQ |			\
+	FIF_MCAST_ACTION)
+
 static void mm81x_mac_ops_configure_filter(struct ieee80211_hw *hw,
 					   unsigned int changed_flags,
 					   unsigned int *total_flags,
 					   u64 multicast)
 {
+	struct mm81x_mcast_filter *cmd = (void *)(unsigned long)multicast;
 	struct mm81x *mors = hw->priv;
-	struct mcast_filter *cmd = (void *)(unsigned long)multicast;
-	struct mm81x_vif *mors_vif = NULL;
-	struct ieee80211_vif *vif = NULL;
-	int vif_id = 0;
-	int ret = 0;
 
 	if (!cmd)
 		goto out;
@@ -1644,25 +1672,15 @@ static void mm81x_mac_ops_configure_filter(struct ieee80211_hw *hw,
 	kfree(mors->mcast_filter);
 	mors->mcast_filter = cmd;
 
-	for (vif_id = 0; vif_id < ARRAY_SIZE(mors->vifs); vif_id++) {
-		vif = mm81x_rcu_dereference_vif_id(mors, vif_id, false);
-		if (!vif)
-			continue;
-
-		mors_vif = ieee80211_vif_to_mors_vif(vif);
-
-		ret = mm81x_cmd_cfg_multicast_filter(mors, mors_vif);
-		if (!ret)
-			continue;
-
-		dev_err(mors->dev, "Multicast filtering failed - rc=%d", ret);
-		mors->mcast_filter = NULL;
-		kfree(cmd);
-		break;
-	}
+	ieee80211_iterate_active_interfaces(mors->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    mm81x_mc_iface_iterator, mors);
 
 out:
-	*total_flags &= 0;
+	if (mors->monitor_en)
+		*total_flags &= MM81X_MONITOR_FILTERS;
+	else
+		*total_flags = 0;
 }
 
 static int mm81x_mac_ops_conf_tx(struct ieee80211_hw *hw,
@@ -1900,14 +1918,95 @@ static u8 mm81x_rx_h_rc_bw_to_rx_bw(__le32 ratecode)
 	}
 }
 
+static u32 mm81x_rx_h_ampdu_reference(struct mm81x *mors, u64 timestamp)
+{
+	if (timestamp != mors->rx_ampdu.timestamp) {
+		mors->rx_ampdu.timestamp = timestamp;
+		mors->rx_ampdu.reference++;
+	}
+
+	return mors->rx_ampdu.reference;
+}
+
+static enum ieee80211_radiotap_s1g_ppdu_format
+mm81x_rx_h_ppdu_format(__le32 ratecode)
+{
+	switch (mm81x_ratecode_preamble_get(ratecode)) {
+	case MM81X_RATE_PREAMBLE_S1G_1M:
+		return IEEE80211_RADIOTAP_S1G_PPDU_FORMAT_1M;
+	case MM81X_RATE_PREAMBLE_S1G_LONG:
+		return IEEE80211_RADIOTAP_S1G_PPDU_FORMAT_LONG;
+	default:
+		return IEEE80211_RADIOTAP_S1G_PPDU_FORMAT_SHORT;
+	}
+}
+
+#define S1G_RADIOTAP_TLV_LEN				\
+	(sizeof(struct ieee80211_radiotap_tlv) +	\
+	 ALIGN(sizeof(struct ieee80211_radiotap_s1g), 4))
+
+static void mm81x_rx_h_add_rt_s1g_tlv(struct sk_buff *skb,
+				      struct mm81x_skb_rx_status *hdr_rx_status,
+				      struct ieee80211_rx_status *rx_status)
+{
+	__le32 ratecode = hdr_rx_status->mm81x_ratecode;
+	u32 flags = le32_to_cpu(hdr_rx_status->flags);
+	u8 color = hdr_rx_status->bss_color;
+	struct ieee80211_radiotap_tlv *tlv;
+	struct ieee80211_radiotap_s1g s1g;
+
+	if (skb_headroom(skb) < S1G_RADIOTAP_TLV_LEN)
+		return;
+
+	s1g.known = cpu_to_le16(IEEE80211_RADIOTAP_S1G_KNOWN_PPDU_FORMAT |
+				IEEE80211_RADIOTAP_S1G_KNOWN_RESPONSE_IND |
+				IEEE80211_RADIOTAP_S1G_KNOWN_GI |
+				IEEE80211_RADIOTAP_S1G_KNOWN_BW |
+				IEEE80211_RADIOTAP_S1G_KNOWN_UPLINK_IND |
+				IEEE80211_RADIOTAP_S1G_KNOWN_NSS |
+				IEEE80211_RADIOTAP_S1G_KNOWN_MCS |
+				IEEE80211_RADIOTAP_S1G_KNOWN_COLOR);
+
+	s1g.data1 = le16_encode_bits(mm81x_rx_h_ppdu_format(ratecode),
+				     IEEE80211_RADIOTAP_S1G_DATA1_PPDU_FORMAT) |
+		    le16_encode_bits(MM81X_RX_STATUS_FLAGS_RI_GET(flags),
+				     IEEE80211_RADIOTAP_S1G_DATA1_RESPONSE_IND) |
+		    le16_encode_bits(mm81x_ratecode_sgi_get(ratecode),
+				     IEEE80211_RADIOTAP_S1G_DATA1_GI) |
+		    le16_encode_bits(mm81x_ratecode_nss_index_get(ratecode),
+				     IEEE80211_RADIOTAP_S1G_DATA1_NSS) |
+		    le16_encode_bits(mm81x_ratecode_bw_index_get(ratecode),
+				     IEEE80211_RADIOTAP_S1G_DATA1_BW) |
+		    le16_encode_bits(mm81x_ratecode_mcs_index_get(ratecode),
+				     IEEE80211_RADIOTAP_S1G_DATA1_MCS);
+
+	s1g.data2 = le16_encode_bits(color, IEEE80211_RADIOTAP_S1G_DATA2_COLOR) |
+		    le16_encode_bits(MM81X_RX_STATUS_FLAGS_UPL_IND_GET(flags),
+				     IEEE80211_RADIOTAP_S1G_DATA2_UPLINK_IND) |
+		    le16_encode_bits((u8)rx_status->signal,
+				     IEEE80211_RADIOTAP_S1G_DATA2_RSSI);
+
+	tlv = skb_push(skb, S1G_RADIOTAP_TLV_LEN);
+	tlv->type = cpu_to_le16(IEEE80211_RADIOTAP_S1G);
+	tlv->len = cpu_to_le16(sizeof(s1g));
+
+	memcpy(tlv->data, &s1g, sizeof(s1g));
+	memset(tlv->data + sizeof(s1g), 0,
+	       S1G_RADIOTAP_TLV_LEN - sizeof(*tlv) - sizeof(s1g));
+
+	skb_set_mac_header(skb, S1G_RADIOTAP_TLV_LEN);
+	rx_status->flag |= RX_FLAG_RADIOTAP_TLV_AT_END;
+}
+
 static void mm81x_rx_h_fill_status(struct mm81x *mors,
 				   struct mm81x_skb_rx_status *hdr_rx_status,
 				   struct ieee80211_rx_status *rx_status,
 				   struct sk_buff *skb)
 {
-	u32 flags = le32_to_cpu(hdr_rx_status->flags);
+	u64 timestamp = le64_to_cpu(hdr_rx_status->rx_timestamp_us);
 	u16 freq_100khz = le16_to_cpu(hdr_rx_status->freq_100khz);
 	__le32 ratecode = hdr_rx_status->mm81x_ratecode;
+	u32 flags = le32_to_cpu(hdr_rx_status->flags);
 
 	rx_status->signal = le16_to_cpu(hdr_rx_status->rssi);
 	rx_status->encoding = RX_ENC_S1G;
@@ -1915,15 +2014,51 @@ static void mm81x_rx_h_fill_status(struct mm81x *mors,
 	rx_status->freq = KHZ100_TO_MHZ(freq_100khz);
 	rx_status->freq_offset = (freq_100khz % 10) ? 1 : 0;
 	rx_status->nss = NSS_IDX_TO_NSS(mm81x_ratecode_nss_index_get(ratecode));
+	rx_status->rate_idx = mm81x_ratecode_mcs_index_get(ratecode);
+	rx_status->bw = mm81x_rx_h_rc_bw_to_rx_bw(ratecode);
+	rx_status->mactime = timestamp;
+	rx_status->flag |= RX_FLAG_MACTIME_IS_RTAP_TS64;
 
 	if (flags & MM81X_RX_STATUS_FLAGS_DECRYPTED)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 
-	rx_status->rate_idx = mm81x_ratecode_mcs_index_get(ratecode);
-	rx_status->bw = mm81x_rx_h_rc_bw_to_rx_bw(ratecode);
-
 	if (mm81x_ratecode_sgi_get(ratecode))
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
+
+	if (mors->monitor_en) {
+		if (flags & MM81X_RX_STATUS_FLAGS_CRC_ERROR)
+			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
+		if (flags & MM81X_RX_STATUS_FLAGS_AMPDU) {
+			rx_status->flag |= RX_FLAG_AMPDU_DETAILS |
+					   RX_FLAG_AMPDU_EOF_BIT_KNOWN;
+			rx_status->ampdu_reference =
+				mm81x_rx_h_ampdu_reference(mors, timestamp);
+
+			if (flags & MM81X_RX_STATUS_FLAGS_EOF)
+				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
+		}
+
+		if (flags & MM81X_RX_STATUS_FLAGS_NDP) {
+			rx_status->flag |= RX_FLAG_NO_PSDU;
+
+			/*
+			 * S1G PSDUs are not standardised in radiotap yet, so
+			 * for now report as sounding PSDUs so that acks etc.
+			 * can be passed through.
+			 */
+			rx_status->zero_length_psdu_type =
+				IEEE80211_RADIOTAP_ZERO_LEN_PSDU_SOUNDING;
+
+			/*
+			 * Null Data Packets contain no data, therefore no
+			 * mcs encoding. The STF/LTF are usually BPSK, therefore
+			 * the NDP mcs rate can always be considered as 0.
+			 */
+			rx_status->rate_idx = 0;
+			rx_status->nss = 1;
+		}
+	}
 }
 
 static void mm81x_rx_h_update_sta(struct ieee80211_sta *sta,
@@ -1977,7 +2112,6 @@ void mm81x_mac_rx_skb(struct mm81x *mors, struct sk_buff *skb,
 							       hdr->addr2;
 
 	mm81x_rx_h_fill_status(mors, hdr_rx_status, &rx_status, skb);
-	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
 	scoped_guard(rcu) {
 		vif = mm81x_rx_h_skb_get_vif(mors, skb, hdr_rx_status);
@@ -1987,6 +2121,11 @@ void mm81x_mac_rx_skb(struct mm81x *mors, struct sk_buff *skb,
 				mm81x_rx_h_update_sta(sta, &rx_status);
 		}
 
+		if (mors->monitor_en)
+			mm81x_rx_h_add_rt_s1g_tlv(skb, hdr_rx_status, &rx_status);
+
+		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+
 		local_bh_disable();
 		ieee80211_rx_napi(hw, sta ? &sta->deflink : NULL, skb, NULL);
 		local_bh_enable();
@@ -2257,9 +2396,6 @@ static int mm81x_mac_ops_add_interface(struct ieee80211_hw *hw,
 
 	rcu_assign_pointer(mors->vifs[mors_vif->id], vif);
 
-	if (vif->type == NL80211_IFTYPE_AP)
-		mm81x_mac_beacon_init(mors_vif);
-
 	ret = mm81x_cmd_get_capabilities(mors, mors_vif->id, &mors->fw_caps);
 	if (ret) {
 		dev_err(mors->dev,
@@ -2268,6 +2404,12 @@ static int mm81x_mac_ops_add_interface(struct ieee80211_hw *hw,
 		return ret;
 	}
 
+	if (vif->type == NL80211_IFTYPE_MONITOR)
+		ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		mm81x_mac_beacon_init(mors_vif);
+
 	ieee80211_wake_queues(mors->hw);
 	return ret;
 }
@@ -2341,6 +2483,9 @@ static void mm81x_mac_config_hw(struct mm81x *mors)
 	hw->sta_data_size = sizeof(struct mm81x_sta);
 	hw->extra_tx_headroom =
 		sizeof(struct mm81x_skb_hdr) + mm81x_bus_get_alignment(mors);
+	hw->radiotap_timestamp.units_pos =
+		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US |
+		IEEE80211_RADIOTAP_TIMESTAMP_SPOS_BEGIN_MDPU;
 
 	mors->wiphy = hw->wiphy;
 
@@ -2355,6 +2500,7 @@ static void mm81x_mac_config_hw(struct mm81x *mors)
 	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
 	ieee80211_hw_set(hw, SUPPORTS_TX_FRAG);
 	ieee80211_hw_set(hw, SUPPORTS_NDP_BLOCKACK);
+	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 
 	SET_IEEE80211_PERM_ADDR(hw, mors->macaddr);
 
-- 
2.43.0

