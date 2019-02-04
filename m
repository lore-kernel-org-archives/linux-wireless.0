Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66112C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 346302177E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qA1hSeaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfBDGeD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:34:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37205 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfBDGeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 01:34:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id c25so5849983pgb.4
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2019 22:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C/IPLfRZQKxy/vjOToflTi/6W+HYcEMZq2LJ+fpWG7Y=;
        b=qA1hSeafCq6Zv0kqydoq2/mpxAvftejt6ngnDRkiqEV9U4D044GfWuMD6F5fT8zW9o
         keyRiUmsZip6bPz+10aioBxn3T5+E8WjbM2ZyPGUj0zFhZ7ksq9CJiK1BKP0qD9nIKQs
         KC3ISYHdlX61eUqZO2kpgaazMYezUJxDBCjjMjfVpzKd25aMVUcTYbwrYdSF44sIlKNn
         21WFP7mq46JbUJiIc5Vyng+MoJebmCwYN5/yvt1LCXrdlEa1Sv1IacfExlOcVWtfBDec
         daF1PJS1gnL1EIlTI5qGCbDjDcy2R/Dtkw9m6Gmaf1DJ6hoqYBQg0f+GVK9PrkdnfcMo
         6Uyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C/IPLfRZQKxy/vjOToflTi/6W+HYcEMZq2LJ+fpWG7Y=;
        b=H9IRYGjTCsplfph7U9pAbL2/ydNEsvL8v8bdPktzeOTYszXsKlhiiQhAEAzbPnINQj
         5j6RuUp9Z8tdWQaTR+8MsLrWFadyGE/EUXIgOKmVFfpxRpqZFhEsZ2U7PAxrVBrmzWjG
         JjUg+sunoFa8x/9tTLzpYztJIDARvIyCLPqhu3tjczor9EF5SWYJ5D5PtLGTp8kycGKK
         WTuxUDhtSoDvFxuOYHVgZqONQS6An+cesLi9iBrz7XaKIf4/xjg+xqSLNSFwCPsJ/Ul4
         kGQTpBL2W9q5/bdjhGIH6pEqkmy4Y80wXq80BlzvKCjH7OqeMHgm/ITWVfAhx5KbU5JV
         raXg==
X-Gm-Message-State: AJcUukdT1PMme30YdjVVwxt/KzS+D2zkS2gKFW4xYGdKFpFuTWZ1OTY2
        MZ8OVhD3m00VbVVRkBZc8OY=
X-Google-Smtp-Source: ALg8bN6w/KR611aBkNZPM0at9grpleYM0c/cgxoc+Jde+zWwOwfDIaBeJyEBs9qm6i085lGbv4kFnA==
X-Received: by 2002:a62:1709:: with SMTP id 9mr49309297pfx.249.1549262042123;
        Sun, 03 Feb 2019 22:34:02 -0800 (PST)
Received: from cpu459.localdomain ([27.59.252.63])
        by smtp.gmail.com with ESMTPSA id t21sm20240438pgg.24.2019.02.03.22.33.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:34:01 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com, amitkarwar@gmail.com
Subject: [v3 4/5] rsi: resolve power save issue after S4 resume
Date:   Mon,  4 Feb 2019 12:03:28 +0530
Message-Id: <1549262009-8766-5-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
References: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

We are redownloading the firmware after S4 restore and observed in
stress test that mac80211 sometimes gives power save request after
resume which causes the firmware in bad state. mac_ops_resumed flag
is added to skip that request until initialisation is done and Keeping
power save state is NONE.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 9 ++++++++-
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 1 +
 drivers/net/wireless/rsi/rsi_main.h         | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 8d1282f..7bc8da6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -239,6 +239,7 @@ static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
 	struct ieee80211_bss_conf *bss = &vif->bss_conf;
 
 	rsi_dbg(INFO_ZONE, "***** Hardware scan start *****\n");
+	common->mac_ops_resumed = false;
 
 	if (common->fsm_state != FSM_MAC_INIT_DONE)
 		return -ENODEV;
@@ -370,6 +371,10 @@ static void rsi_mac80211_tx(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	struct ieee80211_hdr *wlh = (struct ieee80211_hdr *)skb->data;
+
+	if (ieee80211_is_auth(wlh->frame_control))
+		common->mac_ops_resumed = false;
 
 	rsi_core_xmit(common, skb);
 }
@@ -677,7 +682,8 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 	}
 
 	/* Power save parameters */
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
+	if ((changed & IEEE80211_CONF_CHANGE_PS) &&
+	    !common->mac_ops_resumed) {
 		struct ieee80211_vif *vif, *sta_vif = NULL;
 		unsigned long flags;
 		int i, set_ps = 1;
@@ -1939,6 +1945,7 @@ static int rsi_mac80211_resume(struct ieee80211_hw *hw)
 	rsi_dbg(INFO_ZONE, "%s: mac80211 resume\n", __func__);
 
 	if (common->hibernate_resume) {
+		common->mac_ops_resumed = true;
 		/* Device need a complete restart of all MAC operations.
 		 * returning 1 will serve this purpose.
 		 */
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 449803c..764ad06 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1396,6 +1396,7 @@ static int rsi_restore(struct device *dev)
 	common->iface_down = true;
 
 	adapter->sc_nvifs = 0;
+	adapter->ps_state = PS_NONE;
 
 	common->wow_flags = 0;
 	common->iface_down = false;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 4dc0c01..35d13f3 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -311,6 +311,7 @@ struct rsi_common {
 	struct cfg80211_scan_request *hwscan;
 	struct rsi_bgscan_params bgscan;
 	u8 bgscan_en;
+	u8 mac_ops_resumed;
 };
 
 struct eepromrw_info {
-- 
2.5.5

