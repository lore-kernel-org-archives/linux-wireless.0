Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58792 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbbHTHIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 03:08:41 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 17/18] NFC: trf7970a: Add OF match table
Date: Thu, 20 Aug 2015 09:07:30 +0200
Message-Id: <1440054451-1223-18-git-send-email-javier@osg.samsung.com> (sfid-20150820_090918_651833_9EACB558)
In-Reply-To: <1440054451-1223-1-git-send-email-javier@osg.samsung.com>
References: <1440054451-1223-1-git-send-email-javier@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Documentation/devicetree/bindings/net/nfc/trf7970a.txt DT binding doc
lists "ti,trf7970a" as a compatible string but the corresponding driver
does not have an OF match table. Add the table to the driver so the SPI
core can do an OF style match.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/nfc/trf7970a.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 85b4d86772d8..2021f2135445 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2209,6 +2209,12 @@ static const struct dev_pm_ops trf7970a_pm_ops = {
 			trf7970a_pm_runtime_resume, NULL)
 };
 
+static const struct of_device_id trf7970a_of_match[] = {
+	{ .compatible = "ti,trf7970a", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, trf7970a_of_match);
+
 static const struct spi_device_id trf7970a_id_table[] = {
 	{ "trf7970a", 0 },
 	{ }
@@ -2221,6 +2227,7 @@ static struct spi_driver trf7970a_spi_driver = {
 	.id_table	= trf7970a_id_table,
 	.driver		= {
 		.name	= "trf7970a",
+		.of_match_table = of_match_ptr(trf7970a_of_match),
 		.owner	= THIS_MODULE,
 		.pm	= &trf7970a_pm_ops,
 	},
-- 
2.4.3

