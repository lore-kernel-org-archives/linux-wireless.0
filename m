Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E4C5304BD
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072032; cv=none; b=NJmXOH8zNqeXf922AqaOZ84ReV67AT3GaZDxaGR963PkydUr8Ci9zCJQ4+MQli93HtCxD7LKT3kSYGN5Tjl+w1GW+094gvXMzAf8S0mqIVqgLKsDYGPcbWUaoMB6M/QJvVDm6JC/K4MjYOAQWPurmJJpcJdmV7PWTL5dMI8QdMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072032; c=relaxed/simple;
	bh=tYgW7k39Ra9voPeGl6x2Bx+oGeqc+esNXRDYpnpLUqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb+cfqkPNCn4jr5p3d2/E/YIhLM5Nt3zdhXo84A/qPqVsFxWG0dOAjTXCacUPIcKaMCp2he6gqIzBjk6D4kHxnIkjOZ7WtgRhZvwr6t9+fj6JjF/tBnJgh/mBrwdrK6JN65Evz9MUcwss8aUWJHrwxL8OOUCYTGKCuievC5KREM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=nxcDKBLc; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="nxcDKBLc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ELYVGgN8Q+mAdFmTu3HEPWsUSCl5OUNL9yvJtE9WKyo=; b=nxcDKBLcYLlAbQIZdeM3pyVQBL
	PZ4lKLxSCnul27UHMWKcnWqizLHeyGc3aWdFuOuWMHFQMrbaT+AnZZLshjiwQO8AInCjY3/XbRUUF
	85JbmpHDPhpzCxuVz3Vjr2w3Q3yopArlGzfeTRN0X2qPBhYDxefAKtvv13ikYouCaJHk=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVT-00807z-1c;
	Tue, 22 Sep 2026 12:13:47 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 06/16] wifi: cfg80211: add set_scs and set_mscs driver ops
Date: Tue, 22 Sep 2026 12:13:33 +0200
Message-ID: <cde06523533791e8d6374dc777c8a38f9b00d7e3.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
References: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the ops that install the SCS descriptors and the MSCS of one peer,
the extended feature flags that advertise them, and a wiphy_register()
check that a wiphy which advertises a service also implements the op.
Userspace sets the SCS and Mirrored SCS capability bits based on the
feature flags.

One SCS Request frame can carry several descriptors with different
request types, so set_scs takes an array and answers each descriptor in
a result entry of the same index. A declined change leaves the previous
classification of that SCSID in force. A negative return fails the
request as a whole. A peer has at most one active MSCS, so set_mscs
returns a single status.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h       | 23 +++++++++++++++++-
 include/uapi/linux/nl80211.h |  6 +++++-
 net/wireless/core.c          | 10 ++++++++-
 net/wireless/rdev-ops.h      | 32 ++++++++++++++++++++++++-
 net/wireless/trace.h         | 49 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 120 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1e65021cc1f0..58b28c53a86b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4270,6 +4270,15 @@ struct cfg80211_scs_desc {
 };
 
 /**
+ * struct cfg80211_scs_result - result for one SCS descriptor
+ *
+ * @status: IEEE status code
+ */
+struct cfg80211_scs_result {
+	u16 status;
+};
+
+/**
  * struct cfg80211_mscs_desc - the MSCS of one peer
  *
  * @req_type: add, remove or change
@@ -5388,6 +5397,13 @@ struct mgmt_frame_regs {
  *
  * @set_qos_map: Set QoS mapping information to the driver
  *
+ * @set_scs: Add, change or remove SCS descriptors of one peer. Userspace
+ *	handles the action frame exchange. Each descriptor is answered with
+ *	a status code in the result entry of the same index. A declined add
+ *	or change leaves the previous classification of that SCSID in force.
+ *	A negative return fails the request as a whole.
+ * @set_mscs: Install, change or remove the MSCS of one peer.
+ *
  * @set_ap_chanwidth: Set the AP (including P2P GO) mode channel width for the
  *	given interface This is used e.g. for dynamic HT 20/40 MHz channel width
  *	changes during the lifetime of the BSS.
@@ -5792,6 +5808,13 @@ struct cfg80211_ops {
 			       struct net_device *dev,
 			       struct cfg80211_qos_map *qos_map);
 
+	int	(*set_scs)(struct wiphy *wiphy, struct net_device *dev,
+			   const u8 *peer,
+			   struct cfg80211_scs_desc * const *desc,
+			   struct cfg80211_scs_result *res, u8 n_desc);
+	int	(*set_mscs)(struct wiphy *wiphy, struct net_device *dev,
+			    const u8 *peer, struct cfg80211_mscs_desc *desc);
+
 	int	(*set_ap_chanwidth)(struct wiphy *wiphy, struct net_device *dev,
 				    unsigned int link_id,
 				    struct cfg80211_chan_def *chandef);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f010addee737..7fff9ae133e9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7142,6 +7142,10 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD: Driver supports fast roaming
  *	offload in station mode, including Fast Transition or Opportunistic
  *	Key Caching.
+ * @NL80211_EXT_FEATURE_SCS: Driver supports the stream classification
+ *	service, configured with %NL80211_CMD_SET_SCS.
+ * @NL80211_EXT_FEATURE_MSCS: Driver supports the mirrored stream
+ *	classification service, configured with %NL80211_CMD_SET_MSCS.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -7226,6 +7230,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
 	NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD,
+	NL80211_EXT_FEATURE_SCS,
+	NL80211_EXT_FEATURE_MSCS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index cde3ca85494d..d7b47cbbf542 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -999,6 +999,16 @@ int wiphy_register(struct wiphy *wiphy)
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
index adcfd0278da3..8d5c99be7413 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1188,6 +1188,38 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_set_scs(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev, const u8 *peer,
+			       struct cfg80211_scs_desc * const *desc,
+			       struct cfg80211_scs_result *res, u8 n_desc)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (rdev->ops->set_scs) {
+		trace_rdev_set_scs(&rdev->wiphy, dev, peer, n_desc);
+		ret = rdev->ops->set_scs(&rdev->wiphy, dev, peer, desc, res,
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
index 8c2a91b85c39..81c0899cb212 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2636,6 +2636,55 @@ TRACE_EVENT(rdev_set_ap_chanwidth,
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
