Return-Path: <SRS0=+Ljc=XP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D926C3A5A6
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Sep 2019 02:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279DA21924
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Sep 2019 02:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sjzl4RmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405315AbfITCZm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Sep 2019 22:25:42 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39868 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388199AbfITCZm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Sep 2019 22:25:42 -0400
Received: by mail-oi1-f194.google.com with SMTP id w144so490058oia.6
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2019 19:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTjwCGx2uilOM/mBRegFq/mkVZQbTmGgq3aj90/aKsU=;
        b=sjzl4RmYoz118SK13DsyOb54HsR9b4qzBtP/CK/sudbk89UKWFPhwRGZYQksTY2u3o
         P1bZL+3QWYd9cminQIJJ+QWi7iCmsldpwivdWraAZTH2phl+YsnwaHQSehAy5b5aTg/y
         hAcMiDcpFy+3om2BufNguSGTWiazx+fPK7HAXHCPVGRwfTRm3x5JyNapCX/AoNdPAM69
         v7QtHlEtmCDD9IRT34+O9bob8ZITxVrU5itgXam16ioHGzHeH+Gcd7rYfWuUhwP4zpTu
         iuZhUvRJKtS/1yoWC7RziajL9ZnK2t9n6csIP1OQjBphds8aa5osgR3TwMvvxVHx11yK
         C6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=fTjwCGx2uilOM/mBRegFq/mkVZQbTmGgq3aj90/aKsU=;
        b=D4VR5BMTM0wUjNNwE6EEjT/RyAFuBrogXTZNl4+J2dmBJT2qjRF2Bi3AapHL/cVTFD
         U2OOL6jcJ8VFArJRXkqqlG8f7t8Ib76Ge9zNLZtXCp9OFwYQSRfjhGzeKAlYlkhCWS2b
         9nIovWf8ud2/a7ART/hlU56xTMIyMf8D2CrmsubiKmhhN4jiNXlanKEfw8/IP32u3PW+
         kRGF0KjWgt30ljC68g12uQaVURHkbhRfAL9q4dz93dNU4aeR1qYdfl5Iz2Dhfb0pzu96
         FiLUz6iemv6yqoC+CNdW3qm5GzWb5+fkO7jGYxMJbvJ0OhIt6thTLFqLmFR9Jc8bUHlI
         axEw==
X-Gm-Message-State: APjAAAXFPL7gP3WBV+79gBcwNp6OCzuGJXkNrlyw7VA01J0WKINn9xKP
        XdIaGfVkScjqRyKUycC8Qfc=
X-Google-Smtp-Source: APXvYqzmIiFq0pSqvQc1JTd5H+iXbcx+HRZ8HSpyEpRWZe3I8NJ1gp7THgD7/EyfHp9LI/sHS+5qMw==
X-Received: by 2002:aca:c592:: with SMTP id v140mr1029934oif.92.1568946341300;
        Thu, 19 Sep 2019 19:25:41 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d194sm156757oib.47.2019.09.19.19.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 19:25:40 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: rtl_pci: Fix errors when CONFIG_RTLWIFI_DEBUG is not set
Date:   Thu, 19 Sep 2019 21:25:33 -0500
Message-Id: <20190920022533.23085-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When rtlwifi debugging is disabled, missing globals occur due to the
attempt execution of code that is never generated.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 6087ec7a90a6..2f8aad28f1c0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2298,8 +2298,10 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	}
 	rtlpriv->mac80211.mac80211_registered = 1;
 
+#ifdef CONFIG_RTLWIFI_DEBUG
 	/* add for debug */
 	rtl_debug_add_one(hw);
+#endif
 
 	/*init rfkill */
 	rtl_init_rfkill(hw);	/* Init PCI sw */
@@ -2349,8 +2351,10 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	clear_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 
+#ifdef CONFIG_RTLWIFI_DEBUG
 	/* remove form debug */
 	rtl_debug_remove_one(hw);
+#endif
 
 	/*ieee80211_unregister_hw will call ops_stop */
 	if (rtlmac->mac80211_registered == 1) {
-- 
2.23.0

