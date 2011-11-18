Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1KRIWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:42 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MgGA032444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:42 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 52/77] iwlegacy: move IL_MASK
Date: Fri, 18 Nov 2011 09:22:14 +0100
Message-Id: <1321604559-10707-52-git-send-email-sgruszka@redhat.com> (sfid-20111118_092247_244503_87EC7B1E)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c    |    2 ++
 drivers/net/wireless/iwlegacy/iwl-helpers.h |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2bab0fc..dbe5bf2 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4944,6 +4944,8 @@ static const s8 default_queue_to_tx_fifo[] = {
 	IL_TX_FIFO_UNUSED,
 };
 
+#define IL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
+
 static int il4965_alive_notify(struct il_priv *il)
 {
 	u32 a;
diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index eb5a287..2db83fc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -35,9 +35,6 @@
 
 #include "iwl-io.h"
 
-#define IL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
-
-
 /**
  * il_queue_inc_wrap - increment queue idx, wrap back to beginning
  * @idx -- current idx
-- 
1.7.1

