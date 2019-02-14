Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E071FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 826BE21872
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3L8mmW4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503031AbfBNT7q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 14:59:46 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36270 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392068AbfBNT7p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 14:59:45 -0500
Received: by mail-ot1-f65.google.com with SMTP id v62so3827627otb.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 11:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QHm4/Z8JDyHEpBmsh+FxsmcqA09S0ctih820wAPYrok=;
        b=W3L8mmW4+2pcGae39lxBjyNNsw6r66IMIrNG8R+rmb7HLoAy+HvPyr4j9eHoBL3vGq
         Jib7OQvLLX9uRszXH+NXroElKoOXwDSO34PlRoG/BpNaC3xFiF7DugYnGpo+g3jusVfX
         MSKU/RzkumNUs5VpOqigsc38b2Cu3L1HERjP+AqIIFJ6F0oWT76bPEkUjUh91eflnA5f
         2WinlETqER7xjWQphjGmX0MaafZYxr2wnOUGazOHMTALWk6mygGLDr+BIaau9VERqd/L
         dHoMrhlAbssRYfwaINA5fDbAdzJXUtr1fZWNrglqne3P7NVlHsupT3LmjK/VoMEcc4U2
         /jHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QHm4/Z8JDyHEpBmsh+FxsmcqA09S0ctih820wAPYrok=;
        b=A5WtgR4cntVvAttO6o2n4xhEODtm3OuwOVKsKCrQTgi+aJr7t1SkmnPLhHFWqv/8dE
         BMenYrbBdOOgdmhYYwJsJ/T0X2Y+RihR3zD+CwAikiPEKUPdPsizr1laBEaOB78SPe6+
         sfhqpn9QjOeshaw1Wqhj/RoQVMsCyCmNlRB4BTHRbEJzZ61hTx8Yw/xqdEMLKoR/5NgF
         185pJjuOkFowVsrh17jjBTV63sd8Q13EgJxA+ZpMuLGyIX4QanXcBnFHFzrpW6jvhar2
         T9+YkA30mQDfVI/xc2gVtST13u28RWTg+13SP79ja3ydDC/IktecW6A06N+vlejExYRk
         Ul2g==
X-Gm-Message-State: AHQUAuYrNqwVLYsn8DrCE2762b9LWLCsPYqBKFxecOcTiBgrgNuDT38b
        gWhu/KYlZvLFBOcZQxvJ87M=
X-Google-Smtp-Source: AHgI3IYXiwg349THWKIdxbeg57SkcEFrAsuzCVG/0p6+dbUTcthTlfkqeB50Gf6IJIm5So7qr1Q/TA==
X-Received: by 2002:a9d:480f:: with SMTP id c15mr3497576otf.265.1550174383693;
        Thu, 14 Feb 2019 11:59:43 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v20sm873519oto.31.2019.02.14.11.59.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 11:59:43 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v3 13/13] rtlwifi: rtl8821ae: Replace old-style license information
Date:   Thu, 14 Feb 2019 13:59:20 -0600
Message-Id: <20190214195920.1504-14-Larry.Finger@lwfinger.net>
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
 .../wireless/realtek/rtlwifi/rtl8821ae/def.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.h   | 25 ++--------------
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/led.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/led.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.h  | 26 ++---------------
 .../realtek/rtlwifi/rtl8821ae/pwrseq.c        | 26 ++---------------
 .../realtek/rtlwifi/rtl8821ae/pwrseq.h        | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/reg.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/rf.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/rf.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/sw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/sw.h   | 26 ++---------------
 .../realtek/rtlwifi/rtl8821ae/table.c         | 29 ++-----------------
 .../realtek/rtlwifi/rtl8821ae/table.h         | 28 ++----------------
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.h  | 26 ++---------------
 22 files changed, 45 insertions(+), 531 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
index 3fe3aaa5fe3c..53afaea3b016 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_DEF_H__
 #define __RTL8821AE_DEF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 3be8c88971e2..e8aa3cd01a2f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../base.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
index 433923e9b461..8e43336b7c00 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef	__RTL8821AE_DM_H__
 #define __RTL8821AE_DM_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index d868a034659f..4c87de69b54e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
index 99c902ff0b84..7fc5557462ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
@@ -1,26 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE__FW__H__
 #define __RTL8821AE__FW__H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index ba258318ee9f..dbc16da10eb2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../efuse.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
index e2ab783a2ad9..a3283f3b458f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_HW_H__
 #define __RTL8821AE_HW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
index 405c7541b386..f37e60fa8af3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.h
index 038e64e18ae8..4ca1c6fa5e2a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_LED_H__
 #define __RTL8821AE_LED_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index a75451c246fd..7524aad020f4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
index 1285e1adfe9d..e68bd8af4a01 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_PHY_H__
 #define __RTL8821AE_PHY_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.c
index 9ddf78a187dd..4897b4da6da0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../pwrseqcmd.h"
 #include "pwrseq.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
index 6dd575435c63..9359c2ff9669 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_PWRSEQ_H__
 #define __RTL8821AE_PWRSEQ_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
index db8bc8a2de61..3798791626c1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_REG_H__
 #define __RTL8821AE_REG_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
index 95489f41f8a0..81bb960c9552 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.h
index efd22bd0b139..c4696706b973 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_RF_H__
 #define __RTL8821AE_RF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 77f6401021c9..18e8686e3ba6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../core.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h
index d001e7ce3052..21cf1c57ab12 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_SW_H__
 #define __RTL8821AE_SW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
index f87f9d03b9fa..c9e3adf19e4b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
@@ -1,29 +1,6 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
+
 #include <linux/kernel.h>
 #include "table.h"
 u32 RTL8812AE_PHY_REG_ARRAY[] = {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
index 36c2388b60bc..39a1918fc93a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
@@ -1,29 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_TABLE__H_
 #define __RTL8821AE_TABLE__H_
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 0f2b7c619918..91c6f13ae35d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #include "../wifi.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
index 4ff0968dba81..8f3b7b032493 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
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
+/* Copyright(c) 2009-2010  Realtek Corporation.*/
 
 #ifndef __RTL8821AE_TRX_H__
 #define __RTL8821AE_TRX_H__
-- 
2.20.1

