Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8187DC282D7
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503DE20855
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQM56vZ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfBHRWq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:22:46 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46401 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbfBHRWo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 12:22:44 -0500
Received: by mail-ot1-f67.google.com with SMTP id w25so6985255otm.13
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 09:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m77smnOEZEpyX/pFbpz9XHe4BctGyKaqj+Vd5ER3jO4=;
        b=CQM56vZ9xVVjcvXSkpfxcipx4h4GKEaqNFUG5Au1PkMjqtUH/i/iKlvY4X/0//kiI0
         b5JU+YTDTU7DCvr4fvM5qHIMF21dod0cA2ljL9HU75fAi0jR92XQdMYoYIuwhv+GHxje
         JTW8QP0GlYEKTJWUSf4GfOowfL5DCzAW9YvCs7qOcxJmxAWNJ2kQSyRdJbt8VJYAJhrm
         XYYWStuC8tI9GvvPg4fzyYJ4MX3M+J9OzXUgM9ckLESdfu7DC7v4W6ZCRHDiaO005uek
         YGC0wivWp0gHwOEcX3xKOxe6+mHCHERKM5FLJLfZDr6fw/gaSbfjjeYWstk62MZqYzh4
         0k3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=m77smnOEZEpyX/pFbpz9XHe4BctGyKaqj+Vd5ER3jO4=;
        b=Yyn3GnW3E+GcG4oxODxSdOILbiWea8aWn1RD1IW6/WKtTgz7RDkrIWfLtHXPWXXi3o
         XusZu14izwWCpDLXHwxE8lAfXB2ulEezZqyXtee1O+/pJsV5QxK/YPLW9zJf0LFanJlN
         B51gZ4ov1oSQ1hZ+YL6qP3pkuFTqLg9bIzs8/8iM3MbT7/RJVCxUuz0q9dNWy77ZwMJO
         seGNxTrGQbx4e3ca6a1m4MaawsnlHFxMHnFPS893d40O4aY/EHWMY6/Fe2AefHCiqhNs
         OrEI3OWLmI7qzMw5tfFyokfiu7WCxmOCwVvdX0+5HlHxrvxjZ7c54BifD06WhAaPaMH1
         Id1A==
X-Gm-Message-State: AHQUAub8OLbVjmc7D20JZUepx7amwFLPxcm10eUZs/XJ0oGp8bYN24hs
        MFUV6ecYhoc47dRIs3brkDE=
X-Google-Smtp-Source: AHgI3IZ8s4IZgYZs5y5/p1mv56W5xMJ9m1Nh5YulBfSb6cUmRg6CaZm65dFOvAy0RQIkkGyeTc0U/w==
X-Received: by 2002:a9d:5e81:: with SMTP id f1mr11510623otl.276.1549646563378;
        Fri, 08 Feb 2019 09:22:43 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o2sm1107262otj.2.2019.02.08.09.22.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 09:22:42 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 04/13] rtlwifi: rtl8192com: Replace old-style license information
Date:   Fri,  8 Feb 2019 11:22:00 -0600
Message-Id: <20190208172209.28530-5-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
References: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
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
 .../realtek/rtlwifi/rtl8192c/dm_common.c      | 26 ++-----------------
 .../realtek/rtlwifi/rtl8192c/dm_common.h      | 26 ++-----------------
 .../realtek/rtlwifi/rtl8192c/fw_common.c      | 26 ++-----------------
 .../realtek/rtlwifi/rtl8192c/fw_common.h      | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192c/main.c  | 26 ++-----------------
 .../realtek/rtlwifi/rtl8192c/phy_common.c     | 26 ++-----------------
 .../realtek/rtlwifi/rtl8192c/phy_common.h     | 26 ++-----------------
 7 files changed, 14 insertions(+), 168 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index 67898bc75b32..a4c99b087bb6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation.
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include <linux/export.h>
 #include "dm_common.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
index 441604ff5858..2cad719e2970 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation.
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef	__RTL92COMMON_DM_H__
 #define __RTL92COMMON_DM_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index f3bff66e85d0..44e896374fc4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation.
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h
index c5fa14bda387..c64a90ff3879 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation.
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL92C__FW__COMMON__H__
 #define __RTL92C__FW__COMMON__H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
index 889bd1301154..6a82b14ef17e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation.
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include <linux/module.h>
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index 7c6e5d91439d..49fb4bd7df61 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation.
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../rtl8192ce/reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
index d11261e05a2e..f1ed1a999b8f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation.
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL92C_PHY_COMMON_H__
 #define __RTL92C_PHY_COMMON_H__
-- 
2.20.1

