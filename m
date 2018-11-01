Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1629ECDE46
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 09:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E1A120657
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 09:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="O+GD6OxX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E1A120657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbeKASsS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 14:48:18 -0400
Received: from nbd.name ([46.4.11.11]:53292 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbeKASsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 14:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QHnDH3lpNCVsw3kt5cUuqNbQjCPVJY10uc7D/qZOIC8=; b=O+GD6OxX5hDxFRI2UPLvVhN1ri
        3a/oJ7zcJajY/nrEQO5dEaiA5tNDg0JA2vciSB803lg9aWcBox0vHP7JyYuGbk16KCH/RpiF+cTkk
        ztXXm2vWykMwCSJVEApRg+8vUq+WzwwHL6ESl5l0LP2kFsvpMIXaS3+56eAiBNzl678A=;
Received: by maeck.local (Postfix, from userid 501)
        id 43F98427BB5E; Thu,  1 Nov 2018 10:46:01 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, sgruszka@redhat.com
Subject: [PATCH v2 3/4] mt76: mt76x02: only override control->sta on sw-encrypted tx
Date:   Thu,  1 Nov 2018 10:45:59 +0100
Message-Id: <20181101094600.37077-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181101094600.37077-1-nbd@nbd.name>
References: <20181101094600.37077-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

control->sta is set to NULL early when encryption is turned on for the
station and info->control.hw_key is not set.
This code is missing a check for the 802.11 header protected flag, otherwise
it resets the station for other frames, e.g. client probing frames.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 7ec3f8f5f228..c008e08602f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -22,6 +22,7 @@
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mt76x02_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
@@ -33,7 +34,8 @@ void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		msta = (struct mt76x02_sta *)control->sta->drv_priv;
 		wcid = &msta->wcid;
 		/* sw encrypted frames */
-		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
+		if (!info->control.hw_key && wcid->hw_key_idx != 0xff &&
+		    ieee80211_has_protected(hdr->frame_control))
 			control->sta = NULL;
 	}
 
-- 
2.17.0

