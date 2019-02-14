Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9D9C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6871121872
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsFcuvr6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503028AbfBNT7p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 14:59:45 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46856 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405940AbfBNT7n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 14:59:43 -0500
Received: by mail-ot1-f68.google.com with SMTP id w25so12575068otm.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 11:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yUtB5YISbd8yGyB4ucoTUjtkX4oW39+5zlgrBsGO5Qo=;
        b=lsFcuvr6r4s9F2LdzscDf3xRdf5R33MeKZG/m1ve+YTQEbDtuwMHGZvoVSH+AT6BvH
         M9sBVnzNGxH5F7GEFVdOkXR16vkBwvxWq0g2eTC5TjqS6zzUD09KSiMSWOk5EkslFhxk
         uOrojPBhbACksYJ16jnf577S6/h/63+tWx/ZIqHC8r3p8O6CzXeDmzQzNhFh+IoH7rp/
         p89giWPQMRiOpGXjn4sdpUw4n0CEFZvvGlbhH6ricKp/pTAmqjuIfrGDmJAlNzp3o9Eo
         maL5gQMR8+iWYEm/nWedF4uqrCZMlHK/nURv2qJMLsf35HId0PGdaW5tNdC0zN7QtI8a
         C/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=yUtB5YISbd8yGyB4ucoTUjtkX4oW39+5zlgrBsGO5Qo=;
        b=TW/Hju8yl3j++k6MpjQkpoiDm9sdK+Iu0/GoscoANklqwO/8meW4dpBWWCscAdHEZj
         b1woqKDT21FjTOX4RIBZWnZFVcHkhKTX3Ti7uG2WwrWeQCUZ+OvbppPHkcsN+ZKp98nQ
         Eg8i8VQN5BLPA9OcfLGrDsmdbAktTxzdQidG/0gtH3SMWYBld9mFZju0eBF8AYD8akMI
         ReNOM8xSjjkT5ub6IEMhdJ8xvVcTfoEJAuH5n0mfUJ2dWwoVBpmjwcT234u6rccZa4Ly
         4UJ+2pMeOw0Dh+Pu0mF3/BmpCoC4rnqbH+ryGC/tKvhpXBTo+NkynYgH0fSpOQ395l3Z
         uniQ==
X-Gm-Message-State: AHQUAuYS8AhXoIiF754z07Uu9dwxycd+BJLlV79ulKRbP7IIWQlh+DVn
        y7LZ0UU5dKXuntrBODGcOJQ=
X-Google-Smtp-Source: AHgI3IaKl1a8jFqIVcLg+xgNapgv0i5bQHwQVM/c4qtACjxHJZaBI38ZEzAqvlliDX9281R/HJUI0g==
X-Received: by 2002:aca:32c3:: with SMTP id y186mr3390466oiy.118.1550174382692;
        Thu, 14 Feb 2019 11:59:42 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v20sm873519oto.31.2019.02.14.11.59.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 11:59:42 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v3 12/13] rtlwifi: rtl8723_common: Replace old-style license information
Date:   Thu, 14 Feb 2019 13:59:19 -0600
Message-Id: <20190214195920.1504-13-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214195920.1504-1-Larry.Finger@lwfinger.net>
References: <20190214195920.1504-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The traditional license information is replaced by the SPDX form. There
are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
v2 - C++ comment style used for SPDX line in .c files, and GPL 2.0+ changed to 2.0.
v3 - Removed extraneous / following SPDX
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
+// SPDX-License-Identifier: GPL-2.0
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
+// SPDX-License-Identifier: GPL-2.0
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
+// SPDX-License-Identifier: GPL-2.0
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
+// SPDX-License-Identifier: GPL-2.0
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

