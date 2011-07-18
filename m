Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41224 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1GQXW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 19:22:56 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so5569858fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 16:22:56 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: bcma: define 80211 core specific IO status bits
Date: Mon, 18 Jul 2011 02:01:29 +0200
Message-Id: <1310947290-3099-2-git-send-email-zajec5@gmail.com> (sfid-20110718_012259_871706_4A7F9A48)
In-Reply-To: <1310947290-3099-1-git-send-email-zajec5@gmail.com>
References: <1310947290-3099-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 08a2827..8cf0459 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -433,6 +433,12 @@ enum {
 #define  B43_BCMA_IOCTL_PHY_BW_40MHZ	0x00000080	/* 40 MHz bandwidth, 160 MHz PHY */
 #define B43_BCMA_IOCTL_GMODE		0x00002000	/* G Mode Enable */
 
+/* BCMA 802.11 core specific IO status (BCMA_IOST) flags */
+#define B43_BCMA_IOST_2G_PHY		0x00000001	/* 2.4G capable phy */
+#define B43_BCMA_IOST_5G_PHY		0x00000002	/* 5G capable phy */
+#define B43_BCMA_IOST_FASTCLKA		0x00000004	/* Fast Clock Available */
+#define B43_BCMA_IOST_DUALB_PHY		0x00000008	/* Dualband phy */
+
 /* 802.11 core specific TM State Low (SSB_TMSLOW) flags */
 #define B43_TMSLOW_GMODE		0x20000000	/* G Mode Enable */
 #define B43_TMSLOW_PHY_BANDWIDTH	0x00C00000	/* PHY band width and clock speed mask (N-PHY only) */
-- 
1.7.3.4

