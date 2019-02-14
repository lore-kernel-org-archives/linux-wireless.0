Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFBFC10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5119222DA
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkOeg0K/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbfBNRBX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:01:23 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46564 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfBNRBV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 12:01:21 -0500
Received: by mail-ot1-f65.google.com with SMTP id w25so11595551otm.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 09:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zc43GYdIfnj6F38EUrBxIdN/URpN/YtV1CT+SZGunVE=;
        b=WkOeg0K/gE6ysUfFc43iWCrHYZI/uxaB5n000I2+EChDXlNG3NGeUfngJHOo0R+D/k
         E3F/8L5eV7k3HWtV5rmjpIvruQ0tm/1TwS3XFcnCwiMZOYtuzqzpIpFEyn9h7lCHvk5v
         VSiyZOaLC6A9ZetdJIP2OJG3Kk9/bkxi7NKuspaerIyt5P71fzVNPf5pYG1iZjBtVd2+
         hnWnbb4JsjDvkZd9PEoJic1XTK7+PntORsdtcqLNRkfZ/HizYRV8wnmuT1BiYmcJVLvX
         7WEDZQWFVHFZ4kNOU9MG19t22deA9kfXAcG0LbrsrGFIoKfOoXydYNE0Qq3q9bj8j8Px
         73nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Zc43GYdIfnj6F38EUrBxIdN/URpN/YtV1CT+SZGunVE=;
        b=HswyH6ddR6oxMQhYxjGc2xUSsCF+nu+iMbyFIAXWOMLPDLX3HA3vf2ioI1roqfAuCl
         PoCiR9GYzt/XuaiUEVKJ70stlXcQ3OW4KtSosu5C9ZTM+OG8nHCMJrsjigDJl/i047yo
         3KYEMt14RlfXTxIn/mmoqoViH96WkUqNvub3+GbjgO+dMdNa+iptUmPNFqZZv9nwyDwS
         Uawz498PSxL9eWtEObJCzh0SWTPCWxJxAUthX6LHx4LZyF4xFk2fOx6lbN3KZ3WXhmMu
         G38+Tu7FJwQUmXVYYerP3yTwk+jqGp5OUoGZ7WUDGyzQ1syA6wxdp5s/P5OEcDUdqiVM
         0a5Q==
X-Gm-Message-State: AHQUAub0SWb7yXw79E1slGBu3HBWJAMELUVrHB/nZdxP9mBDcahvBu0m
        jPmujOrzTlRFX02t35kjmTg=
X-Google-Smtp-Source: AHgI3Ibw0l1/CJgNdUYJ1q9L+wCyVw6dxXZcfolwblveNqRmtE0Teq7jxC127lQGcgXmVfpHL12pMg==
X-Received: by 2002:a05:6830:2005:: with SMTP id e5mr2998051otp.258.1550163680748;
        Thu, 14 Feb 2019 09:01:20 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l5sm1158327oil.15.2019.02.14.09.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 09:01:19 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 12/13] rtlwifi: rtl8723_common: Replace old-style license information
Date:   Thu, 14 Feb 2019 11:00:42 -0600
Message-Id: <20190214170043.3705-13-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190214170043.3705-1-Larry.Finger@lwfinger.net>
References: <20190214170043.3705-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The traditional license information is replaced by the SPDX form. There
are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
v2 - C++ comment style used for SPDX line in .c files, and GPL 2.0+ changed to 2.0.
---
 .../realtek/rtlwifi/rtl8723com/dm_common.c    | 26 ++-----------------
 .../realtek/rtlwifi/rtl8723com/dm_common.h    | 26 ++-----------------
 .../realtek/rtlwifi/rtl8723com/fw_common.c    | 26 ++-----------------
 .../realtek/rtlwifi/rtl8723com/fw_common.h    | 26 ++-----------------
 .../realtek/rtlwifi/rtl8723com/main.c         | 26 ++-----------------
 .../realtek/rtlwifi/rtl8723com/phy_common.c   | 26 ++-----------------
 .../realtek/rtlwifi/rtl8723com/phy_common.h   | 26 ++-----------------
 7 files changed, 14 insertions(+), 168 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.c
index 064340641913..ac5955577db7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2014  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "dm_common.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.h
index 5c1b94ce2f86..584954114253 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2014  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #ifndef __DM_COMMON_H__
 #define __DM_COMMON_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index 521039c5d4ce..9f35a9d3027d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2014  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
index 77c25a976233..91ee9fa73426 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2014  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #ifndef __FW_COMMON_H__
 #define __FW_COMMON_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/main.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/main.c
index 9014a94fac6a..0f62da7c3d77 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/main.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/main.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2014  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include <linux/module.h>
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
index 43d24e1ee5e6..0b93d4d09746 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2014  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "phy_common.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.h
index 83b891a9adb8..0c42ad379735 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2014  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #ifndef __PHY_COMMON__
 #define __PHY_COMMON__
-- 
2.20.1

