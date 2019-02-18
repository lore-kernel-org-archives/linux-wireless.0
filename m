Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4809CC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 176F0218B0
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="glKgys35";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MMS6Gr6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbfBRGEi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:04:38 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34620 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfBRGEi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 01:04:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1152B608C6; Mon, 18 Feb 2019 06:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550469877;
        bh=YYc2YtGyRfJHgn4hMQSBKDCJ+gfCpAITe7hPfXhQ0CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glKgys35Tb2NFVtd/V3HnJd5X8E2BimNCVtC/dHIG86D6OZlCOrgw2GdH4ZzHtjni
         UZkpsOedXjbbld/0e/5crhPJ7pH1P7x/k78zuoXYtAf9SF1nNsgM27j8+6QUDyxFWh
         eDkK2YYHZJj4dChuIb9fX3qol/BFx+2dg4Jw2WSk=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0BBB1608CD;
        Mon, 18 Feb 2019 06:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550469876;
        bh=YYc2YtGyRfJHgn4hMQSBKDCJ+gfCpAITe7hPfXhQ0CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMS6Gr6l2uRdWY+ZHljnbXN1BoyVQS3lhrJI03iVn4+mrgZp1mSzSJM455N+oW7ar
         vPxyNK/r/16AjRgdXsRuZ7IDPLZR/KsaODoJzR5oSqi7YgB0H7dTiYoBxBTvVBi7t0
         HIMkI2HKn47y9V6pXJqZfIWO0cd6DD0uzoL39HWU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0BBB1608CD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Sun, 17 Feb 2019 22:04:34 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH 3/3] mac80211: probe unexercised mesh links
Date:   Sun, 17 Feb 2019 22:04:17 -0800
Message-Id: <1550469857-3968-4-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550469857-3968-1-git-send-email-rmanohar@codeaurora.org>
References: <1550469857-3968-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The requirement for mesh link metric refreshing, is that from one
mesh point we be able to send some data frames to other mesh points
which are not currently selected as a primary traffic path, but which
are only 1 hop away. The absence of the primary path to the chosen node
makes it necessary to apply some form of marking on a chosen packet
stream so that the packets can be properly steered to the selected node
for testing, and not by the regular mesh path lookup.

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mesh_hwmp.c   |  4 ++++
 net/mac80211/tx.c          | 29 +++++++++++++++++++++++++++++
 5 files changed, 38 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 88219cc137c3..65a5889be6b0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -786,6 +786,7 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_RATE_INJECT: This frame is injected with rate information
  * @IEEE80211_TX_CTRL_AMSDU: This frame is an A-MSDU frame
  * @IEEE80211_TX_CTRL_FAST_XMIT: This frame is going through the fast_xmit path
+ * @IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP: This frame skips mesh path lookup
  *
  * These flags are used in tx_info->control.flags.
  */
@@ -795,6 +796,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_RATE_INJECT		= BIT(2),
 	IEEE80211_TX_CTRL_AMSDU			= BIT(3),
 	IEEE80211_TX_CTRL_FAST_XMIT		= BIT(4),
+	IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP	= BIT(5),
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 96496b2c1670..23df122d14a6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3978,4 +3978,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 	.start_pmsr = ieee80211_start_pmsr,
 	.abort_pmsr = ieee80211_abort_pmsr,
+	.probe_mesh_link = ieee80211_probe_mesh_link,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a1638a5d4188..974b651e3fbe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1754,6 +1754,8 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len,
 			      const u8 *dest, __be16 proto, bool unencrypted);
+int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *buf, size_t len);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6950cd0bf594..fe11bbd137ef 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1118,6 +1118,10 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
 		return 0;
 
+	/* Allow injected packets to bypass mesh routing */
+	if (info->control.flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP)
+		return 0;
+
 	rcu_read_lock();
 	err = mesh_nexthop_lookup(sdata, skb);
 	if (!err)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c2ee5678b2d8..71dc21793060 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4916,3 +4916,32 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 
 	return 0;
 }
+
+int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *buf, size_t len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len +
+			    30 + /* header size */
+			    18); /* 11s header size */
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	skb_put_data(skb, buf, len);
+
+	skb->dev = dev;
+	skb->protocol = htons(ETH_P_802_3);
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+
+	local_bh_disable();
+	__ieee80211_subif_start_xmit(skb, skb->dev, 0,
+				     IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP);
+	local_bh_enable();
+
+	return 0;
+}
-- 
1.9.1

