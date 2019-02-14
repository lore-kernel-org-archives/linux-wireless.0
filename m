Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E575C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1279222DA
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXHp+a+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437240AbfBNRBW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:01:22 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46528 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436476AbfBNRBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 12:01:09 -0500
Received: by mail-ot1-f67.google.com with SMTP id w25so11594124otm.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 09:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vpwqobN9/kv2mtrj/t30wkSO69Qe6vDLL1HVUOtwah8=;
        b=LXHp+a+X9xxqbBDpcoZ8/R4kpv5vupvllV2mjn/YyZSjiKQIZDrWklL2TGOrjbNHPT
         uxQbxn9X2xcwqhag+cVNfMWOnEQOu0i2K/gCRIsK9ucpp7em3XHmc8z2JXnkAimY6z4c
         LGNM9OSYsnaZgDbrFMKxRIQz+NJHeWKT4flRSAcE7BoCc7tDmIuEB1P/vFhW3vnStKux
         YF2VuWTzU55aT4eYnwKJi2oh89E9grOoPv/qK2rv8g7FGGF24JHKZHDZKr1t+Vl037dU
         rGl2BN04/b+p+rOsTCHhOrwRlsLOiV6SrG9RAGHnIwr6FG3VosqPM2kDjPRN4iKGukF8
         OwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=vpwqobN9/kv2mtrj/t30wkSO69Qe6vDLL1HVUOtwah8=;
        b=brewoNttqNsmhwFPhbsz8UKZwx7G5XQLv+E3/gUiwXU8mTrDKrxbHNZnvMrxrAMrdG
         RqIulHI7EvJ2hLNm7wNJe4gbXmisgmRiF0XUdF8hlxCtHy1DOqiCt133tv74mq+AYym3
         yVFVGRniz89VLVs2wu8E0AUhGlQtZbKvCbZ3DpAindC5rUSjYPHX0nhiB7U1rVEWbM8P
         WV6qgHhYDYJa707R+i0JtSbPq4jEOtGRn/eglEKuu6wVnGfgFwAlYr5e7Nuo9fMrfPIL
         Odo5tf+caKlhxZ7A9B5MNCGF3CHLjHpRan2aZoQ4dL4E7cwJlAmSKwQVUBK18jq+ZXUe
         8O3w==
X-Gm-Message-State: AHQUAuZi39ast2Dk8Zj9uOx7RaHSBU08wSnUDk/cprfYqRc8anFSvwxi
        /htEAoQs0b/U794FSAlQsWc=
X-Google-Smtp-Source: AHgI3IYX4mBIHzDQUERppPgSIAvTtfl0zw3gBkqBmncNNnqVUcZ6Ns/bjckbUclUWh+hlhJ7uLznqQ==
X-Received: by 2002:a9d:5907:: with SMTP id t7mr3072539oth.28.1550163667533;
        Thu, 14 Feb 2019 09:01:07 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l5sm1158327oil.15.2019.02.14.09.01.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 09:01:06 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 06/13] rtlwifi: rtl8192cu: Replace old-style license information
Date:   Thu, 14 Feb 2019 11:00:36 -0600
Message-Id: <20190214170043.3705-7-Larry.Finger@lwfinger.net>
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
 .../wireless/realtek/rtlwifi/rtl8192cu/def.h  | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/dm.c   | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/dm.h   | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.h   | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/led.c  | 24 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192cu/led.h  | 24 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.h  | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/phy.c  | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/phy.h  | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/reg.h  | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/rf.c   | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/rf.h   | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/sw.c   | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/sw.h   | 26 ++-----------------
 .../realtek/rtlwifi/rtl8192cu/table.c         | 26 ++-----------------
 .../realtek/rtlwifi/rtl8192cu/table.h         | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.c  | 26 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.h  | 26 ++-----------------
 20 files changed, 40 insertions(+), 476 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
index 316fe9990b6d..9ffa7fc998ff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
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
 
 #include "../rtl8192ce/def.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
index 00fc0685317a..c10e92b2fcc2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
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
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../base.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
index ce71433792e3..d01e2cf0fd03 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
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
 
 #include "../rtl8192ce/dm.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 1e60f70481f5..1afd2a9a3778 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../efuse.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
index ebd168400d45..988af26ae598 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
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
 
 #ifndef __RTL92CU_HW_H__
 #define __RTL92CU_HW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
index 66d2784de67d..065f3c9267b7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
@@ -1,25 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
- *****************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../usb.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
index 551deb8afb6f..f3fc06a45040 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
@@ -1,25 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL92CU_LED_H__
 #define __RTL92CU_LED_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index 5657b1e34ad0..51bad6ce7fec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
-****************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
index 8573b7e257d9..c610066214e5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
 
 #ifndef __RTL92C_MAC_H__
 #define __RTL92C_MAC_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
index f068dd5317a7..87a0a200f846 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
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
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
index a422c4db1a41..2f1a2bb620e0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
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
 
 #include "../rtl8192ce/phy.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
index 8185886daa8e..1c54c146b589 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
@@ -1,26 +1,4 @@
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
 
 #include "../rtl8192ce/reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
index cf551785eb08..09fb3ced68b3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
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
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
index 07aec0b20cc9..051288eb981b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
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
 
 #ifndef __RTL92CU_RF_H__
 #define __RTL92CU_RF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 43e021b49260..8c7aadb39dc0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../core.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
index 4ea2cb225580..3fb600cb1702 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
 
 #ifndef __RTL92CU_SW_H__
 #define __RTL92CU_SW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
index b3ac981d88c6..468a896d89b8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
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
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "table.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
index 851bf53d246c..9a9805808541 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
 
 #ifndef __RTL92CU_TABLE__H_
 #define __RTL92CU_TABLE__H_
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index 9ab56827124e..c46c808a637f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../usb.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
index 15a66c547287..21038540a5b2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2012  Realtek Corporation. All rights reserved.
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
 
 #ifndef __RTL92CU_TRX_H__
 #define __RTL92CU_TRX_H__
-- 
2.20.1

