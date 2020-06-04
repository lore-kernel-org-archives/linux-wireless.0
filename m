Return-Path: <SRS0=wyJf=7R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E654FC433DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Jun 2020 07:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C061D206DC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Jun 2020 07:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgFDHKJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Jun 2020 03:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgFDHKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jun 2020 03:10:02 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A059BC05BD1E
        for <linux-wireless@vger.kernel.org>; Thu,  4 Jun 2020 00:10:02 -0700 (PDT)
Received: from [46.59.202.224] (helo=localhost.localdomain)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1jgk0m-0001P3-0s; Thu, 04 Jun 2020 09:10:00 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        John Crispin <john@phrozen.org>
Subject: [PATCH 07/12] mac80211: propagate beacon tx mode to the driver
Date:   Thu,  4 Jun 2020 09:09:47 +0200
Message-Id: <20200604070952.15481-8-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200604070952.15481-1-john@phrozen.org>
References: <20200604070952.15481-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now that we can set the beacon xmit mode via nl80211 we want to also
propagate that info to the device driver. This patch sets the field
inside bss_config.

Signed-off-by: John Crispin <john@phrozen.org>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/cfg.c     | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3812adcef7d7..f99abd5e8bc6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -607,6 +607,7 @@ struct ieee80211_ftm_responder_params {
  * @he_obss_pd: OBSS Packet Detection parameters.
  * @he_bss_color: BSS coloring settings, if BSS supports HE
  * @multi_bssid: the multi bssid settings of the AP.
+ * @beacon_tx_mode: the beacon tx mode. This can be staggered or burst.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -671,6 +672,7 @@ struct ieee80211_bss_conf {
 	struct ieee80211_he_obss_pd he_obss_pd;
 	struct cfg80211_he_bss_color he_bss_color;
 	struct ieee80211_multi_bssid multi_bssid;
+	enum nl80211_beacon_tx_mode beacon_tx_mode;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f6f7323c66ab..1f3c93b8f265 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1071,6 +1071,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	prev_beacon_int = sdata->vif.bss_conf.beacon_int;
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
+	sdata->vif.bss_conf.beacon_tx_mode = params->beacon_tx_mode;
 
 	if (params->he_cap && params->he_oper) {
 		sdata->vif.bss_conf.he_support = true;
-- 
2.20.1

