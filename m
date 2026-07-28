Received: from mail-yx1-f100.google.com (mail-yx1-f100.google.com [74.125.224.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654EA25E469
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249985; cv=none; b=AjIOnKf2QlQkW8qfmvHQCCBXoUA9zNSFj+pk48l4QGVGktS+kmQs5lanpDWo5dxSrEYemUXl8DuP9YYXbpg6C8mQfZFmk6EBmBo6I52vxcmelUMPgfFWEI15trQdjgAQiWN7SAwbUUq9L9tIRCiXwp0ruuIlT3vT1uJ0Ukl7XE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249985; c=relaxed/simple;
	bh=bo4fiCOJe6kPCbIbomajAVvgZri1nxDNhbW1NjXWnrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ij7wHJ2R3l7D0GIng/ZBLFCohfga+1Wuos255wo+Q0+0Lxg6/PC+rSj7yRKsyPnXIrmQ1M5anf8hP5LBHzyHgz2oubGhSvYOohUfcV0u4aO5EuapoMfVgIKAvzu5XFWoCkEDckS766Dwa6FHuhPYYbojg8SaK69qGuH4GT3G6zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NSQMxQXp; arc=none smtp.client-ip=74.125.224.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NSQMxQXp"
Received: by mail-yx1-f100.google.com with SMTP id 956f58d0204a3-66804667af2so3129931d50.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249982; x=1785854782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tf3sYBnd/ttcrab94jSKtw73YcmjtOSF1f6/BzQBueQ=;
        b=m45x8Wy99qamerVBITn5DAkfOB7FMpmN8SXrVM9c2OohWrfq2+Gp+ZlahO1lPdGMPW
         E3HbQSSVFucA/7Y+B6jMgm20zuExzM73F4YEyI+dwAuaBoQWSZ/9HuX01fc+DIVslgia
         Rv4pcVZ4cST3/4R/IUsMRJ52El5WW0tFvQZ1qFBZmIhwcHcDMpbG+99Tq8xaTXtvq1Yb
         M3Mcc4ukI5wcAYPWwGNpTgqjrDTgoWNuU92Vqm8/ruNe1i77SJTe6sLgTg/6JVmKRDqQ
         V3vbDberlfoqzAhGVURI5w+NiyoLZn8GhV5s62M3SuL6xaadm4H6bB/MeM2PRAmAOv+Y
         gsdw==
X-Gm-Message-State: AOJu0YwPOH8rKyLaOQl+wjt8/z+O6TIwXla0/rjOkj7tIQatstqN3Nz4
	2XNtRX4HuRGJPnvjyNZlINW8TPCkT61neLPtLIwkd1ejNAQwdDVuc0845HT2h+4aYqHKYN65u/E
	dEFsn7xJ+QBco0eyBsZ1+T1gQuQWJGf+9qqrlTH0aMu5MkaVTf5uikY277Uz+I5jwBgvMG8Yj53
	fS8QLzOfdgFOwsJUwCoGACvRFeweLVajT82yVIXzQiW7ic2HJ1h2z4xXpKkRZ0yb78xmEl9CALj
	/t1Ppu+ZSQhJbCnGjgVR3MM1Bra
X-Gm-Gg: AR+sD11276bRFuY5aar7cra7kb7rK6zTy/O97Ykllh6MNu/1Atw5i2s2+oTGHpUmJDo
	MyuDg6dRoLjU7zsJRjTzU3xnUUlZtsnwjqvPmqc9JrnOeOy621hk2FI9RSJVXX2Sn39H21Xk8PO
	ylWrdzjJfpfzyICgyixptOCYVp1ahYoUeWFNKf/l+Hg5ufz99iHETlYggCvZnug10k+gMYeTeXv
	tijWaYX+EJ2ICNaVd4v1lkNcJYPRzBtMHlzxvZJ/ilSAyPf8/zVuQ7HGOsPAsheqZfm8PZd6LI0
	Bt2uFvZd66xYxBAlkU7WtUuiZXdsdeDRy49nWfy+bNJ4R7dp+TIXiBAWRj7qwQYHXbyEv7a0Ifv
	4dotxXux0cP0yD8P0PLgHghEJXzreCEM4xwifF65RZbINRux0suTziVJy4eGaGZ6TsvjT1hwXRT
	6NU2/jKdq+SlHSOv37PlOWccpzSmwa/1NpBu2bBXI=
X-Received: by 2002:a05:690e:4252:b0:668:180c:bf6a with SMTP id 956f58d0204a3-669056bc42bmr875130d50.37.1785249982162;
        Tue, 28 Jul 2026 07:46:22 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-668c6cfea32sm897570d50.1.2026.07.28.07.46.21
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:22 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e9a2b95b5so716028285a.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249981; x=1785854781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tf3sYBnd/ttcrab94jSKtw73YcmjtOSF1f6/BzQBueQ=;
        b=NSQMxQXp7dg9bPMP6F7lCWrEzfOvkgXk/eO52WyB9U1SDs5kqE4asTI6ryKtWiZ6ac
         kddmdN5JOLLhUNUNtXISzSMiZPpi9hZaeOXbni//Rp4vyVVcq343jEO6BWl3ByHfhuEI
         n9z1OrCj2ge5A7h5I8eMOlLYzllsuxwSDqHsc=
X-Received: by 2002:a05:620a:4622:b0:92b:d4e3:1f08 with SMTP id af79cd13be357-933027cd622mr271872985a.55.1785249980584;
        Tue, 28 Jul 2026 07:46:20 -0700 (PDT)
X-Received: by 2002:a05:620a:4622:b0:92b:d4e3:1f08 with SMTP id af79cd13be357-933027cd622mr271867685a.55.1785249980019;
        Tue, 28 Jul 2026 07:46:20 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:19 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 11/12] wifi: cfg80211: convert tx_control_port cookie to input parameter
Date: Tue, 28 Jul 2026 16:45:48 +0200
Message-ID: <20260728144549.2207061-12-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The tx_control_port op was excluded from the previous cookie output-to-
input conversion because a NULL cookie was affecting different behavior, ie.
signalling that no TX status is wanted.

Since cfg80211_assign_cookie() guarantees a non-zero value, cookie value
0 can be used instead. So pass 0 when dont_wait_for_ack is set, otherwise
pass value returned from cfg80211_assign_cookie() call.
a pre-assigned value otherwise. Convert the op signature and all
internal mac80211 functions from u64 *cookie to u64 cookie:

- ieee80211_tx_control_port()
- __ieee80211_subif_start_xmit()
- ieee80211_build_hdr()
- ieee80211_store_ack_skb()

All callers that previously passed NULL now pass 0 retaining the
behavior.

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
index 7e2ef8f0e2e1..7b346226fe74 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5219,8 +5219,8 @@ struct mgmt_frame_regs {
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
@@ -5609,7 +5609,7 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt, int link_id,
-				   u64 *cookie);
+				   u64 cookie);
 
 	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
 				struct net_device *dev,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index eecaaa2752db..4f1f52f6edcb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2232,7 +2232,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags,
 				  u32 ctrl_flags,
-				  u64 *cookie);
+				  u64 cookie);
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags);
@@ -2246,7 +2246,7 @@ void ieee80211_clear_fast_xmit(struct sta_info *sta);
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
index 183beae2193a..5549cb8d5cda 100644
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
@@ -2639,7 +2639,7 @@ static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb, u32 info_flags,
 					   struct sta_info *sta, u32 ctrl_flags,
-					   u64 *cookie)
+					   u64 cookie)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -4335,7 +4335,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags,
 				  u32 ctrl_flags,
-				  u64 *cookie)
+				  u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -4530,7 +4530,7 @@ static void ieee80211_mlo_multicast_tx_one(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	ctrl_flags |= u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
-	__ieee80211_subif_start_xmit(out, sdata->dev, 0, ctrl_flags, NULL);
+	__ieee80211_subif_start_xmit(out, sdata->dev, 0, ctrl_flags, 0);
 }
 
 static void ieee80211_mlo_multicast_tx(struct net_device *dev,
@@ -4545,8 +4545,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 		ctrl_flags |= u32_encode_bits(__ffs(links),
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
-		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-					     NULL);
+		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags, 0);
 		return;
 	}
 
@@ -4588,7 +4587,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		while ((skb = __skb_dequeue(&queue)))
 			__ieee80211_subif_start_xmit(skb, dev, 0,
 						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-						     NULL);
+						     0);
 	} else if (ieee80211_vif_is_mld(&sdata->vif) &&
 		   ((sdata->vif.type == NL80211_IFTYPE_AP &&
 		     !ieee80211_hw_check(&sdata->local->hw, MLO_MCAST_MULTI_LINK_TX)) ||
@@ -4599,7 +4598,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 normal:
 		__ieee80211_subif_start_xmit(skb, dev, 0,
 					     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-					     NULL);
+					     0);
 	}
 
 	return NETDEV_TX_OK;
@@ -4698,7 +4697,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 			/* fall back to non-offload slow path */
 			__ieee80211_subif_start_xmit(skb, dev, 0,
 						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
-						     NULL);
+						     0);
 			return;
 		}
 
@@ -4734,7 +4733,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 
 	if (unlikely(sk_requests_wifi_status(skb->sk))) {
 		info->status_data = ieee80211_store_ack_skb(local, skb,
-							    &info->flags, NULL);
+							    &info->flags, 0);
 		if (info->status_data)
 			info->status_data_idr = 1;
 	}
@@ -4877,7 +4876,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 	}
 
 	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta,
-				  IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, NULL);
+				  IEEE80211_TX_CTRL_MLO_LINK_UNSPEC, 0);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -6492,7 +6491,7 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len,
 			      const u8 *dest, __be16 proto, bool unencrypted,
-			      int link_id, u64 *cookie)
+			      int link_id, u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -6627,7 +6626,7 @@ int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
 	local_bh_disable();
 	__ieee80211_subif_start_xmit(skb, skb->dev, 0,
 				     IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP,
-				     NULL);
+				     0);
 	local_bh_enable();
 
 	return 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cf2fece5a1e1..39398d89c5ad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18577,12 +18577,11 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 
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

