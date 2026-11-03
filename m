Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723048;
	b=WTEJyjIlJjV9oEeDXzgLT+2dW6ocNpnWFQemhMvITBhWAcgWRweMJNs6KqIMdh11MFRa
	 bwi5O3b5lVPXNLIFpQzF1iCAnpxE52DLqZKZPuzro501q/oHUOkJmNLhUtxw5Hj1yxnbY
	 e2tdeN6wTvzPHGPKP+Z3jVq7d6ddy6FkUoPCPLp2Svlqwoh59pB3PsUokk/fPXpYXjCBt
	 MhmSdi2EGfqx0cuPHh9Ah7B9wT892/JlThyMFNUwZk9qChkBaPI+KbSkynh0VLsuFhyg0
	 ATpCgTZ6RnyKWYt7JM6UioMxT/5Q9ue2Pe09yQW8mGPGs13FZoKqkV8nBEH4+KEBE1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723048;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oD8fIbToyzi6498lqZJ1n3u0fqFBAVACoV1GBhqCvQY=;
	b=dk2Cig4N/EkNuHbSgo8C+W+muonB+E4bjBnuU++YSOQKnjIV7wirX5J0hphg+Uj5mYhh
	 RWHrpAzye1wIhtBvXVmzCgKMkR6QraoJMhoEFO2QkV9zWwEq+0lfhzb5r9whig4ZFStvA
	 NSUEX6iwLlKUJgTyVK+6ogrVW9QBZB/TH2kM8WZqVyU4smgQBODQLpRpGgrQG1lAJNMSY
	 n/2GpISHbzkLy0101fcIV2a84c21Dbv3/LmJalSEEUlvsiTfLFILEkmlVUltm96KhP9DJ
	 ZYW0nVwaCnhhCBbtmehyn3X9v3PHMNOZIrQmLA34Qlw3JsX6lexPzOyD5s89fmPdUfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=DH5UrV3X;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C75606A33F
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32C75606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=DH5UrV3X
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oD8fIbToyzi6498lqZJ1n3u0fqFBAVACoV1GBhqCvQY=; b=DH5UrV3Xm29HisMTDFUCIq3EAh
	MJc3rVTL8cFc/FXIrqYgdjLmcA0kXAsgYDfaco0SB/QaqtOM1T/Yg0p4otB7uw9xrVpI5oKIW4FYi
	YTP3mjBWT8LPNQ1ACOZbpnKkuFaoj5w/2afwP4o5gweqe+FQ7H3q1Qd5dcAa3sngYN4A=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIm-00FDFp-0A;
	Tue, 03 Nov 2026 17:24:00 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 06/18] wifi: cfg80211: add set_scs and set_mscs driver ops
Date: Tue,  3 Nov 2026 17:23:39 +0100
Message-ID: <83ce8852483e67dfcd8bf14729119ed269d24d10.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
References: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the ops that install the SCS descriptors and the MSCS of one peer,
and the extended feature flags that advertise them. Userspace sets the
SCS and Mirrored SCS capability bits based on the feature flags.

One SCS Request frame can carry several descriptors with different
request types, so set_scs takes an array and answers each descriptor
on its own. A declined change leaves the previous classification of
that SCSID in force. An MSCS request carries one descriptor, so
set_mscs returns a single status.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h       | 18 ++++++++++++++-
 include/uapi/linux/nl80211.h |  6 +++++-
 net/wireless/core.c          | 10 ++++++++-
 net/wireless/rdev-ops.h      | 32 ++++++++++++++++++++++++-
 net/wireless/trace.h         | 49 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 115 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6132f218174a..35381c112af2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5455,6 +5455,17 @@ struct mgmt_frame_regs {
  *
  * @set_qos_map: Set QoS mapping information to the driver
  *
+ * @set_scs: Add, change or remove SCS descriptors of one peer. Userspace
+ *	handles the action frame exchange. Each descriptor is answered with
+ *	an IEEE status code in the @status entry of the same index. A
+ *	declined add or change leaves the previous classification of that
+ *	SCSID in force. cfg80211 answers an accepted removal with
+ *	%WLAN_STATUS_TCLAS_PROCESSING_TERMINATED. A negative return fails
+ *	the request as a whole.
+ * @set_mscs: Install, change or remove an MSCS of one peer. -ENOSPC, for a
+ *	peer that holds no room for another MSCS, is answered with a status
+ *	code.
+ *
  * @set_ap_chanwidth: Set the AP (including P2P GO) mode channel width for the
  *	given interface This is used e.g. for dynamic HT 20/40 MHz channel width
  *	changes during the lifetime of the BSS.
@@ -5883,6 +5894,13 @@ struct cfg80211_ops {
 			       struct net_device *dev,
 			       struct cfg80211_qos_map *qos_map);
 
+	int	(*set_scs)(struct wiphy *wiphy, struct net_device *dev,
+			   const u8 *peer,
+			   struct cfg80211_scs_desc * const *desc,
+			   u16 *status, u8 n_desc);
+	int	(*set_mscs)(struct wiphy *wiphy, struct net_device *dev,
+			    const u8 *peer, struct cfg80211_mscs_desc *desc);
+
 	int	(*set_ap_chanwidth)(struct wiphy *wiphy, struct net_device *dev,
 				    unsigned int link_id,
 				    struct cfg80211_chan_def *chandef);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1d38d59ea261..c39cf8a633e9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7209,6 +7209,10 @@ enum nl80211_feature_flags {
  *
  * @NL80211_EXT_FEATURE_UPDATE_BEACON: Driver supports
  *	%NL80211_CMD_UPDATE_BEACON.
+ * @NL80211_EXT_FEATURE_SCS: Driver supports the stream classification
+ *	service, configured with %NL80211_CMD_SET_SCS.
+ * @NL80211_EXT_FEATURE_MSCS: Driver supports the mirrored stream
+ *	classification service, configured with %NL80211_CMD_SET_MSCS.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -7294,6 +7298,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_PROBE_AP,
 	NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD,
 	NL80211_EXT_FEATURE_UPDATE_BEACON,
+	NL80211_EXT_FEATURE_SCS,
+	NL80211_EXT_FEATURE_MSCS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f4153c249599..41081d6ff623 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1037,6 +1037,16 @@ int wiphy_register(struct wiphy *wiphy)
 		    rdev->ops->update_connect_params))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_SCS) &&
+		    !rdev->ops->set_scs))
+		return -EINVAL;
+
+	if (WARN_ON(wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_MSCS) &&
+		    !rdev->ops->set_mscs))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 7b8440c1f697..f432114e70c6 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1262,6 +1262,38 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_set_scs(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev, const u8 *peer,
+			       struct cfg80211_scs_desc * const *desc,
+			       u16 *status, u8 n_desc)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (rdev->ops->set_scs) {
+		trace_rdev_set_scs(&rdev->wiphy, dev, peer, n_desc);
+		ret = rdev->ops->set_scs(&rdev->wiphy, dev, peer, desc, status,
+					 n_desc);
+		trace_rdev_return_int(&rdev->wiphy, ret);
+	}
+
+	return ret;
+}
+
+static inline int rdev_set_mscs(struct cfg80211_registered_device *rdev,
+				struct net_device *dev, const u8 *peer,
+				struct cfg80211_mscs_desc *desc)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (rdev->ops->set_mscs) {
+		trace_rdev_set_mscs(&rdev->wiphy, dev, peer, desc);
+		ret = rdev->ops->set_mscs(&rdev->wiphy, dev, peer, desc);
+		trace_rdev_return_int(&rdev->wiphy, ret);
+	}
+
+	return ret;
+}
+
 static inline int
 rdev_set_ap_chanwidth(struct cfg80211_registered_device *rdev,
 		      struct net_device *dev,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 31000ffebe43..6c1daaa9d1e5 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2705,6 +2705,55 @@ TRACE_EVENT(rdev_set_ap_chanwidth,
 		  __entry->link_id)
 );
 
+TRACE_EVENT(rdev_set_scs,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *peer, u8 n_desc),
+	TP_ARGS(wiphy, netdev, peer, n_desc),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u8, n_desc)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->n_desc = n_desc;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", %pM, %d descriptors",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->peer, __entry->n_desc)
+);
+
+TRACE_EVENT(rdev_set_mscs,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *peer, const struct cfg80211_mscs_desc *desc),
+	TP_ARGS(wiphy, netdev, peer, desc),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u32, fields)
+		__field(u32, stream_timeout)
+		__field(u8, up_bitmap)
+		__field(u8, up_limit)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->fields = desc ? desc->fields : 0;
+		__entry->stream_timeout = desc ? desc->stream_timeout : 0;
+		__entry->up_bitmap = desc ? desc->up_bitmap : 0;
+		__entry->up_limit = desc ? desc->up_limit : 0;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT
+		  ", %pM, fields %x, UP bitmap %x, UP limit %d, timeout %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->peer, __entry->fields,
+		  __entry->up_bitmap, __entry->up_limit,
+		  __entry->stream_timeout)
+);
+
 TRACE_EVENT(rdev_add_tx_ts,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 u8 tsid, const u8 *peer, u8 user_prio, u16 admitted_time),
-- 
git-series 0.9.1
