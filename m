Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2FFKIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:13 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 26/29] NFC: Destroy LLCP timout workqueue when releasing the link
Date: Wed,  6 Jun 2012 12:16:43 +0200
Message-Id: <1338977806-30279-27-git-send-email-sameo@linux.intel.com> (sfid-20120606_120821_287981_EA69A7EF)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 3fe68e1..5d503ee 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -111,6 +111,7 @@ static void local_release(struct kref *ref)
 	skb_queue_purge(&local->tx_queue);
 	destroy_workqueue(local->tx_wq);
 	destroy_workqueue(local->rx_wq);
+	destroy_workqueue(local->timeout_wq);
 	kfree_skb(local->rx_pending);
 	kfree(local);
 }
-- 
1.7.9.1

