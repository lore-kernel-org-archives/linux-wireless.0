Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44731 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1IWSGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 14:06:05 -0400
Received: by gwb15 with SMTP id 15so3913745gwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 11:06:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110922154726.521122680@sipsolutions.net>
References: <20110922154726.521122680@sipsolutions.net>
Date: Fri, 23 Sep 2011 20:06:04 +0200
Message-ID: <CAMG6FYiiyW3Ai_G8vs9Ksxqy9-3bwp88HpCX_iDSSwb7UKO-Hg@mail.gmail.com> (sfid-20110923_200610_545012_4E427626)
Subject: Re: [RFC 00/15] mac80211 uAPSD support
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I think it should be like below (NL80211_ATTR_QOS_INFO and
NL80211_ATTR_UAPSD_SUPPORTED only for backward-compatibility)

With best regards,
Dmitry

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 69cd37d..f627621 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -117,6 +117,7 @@
 #define IEEE80211_MAX_MESH_ID_LEN	32

 #define IEEE80211_QOS_CTL_LEN		2
+#define IEEE80211_QOS_CTL_EOSP		0x0010
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
 #define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2636c01..d831c15 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -610,8 +610,6 @@ enum nl80211_commands {
 	NL80211_CMD_SET_NOA,
 	NL80211_CMD_SET_P2P_POWER_SAVE,

-	NL80211_ATTR_STA_WME,
-
 	/* add new commands above here */

 	/* used to define NL80211_CMD_MAX below */
@@ -1216,6 +1214,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_P2P_PS_CTWINDOW,
 	NL80211_ATTR_UAPSD,

+	NL80211_ATTR_STA_WME,
+	NL80211_ATTR_UAPSD_SUPPORTED,	/* OBSOLETE */
+	NL80211_ATTR_QOS_INFO,		/* OBSOLETE */
+
 	/* add attributes here, update the policy in nl80211.c */

 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 47bcfee..80ece31 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -625,7 +625,7 @@ static bool
sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 	unsigned long flags;
 	struct sk_buff *skb;

-	if (skb_queue_empty(&sta->ps_tx_buf))
+	if (skb_queue_empty(&sta->ps_tx_buf[ac]))
 		return false;

 	/*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b98f18d..791c0e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -176,6 +176,7 @@ static const struct nla_policy
nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_PLINK_STATE] = { .type = NLA_U8 },
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_ATTR_QOS_INFO] = { .type = NLA_U8 },
 	[NL80211_ATTR_P2P_PS_NOA] = { .type = NLA_BINARY,
 				      .len = 32 },
 	[NL80211_ATTR_P2P_PS_NOA_COUNT] = { .type = NLA_U8 },
@@ -952,6 +953,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
u32 pid, u32 seq, int flags,
 	if (nl80211_put_iface_combinations(&dev->wiphy, msg))
 		goto nla_put_failure;

+	if (dev->wiphy.flags & WIPHY_FLAG_AP_UAPSD)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_UAPSD_SUPPORTED);
+
 	return genlmsg_end(msg, hdr);

  nla_put_failure:
