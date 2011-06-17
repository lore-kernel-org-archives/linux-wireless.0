Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42583 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab1FQKhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 06:37:15 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so459904ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 03:37:14 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: fix BCM43224 rev 0 workaround
Date: Fri, 17 Jun 2011 13:15:24 +0200
Message-Id: <1308309324-8680-2-git-send-email-zajec5@gmail.com> (sfid-20110617_123721_465271_7BA3BDA1)
In-Reply-To: <1308309324-8680-1-git-send-email-zajec5@gmail.com>
References: <1308309324-8680-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 934b7ed..dd5846b 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -98,7 +98,7 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		if (bus->chipinfo.rev == 0) {
 			pr_err("Workarounds for 43224 rev 0 not fully "
 				"implemented\n");
-			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
+			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x00F000F0);
 		} else {
 			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
 		}
-- 
1.7.3.4

