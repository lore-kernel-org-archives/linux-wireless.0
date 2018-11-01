Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B257C6786F
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 10:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AD94205F4
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 10:03:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AD94205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbeKATFp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 15:05:45 -0400
Received: from smtp3-1.goneo.de ([85.220.129.38]:35258 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbeKATFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 15:05:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 581E723F83E;
        Thu,  1 Nov 2018 11:03:25 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RgZlqvnTZ_oD; Thu,  1 Nov 2018 11:03:24 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPA id 3263B23F486;
        Thu,  1 Nov 2018 11:03:24 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 3/6] nfc: pn533: Add dev_up/dev_down hooks to phy_ops
Date:   Thu,  1 Nov 2018 11:02:11 +0100
Message-Id: <20181101100216.613-3-poeschel@lemonage.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181101100216.613-1-poeschel@lemonage.de>
References: <20181101100216.613-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds hooks for dev_up and dev_down to the phy_ops. They are
optional.
The idea is to inform the phy driver when the nfc chip is really going
to be used. When it is not used, the phy driver can suspend it's
interface to the nfc chip to save some power. The nfc chip is considered
not in use before dev_up and after dev_down.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v4:
- This patch is new in v4

 drivers/nfc/pn533/pn533.c | 12 +++++++++++-
 drivers/nfc/pn533/pn533.h |  9 +++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a0cc1cc45292..f0c541152777 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2468,6 +2468,9 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 
+	if (dev->phy_ops)
+		dev->phy_ops->dev_up(dev);
+
 	if (dev->device_type == PN533_DEVICE_PN532) {
 		int rc = pn532_sam_configuration(nfc_dev);
 
@@ -2480,7 +2483,14 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 
 static int pn533_dev_down(struct nfc_dev *nfc_dev)
 {
-	return pn533_rf_field(nfc_dev, 0);
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+	int ret;
+
+	ret = pn533_rf_field(nfc_dev, 0);
+	if (dev->phy_ops && !ret)
+		dev->phy_ops->dev_down(dev);
+
+	return ret;
 }
 
 static struct nfc_ops pn533_nfc_ops = {
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 88d569666c51..eb5ccefc32e5 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -219,6 +219,15 @@ struct pn533_phy_ops {
 			  struct sk_buff *out);
 	int (*send_ack)(struct pn533 *dev, gfp_t flags);
 	void (*abort_cmd)(struct pn533 *priv, gfp_t flags);
+	/*
+	 * dev_up and dev_down are optional.
+	 * They are used to inform the phy layer that the nfc chip
+	 * is going to be really used very soon. The phy layer can then
+	 * bring up it's interface to the chip and have it suspended for power
+	 * saving reasons otherwise.
+	 */
+	void (*dev_up)(struct pn533 *priv);
+	void (*dev_down)(struct pn533 *priv);
 };
 
 
-- 
2.19.1

