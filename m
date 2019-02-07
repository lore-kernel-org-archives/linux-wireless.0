Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D64C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 20:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A5E721721
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 20:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JhTkksUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfBGUPq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 15:15:46 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37521 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbfBGUPq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 15:15:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id b5so472861plr.4
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 12:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EYBloDVY93y9seyuM9S5UKqaLVcoB4H9HsMdT8PzIXs=;
        b=JhTkksUIS4xVI7XOThu+Wu5UBn5nxXyOWvDXOf6ZUvRvk0b8ZItQVuiCHXhF0KoU5q
         rFqyu00AQP7V9QlfH7xD5MnoXlWtYjjwDlCaJ56gA+xkQ5C+GNTdpQrwqIOeBp2Nn6c2
         lh/0t+2FUpDfMCDocmtMDS01Ui80PBI2PkgSUOJ/cm2PiElVXAOvyL/PNNb8/4Im+TW7
         yh0P9Hur9OZ7mViFljHu1/CGoOObXMxo6HJTZUT20JW/ZKWj1+r9AuLxEMrY3wQfeiN7
         lF6mgkt0LVb4QhjLYPWAaWKc2Usft0cFP+ptwvinJS/ce//yvM0Isv4Kpxfje/ncpvAn
         oMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EYBloDVY93y9seyuM9S5UKqaLVcoB4H9HsMdT8PzIXs=;
        b=QxEvrCIbY5+a0lETtZrTnh5pTQ8j3J15JbkylB/x1lUckkXu6V9nI9ixCC5dOjIMKD
         /6Bjs6SFf/Hm1ZXpwcsnoBy3dW+T8shHu3/du2u+M0/+oaMCZZRrtTjCci+Ks/5GgyHA
         zXaK4yDzp5ZwmRa6VFc8bvnOqX/txiq4pHXJBqlonJ2rgSYRpE9wFAp3Kjq2dSEee0pN
         KZWHRE5nTrW/6DhwdhJlFm2AO1VQo4B6sUOu/tHdoagQenzcJpjSYek7CPjTrmS9SDkJ
         OYbzldKxlev94lXsMhkhoBReo/yWJrV4KUYQbsKeIeH0+1eONUzkXTC7S0OA005kCHaR
         +mbw==
X-Gm-Message-State: AHQUAua8d6INFfu7XNuIDPTBmnLQk+ohIhI6WLpNxqkuVoFj5ZSqFv+v
        23ZEMnRuGPV9VHUbdeGogHc=
X-Google-Smtp-Source: AHgI3IYXRcX2iNUO5IHDvETmdBDj1FWbbfuPH1pXtv6r9tqTW+Fs1tihd3/rph4AHpUrWYoOJ2DY2Q==
X-Received: by 2002:a17:902:bf0c:: with SMTP id bi12mr18669051plb.0.1549570545217;
        Thu, 07 Feb 2019 12:15:45 -0800 (PST)
Received: from localhost.localdomain ([100.90.116.195])
        by smtp.googlemail.com with ESMTPSA id m198sm20133857pga.10.2019.02.07.12.15.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 07 Feb 2019 12:15:44 -0800 (PST)
From:   Narayanraddi Masti <team.nmasti@gmail.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Narayanraddi Masti <team.nmasti@gmail.com>
Subject: [PATCH 2/2] mac8011: Add support for NL80211_STA_INFO_RX_MCAST_BCAST
Date:   Thu,  7 Feb 2019 12:16:06 -0800
Message-Id: <1549570566-28658-2-git-send-email-team.nmasti@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1549570566-28658-1-git-send-email-team.nmasti@gmail.com>
References: <1549570566-28658-1-git-send-email-team.nmasti@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support to collect per STA mcast/bcast packet information attribute
NL80211_STA_INFO_RX_MCAST_BCAST.

Signed-off-by: Narayanraddi Masti <team.nmasti@gmail.com>
---
 include/net/cfg80211.h       | 17 +++++++++++++++++
 include/uapi/linux/nl80211.h | 28 ++++++++++++++++++++++++++++
 net/mac80211/rx.c            | 17 +++++++++++++++++
 net/mac80211/sta_info.c      | 12 ++++++++++++
 net/mac80211/sta_info.h      |  6 ++++++
 net/wireless/nl80211.c       | 23 +++++++++++++++++++++++
 6 files changed, 103 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f1259e1..e4948b6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1250,6 +1250,20 @@ struct cfg80211_tid_stats {
 #define IEEE80211_MAX_CHAINS	4
 
 /**
+ * struct mc_bc_stats - per STA multicast/broadcast data packets
+ * @mc_pkts: number of multicast packets
+ * @mc_bytes: number of bytes of multicast
+ * @bc_pkts: number of broadcast packets
+ * @bc_bytes: number of bytes of broadcast
+ */
+struct mc_bc_stats {
+	u64 mc_pkts;
+	u64 mc_bytes;
+	u64 bc_pkts;
+	u64 bc_bytes;
+};
+
+/**
  * struct station_info - station information
  *
  * Station information filled by driver for get_station() and dump_station.
@@ -1311,6 +1325,7 @@ struct cfg80211_tid_stats {
  *	an FCS error. This counter should be incremented only when TA of the
  *	received packet with an FCS error matches the peer MAC address.
  * @airtime_link_metric: mesh airtime link metric.
+ * @mc_bc_stat: per STA rx mcast/bcast count stats.
  */
 struct station_info {
 	u64 filled;
@@ -1364,6 +1379,8 @@ struct station_info {
 	u32 fcs_err_count;
 
 	u32 airtime_link_metric;
+
+	struct mc_bc_stats mc_bc_stat;
 };
 
 #if IS_ENABLED(CONFIG_CFG80211)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 99bebbf..6e9d54e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3054,6 +3054,32 @@ enum nl80211_sta_bss_param {
 };
 
 /**
+ * enum nl80211_rx_mcast_bcast - per sta received mc/bc packet count information
+ *
+ * These attribute types are used with %NL80211_STA_INFO_RX_MCAST_BCAST
+ * when getting information about a station's received mcast/bcast packets.
+ *
+ * __NL80211_RX_MCAST_BCAST_INVALID: attribute number 0 is reserved
+ * @NL80211_RX_MCAST_PACKETS: number of received multicast packets
+ * @NL80211_RX_MCAST_BYTES: number of received multicast bytes
+ * @NL80211_RX_BCAST_PACKETS: number of received broadcast packets
+ * @NL80211_RX_BCAST_BYTES: number of received broadcast bytes
+ * @_NL80211_RX_MCAST_BCAST_AFTER_LAST: internal use
+ * @NL80211_RX_MCAST_BCAST_MAX: highest rx mcast_bcast info number
+ */
+enum nl80211_rx_mcast_bcast {
+	__NL80211_RX_MCAST_BCAST_INVALID,
+	NL80211_RX_MCAST_PACKETS,
+	NL80211_RX_MCAST_BYTES,
+	NL80211_RX_BCAST_PACKETS,
+	NL80211_RX_BCAST_BYTES,
+
+	/* keep last */
+	__NL80211_RX_MCAST_BCAST_AFTER_LAST,
+	NL80211_RX_MCAST_BCAST_MAX = __NL80211_RX_MCAST_BCAST_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_sta_info - station information
  *
  * These attribute types are used with %NL80211_ATTR_STA_INFO
@@ -3126,6 +3152,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_CONNECTED_TO_GATE: set to true if STA has a path to a
  *	mesh gate (u8, 0 or 1)
  * @NL80211_STA_INFO_AIRTIME_LINK_METRIC: airtime link metric for mesh station
+ * @NL80211_STA_INFO_RX_MCAST_BCAST: per station rx mcast/bcast count stats.
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3170,6 +3197,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_FCS_ERROR_COUNT,
 	NL80211_STA_INFO_CONNECTED_TO_GATE,
 	NL80211_STA_INFO_AIRTIME_LINK_METRIC,
+	NL80211_STA_INFO_RX_MCAST_BCAST,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bb4d71e..af73562 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2772,6 +2772,20 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 }
 #endif
 
+static inline void ieee80211_mc_bc_stats(char *dst,
+					 struct ieee80211_rx_data *rx)
+{
+	if (is_multicast_ether_addr(dst) && rx->sta) {
+		if (is_broadcast_ether_addr(dst)) {
+			rx->sta->mc_bc_stat.bc_pkts++;
+			rx->sta->mc_bc_stat.bc_bytes += rx->skb->len;
+		} else {
+			rx->sta->mc_bc_stat.mc_pkts++;
+			rx->sta->mc_bc_stat.mc_bytes += rx->skb->len;
+		}
+	}
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
@@ -2806,6 +2820,9 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 	if (unlikely(err))
 		return RX_DROP_UNUSABLE;
 
+	/* Get the multicat broadcast stats */
+	ieee80211_mc_bc_stats(((struct ethhdr *)rx->skb->data)->h_dest, rx);
+
 	if (!ieee80211_frame_allowed(rx, fc))
 		return RX_DROP_MONITOR;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e24dd28..fa27961 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2341,6 +2341,18 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->airtime_link_metric =
 			airtime_link_metric_get(local, sta);
 	}
+
+	sta_get_rx_multicast_broadcast_info(sta, &sinfo->mc_bc_stat);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_MCAST_BCAST);
+}
+
+void sta_get_rx_multicast_broadcast_info(struct sta_info *sta,
+					 struct mc_bc_stats *stats)
+{
+	stats->mc_pkts = sta->mc_bc_stat.mc_pkts;
+	stats->mc_bytes = sta->mc_bc_stat.mc_bytes;
+	stats->bc_pkts = sta->mc_bc_stat.bc_pkts;
+	stats->bc_bytes = sta->mc_bc_stat.bc_bytes;
 }
 
 u32 sta_get_expected_throughput(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8eb2904..75f5114 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -479,6 +479,7 @@ struct ieee80211_sta_rx_stats {
  * @fast_rx: RX fastpath information
  * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
  *	the BSS one.
+ * @mc_bc_stat: per STA rx mcast/bcast count stats.
  * @tx_stats: TX statistics
  * @rx_stats: RX statistics
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
@@ -585,6 +586,8 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct mc_bc_stats mc_bc_stat;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -749,6 +752,9 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		   bool tidstats);
 
+void sta_get_rx_multicast_broadcast_info(struct sta_info *sta,
+					 struct mc_bc_stats *stats);
+
 u32 sta_get_expected_throughput(struct sta_info *sta);
 
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 326493a..dfe474d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4981,6 +4981,29 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 		nla_nest_end(msg, tidsattr);
 	}
 
+	if (sinfo->filled & BIT_ULL(NL80211_STA_INFO_RX_MCAST_BCAST)) {
+		struct nlattr *packetsattr;
+
+		packetsattr = nla_nest_start(msg,
+					     NL80211_STA_INFO_RX_MCAST_BCAST);
+		if (!packetsattr)
+			goto nla_put_failure;
+
+#define PUT_MC_BC_VAL_U64(attr, memb) do {				\
+	if (nla_put_u64_64bit(msg, NL80211_RX_ ## attr,	\
+			  sinfo->mc_bc_stat.memb, NL80211_STA_INFO_PAD)) \
+		goto nla_put_failure;					\
+	} while (0)
+
+		PUT_MC_BC_VAL_U64(MCAST_PACKETS, mc_pkts);
+		PUT_MC_BC_VAL_U64(MCAST_BYTES, mc_bytes);
+		PUT_MC_BC_VAL_U64(BCAST_PACKETS, bc_pkts);
+		PUT_MC_BC_VAL_U64(BCAST_BYTES, bc_bytes);
+
+#undef PUT_MC_BC_VAL_U64
+		nla_nest_end(msg, packetsattr);
+	}
+
 	nla_nest_end(msg, sinfoattr);
 
 	if (sinfo->assoc_req_ies_len &&
-- 
1.9.1

