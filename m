Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57279C4708C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 May 2021 06:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC22613D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 May 2021 06:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbhE1GLr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 May 2021 02:11:47 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:42948 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235513AbhE1GLl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 May 2021 02:11:41 -0400
X-UUID: 342094424fcf4655accfbcec0262e0ff-20210528
X-UUID: 342094424fcf4655accfbcec0262e0ff-20210528
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1013117767; Fri, 28 May 2021 14:09:37 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 28 May 2021 14:09:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 May 2021 14:09:35 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
CC:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v2 2/4] mac80211: minstrel_ht: fix minstrel_aggr_check for encap offload
Date:   Fri, 28 May 2021 14:05:42 +0800
Message-ID: <2b98f1d3f6fb9f2beb6d3458af3f0c25e863c191.1622164961.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <2176023d8f13d82d093452e1c105609396c30622.1622164961.git.ryder.lee@mediatek.com>
References: <2176023d8f13d82d093452e1c105609396c30622.1622164961.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Avoid checking ieee80211_hdr to support encap offload.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
change since v2 - none
---
 net/mac80211/rc80211_minstrel_ht.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 6487b05da6fa..55ff93c803ac 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1179,19 +1179,24 @@ static void
 minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	u16 tid;
 
 	if (skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
 		return;
 
-	if (unlikely(!ieee80211_is_data_qos(hdr->frame_control)))
+	if (unlikely(!pubsta->wme))
+		return;
+
+	if (!(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) &&
+	    unlikely(!ieee80211_is_data_qos(hdr->frame_control)))
 		return;
 
 	if (unlikely(skb->protocol == cpu_to_be16(ETH_P_PAE)))
 		return;
 
-	tid = ieee80211_get_tid(hdr);
+	tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	if (likely(sta->ampdu_mlme.tid_tx[tid]))
 		return;
 
-- 
2.18.0

