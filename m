Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B633BFE40
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478530; cv=none; b=aS9Gk4jEKJRP2OPd+1mmp4yrrIXwjirE9gkthsUOAcIt+eNgjo5R+yTzpQEM+wiyBepHlH2eA8QdJ9eoAxcdQBpBg9gwRHyIzBvXu0sJx8EwVJnA/xiU6F8mouXYnNGDyckmRjrOpgP/jekFwddqKC2G7QTDNQUyHDAfKMRk6Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478530; c=relaxed/simple;
	bh=lcE/RDya6EcfS6ZuuxYwGvsAu5u/rlZ6t3NIUH38ceo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9UCxKBTpHnzqM49dQ4iwINriaAHOVGHlmLowMEoAhccRlse7JrvC9THIm8oa6xgqvrK/laC2KR9eiuB/YBCHYV12rPr0y/LJiL3xyQf/hxw+bV+SY47v6kjA60z5UrLs8SfUFmQ9wOeTw9eTuCWPvgc75JhW5BjCRc6Vr+SYyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aCgX+UVw; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aCgX+UVw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=96Gt05m6I7x5tIjLBQue5PC//ka+PdxH44ahG5H6QBg=;
	t=1789478529; x=1790688129; b=aCgX+UVwNAhr4i3RYrTeCM+J38MYoFgIjUJK3oRQQp29ZKh
	ZuZ/zx0+CfeMA6uQS9tTsHukb79ZEZnB6XUzafoz2KQBUXPBPfNnGj0s/4XhTXCRPHUGPkLYbUsUS
	QOcMSgEV3nrW7yuIWmcxpvwG7uk77SY977tkdG221h+xoplzL7Ddw/eZiV93L+HZ9SWW0+WvH7TyX
	rqU5FJe0If3JmDWSuSIidNwdNZCE3549UC+a5K89+C8RJv7Fz5j/aepYC0jnU4lvs/YVetCOKOhRw
	CaMLb1rrfNPXJfvyhCBtU2Fbf05rfsFPWioBWDHzhJikvVR9ZIMlz6+Ol2TnSatw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x6T6k-0000000H08V-2A3k;
	Tue, 15 Sep 2026 15:21:58 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v4 5/8] wifi: cfg80211: add attribute for TX/RX denoting there is no station
Date: Tue, 15 Sep 2026 15:19:31 +0200
Message-ID: <20260915151925.f12af80b1972.I4cfd3db83ba3dc0267575f919ba613ea5d10abd5@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915131925.1780764-10-benjamin@sipsolutions.net>
References: <20260915131925.1780764-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

For MLD stations, userspace may need to explicitly transmit a frame to
a specific link address. In that case, it needs to ensure that no
address translation happens.

In the reverse case of an RX, userspace may need to know the link
address for a frame. By passing the information whether a STA is known
for the frame, userspace knows whether link translation happened and
can do the reverse lookup when needed.

This is important for flows where a STA is still registered but the
connection has been lost and it is returning again.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>

---

v4:
- Change name to NL80211_ATTR_FRAME_NO_STA and use reference for
  NL80211_CMD_FRAME in documentation
---
 include/net/cfg80211.h       | 4 ++++
 include/uapi/linux/nl80211.h | 7 +++++++
 net/wireless/nl80211.c       | 8 +++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6461a7bd0169..9aa7d2d4a184 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4009,6 +4009,7 @@ struct cfg80211_update_ft_ies_params {
  * @link_id: for MLO, the link ID to transmit on, -1 if not given; note
  *	that the link ID isn't validated (much), it's in range but the
  *	link might not exist (or be used by the receiver STA)
+ * @no_sta: set if the frame should not be transmitted using an existing STA
  */
 struct cfg80211_mgmt_tx_params {
 	struct ieee80211_channel *chan;
@@ -4021,6 +4022,7 @@ struct cfg80211_mgmt_tx_params {
 	int n_csa_offsets;
 	const u16 *csa_offsets;
 	int link_id;
+	bool no_sta;
 };
 
 /**
@@ -9501,6 +9503,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
  * @flags: flags, as defined in &enum nl80211_rxmgmt_flags
  * @rx_tstamp: Hardware timestamp of frame RX in nanoseconds
  * @ack_tstamp: Hardware timestamp of ack TX in nanoseconds
+ * @no_sta: set if no station is known for the frame (relevant for MLD)
  */
 struct cfg80211_rx_info {
 	int freq;
@@ -9512,6 +9515,7 @@ struct cfg80211_rx_info {
 	u32 flags;
 	u64 rx_tstamp;
 	u64 ack_tstamp;
+	bool no_sta;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 32553cacf988..510102febc26 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3185,6 +3185,11 @@ enum nl80211_commands {
  *	The aggregated message always precedes the per-link messages for the
  *	same station within a dump sequence.
  *
+ * @NL80211_ATTR_FRAME_NO_STA: Valid for @NL80211_CMD_FRAME to denote that
+ *	the kernel had no station for a received frame or should not use a
+ *	known station to transmit a frame. This is relevant to know whether
+ *	MLD address translation happened or to disable it when sending a frame.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3785,6 +3790,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_STA_DUMP_LINK_STATS,
 
+	NL80211_ATTR_FRAME_NO_STA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b081eeaf7016..e77a4c81d031 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1097,6 +1097,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NPCA_PUNCT_BITMAP] =
 		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
 	[NL80211_ATTR_STA_DUMP_LINK_STATS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_FRAME_NO_STA] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -14873,6 +14874,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	    !(wdev->valid_links & BIT(params.link_id)))
 		return -EINVAL;
 
+	params.no_sta =
+		nla_get_flag(info->attrs[NL80211_ATTR_FRAME_NO_STA]);
+
 	params.buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
 	params.len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
 
@@ -22042,7 +22046,9 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 	    (info->ack_tstamp && nla_put_u64_64bit(msg,
 						   NL80211_ATTR_TX_HW_TIMESTAMP,
 						   info->ack_tstamp,
-						   NL80211_ATTR_PAD)))
+						   NL80211_ATTR_PAD)) ||
+	    (info->no_sta &&
+	     nla_put_flag(msg, NL80211_ATTR_FRAME_NO_STA)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
-- 
2.55.0

