Return-Path: <SRS0=kXDB=22=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28631C33C8C
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF124215A4
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578226954;
	bh=6uXMwNokyj+aFN4iwBL8z+AHoKtNdrs6oFdd3beYa4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=L/KyWuG3BkBmGy334bFZuaBKGth2mQW0orGy6lL6jXzR1xtTidqkvbSYwmqa85cRP
	 s9U5j4FIXlE5CayvfqUi5ApUWPTa4LBngGIsNdA9hCFswBsV0bAnWfRvxmHXagl11j
	 IqOCu7TXMqeDfhvVKd028J2tdYnYQm5s87xbLYDQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgAEMWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 5 Jan 2020 07:22:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAEMWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Jan 2020 07:22:20 -0500
Received: from new-host-5.station (net-2-42-61-77.cust.vodafonedsl.it [2.42.61.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 114CD217F4;
        Sun,  5 Jan 2020 12:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578226939;
        bh=6uXMwNokyj+aFN4iwBL8z+AHoKtNdrs6oFdd3beYa4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GCPPmIKVX2HUj52/BU8Y0s5bWPQgrm88et84GrV2/S/E3wyi4W4aA78o32rlH4rI
         y+LmyYKoRjHU1Zj7J1qBzqUC9NlB+fOTlXtu7Elz7csyZVqql3CwJFIQClUFC3J03b
         UwaQCLCz2lNkQFdH+/o8ok5IOWGkdF4mN4tbWiR0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH v2 01/18] mt76: mt76u: check tx_status_data pointer in mt76u_tx_tasklet
Date:   Sun,  5 Jan 2020 13:21:39 +0100
Message-Id: <abcddd40dcf003980e1d095d6cbd40b22ac98a43.1578226544.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1578226544.git.lorenzo@kernel.org>
References: <cover.1578226544.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

New devices (e.g. mt7663u) do not rely on stats workqueue to load tx
statistics but will be reported by the firmware. Check tx_status_data
pointer in mt76u_tx_tasklet in order to reuse tx tasklet for new devices

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 22dacf040123..fbc4c0bb0102 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -708,7 +708,8 @@ static void mt76u_tx_tasklet(unsigned long data)
 
 		mt76_txq_schedule(&dev->phy, i);
 
-		if (!test_and_set_bit(MT76_READING_STATS, &dev->phy.state))
+		if (dev->drv->tx_status_data &&
+		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state))
 			queue_work(dev->usb.stat_wq, &dev->usb.stat_work);
 		if (wake)
 			ieee80211_wake_queue(dev->hw, i);
-- 
2.21.1

