Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32B3C10F14
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 20:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 676392146F
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 20:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ESSyTxiH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ESSyTxiH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfDKUrx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 16:47:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbfDKUrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 16:47:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D6A1A611BE; Thu, 11 Apr 2019 20:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555015671;
        bh=ez7R7phU288hSc3jy1Bb/l5nTG0p9/+lS5HfbbXeE0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESSyTxiHdL914C+uc3m6JGfoA63POH2+VO50D1BBAwVoB4MA+a8MbkNj2YtJwcChi
         NShRuSaRpWTF0QzADuvde1Gj+w7oPmcTURr8dnbAPmFpqCfwK7KtSVvW48L0++L33Y
         4v3f9PjmN2Pb9adE4qmTU/PSO5NpJ67Qgc0Pa4fM=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 18CC961196;
        Thu, 11 Apr 2019 20:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555015671;
        bh=ez7R7phU288hSc3jy1Bb/l5nTG0p9/+lS5HfbbXeE0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESSyTxiHdL914C+uc3m6JGfoA63POH2+VO50D1BBAwVoB4MA+a8MbkNj2YtJwcChi
         NShRuSaRpWTF0QzADuvde1Gj+w7oPmcTURr8dnbAPmFpqCfwK7KtSVvW48L0++L33Y
         4v3f9PjmN2Pb9adE4qmTU/PSO5NpJ67Qgc0Pa4fM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 18CC961196
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Thu, 11 Apr 2019 13:47:49 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v4 3/3] mac80211: probe unexercised mesh links
Date:   Thu, 11 Apr 2019 13:47:26 -0700
Message-Id: <1555015646-7655-4-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1555015646-7655-1-git-send-email-rmanohar@codeaurora.org>
References: <1555015646-7655-1-git-send-email-rmanohar@codeaurora.org>
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

Tested-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
v2: fix addr1 for injected frames
v3: bugfix in filling DA

 include/net/mac80211.h     |  2 ++
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mesh_hwmp.c   |  4 ++++
 net/mac80211/tx.c          | 36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 45 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d66fbfe8d55d..76a443f32fc8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -807,6 +807,7 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_RATE_INJECT: This frame is injected with rate information
  * @IEEE80211_TX_CTRL_AMSDU: This frame is an A-MSDU frame
  * @IEEE80211_TX_CTRL_FAST_XMIT: This frame is going through the fast_xmit path
+ * @IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP: This frame skips mesh path lookup
  *
  * These flags are used in tx_info->control.flags.
  */
@@ -816,6 +817,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_RATE_INJECT		= BIT(2),
 	IEEE80211_TX_CTRL_AMSDU			= BIT(3),
 	IEEE80211_TX_CTRL_FAST_XMIT		= BIT(4),
+	IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP	= BIT(5),
 };
 
 /*
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ba6e4080d63d..52e6a091b7e4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4035,4 +4035,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 	.start_pmsr = ieee80211_start_pmsr,
 	.abort_pmsr = ieee80211_abort_pmsr,
+	.probe_mesh_link = ieee80211_probe_mesh_link,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8a99bcfe81ec..1cd6a8bb17f2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1780,6 +1780,8 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len,
 			      const u8 *dest, __be16 proto, bool unencrypted);
+int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *buf, size_t len);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 2c5929c0fa62..bf8e13cd5fd1 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1135,6 +1135,10 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
 		return 0;
 
+	/* Allow injected packets to bypass mesh routing */
+	if (info->control.flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP)
+		return 0;
+
 	if (!mesh_nexthop_lookup(sdata, skb))
 		return 0;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ffe35fc89351..2b16a2527a6a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2607,6 +2607,13 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			goto free;
 		}
 		band = chanctx_conf->def.chan->band;
+
+		/* For injected frames, fill RA right away as nexthop lookup
+		 * will be skipped.
+		 */
+		if ((ctrl_flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP) &&
+		    is_zero_ether_addr(hdr.addr1))
+			memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
@@ -5093,3 +5100,32 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 
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

