Received: from mail-vs1-f97.google.com (mail-vs1-f97.google.com [209.85.217.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599A1418A36
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501350; cv=none; b=Mr+XlV6SGr4jAjbsS1lgzS6icgEB701fxWILYvaebo0gJ2yw26gM1Jm5fIawW6fZhpEr75NZmi608mdcWVV/rH3WyuIKFazWDgr3cZHbe2OO51w3YKYSC91HVMIRmcfFmkNRpFLsSwWNL6G1tpyezkUqCiJj4JNB5SxL9eiZw2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501350; c=relaxed/simple;
	bh=vJ09VNKyoc4jzgHawiyPlvyglba/MTqjh2MVsl4iyY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsPDgVmvvpNkERWj3c16BxzmsT3llbQ2XIk1dyBzjHcbK6Y/CVu7B2qGAhGib4dWwQJN4HK/QY6zER6jT0N2ZSvB98kxfTQdxEOTFW+75T1f+nkfNSTLVAFHbNFxlXAfnloxeteRTVMr5lbaZR6DF+kxzKPsDXTogcJE5jCww/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ph4Sosl8; arc=none smtp.client-ip=209.85.217.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ph4Sosl8"
Received: by mail-vs1-f97.google.com with SMTP id ada2fe7eead31-73720e58dafso428399137.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501347; x=1786106147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w/mfVFxqcgjXVPIGHhD2RvYEcGhBfvkU2nDd+lZB8dg=;
        b=AM7exX9cQ53vW4/4tDobS0cE3X94ZMk6QXFymfgCwxTaXr6hk68EU/Pj81dKn4DHMo
         tf1C2F0S1zxifEXhtp1utnojpZmXT6RsmOGw+DlwSx7LpC/WTLYUIlq03gfXLpi0V74t
         TpANGgdhV5cQSJeu9qY2/VZy6Z8rQXamGIDWUSxJpD9F7vRTeneHfdvvuWD1deUe+UVr
         M0XEav8uoCQ4ERiFxWzgLCWe4+THWcl5EYIXtxfj7piv0kS583qve4lwxdcnmUiAO/lB
         aklXBcT1l3numLK9fkQH/SggHXv+FqnkFl6yktiPgx8K2lwMKtfGkoTgn/v9tkBettRq
         JH8g==
X-Gm-Message-State: AOJu0YyPjjDzUSpgrS8LoRmgcQMgtI2HcCQmpcE1nCNTuoD+6HrbXNme
	c6tq5AP2D/11abWCKF7hF8p4XNSTtx8uKCXtvqWOS7P1ZnEy5smNbWM5qYRlDwOZWIsleeY7ZOf
	h15oWzgomzxqhwwTeoXULfdMDPM5gMQBy248BiAiDA/11MF42Mwrffh5I3yXy6kMmAkvSG/+nT2
	VhippZ2f8XGhrtbJL7AHnNtaOdHV6Ebvq1HBZuXurSA1v2rx69QvLa27AcXfVGJ1HUfzmUw1D4e
	mmN9KRXVIniiaCvsJRzUK/Y1J0m
X-Gm-Gg: AR+sD11whZ3NqYEhjF/J+/dDdKkv15xIPlFuOnA6nOi2Gj4aXOU9XJNWcp8Ei9tdB81
	XhVm4547sSxFSKeEHqI4kWvhgClBQLppSDgiV5cP2YiTeG4FqSDoNVASq5TU7tDKN3b7kg56ANk
	CGynsxM3ltqCoCzwNOKFXKduHgFCxcEFA4dTitAHpoY6X0ICZj/2aPn5Bam1+78gWacHJe/jwDM
	z4vaPS9M4B1Z+17WuaL8+bIOoipU0OfG7gEZBaUPtul/f1VhEw6Dd+nHWiJWSakz/TiwVKLi9Bg
	72bknzUIaaHOrSTlWg0LxSn5gNaOo7aUrbhLD+uV6FB7B+5HgTUosC+7qGv/he8gxqhcHuKdSeM
	UrJEdx2VCXblrxqD6SiMXA02he8UffF5aftGuhN9a9QiutaJoXxW80MMelnDm7ta5JUHYBvV6tC
	axeRm822CwSljTg+FpXuN58wZ2tw4YDoKRyu4HGdA=
X-Received: by 2002:a05:6102:358c:b0:740:2717:a1b2 with SMTP id ada2fe7eead31-758fb5de6d4mr914534137.1.1785501347143;
        Fri, 31 Jul 2026 05:35:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-759b8a1166dsm89688137.4.2026.07.31.05.35.46
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so1066419a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501345; x=1786106145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w/mfVFxqcgjXVPIGHhD2RvYEcGhBfvkU2nDd+lZB8dg=;
        b=Ph4Sosl8BGVTz3dN3ISa1URoHXHg8iXumn//IqsilMlae58FooFfJtOX3C+cnbst79
         5VBoBPS8p6XEau0vuu5Mo5ouFWz4wGRSNDc6mzODNHzpzbFK7oYlBdz4TeMnIQiSBZ2b
         ONhRp4uT9hARe0uRfZ0Xmq8TiURF3fUItb5e4=
X-Received: by 2002:a05:6a21:e8b:b0:3c3:cb39:669a with SMTP id adf61e73a8af0-3c91b3f9ff6mr1807677637.73.1785501345098;
        Fri, 31 Jul 2026 05:35:45 -0700 (PDT)
X-Received: by 2002:a05:6a21:e8b:b0:3c3:cb39:669a with SMTP id adf61e73a8af0-3c91b3f9ff6mr1807636637.73.1785501344558;
        Fri, 31 Jul 2026 05:35:44 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:42 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 12/13] wifi: cfg80211: convert tx_control_port cookie to input parameter
Date: Fri, 31 Jul 2026 14:35:08 +0200
Message-ID: <20260731123509.1975281-13-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The tx_control_port op was excluded from the previous commit because
a NULL cookie was affecting different behavior, ie. signalling that
no TX status is wanted.

Since cfg80211_assign_cookie() guarantees a non-zero value, cookie value
0 can be used instead. So pass 0 when dont_wait_for_ack is set, otherwise
pass value returned from cfg80211_assign_cookie() call.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h     |  6 +++---
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/tdls.c        |  2 +-
 net/mac80211/tx.c          | 27 +++++++++++++--------------
 net/wireless/nl80211.c     |  7 +++----
 net/wireless/rdev-ops.h    |  4 ++--
 6 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 74e267f72c19..97c16d4ff127 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5220,8 +5220,8 @@ struct mgmt_frame_regs {
  *     user space
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
- *	tells the driver that the frame should not be encrypted. When @cookie
- *	is non-NULL it is pre-assigned by cfg80211; drivers must not modify it.
+ *	tells the driver that the frame should not be encrypted. A @cookie
+ *	value of 0 means the caller does not want TX status reporting.
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
@@ -5610,7 +5610,7 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt, int link_id,
-				   u64 *cookie);
+				   u64 cookie);
 
 	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
 				struct net_device *dev,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d74da4e9ebf3..5761e9621491 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2234,7 +2234,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags,
 				  u32 ctrl_flags,
-				  u64 *cookie);
+				  u64 cookie);
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags);
@@ -2248,7 +2248,7 @@ void ieee80211_clear_fast_xmit(struct sta_info *sta);
 int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len,
 			      const u8 *dest, __be16 proto, bool unencrypted,
-			      int link_id, u64 *cookie);
+			      int link_id, u64 cookie);
 int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len);
 void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index ffd575a8d188..dc2f662fe4c4 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1121,7 +1121,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	/* disable bottom halves when entering the Tx path */
 	local_bh_disable();
 	__ieee80211_subif_start_xmit(skb, dev, flags,
-				     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, NULL);
+				     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, 0);
 	local_bh_enable();
 
 	return ret;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6993e694e835..454a872b259a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2583,7 +2583,7 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
 				   struct sk_buff *skb,
 				   u32 *info_flags,
-				   u64 *cookie)
+				   u64 cookie)
 {
 	struct sk_buff *ack_skb;
 	u16 info_id = 0;
@@ -2606,7 +2606,7 @@ static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
 			info_id = id;
 			*info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 			if (cookie)
-				IEEE80211_SKB_CB(ack_skb)->ack.cookie = *cookie;
+				IEEE80211_SKB_CB(ack_skb)->ack.cookie = cookie;
 		} else {
 			kfree_skb(ack_skb);
 		}
@@ -2651,7 +2651,7 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb, u32 info_flags,
 					   struct sta_info *sta, u32 ctrl_flags,
-					   u64 *cookie)
+					   u64 cookie)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -4372,7 +4372,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags,
 				  u32 ctrl_flags,
-				  u64 *cookie)
+				  u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -4567,7 +4567,7 @@ static void ieee80211_mlo_multicast_tx_one(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ctrl_flags |= u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
-	__ieee80211_subif_start_xmit(out, sdata->dev, 0, ctrl_flags, NULL);
+	__ieee80211_subif_start_xmit(out, sdata->dev, 0, ctrl_flags, 0);
 }
 
 static void ieee80211_mlo_multicast_tx(struct net_device *dev,
@@ -4582,8 +4582,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 		ctrl_flags |= u32_encode_bits(__ffs(links),
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
-		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-					     NULL);
+		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags, 0);
 		return;
 	}
 
@@ -4625,7 +4624,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		while ((skb = __skb_dequeue(&queue)))
 			__ieee80211_subif_start_xmit(skb, dev, 0,
 						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-						     NULL);
+						     0);
 	} else if (ieee80211_vif_is_mld(&sdata->vif) &&
 		   ((sdata->vif.type == NL80211_IFTYPE_AP &&
 		     !ieee80211_hw_check(&sdata->local->hw, MLO_MCAST_MULTI_LINK_TX)) ||
@@ -4636,7 +4635,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 normal:
 		__ieee80211_subif_start_xmit(skb, dev, 0,
 					     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-					     NULL);
+					     0);
 	}
 
 	return NETDEV_TX_OK;
@@ -4735,7 +4734,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 			/* fall back to non-offload slow path */
 			__ieee80211_subif_start_xmit(skb, dev, 0,
 						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-						     NULL);
+						     0);
 			return;
 		}
 
@@ -4771,7 +4770,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 
 	if (unlikely(sk_requests_wifi_status(skb->sk))) {
 		info->status_data = ieee80211_store_ack_skb(local, skb,
-							    &info->flags, NULL);
+							    &info->flags, 0);
 		if (info->status_data)
 			info->status_data_idr = 1;
 	}
@@ -4914,7 +4913,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 	}
 
 	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta,
-				  IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, NULL);
+				  IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, 0);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -6529,7 +6528,7 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len,
 			      const u8 *dest, __be16 proto, bool unencrypted,
-			      int link_id, u64 *cookie)
+			      int link_id, u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -6664,7 +6663,7 @@ int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
 	local_bh_disable();
 	__ieee80211_subif_start_xmit(skb, skb->dev, 0,
 				     IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP,
-				     NULL);
+				     0);
 	local_bh_enable();
 
 	return 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8a46101bfdd0..d12bef11b94f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18589,12 +18589,11 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 
 	link_id = nl80211_link_id_or_invalid(info->attrs);
 
-	if (!dont_wait_for_ack)
-		cookie = cfg80211_assign_cookie(rdev);
+	cookie = dont_wait_for_ack ? 0 : cfg80211_assign_cookie(rdev);
 	err = rdev_tx_control_port(rdev, dev, buf, len,
 				   dest, cpu_to_be16(proto), noencrypt, link_id,
-				   dont_wait_for_ack ? NULL : &cookie);
-	if (!err && !dont_wait_for_ack)
+				   cookie);
+	if (!err && cookie)
 		nl_set_extack_cookie_u64(info->extack, cookie);
 	return err;
 }
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index c46e97c90fdc..46849fe8d0b3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -775,7 +775,7 @@ static inline int rdev_tx_control_port(struct cfg80211_registered_device *rdev,
 				       const void *buf, size_t len,
 				       const u8 *dest, __be16 proto,
 				       const bool noencrypt, int link,
-				       u64 *cookie)
+				       u64 cookie)
 {
 	int ret;
 	trace_rdev_tx_control_port(&rdev->wiphy, dev, buf, len,
@@ -783,7 +783,7 @@ static inline int rdev_tx_control_port(struct cfg80211_registered_device *rdev,
 	ret = rdev->ops->tx_control_port(&rdev->wiphy, dev, buf, len,
 					 dest, proto, noencrypt, link, cookie);
 	if (cookie)
-		trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+		trace_rdev_return_int_cookie(&rdev->wiphy, ret, cookie);
 	else
 		trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
-- 
2.54.0

