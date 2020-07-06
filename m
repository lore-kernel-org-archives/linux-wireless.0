Return-Path: <SRS0=AxV3=AR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891F5C433E0
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jul 2020 11:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F1F20720
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Jul 2020 11:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgGFLwe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Jul 2020 07:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbgGFLwc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Jul 2020 07:52:32 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B79C08C5E2
        for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2020 04:52:32 -0700 (PDT)
Received: from [134.101.131.141] (helo=localhost.localdomain)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1jsPfh-000600-U1; Mon, 06 Jul 2020 13:52:30 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        John Crispin <john@phrozen.org>
Subject: [PATCH V2 05/10] mac80211: propagate multi bssid settings when starting
Date:   Mon,  6 Jul 2020 13:52:14 +0200
Message-Id: <20200706115219.663650-5-john@phrozen.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706115219.663650-1-john@phrozen.org>
References: <20200706115219.663650-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch extends the bss_config allowing us to propagate the multiple
bssid setting down the stack into the driver.

Signed-off-by: John Crispin <john@phrozen.org>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/cfg.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 67729b8fcdb2..d7dce78e261e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -607,6 +607,7 @@ struct ieee80211_ftm_responder_params {
  * @he_oper: HE operation information of the AP we are connected to
  * @he_obss_pd: OBSS Packet Detection parameters.
  * @he_bss_color: BSS coloring settings, if BSS supports HE
+ * @multi_bssid: the multi bssid settings of the AP.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -674,6 +675,7 @@ struct ieee80211_bss_conf {
 	} he_oper;
 	struct ieee80211_he_obss_pd he_obss_pd;
 	struct cfg80211_he_bss_color he_bss_color;
+	struct ieee80211_multi_bssid multi_bssid;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d315120799c0..e4b1ac89b1c0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1137,6 +1137,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	       sizeof(struct ieee80211_he_obss_pd));
 	memcpy(&sdata->vif.bss_conf.he_bss_color, &params->he_bss_color,
 	       sizeof(struct ieee80211_he_bss_color));
+	memcpy(&sdata->vif.bss_conf.multi_bssid, &params->multi_bssid,
+	       sizeof(struct ieee80211_multi_bssid));
 
 	sdata->vif.bss_conf.ssid_len = params->ssid_len;
 	if (params->ssid_len)
-- 
2.25.1

