Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220F6C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 08:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B1A20877
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 08:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u3/YzkRW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3B1A20877
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbeIYO0F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 10:26:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45302 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbeIYO0F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 10:26:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id m16so5829084wrx.12
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 01:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GKEKUhqxpGPnnVGwQ1eDBh2qvquv+MzNiCQMlVFudBg=;
        b=u3/YzkRWSWjGoytcGxNm1rnVZs1O9anI6ONHgdP3gprjQ9jYddYBRXArE1eMvXVS0C
         W5PMt7Xi5pf8sYLVNSXXRjrWqEbjbGtPRedOmJzTFwAy8EjQAuwqu/8cFHSX6gbs1bGL
         ZUST/3m7sXYsomciBpSJ4ARiwVzgfzIZZ4bHgKqxozMf2+cc1PzEek5pllCS3n0Eae1F
         UvnGD4gkBAOlfEV2BBxMLj++IlGzG+il7a/twgTtB2TPfNcsFzdQnCj14wmmkFd18t8h
         zoM8SQ2cDV55rk/X7R6mpA9o1g1gRTnm+wQWIdTv2O/5JrH6o+fiWDjuvTSaYoeaS84X
         CT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GKEKUhqxpGPnnVGwQ1eDBh2qvquv+MzNiCQMlVFudBg=;
        b=b5r8MT7/oFtj96KPuT88S/IlIgnuEtw5AVwlyRyJXZPTyKXRN4GP95Uvp4BOYJLYPO
         AAXPY6GrnmjtMyOSPWtWlJJotdxPQJSUssy0wEy0qrcsAYwghZcmEHL63HkthjlOXWfE
         EofBnKaPiVF80YqjKz4subo7EYzV8bo5n9hEsk35nf2KC2IfM8iRC36WARxvrzyKMqep
         TuJ+1mlT1Isf58ON7owLPlHfrfLz8yXFj0/aJOASySV1MMPAJ4yhEqr78v1w90lnKOwn
         DCWatjIWog7/4glIo6e3Vdsi7yp+LsGkPYonDaEb8hlVlv9lfteyh4R8xakONn5ghTJQ
         WRHQ==
X-Gm-Message-State: ABuFfoh2pkQ6FLKl63BhIbDjt568NRG3LDRU4//EiOMz1WX4sVeR409n
        R8cyGJRIKa/169G/ij+yzZEFn5Ik
X-Google-Smtp-Source: ACcGV62/lsm4he76AYbw4MmzlTpiRgk3uVh9nEzDx11NdwG/cujQUrjZvBx5slVRtm4ib4eg6eHSPA==
X-Received: by 2002:a5d:484f:: with SMTP id n15-v6mr1697726wrs.234.1537863580174;
        Tue, 25 Sep 2018 01:19:40 -0700 (PDT)
Received: from egiraldo.galgus.net (207.250.220.87.dynamic.jazztel.es. [87.220.250.207])
        by smtp.gmail.com with ESMTPSA id e14-v6sm1197841wrv.44.2018.09.25.01.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Sep 2018 01:19:39 -0700 (PDT)
From:   Enrique Giraldo <hgiraldos@gmail.com>
X-Google-Original-From: Enrique Giraldo <enrique.giraldo@galgus.net>
To:     linux-wireless@vger.kernel.org
Cc:     Enrique Giraldo <enrique.giraldo@galgus.net>
Subject: [PATCH] New functionality for aborting ongoing CAC.
Date:   Tue, 25 Sep 2018 10:19:33 +0200
Message-Id: <20180925081933.28553-1-enrique.giraldo@galgus.net>
X-Mailer: git-send-email 2.18.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add NL80211_CMD_ABORT_CAC to the nl80211 interface.

Signed-off-by: Enrique Giraldo <enrique.giraldo@galgus.net>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  4 ++++
 net/mac80211/cfg.c           |  6 ++++++
 net/wireless/nl80211.c       | 23 +++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  8 ++++++++
 net/wireless/trace.h         |  5 +++++
 6 files changed, 48 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8ebabc9873d1..60b60fbdce32 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2896,6 +2896,7 @@ struct cfg80211_external_auth_params {
  *	the scan/scan_done bracket too.
  * @abort_scan: Tell the driver to abort an ongoing scan. The driver shall
  *	indicate the status of the scan through cfg80211_scan_done().
+ * @abort_cac: Tell the driver to abort an ongoing cac.
  *
  * @auth: Request to authenticate with the specified peer
  *	(invoked with the wireless_dev mutex held)
@@ -3227,6 +3228,7 @@ struct cfg80211_ops {
 	int	(*scan)(struct wiphy *wiphy,
 			struct cfg80211_scan_request *request);
 	void	(*abort_scan)(struct wiphy *wiphy, struct wireless_dev *wdev);
+	void	(*abort_cac)(struct wiphy *wiphy, struct wireless_dev *wdev);
 
 	int	(*auth)(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_auth_request *req);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f34942..4ddcb93f370b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -932,6 +932,9 @@
  *	not running. The driver indicates the status of the scan through
  *	cfg80211_scan_done().
  *
+ * @NL80211_CMD_ABORT_CAC: Stop an ongoing CAC. Returns -ENOENT if a CAC
+ *	process is not running.
+ *
  * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
  *	%NL80211_ATTR_WDEV interface. This interface must have been
  *	previously created with %NL80211_CMD_NEW_INTERFACE. After it
@@ -1220,6 +1223,7 @@ enum nl80211_commands {
 	NL80211_CMD_WIPHY_REG_CHANGE,
 
 	NL80211_CMD_ABORT_SCAN,
+	NL80211_CMD_ABORT_CAC,
 
 	NL80211_CMD_START_NAN,
 	NL80211_CMD_STOP_NAN,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d25da0e66da1..2036c91a6e51 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2248,6 +2248,11 @@ static void ieee80211_abort_scan(struct wiphy *wiphy, struct wireless_dev *wdev)
 	ieee80211_scan_cancel(wiphy_priv(wiphy));
 }
 
+static void ieee80211_abort_cac(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	ieee80211_dfs_cac_cancel(wiphy_priv(wiphy));
+}
+
 static int
 ieee80211_sched_scan_start(struct wiphy *wiphy,
 			   struct net_device *dev,
@@ -3850,6 +3855,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
 	.abort_scan = ieee80211_abort_scan,
+	.abort_cac = ieee80211_abort_cac,
 	.sched_scan_start = ieee80211_sched_scan_start,
 	.sched_scan_stop = ieee80211_sched_scan_stop,
 	.auth = ieee80211_auth,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4b8ec659e797..ee80904e098a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7306,6 +7306,21 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int nl80211_abort_cac(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+
+	if (!rdev->ops->abort_cac)
+		return -EOPNOTSUPP;
+
+	if (!wdev->cac_started)
+		return -ENOENT;
+
+	rdev_abort_cac(rdev, wdev);
+	return 0;
+}
+
 static int
 nl80211_parse_sched_scan_plans(struct wiphy *wiphy, int n_plans,
 			       struct cfg80211_sched_scan_request *request,
@@ -13344,6 +13359,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_ABORT_CAC,
+		.doit = nl80211_abort_cac,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 	{
 		.cmd = NL80211_CMD_GET_SCAN,
 		.policy = nl80211_policy,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 364f5d67f05b..edbb11251c03 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -435,6 +435,14 @@ static inline void rdev_abort_scan(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline void rdev_abort_cac(struct cfg80211_registered_device *rdev,
+				  struct wireless_dev *wdev)
+{
+	trace_rdev_abort_cac(&rdev->wiphy, wdev);
+	rdev->ops->abort_cac(&rdev->wiphy, wdev);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 static inline int rdev_auth(struct cfg80211_registered_device *rdev,
 			    struct net_device *dev,
 			    struct cfg80211_auth_request *req)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 7c73510b161f..a585522c678a 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3227,6 +3227,11 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
 	TP_ARGS(wiphy, wdev)
 );
 
+DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_cac,
+	     TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
 TRACE_EVENT(rdev_set_multicast_to_unicast,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 const bool enabled),
-- 
2.18.0

