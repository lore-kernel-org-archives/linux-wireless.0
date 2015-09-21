Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33025 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbbIUHrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 03:47:33 -0400
Received: by lbbvu2 with SMTP id vu2so46715190lbb.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 00:47:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] ssb: unexport ssb_bus_pcibus_register
Date: Mon, 21 Sep 2015 09:47:18 +0200
Message-Id: <1442821640-14582-1-git-send-email-zajec5@gmail.com> (sfid-20150921_094737_004048_85FA6BDB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It isn't used anywhere out of ssb code and we don't (plan to) build
pcihost_wrapper.c as a separated module.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index a48a743..8cf23a2 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -876,7 +876,6 @@ int ssb_bus_pcibus_register(struct ssb_bus *bus, struct pci_dev *host_pci)
 
 	return err;
 }
-EXPORT_SYMBOL(ssb_bus_pcibus_register);
 #endif /* CONFIG_SSB_PCIHOST */
 
 #ifdef CONFIG_SSB_PCMCIAHOST
-- 
1.8.4.5

