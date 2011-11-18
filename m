Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1KRIVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:08 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8L81j022542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:08 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/77] iwlegacy: remove IL_CRIT
Date: Fri, 18 Nov 2011 09:21:31 +0100
Message-Id: <1321604559-10707-9-git-send-email-sgruszka@redhat.com> (sfid-20111118_092117_853426_32475D61)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |    2 +-
 drivers/net/wireless/iwlegacy/iwl-debug.h    |    1 -
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index f4df28d..6503b8f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -309,7 +309,7 @@ static void il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
-				IL_CRIT(
+				IL_ERR(
 					"Failed to alloc_pages with %s. "
 					"Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index 373188d..77467de 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -35,7 +35,6 @@ extern u32 il_debug_level;
 #define IL_ERR(f, a...) dev_err(&il->pci_dev->dev, f, ## a)
 #define IL_WARN(f, a...) dev_warn(&il->pci_dev->dev, f, ## a)
 #define IL_INFO(f, a...) dev_info(&il->pci_dev->dev, f, ## a)
-#define IL_CRIT(f, a...) dev_crit(&il->pci_dev->dev, f, ## a)
 
 #define il_print_hex_error(il, p, len)					\
 do {									\
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 8a6b193..66aa850 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -1043,7 +1043,7 @@ static void il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 				D_INFO("Failed to allocate SKB buffer.\n");
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
-				IL_CRIT("Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
+				IL_ERR("Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
 					 rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
-- 
1.7.1

