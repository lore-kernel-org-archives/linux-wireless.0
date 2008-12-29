Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:51268 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYL2QZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 11:25:27 -0500
Received: by nf-out-0910.google.com with SMTP id d3so594832nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 08:25:25 -0800 (PST)
From: Ville Nuorvala <ville.nuorvala@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Ville Nuorvala <ville.nuorvala@gmail.com>
Subject: [PATCH] mac80211: Add IWSPY support to mac80211 stack
Date: Mon, 29 Dec 2008 18:25:20 +0200
Message-Id: <1230567920-16623-1-git-send-email-ville.nuorvala@gmail.com> (sfid-20081229_172531_641216_0EFCA5CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IWSPY ioctls and netlink events were supported in the old ieee80211
stack. This patch adds them to mac80211.

Signed-off-by: Ville Nuorvala <ville.nuorvala@gmail.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    3 +++
 net/mac80211/rx.c          |   38 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/wext.c        |    8 ++++----
 4 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 117718b..cdfbea5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -431,6 +431,9 @@ struct ieee80211_sub_if_data {
 		u32 mntr_flags;
 	} u;
 
+	struct iw_public_data wireless_data;
+	struct iw_spy_data spy_data;
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *debugfsdir;
 	union {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2c7a87d..128e374 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -778,6 +778,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	/* setup type-dependent data */
 	ieee80211_setup_sdata(sdata, type);
 
+	sdata->wireless_data.spy_data = &sdata->spy_data;
+	ndev->wireless_data = &sdata->wireless_data;
+
 	ret = register_netdevice(ndev);
 	if (ret)
 		goto fail;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 384cb3b..f73e245 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1926,6 +1926,41 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 	return 1;
 }
 
+static void ieee80211_rx_qual_report(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_hdr *hdr,
+				     struct ieee80211_rx_status *status)
+
+{
+#ifdef IW_WIRELESS_SPY		/* defined in iw_handler.h */
+	/* If spy monitoring on */
+	if (sdata->spy_data.spy_number > 0) {
+		struct iw_quality wstats;
+
+		wstats.updated = 0;
+		if (status->signal != 0) {
+			wstats.level = status->signal;
+			wstats.updated |= IW_QUAL_LEVEL_UPDATED;
+		} else
+			wstats.updated |= IW_QUAL_LEVEL_INVALID;
+
+		if (status->noise != 0) {
+			wstats.noise = status->noise;
+			wstats.updated |= IW_QUAL_NOISE_UPDATED;
+		} else
+			wstats.updated |= IW_QUAL_NOISE_INVALID;
+
+		if (status->qual != 0) {
+			wstats.qual = status->qual;
+			wstats.updated |= IW_QUAL_QUAL_UPDATED;
+		} else
+			wstats.updated |= IW_QUAL_QUAL_INVALID;
+
+		/* Update spy records */
+		wireless_spy_update(sdata->dev, hdr->addr2, &wstats);
+	}
+#endif				/* IW_WIRELESS_SPY */
+}
+
 /*
  * This is the actual Rx frames handler. as it blongs to Rx path it must
  * be called with rcu_read_lock protection.
@@ -1988,6 +2023,9 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		if (!prepares)
 			continue;
 
+		/* update signal quality parameters */
+		ieee80211_rx_qual_report(sdata, hdr, status);
+
 		/*
 		 * frame is destined for this interface, but if it's not
 		 * also for the previous one we handle that after the
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 48fc6b9..8056fdd 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -1084,10 +1084,10 @@ static const iw_handler ieee80211_handler[] =
 	(iw_handler) NULL /* kernel code */,		/* SIOCGIWPRIV */
 	(iw_handler) NULL /* not used */,		/* SIOCSIWSTATS */
 	(iw_handler) NULL /* kernel code */,		/* SIOCGIWSTATS */
-	(iw_handler) NULL,				/* SIOCSIWSPY */
-	(iw_handler) NULL,				/* SIOCGIWSPY */
-	(iw_handler) NULL,				/* SIOCSIWTHRSPY */
-	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
+	(iw_handler) iw_handler_set_spy,		/* SIOCSIWSPY */
+	(iw_handler) iw_handler_get_spy,		/* SIOCGIWSPY */
+	(iw_handler) iw_handler_set_thrspy,		/* SIOCSIWTHRSPY */
+	(iw_handler) iw_handler_get_thrspy,		/* SIOCGIWTHRSPY */
 	(iw_handler) ieee80211_ioctl_siwap,		/* SIOCSIWAP */
 	(iw_handler) ieee80211_ioctl_giwap,		/* SIOCGIWAP */
 	(iw_handler) ieee80211_ioctl_siwmlme,		/* SIOCSIWMLME */
-- 
1.6.0.6

