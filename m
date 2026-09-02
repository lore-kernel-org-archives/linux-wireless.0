Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45873377EC2
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338778; cv=none; b=jSWitR6TUcxjXTWAm7mjVg1YHRa4IVp2LIiWrsX3DNQcNl/AF9jsLnAGMlH9/ueirQyzFFD0OSJgr/neiNcBc+xZzN8klJUupc52pfU+eFIh4Uud0nly1Qi4o+43rYveMBQDFe3qba8g+AGfZbk6SuOgfBXeb3w2X5QaVoDjzmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338778; c=relaxed/simple;
	bh=4HyCousZl5tdIN2BfB70LAsFn6FmHPVvnrVR53P7wzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPQs1FcnDfmsJoGhl2q3snEo8weYWkWLDu0sghG18vDYHYrxlrFsUI6fAR8GiFfQF8jvFvNwwzW5rC4/tlMd8y02TWY5pTZN6rbMksK4N5dB7+dXajzBI+ACCWQLWQBxBLu8HgcCfVSllB9hR76c0T2u39UHOIOgK5Rveh4zkJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=QTS7hm4H; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="QTS7hm4H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FskLG2VHtlexQp2vOvED2Rm7AhaWvT0/PywaoTp5rfc=; b=QTS7hm4HDUtMD8KUrfim/AcMCg
	Qru8Npgw8hLMGbgjLbiwlGpP97hmn3aOX3T+YqHWBQ/SAkSEYGntBRNQ13Kd6Xl4hdKkR92f2aodH
	XG0qBxz6L5gA8142TqA4sLU4Y3UIMuv7AV18RhhF/FVmIc32eoCAPVKfBFhNjq7XQxis=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbm-00Cwkn-1d;
	Wed, 02 Sep 2026 10:46:14 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 05/15] wifi: cfg80211: add set_scs and set_mscs driver ops
Date: Wed,  2 Sep 2026 10:46:00 +0200
Message-ID: <7bcf9052cf02f1f5d12d8e14ea8d8eca253892f4.1788338716.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
References: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the two ops that install a stream classification on a peer, the
extended feature flags that advertise them, and a wiphy_register() check
that a wiphy does not advertise what it cannot do.

One SCS Request frame can carry several descriptors with different
request types, so set_scs takes a set and each descriptor carries its own
status back. A peer has at most one active MSCS, so set_mscs needs only a
return value.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h       | 28 +++++++++++++++++++++-
 include/uapi/linux/nl80211.h | 10 ++++++++-
 net/wireless/core.c          | 10 ++++++++-
 net/wireless/rdev-ops.h      | 32 ++++++++++++++++++++++++-
 net/wireless/trace.h         | 49 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 129 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f140c3c2a5b8..73ccb6e3173c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4237,6 +4237,18 @@ struct cfg80211_scs_desc {
 };
 
 /**
+ * struct cfg80211_scs_result - what one SCS descriptor is answered with
+ *
+ * Parallel to the descriptor array, so a descriptor holds what was asked for
+ * and never what came of it.
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
@@ -5359,6 +5371,16 @@ struct mgmt_frame_regs {
  *
  * @set_qos_map: Set QoS mapping information to the driver
  *
+ * @set_scs: Add, change or remove SCS descriptors of one peer. The action
+ *	frame exchange has been handled by userspace, so this just has to make
+ *	the transmit path classify matching MSDUs. The op answers every
+ *	descriptor in the result entry of the same index, and a declined change
+ *	leaves the previously accepted classification of that SCSID in force.
+ *	A negative return fails the request as a whole and answers nothing.
+ * @set_mscs: Install, change or remove the MSCS of one peer. A peer has at
+ *	most one active MSCS, so the result is a single return value rather
+ *	than a per descriptor status.
+ *
  * @set_ap_chanwidth: Set the AP (including P2P GO) mode channel width for the
  *	given interface This is used e.g. for dynamic HT 20/40 MHz channel width
  *	changes during the lifetime of the BSS.
@@ -5763,6 +5785,12 @@ struct cfg80211_ops {
 			       struct net_device *dev,
 			       struct cfg80211_qos_map *qos_map);
 
+	int	(*set_scs)(struct wiphy *wiphy, struct net_device *dev,
+			   const u8 *peer, struct cfg80211_scs_desc * const *desc,
+			   struct cfg80211_scs_result *res, u8 n_desc);
+	int	(*set_mscs)(struct wiphy *wiphy, struct net_device *dev,
+			    const u8 *peer, struct cfg80211_mscs_desc *desc);
+
 	int	(*set_ap_chanwidth)(struct wiphy *wiphy, struct net_device *dev,
 				    unsigned int link_id,
 				    struct cfg80211_chan_def *chandef);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 86e1855c8475..f3e085c3c34c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7127,6 +7127,14 @@ enum nl80211_feature_flags {
  *
  * @NL80211_EXT_FEATURE_PROBE_AP: Driver supports probing the associated AP
  *	in STA mode using @NL80211_CMD_PROBE_PEER.
+ * @NL80211_EXT_FEATURE_SCS: Driver or device supports the stream
+ *	classification service, so it classifies transmitted MSDUs against the
+ *	descriptors given with %NL80211_CMD_SET_SCS. Userspace sets the SCS
+ *	field of the Extended Capabilities element only when this is reported.
+ * @NL80211_EXT_FEATURE_MSCS: Driver or device supports the mirrored stream
+ *	classification service, configured with %NL80211_CMD_SET_MSCS.
+ *	Userspace sets the Mirrored SCS field of the Extended Capabilities
+ *	element only when this is reported.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -7210,6 +7218,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ROC_ADDR_FILTER,
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
+	NL80211_EXT_FEATURE_SCS,
+	NL80211_EXT_FEATURE_MSCS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index d13310fef691..cc2cff43ef75 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -974,6 +974,16 @@ int wiphy_register(struct wiphy *wiphy)
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
index 46849fe8d0b3..1287c3542d93 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1185,6 +1185,38 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
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
