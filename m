Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42715 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1KQAp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 19:45:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] compat: avoid warning in compat_system_workqueue_create
Date: Wed, 16 Nov 2011 19:39:33 -0500
Message-Id: <1321490374-24529-1-git-send-email-linville@tuxdriver.com> (sfid-20111117_014556_510646_1E85477F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check in the WARN_ON is inverted.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 compat/compat-2.6.36.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index aab25df..fe24da8 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(system_nrt_wq);
 void compat_system_workqueue_create()
 {
 	system_nrt_wq = create_singlethread_workqueue("events_nrt");
-	WARN_ON(system_nrt_wq);
+	WARN_ON(!system_nrt_wq);
 }
 
 void compat_system_workqueue_destroy()
-- 
1.7.4.4

