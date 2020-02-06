Return-Path: <SRS0=7N28=32=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7457BC35247
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Feb 2020 00:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C673217BA
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Feb 2020 00:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580947435;
	bh=LmAw6LaVHwTDKVxrYZBbB7bcCgdIN2t+tFJGjqkOp1s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Aq3rrcDuUQyqBUpnpQyCOUIda6cLjBpn3MQqJtiPPLStT780wgKsvLHqw4Aiqnd5G
	 8PITGhZmnOpK/lKiJmcs/9cfSdNzKrgmrroX0BZjiTC38AzACwk6WaDUEGWN00JoTa
	 DBoCvjMObsGLzG5eCKbmF4K9Cft5D2UDMcoV8aI0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgBFADy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Feb 2020 19:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgBFADy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Feb 2020 19:03:54 -0500
Received: from localhost.lan (unknown [151.48.147.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B833214AF;
        Thu,  6 Feb 2020 00:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580947433;
        bh=LmAw6LaVHwTDKVxrYZBbB7bcCgdIN2t+tFJGjqkOp1s=;
        h=From:To:Cc:Subject:Date:From;
        b=vf+zptLawKvXdpWnnl9O4Q2Q0hfzA7Ru935sM78Tr7/idTx6LwFAmDlg8zQNrJQyv
         0DlGrSlG7ty3XolZbRC+r+OKF0q/n5FkdKOWgpe3J+ZvKlhX7M/lTJJJ70pqgSZtwv
         YR2dymjS0x3GUdpl7Gxor4TQPGeGsN2nAvPOmiXo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, shayne.chen@mediatek.com
Subject: [PATCH] mt76: mt7615: fix msdu_id endianness in mt7615_write_hw_txp
Date:   Thu,  6 Feb 2020 01:03:44 +0100
Message-Id: <3bf70b6584e27d14760f39f7c712392384d1d0bc.1580947049.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix the following sparse warning in mt7615_write_hw_txp:

warning: incorrect type in assignment (different base types)
   expected restricted __le16
   got unsigned long

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index f98ae0be1b03..b0d41ec68b77 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1079,7 +1079,7 @@ mt7615_write_hw_txp(struct mt7615_dev *dev, struct mt76_tx_info *tx_info,
 	tx_info->buf[0].len = MT_TXD_SIZE + sizeof(*txp);
 	tx_info->nbuf = 1;
 
-	txp->msdu_id[0] = id | MT_MSDU_ID_VALID;
+	txp->msdu_id[0] = cpu_to_le16(id | MT_MSDU_ID_VALID);
 
 	for (i = 0; i < nbuf; i++) {
 		u32 addr = tx_info->buf[i + 1].addr;
-- 
2.21.1

