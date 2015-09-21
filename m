Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34222 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbbIUHzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 03:55:32 -0400
Received: by lahg1 with SMTP id g1so63026081lah.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 00:55:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: make ssb_pcmcia_switch_core static
Date: Mon, 21 Sep 2015 09:55:26 +0200
Message-Id: <1442822126-23372-1-git-send-email-zajec5@gmail.com> (sfid-20150921_095536_067099_7E55138E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pcmcia.c      | 3 +--
 drivers/ssb/ssb_private.h | 7 -------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index b413e01..f03422b 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -147,8 +147,7 @@ error:
 	return err;
 }
 
-int ssb_pcmcia_switch_core(struct ssb_bus *bus,
-			   struct ssb_device *dev)
+static int ssb_pcmcia_switch_core(struct ssb_bus *bus, struct ssb_device *dev)
 {
 	int err;
 
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 426c805..8a2ebc8 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -85,8 +85,6 @@ static inline int ssb_pci_init(struct ssb_bus *bus)
 
 /* pcmcia.c */
 #ifdef CONFIG_SSB_PCMCIAHOST
-extern int ssb_pcmcia_switch_core(struct ssb_bus *bus,
-				  struct ssb_device *dev);
 extern int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
 				     u8 coreidx);
 extern int ssb_pcmcia_switch_segment(struct ssb_bus *bus,
@@ -98,11 +96,6 @@ extern void ssb_pcmcia_exit(struct ssb_bus *bus);
 extern int ssb_pcmcia_init(struct ssb_bus *bus);
 extern const struct ssb_bus_ops ssb_pcmcia_ops;
 #else /* CONFIG_SSB_PCMCIAHOST */
-static inline int ssb_pcmcia_switch_core(struct ssb_bus *bus,
-					 struct ssb_device *dev)
-{
-	return 0;
-}
 static inline int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
 					    u8 coreidx)
 {
-- 
1.8.4.5

