Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:38887 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbbJKLfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2015 07:35:09 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	Charles Gorand <charles.gorand@effinnov.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: nxp-nci: constify nxp_nci_phy_ops structure
Date: Sun, 11 Oct 2015 13:24:13 +0200
Message-Id: <1444562653-4914-1-git-send-email-Julia.Lawall@lip6.fr> (sfid-20151011_133513_579952_FED63C92)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only instance of a nxp_nci_phy_ops structure is never modified.  Thus
the declaration of the structure and all references to the structure type
can be made const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/nfc/nxp-nci/core.c    |    3 ++-
 drivers/nfc/nxp-nci/i2c.c     |    2 +-
 drivers/nfc/nxp-nci/nxp-nci.h |    5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index fac80c6..df4333c 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -106,7 +106,7 @@ static int nxp_nci_i2c_write(void *phy_id, struct sk_buff *skb)
 	return r;
 }
 
-static struct nxp_nci_phy_ops i2c_phy_ops = {
+static const struct nxp_nci_phy_ops i2c_phy_ops = {
 	.set_mode = nxp_nci_i2c_set_mode,
 	.write = nxp_nci_i2c_write,
 };
diff --git a/drivers/nfc/nxp-nci/nxp-nci.h b/drivers/nfc/nxp-nci/nxp-nci.h
index f1fecc4..20408cb 100644
--- a/drivers/nfc/nxp-nci/nxp-nci.h
+++ b/drivers/nfc/nxp-nci/nxp-nci.h
@@ -68,7 +68,7 @@ struct nxp_nci_info {
 
 	enum nxp_nci_mode mode;
 
-	struct nxp_nci_phy_ops *phy_ops;
+	const struct nxp_nci_phy_ops *phy_ops;
 	unsigned int max_payload;
 
 	struct mutex info_lock;
@@ -82,7 +82,8 @@ void nxp_nci_fw_recv_frame(struct nci_dev *ndev, struct sk_buff *skb);
 void nxp_nci_fw_work_complete(struct nxp_nci_info *info, int result);
 
 int nxp_nci_probe(void *phy_id, struct device *pdev,
-		  struct nxp_nci_phy_ops *phy_ops, unsigned int max_payload,
+		  const struct nxp_nci_phy_ops *phy_ops,
+		  unsigned int max_payload,
 		  struct nci_dev **ndev);
 void nxp_nci_remove(struct nci_dev *ndev);
 
diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index 8979636..2e4b004 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -109,7 +109,8 @@ static struct nci_ops nxp_nci_ops = {
 };
 
 int nxp_nci_probe(void *phy_id, struct device *pdev,
-		  struct nxp_nci_phy_ops *phy_ops, unsigned int max_payload,
+		  const struct nxp_nci_phy_ops *phy_ops,
+		  unsigned int max_payload,
 		  struct nci_dev **ndev)
 {
 	struct nxp_nci_info *info;

