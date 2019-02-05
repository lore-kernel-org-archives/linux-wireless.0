Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FB7C282D7
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 16:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32D002080F
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 16:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8INj1l5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfBEQBW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 11:01:22 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:54808 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfBEQBW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 11:01:22 -0500
Received: by mail-it1-f193.google.com with SMTP id i145so9560476ita.4;
        Tue, 05 Feb 2019 08:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0gC8NlSJs+7zlaU+/3qAU9IlYl1p9D7dYB3zpo1O8G0=;
        b=b8INj1l5QFr3kZhOux9Wf41c3PcoHpBVhbET1R+T6GBPMtc21WUHhyoNofOtjG7drd
         QGs9qUH4oN8epgY41bhbPueXHuHn14d79P8C0a4MNmKQDut2t5GUcLs5VBkfLqhUztJ9
         5NesVDuhLna5uY0h3DmZybiVaGccE/r3VpNc5Y7XnyvW8mhZt0WRS2jbA6XYus6GUsDn
         RsHNgQqx3vDwaH5uNVzUCg731PClkhmrYvPam0Fq1z4Y0h6I/f8S5xwR9vrOGTaYK3yU
         proeNOQ1mNyx8lmUVvNTRO91gpj2JIEaBTc6YQw+N8ZFz9ZEiLJAC9Q/7dUeOrXKIEbM
         ykxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0gC8NlSJs+7zlaU+/3qAU9IlYl1p9D7dYB3zpo1O8G0=;
        b=OhDCEsnwVRIA3MVYtPPQ7bjSxEwyMTtO8mzi32nv+FhyCDgwxnGhs3ANOJnX0sXaaX
         sgf8EvKUfwqVmXe+Slwds92/SwnzLbwV/FWsSbowGPJsaRervu3mqJ12V56+U9t5h0gh
         EfgV2+M4RiBkL2O+phYyhtvajHPBwlvIQfoAecuS0yDrEplHqgX22rHHVOHkmEgomq4o
         p80pxeVfqsOLsvNkYCbYGJAOZx37vhA7ATvf/Trd56pMhKpimkwYlyN3xIyuNrr3BU4r
         CC3v40R3md5a+FUinNeqNONk1CsZgZCUGE8iO1Rxqz0FXqR9QZ9xbMSWSIlL7rjFt5jv
         Ju7g==
X-Gm-Message-State: AHQUAuaxSTlOMyc+s+7/6JLm5Us8TqDdc22j11uAgeTohyIGtvqlqjho
        JTNIsbvdVelR27zUzQWicfA=
X-Google-Smtp-Source: AHgI3Ib1lUeNWKlvEVKZHoqbNvPK2K2H+F773Y7uya2XV28rQscuMrxUmcmCpfpPfQX9f+Q1YIq1IA==
X-Received: by 2002:a02:6:: with SMTP id 6mr2910857jaa.19.1549382481635;
        Tue, 05 Feb 2019 08:01:21 -0800 (PST)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id a79sm1887447ita.11.2019.02.05.08.01.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 08:01:20 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@googlemail.com>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v1] NFC: port100: prevent use-after-free on disconnect
Date:   Tue,  5 Feb 2019 11:01:18 -0500
Message-Id: <20190205160118.27491-1-TheSven73@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Problem:
The cmd_complete_work work could potentially run after resources
are freed in disconnect(). This could cause user-after-free
issues.

Solution:
Reorder disconnect() calls, and explicitly cancel the work
using cancel_work_sync().

Signed-off-by: Sven Van Asbroeck <TheSven73@googlemail.com>
---

Samuel,

I'm unfamiliar with this driver, and I don't have the h/w, so I cannot test it.
This is just a suggestion on how to fix a potential issue.

Sven

 drivers/nfc/port100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index bb43cebda9dc..66d1bda9208c 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1630,19 +1630,19 @@ static void port100_disconnect(struct usb_interface *interface)
 	struct port100 *dev;
 
 	dev = usb_get_intfdata(interface);
-	usb_set_intfdata(interface, NULL);
 
 	nfc_digital_unregister_device(dev->nfc_digital_dev);
-	nfc_digital_free_device(dev->nfc_digital_dev);
-
 	usb_kill_urb(dev->in_urb);
 	usb_kill_urb(dev->out_urb);
 
+	cancel_work_sync(&dev->cmd_complete_work);
+
 	usb_free_urb(dev->in_urb);
 	usb_free_urb(dev->out_urb);
 	usb_put_dev(dev->udev);
-
+	nfc_digital_free_device(dev->nfc_digital_dev);
 	kfree(dev->cmd);
+	usb_set_intfdata(interface, NULL);
 
 	nfc_info(&interface->dev, "Sony Port-100 NFC device disconnected\n");
 }
-- 
2.17.1

