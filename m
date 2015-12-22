Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:40919 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbbLVQTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 11:19:19 -0500
From: Geliang Tang <geliangtang@163.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] NFC: trf7970a: use to_spi_device
Date: Wed, 23 Dec 2015 00:18:42 +0800
Message-Id: <8847f1817f2c8d91a93b65d87648a4e024b24190.1450800897.git.geliangtang@163.com> (sfid-20151222_171935_843156_FBB98FDE)
In-Reply-To: <a196696aefe502e775a025cdb662c39cbdabf412.1450800897.git.geliangtang@163.com>
References: <a196696aefe502e775a025cdb662c39cbdabf412.1450800897.git.geliangtang@163.com>
In-Reply-To: <a196696aefe502e775a025cdb662c39cbdabf412.1450800897.git.geliangtang@163.com>
References: <a196696aefe502e775a025cdb662c39cbdabf412.1450800897.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use to_spi_device() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/nfc/trf7970a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index f857feb..10842b7 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2139,7 +2139,7 @@ static int trf7970a_remove(struct spi_device *spi)
 #ifdef CONFIG_PM_SLEEP
 static int trf7970a_suspend(struct device *dev)
 {
-	struct spi_device *spi = container_of(dev, struct spi_device, dev);
+	struct spi_device *spi = to_spi_device(dev);
 	struct trf7970a *trf = spi_get_drvdata(spi);
 
 	dev_dbg(dev, "Suspend\n");
@@ -2155,7 +2155,7 @@ static int trf7970a_suspend(struct device *dev)
 
 static int trf7970a_resume(struct device *dev)
 {
-	struct spi_device *spi = container_of(dev, struct spi_device, dev);
+	struct spi_device *spi = to_spi_device(dev);
 	struct trf7970a *trf = spi_get_drvdata(spi);
 	int ret;
 
@@ -2174,7 +2174,7 @@ static int trf7970a_resume(struct device *dev)
 #ifdef CONFIG_PM
 static int trf7970a_pm_runtime_suspend(struct device *dev)
 {
-	struct spi_device *spi = container_of(dev, struct spi_device, dev);
+	struct spi_device *spi = to_spi_device(dev);
 	struct trf7970a *trf = spi_get_drvdata(spi);
 	int ret;
 
@@ -2191,7 +2191,7 @@ static int trf7970a_pm_runtime_suspend(struct device *dev)
 
 static int trf7970a_pm_runtime_resume(struct device *dev)
 {
-	struct spi_device *spi = container_of(dev, struct spi_device, dev);
+	struct spi_device *spi = to_spi_device(dev);
 	struct trf7970a *trf = spi_get_drvdata(spi);
 	int ret;
 
-- 
2.5.0


