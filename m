Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1679EC282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D180C21904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Vt/9Mxw7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfBGNrc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:47:32 -0500
Received: from nbd.name ([46.4.11.11]:47500 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbfBGNr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gbvWbA7hhRJ8mP7ujAtnYh4duQqc4KJSDqOB0p1aisk=; b=Vt/9Mxw7zRehxoZcwh2ZvVtnH/
        bblW+hGN2/t64pNpwU4lWnCsxUzgPnXQ4CXhkQWFZjhgiBwE0S2kGZ0CR/wAINYSQkpVWDWkQBDKE
        VGWH6tJkw3/j9VLbM2lcAaWBlzc9q4g0nT1bLMWIOJakojpVSJ2HqAk3kpIlCTuNVxm8=;
Received: by maeck.lan (Postfix, from userid 501)
        id 83E024F0BF96; Thu,  7 Feb 2019 14:47:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] mt76: fix software encryption issues
Date:   Thu,  7 Feb 2019 14:47:17 +0100
Message-Id: <20190207134723.59163-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Software encrypted packets can be passed not just through the drv_tx callback,
but also through the intermediate tx queue.
In order to deal with that, move the override to mt76x02_mac_write_txwi and
also take care of filling in the per-packet rate information

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 9 +--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 2dc80ea26752..6bd7f87644a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -291,6 +291,13 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 
 	memset(txwi, 0, sizeof(*txwi));
 
+	if (!info->control.hw_key && wcid && wcid->hw_key_idx != 0xff &&
+	    ieee80211_has_protected(hdr->frame_control)) {
+		wcid = NULL;
+		ieee80211_get_tx_rates(info->control.vif, sta, skb,
+		                       info->control.rates, 1);
+	}
+
 	if (wcid)
 		txwi->wcid = wcid->idx;
 	else
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 7861a832940b..94f47248c59f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -22,7 +22,6 @@
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mt76x02_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
@@ -33,13 +32,7 @@ void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 
 		msta = (struct mt76x02_sta *)control->sta->drv_priv;
 		wcid = &msta->wcid;
-		/* sw encrypted frames */
-		if (!info->control.hw_key && wcid->hw_key_idx != 0xff &&
-		    ieee80211_has_protected(hdr->frame_control))
-			control->sta = NULL;
-	}
-
-	if (vif && !control->sta) {
+	} else if (vif) {
 		struct mt76x02_vif *mvif;
 
 		mvif = (struct mt76x02_vif *)vif->drv_priv;
-- 
2.17.0

