Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C305C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D651720855
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6wqYGVc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfBHRWx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:22:53 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45392 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbfBHRWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 12:22:52 -0500
Received: by mail-ot1-f68.google.com with SMTP id 32so6996338ota.12
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 09:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WlLQfAcctjbkJajsbmQtsW0RqKAiPY1RgjmmjEI5rzg=;
        b=f6wqYGVcnzRJGQ8Gvnkvh9rrwcJsFdzNDH+lDA9yTSpgvNuX2KhcMHQTcU7uppvy90
         VG+4sg8Hlh7nvY+N2u+n3xZq/nunkK5gSEMsDnS7k3jN/GesujcxCrrI2FWwNAbRIV8q
         0a5KfkVKPtF/2j/luLiYsVdLimWgkAQPhs8MmaRVEp622E6APWoATyeSKPCdTBfEOc9K
         KjajTwQ49cIJwiCIf8bAUTqHlyoOgkWRgGJgMwQWi04JTtrN/gVrn2cE/eVnKLrRgGHJ
         svgHkLnCYCSsoR1MFxkeffUo9WWKXApmWn4BGqldbMqCWPegj91axYuGyfhcZnO6Ekkq
         JzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=WlLQfAcctjbkJajsbmQtsW0RqKAiPY1RgjmmjEI5rzg=;
        b=b2TYw2hjYoIyzJwESHraFVrurdU9bTcPNOIHMHhFa0aSqSzK+MyuLWP+7VpeX/BdIU
         EdFuRSzLIYh4O8AOmmC5XB+3SD3vjJgdDZdHeHWdrP69RpakC+4meeMkdK1QSBaBF517
         rDg0ieOZa49ay/D9etWSeKEVAJXhhl5CVswpPJWvDmrlki9xiSx3q9tSd+i2ibvJprLL
         jBFix75MMOfS98AtHTQZHusoDniqqmEaxZVFCkH35k9pbxHJnrWYLwK+E9/ruHo2hMIP
         6sQJtPd2pfGrC0yRHK52UcyU8pOfwmqA/B3KD3DijintOX+jlOZgN6jlvuuREGZ+gnH/
         x9ng==
X-Gm-Message-State: AHQUAub75yUjDYn9mzDsi2uyhicQ5DLHxEc71rB6EsjkYg8JvIWkMNvr
        +Mf4dCzf7dfzhnIlcdpBayU=
X-Google-Smtp-Source: AHgI3Ibz2oZgDo+QHlcigX3PWdgNzF74kZ/XSaiJBNysUs+JMbvZ27shzly+xROSX0hK6HK+KLVyhQ==
X-Received: by 2002:a9d:2661:: with SMTP id a88mr14393162otb.91.1549646571571;
        Fri, 08 Feb 2019 09:22:51 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o2sm1107262otj.2.2019.02.08.09.22.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 09:22:51 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 12/13] rtlwifi: rtl8723_common: Replace old-style license information
Date:   Fri,  8 Feb 2019 11:22:08 -0600
Message-Id: <20190208172209.28530-13-Larry.Finger@lwfinger.net>
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
+/* SPDX-License-Identifier: GPL-2.0+ */
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
+/* SPDX-License-Identifier: GPL-2.0+ */
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
+/* SPDX-License-Identifier: GPL-2.0+ */
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
+/* SPDX-License-Identifier: GPL-2.0+ */
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
+/* SPDX-License-Identifier: GPL-2.0+ */
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
+/* SPDX-License-Identifier: GPL-2.0+ */
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
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #ifndef __PHY_COMMON__
 #define __PHY_COMMON__
-- 
2.20.1

