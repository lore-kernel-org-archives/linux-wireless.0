Return-Path: <SRS0=5aJJ=UD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AECC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Jun 2019 22:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B667206C1
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Jun 2019 22:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559686372;
	bh=sKy/yEBh5xWfp2mAWzv3bh0R0yH1wPIwS9LFYeZgTXg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1Y0g2kKKWdRozoUepMgLsRl8EgsLSIbbir+4TYTu7lagDi5XfhGQL5ujSKfH0puEC
	 eaxneYdAyAUoaim3rL7WDp1YhvJkFyQMEj+voj9nXxW8J79aNalWia/hikHfPOn+/B
	 1ONpnVCLsdWUIf9brnIUAO2aFd3063XRLyXvSkf8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFDWMv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Jun 2019 18:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfFDWMv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jun 2019 18:12:51 -0400
Received: from localhost.localdomain (unknown [151.66.15.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF475206B8;
        Tue,  4 Jun 2019 22:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559686371;
        bh=sKy/yEBh5xWfp2mAWzv3bh0R0yH1wPIwS9LFYeZgTXg=;
        h=From:To:Cc:Subject:Date:From;
        b=QSJIDAgtJTk98w8jJi/vPGCkNvsMJ0ym5KcPVDS81ttAbCnj+wX2u7m/nLcdEguJt
         hpJGET0P7/UyaHTAuozRCTFZKnOuAiAu6d6kELOKJkPGHzksgnEANKobL/8eiqbHQM
         +32t58YdiHNHdBRrOY094+KU6tCEWwvQr1IclcxQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH] mt76: mt7615: remove key check in mt7615_mcu_set_wtbl_key
Date:   Wed,  5 Jun 2019 00:12:20 +0200
Message-Id: <51396ab29d290f95caecbb7fd817c654b74b36dc.1559686202.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not check key pointer in mt7615_mcu_set_wtbl_key since if set_key_cmd
is SET_KEY, key will be always not NULL. This patch will address a false
positive reported by Coverity-Scan

Addresses-Coverity-ID: 1445463 ("Dereference after null check")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
This patch is based on 'mt76: mt7615: fix slow performance when enable
encryption'
https://patchwork.kernel.org/patch/10972385/
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index d104435cd901..7a41c37e7460 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -879,7 +879,7 @@ int mt7615_mcu_set_wtbl_key(struct mt7615_dev *dev, int wcid,
 		u8 cipher;
 
 		cipher = mt7615_get_key_info(key, req.key.key_material);
-		if (cipher == MT_CIPHER_NONE && key)
+		if (cipher == MT_CIPHER_NONE)
 			return -EOPNOTSUPP;
 
 		req.key.rkv = 1;
-- 
2.21.0

