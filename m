Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:56724 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388302AbeGXKAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 06:00:17 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v2 10/10] NFC: st95hf: add of match table
Date: Tue, 24 Jul 2018 10:54:26 +0200
Message-Id: <20180724085426.23999-11-daniel@zonque.org> (sfid-20180724_105458_830537_7DFA683D)
In-Reply-To: <20180724085426.23999-1-daniel@zonque.org>
References: <20180724085426.23999-1-daniel@zonque.org>
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
index 4db3c020921c..5a01b454fbc4 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -1012,6 +1012,12 @@ static const struct spi_device_id st95hf_id[] = {
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
@@ -1189,6 +1195,7 @@ static struct spi_driver st95hf_driver = {
 	.driver = {
 		.name = "st95hf",
 		.owner = THIS_MODULE,
+		.of_match_table = st95hf_of_match,
 	},
 	.id_table = st95hf_id,
 	.probe = st95hf_probe,
-- 
2.17.1
