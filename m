Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C90C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 18:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9628520643
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 18:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ny/wL2vN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TjMTS+Tw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfCKStb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 14:49:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfCKStb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 14:49:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0DDEF60ADE; Mon, 11 Mar 2019 18:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552330170;
        bh=5XfanzCWQWlXTipWbGqavaFw128HtXup4ftEzI6CY3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny/wL2vNIpA4+nbkiqyEBhcPWIFI2WnkBY0eNccBB0HVQF5uh3/ERydzzgxpR5/M8
         fUDg1+ps26jZjCvuefmQCuvgm0BPbp+U/CGTXVECm4OLp8GfN1kFyhQUpibadrIQdh
         d5rInnxAEVCrnXaBDVx4cZqbb1i23Tci2vQ6DOOM=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D1B8608CE;
        Mon, 11 Mar 2019 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552330169;
        bh=5XfanzCWQWlXTipWbGqavaFw128HtXup4ftEzI6CY3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjMTS+Twz4bgF80Uk4u5BDLZwSFsG0FV5v7y/AnChDcg+uV2nmlVtTFEWvpdpW50+
         yH/b4NClvedA8nZC8CH76+pWkQLuCnKVQhuUsMF3pmQn6QFfu6tywUJABIKU2usCRa
         CzuSvEWjmtJGtXsECR1YPQzcr/VCY8a82ceSYKRE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D1B8608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Mon, 11 Mar 2019 11:49:27 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, julanhsu@google.com,
        kevinhayes@google.com, Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v2 3/3] mac80211: probe unexercised mesh links
Date:   Mon, 11 Mar 2019 11:49:02 -0700
Message-Id: <1552330142-23228-4-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1552330142-23228-1-git-send-email-rmanohar@codeaurora.org>
References: <1552330142-23228-1-git-send-email-rmanohar@codeaurora.org>
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
v2: fix addr1 for injected frames

 include/net/mac80211.h     |  2 ++
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mesh_hwmp.c   |  4 ++++
 net/mac80211/tx.c          | 36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 45 insertions(+)

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
index c2ee5678b2d8..dd4728b3d844 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2594,6 +2594,13 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			goto free;
 		}
 		band = chanctx_conf->def.chan->band;
+
+		/* For injected frames, fill RA right away as nexthop lookup
+		 * will be skipped.
+		 */
+		if ((ctrl_flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP) &&
+		    is_zero_ether_addr(hdr.addr1))
+			memcpy(hdr.addr1, skb->data + ETH_ALEN, ETH_ALEN);
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
@@ -4916,3 +4923,32 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 
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

