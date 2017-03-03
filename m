Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36415 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdCCKel (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 05:34:41 -0500
Received: by mail-lf0-f66.google.com with SMTP id g70so6713013lfh.3
        for <linux-wireless@vger.kernel.org>; Fri, 03 Mar 2017 02:34:25 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.12 2/2] bcma: fill core OF info independently of bus type
Date: Fri,  3 Mar 2017 11:34:15 +0100
Message-Id: <20170303103415.5188-2-zajec5@gmail.com> (sfid-20170303_113738_531718_CB161101)
In-Reply-To: <20170303103415.5188-1-zajec5@gmail.com>
References: <20170303103415.5188-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

PCI devices can be described in DT as well so we should always execute
relevant code. This will make bcma e.g. set of_node for cores described
in DT.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/bcma/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 4f88821c1b2a..2da7fe1d20a7 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -243,6 +243,8 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
 	core->dev.parent = bcma_bus_get_host_dev(bus);
+	if (core->dev.parent)
+		bcma_of_fill_device(core->dev.parent, core);
 
 	switch (bus->hosttype) {
 	case BCMA_HOSTTYPE_PCI:
@@ -252,8 +254,6 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 	case BCMA_HOSTTYPE_SOC:
 		if (IS_ENABLED(CONFIG_OF) && bus->host_pdev) {
 			core->dma_dev = &bus->host_pdev->dev;
-			if (core->dev.parent)
-				bcma_of_fill_device(core->dev.parent, core);
 		} else {
 			core->dev.dma_mask = &core->dev.coherent_dma_mask;
 			core->dma_dev = &core->dev;
-- 
2.11.0
