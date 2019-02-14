Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA25C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F1B821872
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rxR0ITw9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439899AbfBNT7e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 14:59:34 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36251 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389006AbfBNT7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 14:59:33 -0500
Received: by mail-ot1-f68.google.com with SMTP id v62so3826525otb.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 11:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HLXVN1pdyUlu5lsYeenSecZ+vmmMfjof+p0onJAw6T4=;
        b=rxR0ITw9cVS0gAroYqcYCF7Tkjo3qjSYccAOmMuEiFmVG0DChNdnMuGw2V3AkXG9Ec
         /M6lUE/xM1IscjMrvctjn3P2ujMG735QldqmNC9p41up4MTtvmx5WKXE4f/KoLg/JkzL
         +6Zs5gfwT7ZsNxNdMLdm8B2jboEJoTGx74zcTTEN4jBpLrHOv2soiOxdWl9iWOLkmJ0P
         c0gsgYVZ0Q9kVbuLZaXvt+VP0Jc9z4BfHeYplfHK3GJjbExdy1m4s4vTKwPmAvhQTvHx
         SV3zCKtBBdVGL5ExhU1G9UIOD2Xk/EY6xor0gvGlobs6vFGmhiQcg9rGQHFm6Tqscw5h
         2Q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=HLXVN1pdyUlu5lsYeenSecZ+vmmMfjof+p0onJAw6T4=;
        b=fwl8TCLsZxAt3rxgV7We5wL9iZE9YVmOlDN/MCmWjYhsg8l2tY84T1AQseR3D/0ZeH
         io9QYI8ThAHnp2jhD1dAdJydEbKoVIIQvii6Oeaq4S4B15bXToW32USOzVMh3KquO+M5
         unIKjT13o7WaTOCkfM9MaDZ//qDCzMgUlCKzWcZ3aIYes7JsAZN7SI5vu1mzHfWFEZfl
         TpZ+61A8fcOCGyYp+JoJBAs29rryFv2TrPONhjYopkgBgqDJcACbLRKQFoTauJ+bEV6j
         85yST9B952RmpP+LUd7lBbeRBY7/DcIwtvItvgNBbzXmOISMpih3e2fiuh9SrQ8Lqd+4
         soLg==
X-Gm-Message-State: AHQUAua827T4DO0R8Zw17J0li+QB7O1+qAeNJgA0WATsYJkNWj/VZJNP
        tOYdPCQAPGCmlvVPrzCkFEU=
X-Google-Smtp-Source: AHgI3IbujcFSF5eEAsjkUAffZBao3JUc1NkN2L7uyfydlovU/Wb3FVhUKFZZnNzHUchPsRoGA8sPYQ==
X-Received: by 2002:aca:7201:: with SMTP id p1mr1412336oic.159.1550174371994;
        Thu, 14 Feb 2019 11:59:31 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v20sm873519oto.31.2019.02.14.11.59.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 11:59:30 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v3 04/13] rtlwifi: rtl8192com: Replace old-style license information
Date:   Thu, 14 Feb 2019 13:59:11 -0600
Message-Id: <20190214195920.1504-5-Larry.Finger@lwfinger.net>
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
+// SPDX-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX-License-Identifier: GPL-2.0
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
+// SPDX-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL92C_PHY_COMMON_H__
 #define __RTL92C_PHY_COMMON_H__
-- 
2.20.1

