Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33798 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbcAOXtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 18:49:04 -0500
Received: by mail-lb0-f173.google.com with SMTP id cl12so105492220lbc.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2016 15:49:03 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: support chipsets with PMU and GCI cores (devices)
Date: Sat, 16 Jan 2016 00:48:53 +0100
Message-Id: <1452901733-22271-2-git-send-email-zajec5@gmail.com> (sfid-20160116_004909_565629_EFCA0E9D)
In-Reply-To: <1452901733-22271-1-git-send-email-zajec5@gmail.com>
References: <1452901733-22271-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both cores are another exceptions. They are not accessed in a standard
way and to they don't need or have wrapping addresses.
This fixes bus scanning after finding such core.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 5ee7311..4a2d1b2 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -318,6 +318,8 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		switch (core->id.id) {
 		case BCMA_CORE_4706_MAC_GBIT_COMMON:
 		case BCMA_CORE_NS_CHIPCOMMON_B:
+		case BCMA_CORE_PMU:
+		case BCMA_CORE_GCI:
 		/* Not used yet: case BCMA_CORE_OOB_ROUTER: */
 			break;
 		default:
-- 
1.8.4.5

