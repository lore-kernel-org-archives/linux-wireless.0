Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57667
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbbKMMQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 07:16:21 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: kernel-janitors@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: s3fwrn5: constify s3fwrn5_phy_ops structures
Date: Fri, 13 Nov 2015 13:04:41 +0100
Message-Id: <1447416281-3357-1-git-send-email-Julia.Lawall@lip6.fr> (sfid-20151113_131634_176031_47A30CDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The s3fwrn5_phy_ops structure is never modified, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/nfc/s3fwrn5/core.c    |    2 +-
 drivers/nfc/s3fwrn5/i2c.c     |    2 +-
 drivers/nfc/s3fwrn5/s3fwrn5.h |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index 0d866ca..9d9c8d5 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -147,7 +147,7 @@ static struct nci_ops s3fwrn5_nci_ops = {
 };
 
 int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
-	struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload)
+	const struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload)
 {
 	struct s3fwrn5_info *info;
 	int ret;
diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index c61d8a3..3ed0adf 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -125,7 +125,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
 	return 0;
 }
 
-static struct s3fwrn5_phy_ops i2c_phy_ops = {
+static const struct s3fwrn5_phy_ops i2c_phy_ops = {
 	.set_wake = s3fwrn5_i2c_set_wake,
 	.set_mode = s3fwrn5_i2c_set_mode,
 	.get_mode = s3fwrn5_i2c_get_mode,
diff --git a/drivers/nfc/s3fwrn5/s3fwrn5.h b/drivers/nfc/s3fwrn5/s3fwrn5.h
index 89210d4..7d5e516 100644
--- a/drivers/nfc/s3fwrn5/s3fwrn5.h
+++ b/drivers/nfc/s3fwrn5/s3fwrn5.h
@@ -44,7 +44,7 @@ struct s3fwrn5_info {
 	void *phy_id;
 	struct device *pdev;
 
-	struct s3fwrn5_phy_ops *phy_ops;
+	const struct s3fwrn5_phy_ops *phy_ops;
 	unsigned int max_payload;
 
 	struct s3fwrn5_fw_info fw_info;
@@ -90,7 +90,7 @@ static inline int s3fwrn5_write(struct s3fwrn5_info *info, struct sk_buff *skb)
 }
 
 int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
-	struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload);
+	const struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload);
 void s3fwrn5_remove(struct nci_dev *ndev);
 
 int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,

