Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17207 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab2FFKGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:55 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 06/29] NFC: Export LLCP general bytes getter
Date: Wed,  6 Jun 2012 12:16:23 +0200
Message-Id: <1338977806-30279-7-git-send-email-sameo@linux.intel.com> (sfid-20120606_120658_121234_FF5CBD5E)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    1 +
 net/nfc/core.c        |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index b7ca4a2..3116f92 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -188,6 +188,7 @@ struct sk_buff *nfc_alloc_recv_skb(unsigned int size, gfp_t gfp);
 
 int nfc_set_remote_general_bytes(struct nfc_dev *dev,
 				 u8 *gt, u8 gt_len);
+u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, size_t *gb_len);
 
 int nfc_targets_found(struct nfc_dev *dev,
 		      struct nfc_target *targets, int ntargets);
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 9f6ce01..f5a43f7 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -447,6 +447,14 @@ int nfc_set_remote_general_bytes(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 }
 EXPORT_SYMBOL(nfc_set_remote_general_bytes);
 
+u8 *nfc_get_local_general_bytes(struct nfc_dev *dev, size_t *gb_len)
+{
+	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
+
+	return nfc_llcp_general_bytes(dev, gb_len);
+}
+EXPORT_SYMBOL(nfc_get_local_general_bytes);
+
 /**
  * nfc_alloc_send_skb - allocate a skb for data exchange responses
  *
-- 
1.7.9.1

