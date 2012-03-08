Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab2CHMQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 07:16:24 -0500
Date: Thu, 8 Mar 2012 13:16:01 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwl3945: fix possible il->txq NULL pointer dereference in
 delayed works
Message-ID: <20120308121555.GA14296@redhat.com> (sfid-20120308_131629_354731_334AD20C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On il3945_down procedure we free tx queue data and nullify il->txq
pointer. After that we drop mutex and then cancel delayed works. There
is possibility, that after drooping mutex and before the cancel, some
delayed work will start and crash while trying to send commands to
the device. For example, here is reported crash in
il3945_bg_reg_txpower_periodic():
https://bugzilla.kernel.org/show_bug.cgi?id=42766#c10

Patch fix problem by adding il->txq check on works that send commands,
hence utilize tx queue.

Reported-by: Clemens Eisserer <linuxhippy@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 +-
 drivers/net/wireless/iwlegacy/3945.c     |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 0ccc934..0c12093 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2466,7 +2466,7 @@ il3945_bg_alive_start(struct work_struct *data)
 	    container_of(data, struct il_priv, alive_start.work);
 
 	mutex_lock(&il->mutex);
-	if (test_bit(S_EXIT_PENDING, &il->status))
+	if (test_bit(S_EXIT_PENDING, &il->status) || il->txq == NULL)
 		goto out;
 
 	il3945_alive_start(il);
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 456f32d..c5b1d19 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -1855,11 +1855,12 @@ il3945_bg_reg_txpower_periodic(struct work_struct *work)
 	struct il_priv *il = container_of(work, struct il_priv,
 					  _3945.thermal_periodic.work);
 
-	if (test_bit(S_EXIT_PENDING, &il->status))
-		return;
-
 	mutex_lock(&il->mutex);
+	if (test_bit(S_EXIT_PENDING, &il->status) || il->txq == NULL)
+		goto out;
+
 	il3945_reg_txpower_periodic(il);
+out:
 	mutex_unlock(&il->mutex);
 }
 
-- 
1.7.1

