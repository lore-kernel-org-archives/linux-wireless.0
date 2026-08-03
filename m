Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106EB3E715E
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 11:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785757976; cv=none; b=ZLScLVpRtJmCXC6QPjasettTeR8EjA5zw5MXNsayX7U7uKFJjDfTTF2gtiCHtQI21FGGShAW7zoVaw1opgcTaeez1k+T81Sn4iK2LWQjF1lN+OQbPLGFuQBrKLMhVhrowV4U7tu5aB6o1ww4jkqFaPCcRIRy8Gox1C0s+u++cxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785757976; c=relaxed/simple;
	bh=4US4/LG9EZ1S4KuGNEM4y4TqvN5jAPkeeNSMiFbD7qI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IOUD7F2tVaaf/e7t3fH2DeiMUF0+OKt439ju8X5ZQVpqXrOK7kuudyn+NOiUAA++G743YIp3dNy7s3CaSLh5GhZAqFqQb0iFh4KLUmRK4LJa/q5BEq9/e8jqiLdnN/PDm1ux+PO64cjdt7YOB9JdpUmJUDFBLHrDtaGAHgLwxrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=s7F/hBu6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="s7F/hBu6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=sqZ0hzgGDGOQa0jxCtAC9xGrxloqYmcIjSXvVuiU2J8=; t=1785757975; x=1786967575; 
	b=s7F/hBu6NcltS00wSXp62npac8oV/Iv71BHxOXk/MEXwkKga60lC/ueC5gsULLx985n34qpP4zk
	EcaEmGwSJX9xdOQ/Ib0vJhVf8LsF2UPovcQviRvBILi+WQo0lpuBoDbHSOOPha3rQR6JGIeyLCKF0
	mxJ72LappuwK8WRvX/i2IpTzdFNgauaDf41UrKj3nxzFgOlOc3yQg/j+VIuBkiDxjNX14CBGJqiyU
	uA5K1zBwcF/9A+u4nqhxWzpoco4awP4VIaXYpDCs59gWhi5nGPc1eks7Uxir3hp5g9aayTmL+5pIg
	NxnO/1EqZe93MhQ3WX6pK6iX8j4Pqfodw+Ow==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqrDv-0000000BNTh-1PQq;
	Mon, 03 Aug 2026 13:52:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: make ieee80211_is_tx_data() internal
Date: Mon,  3 Aug 2026 13:52:48 +0200
Message-ID: <20260803135248.cd23ccac65d7.I1c238c6abe39f5a1ff1b11d8556599d01dd03ff0@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This function isn't used by any driver, and we may want to
change it in the future. Don't expose it. Drivers may still
do the same determination based on the flags, but if we'd
ever change the encapsulation internally etc. (which I'm
considering) then the use in mac80211 may need to change,
or the function itself.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 19 -------------------
 net/mac80211/ieee80211_i.h |  9 +++++++++
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d1fac6e8082..f65ddbe99b3e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -8058,25 +8058,6 @@ void
 ieee80211_obss_color_collision_notify(struct ieee80211_vif *vif,
 				      u64 color_bitmap, u8 link_id);
 
-/**
- * ieee80211_is_tx_data - check if frame is a data frame
- *
- * The function is used to check if a frame is a data frame. Frames with
- * hardware encapsulation enabled are data frames.
- *
- * @skb: the frame to be transmitted.
- *
- * Return: %true if @skb is a data frame, %false otherwise
- */
-static inline bool ieee80211_is_tx_data(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (void *) skb->data;
-
-	return info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP ||
-	       ieee80211_is_data(hdr->frame_control);
-}
-
 /**
  * ieee80211_set_active_links - set active links in client mode
  * @vif: interface to set active links on
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5761e9621491..e86d8697f614 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -191,6 +191,15 @@ struct ieee80211_tx_data {
 	unsigned int flags;
 };
 
+static inline bool ieee80211_is_tx_data(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+
+	return info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP ||
+	       ieee80211_is_data(hdr->frame_control);
+}
+
 /**
  * enum ieee80211_packet_rx_flags - packet RX flags
  * @IEEE80211_RX_AMSDU: a-MSDU packet
-- 
2.55.0

