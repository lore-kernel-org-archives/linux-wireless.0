Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9C8C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B343F21872
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScI3wY2P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437147AbfBNT7d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 14:59:33 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42826 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405835AbfBNT7c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 14:59:32 -0500
Received: by mail-ot1-f67.google.com with SMTP id i5so12614438oto.9
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 11:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JMnkpGnnhxKrHj3WGKA0SiDYzNi50s/ctjoZit5KhDw=;
        b=ScI3wY2P+Qk7LMUdGp7EuhWoURUHMw6mkMa5RjXHPSUjzSYLChLi/4aH+vYXrgi56C
         Ko53B0Xy8c5gZ2mOOvcoBSH1RVu6+7xMe3SGBKH7k+dBvbJfa0Wl+RpGp77ngBegrHta
         5BnkZ8ae3Jd/ZK03svWJf2TCjcOur0UjeJS8AcjkrIhCaJwHMeCv4fNOdnOsn/QiRpO+
         i7gdQWF6EMkpa6mjFz8BRjTFtKlUMDShOLaPLRY2LF07AP/JFWeL3IHHkVSLfhsuHKkS
         gbx/7buA5DH8ZSTGG8oW06GE5V1KFptQQldwZK9TmDkK/LtzIY3qjs/nKwAT+bbgqvHO
         LFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=JMnkpGnnhxKrHj3WGKA0SiDYzNi50s/ctjoZit5KhDw=;
        b=n0Z7A08NpFwyZfeMZI75gSBL6NtRpl+dS570lf5Mh4oW08cX8URGmNOT+Y96LUpxIP
         ZkBBUHugf68NaI/fP+zvyoc8xz3Cyhxni0IMAxUCtXvZxfDGXeJeTbih3T5O59jcETCl
         fS51xoceKYvkopPBd6Og7sJ7cYuWW65rNWaegkqml9r6CTb5g7PHnrunYHakLtse/P8T
         x7b+EbjgwXZ9TH3YVejj6GeI9AH7swfdfJCLpysAK1nwG3ylUZ8wNssEut+LU/kPP6h/
         u26KgPT99IgiuDGW651+i0RAHy8lrfGXfS+tEPHpls8CPYVY/DpoU7iIzW4keRfJD5eC
         6ONQ==
X-Gm-Message-State: AHQUAuY4jlGB+itW/L9WmVVdS6+9PpmaF7+BrMw1tjWcUTpqNzVI/Mcp
        6+tqXThvcXwuXF9+FOvor5z/ndeM
X-Google-Smtp-Source: AHgI3IbVxuFROuJMn3C0NzN80QJuv/Ik1wHbihEyCOEffbxnImVR6zD3/WBwDW0tYqjJwhYrLptkuw==
X-Received: by 2002:aca:52cd:: with SMTP id g196mr3576853oib.140.1550174370435;
        Thu, 14 Feb 2019 11:59:30 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v20sm873519oto.31.2019.02.14.11.59.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 11:59:29 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v3 03/13] rtlwifi: rtl8188ee: Replace old-style license information
Date:   Thu, 14 Feb 2019 13:59:10 -0600
Message-Id: <20190214195920.1504-4-Larry.Finger@lwfinger.net>
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

 .../wireless/realtek/rtlwifi/rtl8188ee/def.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/dm.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/dm.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/fw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/fw.h   | 25 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/led.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/led.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/phy.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/phy.h  | 26 ++---------------
 .../realtek/rtlwifi/rtl8188ee/pwrseq.c        | 26 ++---------------
 .../realtek/rtlwifi/rtl8188ee/pwrseq.h        | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/reg.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/rf.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/rf.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/sw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/sw.h   | 26 ++---------------
 .../realtek/rtlwifi/rtl8188ee/table.c         | 28 ++-----------------
 .../realtek/rtlwifi/rtl8188ee/table.h         | 28 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.h  | 26 ++---------------
 22 files changed, 44 insertions(+), 531 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
index 45c866d3ca88..0d856c82a622 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92C_DEF_H__
 #define __RTL92C_DEF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index e05af7d60830..057414b324ef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../base.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
index 50f26a9a97db..559490b42964 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef	__RTL88E_DM_H__
 #define __RTL88E_DM_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
index 63874512598b..390b05650931 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
index b884c30c7b37..a5aab35b6e18 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
@@ -1,26 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92C__FW__H__
 #define __RTL92C__FW__H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 4932076b344e..45174a7c1a26 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../efuse.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
index 214cd2a32018..3250e52dce6f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92CE_HW_H__
 #define __RTL92CE_HW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
index df3e214460db..36555ba1d4f8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
index 4b325b75faaf..b328c81e14de 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92CE_LED_H__
 #define __RTL92CE_LED_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 14a256062614..6f1469205621 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
index b29bd77210f4..397692d514b9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92C_PHY_H__
 #define __RTL92C_PHY_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.c
index 02013df968a0..3bad46cb570c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../pwrseqcmd.h"
 #include "pwrseq.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
index 8379a3e5198c..4ff40278f0a6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL8723E_PWRSEQ_H__
 #define __RTL8723E_PWRSEQ_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
index 0c0d64aea651..7cbec6ac7eae 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92C_REG_H__
 #define __RTL92C_REG_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
index 30798b12a363..ae36adad7431 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
index 0eca030e3238..a6f0557614f6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92C_RF_H__
 #define __RTL92C_RF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 8c15ffd3568b..2005dae9920e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../core.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
index 22398c3753a6..8f0be68ad93d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92CE_SW_H__
 #define __RTL92CE_SW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.c
index 68bcb7fe6a65..281733a74f4b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.c
@@ -1,29 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
- * Created on  2010/ 5/18,  1:41
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "table.h"
 u32 RTL8188EEPHY_REG_1TARRAY[] = {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
index 403c4ddd236f..0655662eb796 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
@@ -1,29 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
- * Created on  2010/ 5/18,  1:41
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92CE_TABLE__H_
 #define __RTL92CE_TABLE__H_
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 14dcb0816bc0..c2f670726198 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
index 127ba977206f..830ce43685da 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2013  Realtek Corporation.
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
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
 
 #ifndef __RTL92CE_TRX_H__
 #define __RTL92CE_TRX_H__
-- 
2.20.1

