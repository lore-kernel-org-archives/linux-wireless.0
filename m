Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41009 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3ITJAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 05:00:36 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so468759pad.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Sep 2013 02:00:35 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-nfc@lists.01.org
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sachin.kamat@linaro.org
Subject: [PATCH 2/2] NFC: pn533: Staticize local symbols
Date: Fri, 20 Sep 2013 14:30:41 +0530
Message-Id: <1379667641-31149-2-git-send-email-sachin.kamat@linaro.org> (sfid-20130920_110038_777267_DE810D91)
In-Reply-To: <1379667641-31149-1-git-send-email-sachin.kamat@linaro.org>
References: <1379667641-31149-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Local symbols used only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/nfc/pn533.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 5df730b..9f12a75 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2793,12 +2793,12 @@ static int pn533_rf_field(struct nfc_dev *nfc_dev, u8 rf)
 	return rc;
 }
 
-int pn533_dev_up(struct nfc_dev *nfc_dev)
+static int pn533_dev_up(struct nfc_dev *nfc_dev)
 {
 	return pn533_rf_field(nfc_dev, 1);
 }
 
-int pn533_dev_down(struct nfc_dev *nfc_dev)
+static int pn533_dev_down(struct nfc_dev *nfc_dev)
 {
 	return pn533_rf_field(nfc_dev, 0);
 }
-- 
1.7.9.5

