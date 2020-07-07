Return-Path: <SRS0=SX74=AS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98524C433E1
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Jul 2020 21:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735782075B
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Jul 2020 21:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594157249;
	bh=mGWKDK4WotVGiEVBdxvYCzz/axsRyrotAxxyi+xiu3s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=tVRDCWZuWLp2HOvQDKQk/nfUw8FVb1QnGuqmQcX3RIqz83GY4HnpemWGZtNEKShjW
	 SpDTP0ajpusHMtgOJKRnKlR1iYI5q/b6XdaxJ5uW/0IcUtS8YzhhWFfLPcBhfEZrVi
	 ZnumaVung/6rMZ5IAHGxl+Thvg9ODwEq6O+BmObo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgGGV12 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 Jul 2020 17:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbgGGV12 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Jul 2020 17:27:28 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1749820720;
        Tue,  7 Jul 2020 21:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594157248;
        bh=mGWKDK4WotVGiEVBdxvYCzz/axsRyrotAxxyi+xiu3s=;
        h=From:To:Cc:Subject:Date:From;
        b=LUR7nrlcXP18mcuoS4uySSwFCyM20VS0vvE/mqGp8DvBnw7pnsGBMt34RApjXMDfT
         KRh8Todn8bKGTaRL/vwRZiCd+wozfNYIe+OF0MPRkk9dDLY0ZrUr9Q1KiGMJP1vEuu
         lxoqSYP+7jYc7DvdfgCRMxmgNCEHjHGjvS9o2Chk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH] mt76: mt7615: reschedule ps work according to last activity
Date:   Tue,  7 Jul 2020 23:27:20 +0200
Message-Id: <23e07dd1296cf7f1e6dd00eed874e4f7336427ac.1594157044.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reschedule runtime-pm delayed work if there is a new activity when ps
delayed work is already scheduled

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index f0034e87c600..d75f4b1e05bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1932,13 +1932,21 @@ EXPORT_SYMBOL_GPL(mt7615_pm_power_save_sched);
 void mt7615_pm_power_save_work(struct work_struct *work)
 {
 	struct mt7615_dev *dev;
+	unsigned long delta;
 
 	dev = (struct mt7615_dev *)container_of(work, struct mt7615_dev,
 						pm.ps_work.work);
 
-	if (mt7615_firmware_own(dev))
-		queue_delayed_work(dev->mt76.wq, &dev->pm.ps_work,
-				   dev->pm.idle_timeout);
+	delta = dev->pm.idle_timeout;
+	if (time_is_after_jiffies(dev->pm.last_activity + delta)) {
+		delta = dev->pm.last_activity + delta - jiffies;
+		goto out;
+	}
+
+	if (!mt7615_firmware_own(dev))
+		return;
+out:
+	queue_delayed_work(dev->mt76.wq, &dev->pm.ps_work, delta);
 }
 
 static void
-- 
2.26.2

