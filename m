Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15956C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 11:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D531D21900
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 11:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/Q1OLkV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfBALFj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 06:05:39 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38518 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfBALFj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 06:05:39 -0500
Received: by mail-pf1-f196.google.com with SMTP id q1so3034722pfi.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 03:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3jeB5pycDca4dLQJwbVreY4Ufzz8oqr/oHnmNtgabIU=;
        b=J/Q1OLkVPapoozrAPO+CLh1LzS21+6F0rM7pZfl2S8cTxSvNwvWc36IvJxD5HmmAPZ
         g9xQ9W6/BQ//0b2e8fHH0xVMk06+wWqZp2aVt314EVbh60RX4rr0GCuhKELUCpTi2+ok
         1XsZajAeopD+hX3QcKn20MrWWUP7Aq2NUrewHddhUDXEb3S+WlUKbfhJe6y9qzXcZJah
         xRl4uEvEd0LNmDOWjRuMS782ATBBxwrFHISsZAssbyN0ni4AAxeYBENufoDSad/9TDRc
         t4x0LG3jNXq4UHyjKJNnjsfQ57CcWl5uDNeUtKgy1W/MmxnzcY/ozH9LJnonXgJqDhnI
         8ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3jeB5pycDca4dLQJwbVreY4Ufzz8oqr/oHnmNtgabIU=;
        b=XL8qcKDbCP5/WHeSxZ+JLa9dJ02BgqUu091JLRuWDBcFTC31zW/zkb6gP/p10d2lKx
         Gw2mk1tXjfj3MeyxYz7Cz8UUN449vxKIPRrCzcMWmWGaJmNAaHxe+DzjO4u8U05TU8FR
         yG/uhX/Rpx/LUueP1bQLD+kuc2EGIIiQNFWBQeBGZt8Mmv7KcG3Vp9c/jZ9hcD1EaXCA
         xPPxxQk37a68ns0QOOYm6L50FoyM4Q4wQfauNtrr94fOnBoyVBMyqZIHoM+459RYBByt
         3nWO1IhEZv7afIOzK1kKGwF8z8QVyOvG1K933mTn57NryKNEtm3Km5tgd/vMEgYv31ac
         L8ug==
X-Gm-Message-State: AHQUAuZgC7sbHkPt8a7HZA6LIGYnNko0nAG38TYBc2+mPGqH7Hny/U9O
        M9ugDuSrJTmKQHZnSoRKM26QEFVMy1Y=
X-Google-Smtp-Source: AHgI3IZzyN9S9dFUT4orU+eb5ssfsRAqOC9SacymwpQrLZacvWLOQh8ytu+xpfNPDeMa/Fmu4/gw4Q==
X-Received: by 2002:a63:4f5e:: with SMTP id p30mr1801448pgl.71.1549019138762;
        Fri, 01 Feb 2019 03:05:38 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id t21sm8088903pgg.24.2019.02.01.03.05.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Feb 2019 03:05:38 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [v2] MAINTAINERS: add entry for redpine wireless driver
Date:   Fri,  1 Feb 2019 16:35:20 +0530
Message-Id: <1549019120-9376-1-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Create an entry for Redpine wireless driver and add Amit and myself as
maintainers.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
changes in v2: Keep entry in alphabetical order [Kvalo]
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 32d44447..1043125 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12864,6 +12864,13 @@ F:	Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
 F:	drivers/net/dsa/realtek-smi*
 F:	drivers/net/dsa/rtl83*
 
+REDPINE WIRELESS DRIVER
+M:	Amitkumar Karwar <amitkarwar@gmail.com>
+M:	Siva Rebbagondla <siva8118@gmail.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/rsi/
+
 REGISTER MAP ABSTRACTION
 M:	Mark Brown <broonie@kernel.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.5.5

