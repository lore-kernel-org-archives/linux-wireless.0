Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57212 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388516AbeGXLFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:51 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v3 11/11] NFC: st95hf: add of match table
Date: Tue, 24 Jul 2018 11:59:41 +0200
Message-Id: <20180724095941.25777-12-daniel@zonque.org> (sfid-20180724_120226_642930_8C050479)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a match table for device tree compatible strings. Interestingly, a
document describing the bindings already exists since a while, but users
currently rely on the implicit matching in the drivers core. Let's be
explicit and add a real match table.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Cc: devicetree@vger.kernel.org
---
 drivers/nfc/st95hf/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index ccb1f1456871..6161838fcf08 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -1027,6 +1027,12 @@ static const struct spi_device_id st95hf_id[] = {
 };
 MODULE_DEVICE_TABLE(spi, st95hf_id);
 
+static const struct of_device_id st95hf_of_match[] = {
+	{ .compatible = "st,st95hf", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, st95hf_of_match);
+
 static int st95hf_probe(struct spi_device *nfc_spi_dev)
 {
 	int ret;
@@ -1204,6 +1210,7 @@ static struct spi_driver st95hf_driver = {
 	.driver = {
 		.name = "st95hf",
 		.owner = THIS_MODULE,
+		.of_match_table = st95hf_of_match,
 	},
 	.id_table = st95hf_id,
 	.probe = st95hf_probe,
-- 
2.17.1
