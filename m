Return-Path: <SRS0=exsR=UM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE2DC31E45
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Jun 2019 16:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE6D20644
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Jun 2019 16:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392630AbfFMQhb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:37:31 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:5006 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730637AbfFMHNv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Jun 2019 03:13:51 -0400
X-UUID: 51f25e94249049ff921656c0b66ba1cc-20190613
X-UUID: 51f25e94249049ff921656c0b66ba1cc-20190613
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1922256054; Thu, 13 Jun 2019 15:13:36 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 13 Jun 2019 15:13:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 13 Jun 2019 15:13:34 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Roy Luo <royluo@google.com>, YF Luo <yf.luo@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v2 2/2] mt76: mt7615: update peer's bssid when state transition occurs
Date:   Thu, 13 Jun 2019 15:13:31 +0800
Message-ID: <75f5e467c6e7fc4187572977a8e1f5d4238d6354.1560330906.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <3065a01998dfa04a5d2d680e820a17cb5c110d0f.1560330906.git.ryder.lee@mediatek.com>
References: <3065a01998dfa04a5d2d680e820a17cb5c110d0f.1560330906.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This makes sure that the driver update peer's bssid when state
transition occurs.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
Changes since v2 - remove unnecessary changes
---
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  5 ++--
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 27 ++++++++++---------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index d21407ddda31..e0824392c019 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -283,9 +283,8 @@ static void mt7615_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&dev->mt76.mutex);
 
-	/* TODO: sta mode connect/disconnect
-	 * BSS_CHANGED_ASSOC | BSS_CHANGED_BSSID
-	 */
+	if (changed & BSS_CHANGED_ASSOC)
+		mt7615_mcu_set_bss_info(dev, vif, info->assoc);
 
 	/* TODO: update beacon content
 	 * BSS_CHANGED_BEACON
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index e82086eb8aa4..52d89f3533bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -759,22 +759,23 @@ int mt7615_mcu_set_bss_info(struct mt7615_dev *dev,
 		conn_type = CONNECTION_INFRA_AP;
 		break;
 	case NL80211_IFTYPE_STATION: {
-		struct ieee80211_sta *sta;
-		struct mt7615_sta *msta;
-
-		rcu_read_lock();
-
-		sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
-		if (!sta) {
+		/* TODO: enable BSS_INFO_UAPSD & BSS_INFO_PM */
+		if (en) {
+			struct ieee80211_sta *sta;
+			struct mt7615_sta *msta;
+
+			rcu_read_lock();
+			sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+			if (!sta) {
+				rcu_read_unlock();
+				return -EINVAL;
+			}
+
+			msta = (struct mt7615_sta *)sta->drv_priv;
+			tx_wlan_idx = msta->wcid.idx;
 			rcu_read_unlock();
-			return -EINVAL;
 		}
-
-		msta = (struct mt7615_sta *)sta->drv_priv;
-		tx_wlan_idx = msta->wcid.idx;
 		conn_type = CONNECTION_INFRA_STA;
-
-		rcu_read_unlock();
 		break;
 	}
 	default:
-- 
2.18.0

