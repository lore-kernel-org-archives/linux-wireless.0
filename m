Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957F8C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 502B020855
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="okPO+mVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfBHRWu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:22:50 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38286 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbfBHRWu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 12:22:50 -0500
Received: by mail-ot1-f65.google.com with SMTP id e12so7079212otl.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 09:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fEQEwjocGKcxv8fcTVGJY5CsOyfIsm2rXnMUFnv+r2o=;
        b=okPO+mVx7BETZEBHFafz9cRbFlMYixI6k3EJKbcvmiEMw0820vtgP5YPOhqy27QuY2
         1m0atl7PCSB4DCB0KKr+Wf8b+D8tUpiuT05DX6yiRh3Rzf5T1OgQhokDPQqNvjj1peQY
         XfpccyEjowkY3ZYf1c7PIZbHTmJmibxRwl9jlLToWUoIu1yd0t8NkfOMMYHRgfvXrMDF
         LfKJXwSkX7A/hLNvZMqztDQFopbGe/KLm0l8RwbdbtfmUpQkLvbAFVL+B8rWACSdzJfP
         ng9OaLgzuGoL4btJ5Y6jJXGPk+XkCWiyDrVhqAyoUxdet9G+eycx7j2kqxt4IEzBvlwb
         +y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fEQEwjocGKcxv8fcTVGJY5CsOyfIsm2rXnMUFnv+r2o=;
        b=W+2H2+3utJJ2ULfKSYKQuf2nwTqbv2KgnIhtRLGWKlFbe/gEAMolsXgBkdyFPzGkMm
         v+9tIRe6MQXaMJpkuhhA7s11bbG8Gnvk7XFdYMYc1iIPSZabIh4rlpbrLo0mBpeTnT/C
         ts9QvsAUYLL0sNz/EN/PYorp0DVmye+im3XYoNn+lHUwsIBFYhQMWPJ7PRw+MMvosv8V
         woic9M6xB1sNInfHc3F6jWeeqrByWWnjq1NsbDXAQXd5xkTKIGwqTHO64iFwZTbfXk0B
         2IW9KNgubd0i+V2qmcqRP5DLITo2EXmhfoZl5dxohBQ5ELR/TbeK2noZ0hwbDTqtuJJ9
         90iA==
X-Gm-Message-State: AHQUAuYei+16IbiRyXSLsDCb24zbMmMkxV2kL3l8Sx6zAooMDOXktb6o
        Jh43y9jKJ2/tgpvKi6JMh8g=
X-Google-Smtp-Source: AHgI3IYk97TR57fhVbVHA3ev+ep++Ghbuu8YFJWt9Xbg08Zd8YQCBk+jTxSeZwTV2sztdqh62rIszA==
X-Received: by 2002:a9d:738a:: with SMTP id j10mr14445629otk.188.1549646567615;
        Fri, 08 Feb 2019 09:22:47 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o2sm1107262otj.2.2019.02.08.09.22.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 09:22:47 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 08/13] rtlwifi: rtl8192ee: Replace old-style license information
Date:   Fri,  8 Feb 2019 11:22:04 -0600
Message-Id: <20190208172209.28530-9-Larry.Finger@lwfinger.net>
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
 .../wireless/realtek/rtlwifi/rtl8192ee/def.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/dm.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/dm.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/fw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/fw.h   | 25 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/hw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/hw.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/led.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/led.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/phy.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/phy.h  | 26 ++---------------
 .../realtek/rtlwifi/rtl8192ee/pwrseq.c        | 26 ++---------------
 .../realtek/rtlwifi/rtl8192ee/pwrseq.h        | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/reg.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/rf.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/rf.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/sw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/sw.h   | 26 ++---------------
 .../realtek/rtlwifi/rtl8192ee/table.c         | 28 ++-----------------
 .../realtek/rtlwifi/rtl8192ee/table.h         | 28 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.h  | 26 ++---------------
 22 files changed, 44 insertions(+), 531 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/def.h
index 9f7e7bb8610b..4661bcee2dfa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/def.h
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
 
 #ifndef __RTL92E_DEF_H__
 #define __RTL92E_DEF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
index faed6e2dedf6..2fcd302dd421 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
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
 #include "../base.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.h
index 107d5a488fa8..68a5cd066b27 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.h
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
 
 #ifndef	__RTL92E_DM_H__
 #define __RTL92E_DM_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 84a0d0eb72e1..53d59adf3489 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
index 6a2fbf20d579..e4bd9976a115 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
@@ -1,26 +1,5 @@
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
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #ifndef __RTL92E__FW__H__
 #define __RTL92E__FW__H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 3f2295fdb02d..e4e0bb96177f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
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
 #include "../efuse.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
index 3a63bec9b0cc..d642786972aa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
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
 
 #ifndef __RTL92E_HW_H__
 #define __RTL92E_HW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
index 96c64785108b..718a9e678eec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.h
index 8ef640a2ef7f..7c657073034b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.h
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
 
 #ifndef __RTL92E_LED_H__
 #define __RTL92E_LED_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index 8b072ee8e0d5..393984c4aa18 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.h
index 49bd0e554c65..e26e7cff62b5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.h
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
 
 #ifndef __RTL92E_PHY_H__
 #define __RTL92E_PHY_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.c
index 1a701d007f0c..53a0959bb02c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.c
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
 
 #include "pwrseq.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
index c570801508cc..9893c0611058 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
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
 
 #ifndef __RTL92E_PWRSEQ_H__
 #define __RTL92E_PWRSEQ_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/reg.h
index 1eaa1fab550d..458af5bec3e8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/reg.h
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
 
 #ifndef __RTL92E_REG_H__
 #define __RTL92E_REG_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
index bc76a91da762..9f0ec9bbc21e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
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
 #include "reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.h
index 039c0133ad6b..e065592884bb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.h
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
 
 #ifndef __RTL92E_RF_H__
 #define __RTL92E_RF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index 9ea62599ecbb..bd789f37f765 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
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
 #include "../core.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
index 21433d0332d0..2ecb21ee761a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
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
 
 #ifndef __RTL92E_SW_H__
 #define __RTL92E_SW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.c
index abcdd0670fd8..f9f5d7c9f9b0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.c
@@ -1,29 +1,5 @@
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
- * Created on  2010/ 5/18,  1:41
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #include "table.h"
 u32 RTL8192EE_PHY_REG_ARRAY[] = {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.h
index bff9df88815d..e49f01e12270 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.h
@@ -1,29 +1,5 @@
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
- * Created on  2010/ 5/18,  1:41
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #ifndef __RTL92E_TABLE__H_
 #define __RTL92E_TABLE__H_
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 14d6e3fc5767..c53b11e83ae2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.h
index 45df3e79f490..a83c3344da8d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.h
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
 
 #ifndef __RTL92E_TRX_H__
 #define __RTL92E_TRX_H__
-- 
2.20.1

