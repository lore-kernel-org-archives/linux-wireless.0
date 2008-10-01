Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hevs.ch ([153.109.23.10]:54879 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYJAInm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 04:43:42 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
To: Dan Williams <dcbw@redhat.com>
Subject: [RFC, PATCH v2] libertas: unify request_firmware failure
Date: Wed, 1 Oct 2008 10:43:33 +0200
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
References: <200809301625.40554.marc.pignat@hevs.ch> <1222792480.27374.25.camel@localhost.localdomain>
In-Reply-To: <1222792480.27374.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810011043.34229.marc.pignat@hevs.ch> (sfid-20081001_104348_373289_2199E021)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use almost the same string for all interfaces (USB, compact flash and SDIO)
when request_firmware fails.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

Hi all!

This patch is an attemp to clarify the message "firmware not found, please fix
your userspace (== this is not a libertas bug)".

changes from v1:
	* replaced %#x with %d because "ret" is supposed to be a negative
	  integer (suggested by Dan Williams).

Best regards

Marc




patch agaisnt 2.6.27-rc7:

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 8941919..5f8e68b 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -553,7 +553,8 @@ static int if_cs_prog_helper(struct if_cs_card *card)
 	ret = request_firmware(&fw, "libertas_cs_helper.fw",
 		&handle_to_dev(card->p_dev));
 	if (ret) {
-		lbs_pr_err("can't load helper firmware\n");
+		lbs_pr_err("request_firmware() failed with %d\n", ret);
+		lbs_pr_err("helper firmware libertas_cs_helper.fw not found\n");
 		ret = -ENODEV;
 		goto done;
 	}
@@ -626,7 +627,8 @@ static int if_cs_prog_real(struct if_cs_card *card)
 	ret = request_firmware(&fw, "libertas_cs.fw",
 		&handle_to_dev(card->p_dev));
 	if (ret) {
-		lbs_pr_err("can't load firmware\n");
+		lbs_pr_err("request_firmware() failed with %d\n", ret);
+		lbs_pr_err("firmware libertas_cs.fw not found\n");
 		ret = -ENODEV;
 		goto done;
 	}
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index b54e2ea..319e211 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -396,7 +396,8 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 
 	ret = request_firmware(&fw, card->helper, &card->func->dev);
 	if (ret) {
-		lbs_pr_err("can't load helper firmware\n");
+		lbs_pr_err("request_firmware() failed with %d\n", ret);
+		lbs_pr_err("helper firmware %s not found\n", card->helper);
 		goto out;
 	}
 
@@ -512,7 +513,8 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 
 	ret = request_firmware(&fw, card->firmware, &card->func->dev);
 	if (ret) {
-		lbs_pr_err("can't load firmware\n");
+		lbs_pr_err("request_firmware() failed with %d\n", ret);
+		lbs_pr_err("firmware %s not found\n", card->firmware);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 632c291..285be43 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -819,7 +819,7 @@ static int if_usb_prog_firmware(struct if_usb_card *cardp)
 
 	if ((ret = request_firmware(&cardp->fw, lbs_fw_name,
 				    &cardp->udev->dev)) < 0) {
-		lbs_pr_err("request_firmware() failed with %#x\n", ret);
+		lbs_pr_err("request_firmware() failed with %d\n", ret);
 		lbs_pr_err("firmware %s not found\n", lbs_fw_name);
 		goto done;
 	}
