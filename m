Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDC6C282C7
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F292087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Au8Dm169"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfAaFxm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 00:53:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44671 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfAaFxm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 00:53:42 -0500
Received: by mail-pf1-f196.google.com with SMTP id u6so981435pfh.11
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 21:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=95+0R5e9tO+mrTmXWMYgJ7rnYO4TYDfqt2dLLXk7Eno=;
        b=Au8Dm169H1gtrNyzyDjyIgRWKXnADt3v8OjPhhLviwNSJFvNcahR815sOJhHvxqOSN
         nGbdOELYuOHAtV1KNzCGaZDKONYQZOMCri4wVPEbZX/jOC7UK4JKUydt/WrHdghdpCms
         1Vh2KlQ38cj4JnF8cT5Iyp+XGjaXt6Iv7oFCAMu1uRzlW62EdCXEiee6MTNw4V1cXNvE
         5XWNfW1OiH9IUniBdHoIFlqeU7e88c2r67N1Tpz2CHk7182Spk1mih3TfyUIGsfo3S0d
         D9QzMAXpeNqEypDBZlyu0AtCJzDRCtIb031JPIsMX/h080z3n8/rmC0sW93KPc65gD/U
         Azqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=95+0R5e9tO+mrTmXWMYgJ7rnYO4TYDfqt2dLLXk7Eno=;
        b=L5h8cH5KE+phXRhZah/yUKpIErlC2BNP1yvnEIE1Mold3U2kY6g6FQeiFTaoM/8iLU
         voqoXMHCKyUXg2vrgZylfl9HPsIqDSFQaOBVc+ZwDixy6bWT+b/kQj04PsQKJSHFj3bc
         PK8y8Tfz4UDmK1Jh0UUsAV21rBX4UNZUhYQiYdfKSrKZJE595EELc9M2uCelFXjW2IZT
         tW6Pswuyse+QxMeUUj7eG/QmNuJLeW7jagdghRpsL9FYbb39PH0npncNlkyLAROErIhL
         evv+G2z8GpcOvSGSk609CIgvuHAE9Put+6aGIrvm4y37tQP61sP/vByaiTl5t90Cuh2l
         uN7g==
X-Gm-Message-State: AJcUukdXjJyST3ty6NUCHMxGaQGe9/5I8Fl5vdGLxoUaBjUhzu+JAQC6
        2acC7PvuoIzf+nbQSWeJuCUFKW7d6C5IbQ==
X-Google-Smtp-Source: ALg8bN6NOqVUVjqHGJsEyvEFEVzRH4gkK5V1MGx6jqT8oAaakQW/ywfm+ObfQgm6BKNhg1JoYCQzmA==
X-Received: by 2002:a63:1408:: with SMTP id u8mr30458705pgl.271.1548914021318;
        Wed, 30 Jan 2019 21:53:41 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id h19sm4314493pfn.114.2019.01.30.21.53.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 21:53:40 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com,
        ganapathi.kondraju@redpinesignals.com
Subject: [v2 4/5] rsi: resolve power save issue after S4 resume
Date:   Thu, 31 Jan 2019 11:23:04 +0530
Message-Id: <1548913985-7180-5-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
References: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
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
index 43e8a0d..f8db5f5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1393,6 +1393,7 @@ static int rsi_restore(struct device *dev)
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

