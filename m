Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C088FC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A55C20896
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731906AbfDAHQz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 03:16:55 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44976 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731888AbfDAHQx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 03:16:53 -0400
X-UUID: ba8bde23ba0d4f7a8d4286da09e07c73-20190401
X-UUID: ba8bde23ba0d4f7a8d4286da09e07c73-20190401
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1916109555; Mon, 01 Apr 2019 15:16:48 +0800
Received: from MTKMBS01DR.mediatek.inc (172.21.101.111) by
 mtkexhb01.mediatek.inc (172.21.101.102) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 1 Apr 2019 15:16:47 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01dr.mediatek.inc (172.21.101.111) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 1 Apr 2019 15:16:46 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 1 Apr 2019 15:16:46 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, Sean Wang <sean.wang@mediatek.com>,
        "Nelson Chang" <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Haipin Liang <haipin.liang@mediatek.com>,
        KL Huang <kl.huang@mediatek.com>,
        YH chen <yh.chen@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Ryder Lee" <ryder.lee@mediatek.com>
Subject: [PATCH v3 3/4] mt76: use macro for sn and seq_ctrl conversion
Date:   Mon, 1 Apr 2019 15:16:43 +0800
Message-ID: <64e6331f3ddbd0a1f254fb3dfc3bed732ba64bf2.1554102584.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1554102584.git.ryder.lee@mediatek.com>
References: <cover.1554102584.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use macro to convert sn and seq_ctrl for better readability.

Signed-off-by: Roy Luo <royluo@google.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c       | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index 73c8b28..27e3ff0 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -135,7 +135,7 @@
 		return;
 
 	status->tid = le16_to_cpu(bar->control) >> 12;
-	seqno = le16_to_cpu(bar->start_seq_num) >> 4;
+	seqno = IEEE80211_SEQ_TO_SN(le16_to_cpu(bar->start_seq_num));
 	tid = rcu_dereference(wcid->aggr[status->tid]);
 	if (!tid)
 		return;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index e498169..2f2961e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -627,7 +627,7 @@ void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid, int ssn,
 	status->aggr = unicast &&
 		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
 	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-	status->seqno = hdr->seq_ctrl >> 4;
+	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 5d38392..0c78044 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -594,7 +594,7 @@
 		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, *ssn, -1);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		mtxq->agg_ssn = *ssn << 4;
+		mtxq->agg_ssn = IEEE80211_SN_TO_SEQ(*ssn);
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index b137ce8..f0e1e12 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -378,7 +378,7 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		mtxq->agg_ssn = *ssn << 4;
+		mtxq->agg_ssn = IEEE80211_SN_TO_SEQ(*ssn);
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
-- 
1.9.1

