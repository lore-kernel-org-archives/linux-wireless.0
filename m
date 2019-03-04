Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B45AC4360F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BF192082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="l5eofnC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfCDICm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:42 -0500
Received: from nbd.name ([46.4.11.11]:40438 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfCDICl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rb4uzP/M2Dhrf4UcSPRl1CbhdLYo7QMpRG4e90ZsINQ=; b=l5eofnC11CUFMrbFhOoBSLtfmU
        4sjzBuiwmBTUXDG5pCwkSFam0YaA+J38HMgoq15sUDgvxZwxbfm0L6lt4etvWdDLAvRTYSgWAKTZG
        YPaV/ZQqu3X8jFADUTzEg/4jRwUexJfhHJ5v+62tK2g88nsoZjdN6UjiO6DVSqAXfot4=;
Received: by maeck.lan (Postfix, from userid 501)
        id 17DC450E540D; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] mt76: mt76x02: disable ED/CCA by default
Date:   Mon,  4 Mar 2019 09:02:33 +0100
Message-Id: <20190304080234.3221-10-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This feature has been reported to cause stability issues on several systems.
Disable it until it has been fixed and verified. It can still be enabled
through debugfs

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  1 +
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  | 27 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  |  3 ++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 0f0fab54e4f1..5ed75d66ef8e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -118,6 +118,7 @@ struct mt76x02_dev {
 	unsigned long ed_trigger_timeout;
 	bool ed_tx_blocked;
 	bool ed_monitor;
+	u8 ed_monitor_enabled;
 	u8 ed_monitor_learning;
 	u8 ed_trigger;
 	u8 ed_silent;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
index 7580c5c986ff..b1d6fd4861e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
@@ -116,6 +116,32 @@ static int read_agc(struct seq_file *file, void *data)
 	return 0;
 }
 
+static int
+mt76_edcca_set(void *data, u64 val)
+{
+	struct mt76x02_dev *dev = data;
+	enum nl80211_dfs_regions region = dev->dfs_pd.region;
+
+	dev->ed_monitor_enabled = !!val;
+	dev->ed_monitor = dev->ed_monitor_enabled &&
+			  region == NL80211_DFS_ETSI;
+	mt76x02_edcca_init(dev, true);
+
+	return 0;
+}
+
+static int
+mt76_edcca_get(void *data, u64 *val)
+{
+	struct mt76x02_dev *dev = data;
+
+	*val = dev->ed_monitor_enabled;
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_edcca, mt76_edcca_get, mt76_edcca_set,
+			 "%lld\n");
+
 void mt76x02_init_debugfs(struct mt76x02_dev *dev)
 {
 	struct dentry *dir;
@@ -127,6 +153,7 @@ void mt76x02_init_debugfs(struct mt76x02_dev *dev)
 	debugfs_create_u8("temperature", 0400, dir, &dev->cal.temp);
 	debugfs_create_bool("tpc", 0600, dir, &dev->enable_tpc);
 
+	debugfs_create_file("edcca", 0400, dir, dev, &fops_edcca);
 	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
 	debugfs_create_file("dfs_stats", 0400, dir, dev, &fops_dfs_stat);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index e4649103efd4..17d12d212d1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -885,7 +885,8 @@ mt76x02_dfs_set_domain(struct mt76x02_dev *dev,
 	if (dfs_pd->region != region) {
 		tasklet_disable(&dfs_pd->dfs_tasklet);
 
-		dev->ed_monitor = region == NL80211_DFS_ETSI;
+		dev->ed_monitor = dev->ed_monitor_enabled &&
+				  region == NL80211_DFS_ETSI;
 		mt76x02_edcca_init(dev, true);
 
 		dfs_pd->region = region;
-- 
2.17.0

