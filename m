Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964911AbbJVJMe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 05:12:34 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Robert Dolca <robert.dolca@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v4 09/10] nfc: nci: add nci_get_conn_info_by_id function
Date: Thu, 22 Oct 2015 12:11:41 +0300
Message-Id: <1445505102-16639-10-git-send-email-robert.dolca@intel.com> (sfid-20151022_111324_964428_E3C63267)
In-Reply-To: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
References: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This functin takes as a parameter a pointer to the nci_dev struct and
the first byte from the values of the first domain specific parameter that
was used for the connection creation.

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 include/net/nfc/nci_core.h |  1 +
 net/nfc/nci/core.c         | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 5daf004..0569cb2 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -374,6 +374,7 @@ void nci_clear_target_list(struct nci_dev *ndev);
 void nci_req_complete(struct nci_dev *ndev, int result);
 struct nci_conn_info *nci_get_conn_info_by_conn_id(struct nci_dev *ndev,
 						   int conn_id);
+int nci_get_conn_info_by_id(struct nci_dev *ndev, u8 id);
 
 /* ----- NCI status code ----- */
 int nci_to_errno(__u8 code);
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 9d5f7a2..75bda34 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -64,6 +64,19 @@ struct nci_conn_info *nci_get_conn_info_by_conn_id(struct nci_dev *ndev,
 	return NULL;
 }
 
+int nci_get_conn_info_by_id(struct nci_dev *ndev, u8 id)
+{
+	struct nci_conn_info *conn_info;
+
+	list_for_each_entry(conn_info, &ndev->conn_info_list, list) {
+		if (conn_info->id == id)
+			return conn_info->conn_id;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(nci_get_conn_info_by_id);
+
 /* ---- NCI requests ---- */
 
 void nci_req_complete(struct nci_dev *ndev, int result)
-- 
1.9.1

