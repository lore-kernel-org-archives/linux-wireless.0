Return-Path: <SRS0=Otg8=OG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C37EC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 393512086B
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 393512086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbeK1JUt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 04:20:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39970 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeK1JUt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 04:20:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id q26so579889wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2018 14:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KVk3rBJcueAUCmvfsxxWAFckXyALr6UVsUu1XYDUXM=;
        b=SF2a9pOXuzEl9d5v5A5Ba5rmZMEC8pghpIk26ikSehtnqDyERh07qBx36qAaoU9c5o
         eA5a/eCJnuqa7HCjju8d+DZbfJAnYHOFoWgyptf2wngyBTVTH35BFo/H5oHccimyX9qn
         3hIZ/t2V1HYDPAFlmEnrqDNPY9CDBfW9LStEFYHUDMXR/E5Of7DoAEnsR2AOK/bXOcbR
         lXWRbc4NiDm1jjeQEKQoi9oZzdjfQAytxCp8xzLa4MjtKkjXKMAUn6IKz9Jx8y3eGrMd
         nT9b9lAksF/UMAEWcqqutw0cgexrxD411XJI711gnIGWwtFrsEIQSB8xklIFAGlAKb0W
         pBSg==
X-Gm-Message-State: AA+aEWZo6yjkg23mrS0kXU85ncXIp67/q+xA1RZq99XzbkXuGuUetS7w
        2TtmQdPuT1K0We51K+NW3bTy25ySda0=
X-Google-Smtp-Source: AFSGD/VnAI5qxXwELf5YfDKwMToFCr0731np4VKTlqLS+UfLw/fkFtVUBVDgTUSS2crQp3L2/Tfzkw==
X-Received: by 2002:a1c:ddc3:: with SMTP id u186mr543649wmg.110.1543357286295;
        Tue, 27 Nov 2018 14:21:26 -0800 (PST)
Received: from localhost.lan ([151.21.135.68])
        by smtp.gmail.com with ESMTPSA id 142sm866245wmw.27.2018.11.27.14.21.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 14:21:25 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name
Subject: [RFC 1/5] mac80211: introduce ieee80211_xdp handler
Date:   Tue, 27 Nov 2018 23:21:08 +0100
Message-Id: <35462be4a802b03c82d0312726e8421dadfa22a1.1543343124.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initialize net_device_ops ndo_bpf callback with ieee80211_xdp routine
in order to load a bpf program into low level driver XDP rx hook

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 include/net/mac80211.h    |  2 ++
 net/mac80211/driver-ops.h | 11 +++++++++++
 net/mac80211/iface.c      | 14 ++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71985e95d2d9..a91f1733ce43 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3623,6 +3623,7 @@ enum ieee80211_reconfig_type {
  *	skb is always a real frame, head may or may not be an A-MSDU.
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ * @xdp: main XDP handler
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3911,6 +3912,7 @@ struct ieee80211_ops {
 	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct cfg80211_ftm_responder_stats *ftm_stats);
+	int (*xdp)(struct ieee80211_hw *hw, struct netdev_bpf *xdp);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0b1747a2313d..48cad0ae0593 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1278,4 +1278,15 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_xdp(struct ieee80211_local *local,
+			  struct netdev_bpf *xdp)
+{
+	might_sleep();
+
+	if (!local->ops->xdp)
+		return -EOPNOTSUPP;
+
+	return local->ops->xdp(&local->hw, xdp);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5836ddeac9e3..e21971f7c652 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1163,6 +1163,19 @@ ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	}
 }
 
+static int ieee80211_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	switch (xdp->command) {
+	case XDP_QUERY_PROG:
+	case XDP_SETUP_PROG:
+		return drv_xdp(sdata->local, xdp);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_open		= ieee80211_open,
 	.ndo_stop		= ieee80211_stop,
@@ -1172,6 +1185,7 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_set_mac_address 	= ieee80211_change_mac,
 	.ndo_select_queue	= ieee80211_netdev_select_queue,
 	.ndo_get_stats64	= ieee80211_get_stats64,
+	.ndo_bpf		= ieee80211_xdp,
 };
 
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
-- 
2.19.1

