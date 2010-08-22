Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from compulab.co.il ([67.18.134.219]:47009 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab0HVLXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 07:23:34 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, rusty@rustcorp.com.au,
	Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] libertas: if_sdio: fix buffer alignment in struct if_sdio_card
Date: Sun, 22 Aug 2010 14:22:40 +0300
Message-Id: <1282476160-6913-1-git-send-email-mike@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 886275ce41a9751117367fb387ed171049eb6148 (param: lock
if_sdio's lbs_helper_name and lbs_fw_name against sysfs changes)
introduced new fields into the if_sdio_card structure. It caused
missalignment of the if_sdio_card.buffer field and failure at driver
load time:

  ~# modprobe libertas_sdio
  [   62.315124] libertas_sdio: Libertas SDIO driver
  [   62.319976] libertas_sdio: Copyright Pierre Ossman
  [   63.020629] DMA misaligned error with device 48
  [   63.025207] mmci-omap-hs mmci-omap-hs.1: unexpected dma status 800
  [   66.005035] libertas: command 0x0003 timed out
  [   66.009826] libertas: Timeout submitting command 0x0003
  [   66.016296] libertas: PREP_CMD: command 0x0003 failed: -110

Adding explicit alignment attribute for the if_sdio_card.buffer field
fixes this problem.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/net/wireless/libertas/if_sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index ba854c7..87b6349 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -128,7 +128,7 @@ struct if_sdio_card {
 	bool			helper_allocated;
 	bool			firmware_allocated;
 
-	u8			buffer[65536];
+	u8			buffer[65536] __attribute__((aligned(4)));
 
 	spinlock_t		lock;
 	struct if_sdio_packet	*packets;
-- 
1.6.6.2

