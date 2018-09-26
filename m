Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A390DC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 11:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E5A620684
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 11:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E5A620684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbeIZRUL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 13:20:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53951 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbeIZRUL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 13:20:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id b19-v6so1818628wme.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2018 04:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6rY8XoqiazM9iArfejycswdlC5o8O3kFOMaOE9Dcwts=;
        b=uNSBulgEX761grfFlKwHziaDMDUD8UdcxGCNpYDK/23OFX74htOdOVS2TbYdkbXUIG
         4B4vq3CCnP7+nyDdDKxWdxHoAWRh82Ap7+9IXzZd6Dnq80Vab4ZzeHxSFyrVHZFqTcL2
         Il7hphc6kt37CIHeOGKg8NR0Nu40P81yGbnCn4AehU7xEY9FEyFa5wh6TiasxLGwXbdy
         WNt9jEnTnTmUgChg90ZzON03XwUWYkST9qU3wYNbgaKHhqAXi3Sch1IC100ec/15vKse
         Cod8OwVmRwnGnDIA0U12Ld5IoD8ZC5euQO8TeTbqgPgnCgwO4Whu0s3kqEcm/4nFOIMn
         6h7Q==
X-Gm-Message-State: ABuFfoiD/Wgla1la7kNHgOri7TaOPycCEG0wj43CowviPia0Mob2xDJa
        84sGlwCH1EPT5IkXV4QtBIxr5zOWQoo=
X-Google-Smtp-Source: ACcGV60e35wUxAgEu1yzhBoHNP7VZ1HfaqhVxQ2u1jx2X7UfuoWqrjCTpqkHFg251rgmrHlefbjPnA==
X-Received: by 2002:a1c:2384:: with SMTP id j126-v6mr3942392wmj.124.1537960063059;
        Wed, 26 Sep 2018 04:07:43 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id l10-v6sm5562033wrp.40.2018.09.26.04.07.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Sep 2018 04:07:42 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: usb: make rx page_frag_cache access atomic
Date:   Wed, 26 Sep 2018 13:07:39 +0200
Message-Id: <079c65bc4ca471dac81da909fa22ee1a0797a6f7.1537959770.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1537959770.git.lorenzo.bianconi@redhat.com>
References: <cover.1537959770.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add rx_page_lock spinlock in order to make rx page fragment access
atomic. This patch fixes the following crash that occasionally
occurs during module loading/unloading

BUG: unable to handle kernel paging request at ffff9f8322e19000
PGD 27ba01067 P4D 27ba01067 PUD 27ddba063 PMD 263b35063 PTE 8000000262e19061
Oops: 0003 [#1] SMP PTI
CPU: 2 PID: 1766 Comm: systemd-udevd Not tainted 4.19.0-rc5+ #6
Hardware name: ASUSTeK COMPUTER INC. ESC2000 G2/Z9PE-D8 WS, BIOS 0405 03/19/2012
RIP: 0010:__memcpy+0x12/0x20
RSP: 0018:ffffba13849b3ad8 EFLAGS: 00010246
RAX: ffff9f8322e17004 RBX: 00000000000038f0 RCX: 000000000000031f
RDX: 0000000000000000 RSI: ffffba13844cf058 RDI: ffff9f8322e18ffc
RBP: 0000000000010c6c R08: 0000000000000000 R09: 0000607ec0000000
R10: 0000000000000003 R11: 0000000000003e2e R12: ffff9f8324cd9540
R13: 0000000000000000 R14: ffffba13849b3b30 R15: ffff9f8322e17000
FS:  00007fadec85b880(0000) GS:ffff9f833fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff9f8322e19000 CR3: 0000000263428001 CR4: 00000000000606e0
Call Trace:
 mt76x02u_mcu_fw_send_data+0x16c/0x270 [mt76x02_usb]
 mt76x0u_probe+0x35a/0x598 [mt76x0u]
 usb_probe_interface+0x113/0x310
 really_probe+0x1c8/0x400
 driver_probe_device+0x5c/0x130
 __driver_attach+0xec/0x110
 bus_for_each_dev+0x50/0x90
 bus_add_driver+0x1c0/0x280
 driver_register+0x5b/0xe0
 usb_register_driver+0x7c/0x140
 do_one_initcall+0x44/0x19b
 do_init_module+0x5a/0x210
 load_module+0x175c/0x1bc0
 __do_sys_finit_module+0x97/0xc0
 do_syscall_64+0x3f/0xf0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fadeb6f1809
RSP: 002b:00007ffe548f9f38 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 00007fadebdf0d89 RCX: 00007fadeb6f1809
RDX: 0000000000000000 RSI: 00007fadebdf0d89 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000006 R11: 0000000000000246 R12: 0000560b9ef58ab0
R13: 0000560b9ef29800 R14: 0000560b9ef59040 R15: 0000000000020000

Fixes: c12128ce44b0 ("mt76: use a per rx queue page fragment cache")
Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h         | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c   | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c | 8 ++++----
 drivers/net/wireless/mediatek/mt76/usb.c          | 8 +++++++-
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 15a5b0c89d86..8031360a6592 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -122,6 +122,7 @@ struct mt76_queue {
 	dma_addr_t desc_dma;
 	struct sk_buff *rx_head;
 	struct page_frag_cache rx_page;
+	spinlock_t rx_page_lock;
 };
 
 struct mt76_mcu_ops {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 76d607f73758..7647d84e59f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -249,11 +249,11 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	if (!(mt76_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
 		dev_warn(dev->mt76.dev, "Warning: eFUSE not present\n");
 
-	ret = mt76u_mcu_init_rx(&dev->mt76);
+	ret = mt76u_alloc_queues(&dev->mt76);
 	if (ret < 0)
 		goto err;
 
-	ret = mt76u_alloc_queues(&dev->mt76);
+	ret = mt76u_mcu_init_rx(&dev->mt76);
 	if (ret < 0)
 		goto err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 7a9ebc8985f2..9ba029451f8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -264,14 +264,14 @@ int mt76x2u_register_device(struct mt76x2_dev *dev)
 	if (err < 0)
 		return err;
 
-	err = mt76u_mcu_init_rx(&dev->mt76);
-	if (err < 0)
-		return err;
-
 	err = mt76u_alloc_queues(&dev->mt76);
 	if (err < 0)
 		goto fail;
 
+	err = mt76u_mcu_init_rx(&dev->mt76);
+	if (err < 0)
+		return err;
+
 	err = mt76x2u_init_hardware(dev);
 	if (err < 0)
 		goto fail;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 03dee4762c69..de7785c4f6af 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -280,6 +280,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 	struct urb *urb = buf->urb;
 	int i;
 
+	spin_lock_bh(&q->rx_page_lock);
 	for (i = 0; i < nsgs; i++) {
 		struct page *page;
 		void *data;
@@ -293,6 +294,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		offset = data - page_address(page);
 		sg_set_page(&urb->sg[i], page, sglen, offset);
 	}
+	spin_unlock_bh(&q->rx_page_lock);
 
 	if (i < nsgs) {
 		int j;
@@ -521,6 +523,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	int i, err, nsgs;
 
+	spin_lock_init(&q->rx_page_lock);
 	spin_lock_init(&q->lock);
 	q->entry = devm_kzalloc(dev->dev,
 				MT_NUM_RX_ENTRIES * sizeof(*q->entry),
@@ -558,12 +561,15 @@ static void mt76u_free_rx(struct mt76_dev *dev)
 	for (i = 0; i < q->ndesc; i++)
 		mt76u_buf_free(&q->entry[i].ubuf);
 
+	spin_lock_bh(&q->rx_page_lock);
 	if (!q->rx_page.va)
-		return;
+		goto out;
 
 	page = virt_to_page(q->rx_page.va);
 	__page_frag_cache_drain(page, q->rx_page.pagecnt_bias);
 	memset(&q->rx_page, 0, sizeof(q->rx_page));
+out:
+	spin_unlock_bh(&q->rx_page_lock);
 }
 
 static void mt76u_stop_rx(struct mt76_dev *dev)
-- 
2.17.1

