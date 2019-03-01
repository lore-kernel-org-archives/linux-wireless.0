Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7685FC4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3983F2084F
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="V52UIB77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbfCAOU2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:20:28 -0500
Received: from nbd.name ([46.4.11.11]:50342 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbfCAOUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 09:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RI4P356ypyh9BR2Pc93/cHaZ2q7ii6FjI/Y1AKo8gkU=; b=V52UIB77ZlXJAIBi+Px6mZ11rm
        fX1L3PGyVI3LeCqyBMDnyXCDdWyU4qhiYgxmgG/UQKOi1K340CRB6LdJUTJZKJ+2iJXOqTELMYm40
        Uyzq/tsiSBoG2YBqWoWPQHSewxWznCWbQsgKEHx06L0wCj7SdyOMGsN1UKcWcw1WK7L8=;
Received: by maeck.lan (Postfix, from userid 501)
        id 0D34250B0029; Fri,  1 Mar 2019 15:20:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76: mt76x02: when setting a key, use PN from mac80211
Date:   Fri,  1 Mar 2019 15:20:22 +0100
Message-Id: <20190301142023.18179-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190301142023.18179-1-nbd@nbd.name>
References: <20190301142023.18179-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Preparation for full device restart support

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 91ff6598eccf..8109bac5aee6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -73,6 +73,7 @@ int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 	enum mt76x02_cipher_type cipher;
 	u8 key_data[32];
 	u8 iv_data[8];
+	u64 pn;
 
 	cipher = mt76x02_mac_get_key_info(key, key_data);
 	if (cipher == MT_CIPHER_NONE && key)
@@ -85,9 +86,22 @@ int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 	if (key) {
 		mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PAIRWISE,
 			       !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
+
+		pn = atomic64_read(&key->tx_pn);
+
 		iv_data[3] = key->keyidx << 6;
-		if (cipher >= MT_CIPHER_TKIP)
+		if (cipher >= MT_CIPHER_TKIP) {
 			iv_data[3] |= 0x20;
+			put_unaligned_le32(pn >> 16, &iv_data[4]);
+		}
+
+		if (cipher == MT_CIPHER_TKIP) {
+			iv_data[0] = (pn >> 8) & 0xff;
+			iv_data[1] = (iv_data[0] | 0x20) & 0x7f;
+			iv_data[2] = pn & 0xff;
+		} else if (cipher >= MT_CIPHER_AES_CCMP) {
+			put_unaligned_le16((pn & 0xffff), &iv_data[0]);
+		}
 	}
 
 	mt76_wr_copy(dev, MT_WCID_IV(idx), iv_data, sizeof(iv_data));
-- 
2.17.0

