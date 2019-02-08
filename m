Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5472C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DB1420855
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 17:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JCH6Jkek"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfBHRWx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:22:53 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33510 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbfBHRWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 12:22:52 -0500
Received: by mail-ot1-f67.google.com with SMTP id i20so7144336otl.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2019 09:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T4iyV0vlvTD8GLFTr7aFPi/NpymWXLbtlEQa7uaa3Gc=;
        b=JCH6JkekBBpDSPXAM1FPex7zr2PFZw2lxjJ7069mspclssGVXRmZGFo2WHiXTdG7om
         aHUz5OOSAY0Tkb02JeUaQ0DwTa0aVOUpSnMfgjRLiXtkH8ztOY4Sj07ojfk0TaYaIWcj
         klpHOtJ9R1eQ5k6EyEeFijzgs786i2hLDUcp0rteZupt7HRQh/jUMj9EYHadyc1alYGk
         yu9nDM0tnPunr8aIUFxUg5VCjkkQ1oACrw55ga2r52u47pfhDPnQnHTsMYXn7cOZwVVD
         Emx4wn67wlzRc6FbZ3wKEt6hdvDjeJkLZ/V3aZIVrkwiENyProEMsirB4rtlQ2Xf15tt
         dhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=T4iyV0vlvTD8GLFTr7aFPi/NpymWXLbtlEQa7uaa3Gc=;
        b=BnGO2SYRSGR5i7ffur0mApYP6drjUO2LuZ8WnQz+qq8u+gIiNv85nLPuMU4ksyvuwk
         M+AmlCddcIWb5xHoxE+4BMvx4ZoEi3r79hR6a770gTjUd0sLA9rxkaFQV3U9/ngySeGE
         QCs5yWBrm8rtSa5DellTQJniJ4ROrp3n3IQs0wEAcIqKrMMwIcNu0mpnSmlgyQa3LOCc
         xJf3nV+mJ9Fmx6ky1Ggi1mrNGLmM4b+sKbat2wPS/luCHI5/zLjqS/DvuowroZzk6X7b
         idKWcvPKP/bJAYAijnT6WhxJKtd5rICDx+PdxKUs73+thEB+gEn6kkxYpJU49emNVpUr
         PhQA==
X-Gm-Message-State: AHQUAuY6qm4ZWOKzbyeDt6E6oxyoc1cJo/UhO1CxZK+5pnqbOdbAmaH+
        Y11zYTZNrEJp0IXJ8yrSbgY=
X-Google-Smtp-Source: AHgI3IbGIBxl/hfdOb8X2EZPUNtDJ4g2iS9VzXC2JT800DJWvYJ8WYClMTIDMYyBHQ1aXvD1ut6NUw==
X-Received: by 2002:a9d:6395:: with SMTP id w21mr8278919otk.66.1549646569402;
        Fri, 08 Feb 2019 09:22:49 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o2sm1107262otj.2.2019.02.08.09.22.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 09:22:48 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 10/13] rtlwifi: rtl8723ae: Replace old-style license information
Date:   Fri,  8 Feb 2019 11:22:06 -0600
Message-Id: <20190208172209.28530-11-Larry.Finger@lwfinger.net>
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
 .../wireless/realtek/rtlwifi/rtl8723ae/btc.h  | 25 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/def.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/dm.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/dm.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/fw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/fw.h   | 25 ++---------------
 .../rtlwifi/rtl8723ae/hal_bt_coexist.c        | 26 ++---------------
 .../rtlwifi/rtl8723ae/hal_bt_coexist.h        | 25 ++---------------
 .../realtek/rtlwifi/rtl8723ae/hal_btc.c       | 27 ++----------------
 .../realtek/rtlwifi/rtl8723ae/hal_btc.h       | 25 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/led.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/led.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.h  | 26 ++---------------
 .../realtek/rtlwifi/rtl8723ae/pwrseq.c        | 26 ++---------------
 .../realtek/rtlwifi/rtl8723ae/pwrseq.h        | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/reg.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/rf.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/rf.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/sw.h   | 26 ++---------------
 .../realtek/rtlwifi/rtl8723ae/table.c         | 28 ++-----------------
 .../realtek/rtlwifi/rtl8723ae/table.h         | 28 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.h  | 26 ++---------------
 27 files changed, 55 insertions(+), 648 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/btc.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/btc.h
index 06c448c010fd..3993128b0e3b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/btc.h
@@ -1,26 +1,5 @@
-/******************************************************************************
- **
- ** Copyright(c) 2009-2012  Realtek Corporation.
- **
- ** This program is free software; you can redistribute it and/or modify it
- ** under the terms of version 2 of the GNU General Public License as
- ** published by the Free Software Foundation.
- **
- ** This program is distributed in the hope that it will be useful, but WITHOUT
- ** ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- ** FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- ** more details.
- **
- ** The full GNU General Public License is included in this distribution in the
- ** file called LICENSE.
- **
- ** Contact Information:
- ** wlanfae <wlanfae@realtek.com>
- ** Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- ** Hsinchu 300, Taiwan.
- ** Larry Finger <Larry.Finger@lwfinger.net>
- **
- ******************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL8723E_BTC_H__
 #define __RTL8723E_BTC_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
index 847544817549..d79b23528f9a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
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
 
 #ifndef __RTL8723E_DEF_H__
 #define __RTL8723E_DEF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
index acfd54c6f8dd..9bb823ffd89c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
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
 #include "../base.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
index 57d3bd6286d7..47dbf044ee04 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
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
 
 #ifndef	__RTL8723E_DM_H__
 #define __RTL8723E_DM_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
index bf9859f74b6f..0dd27a193c8b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
index 2e668fcfc5c2..5e8a7609bd36 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
@@ -1,26 +1,5 @@
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
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL92C__FW__H__
 #define __RTL92C__FW__H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
index 5aac45d5a974..9a2d3a68283e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
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
 
 #include "hal_bt_coexist.h"
 #include "../pci.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
index 45719fdcb067..a836b4866490 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
@@ -1,26 +1,5 @@
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
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL8723E_HAL_BT_COEXIST_H__
 #define __RTL8723E_HAL_BT_COEXIST_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
index 788de88ab1ee..061f14e1816f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
@@ -1,27 +1,6 @@
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
+
 #include "hal_btc.h"
 #include "../pci.h"
 #include "phy.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h
index 756868897d8b..943d645abea3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h
@@ -1,26 +1,5 @@
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
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL8723E_HAL_BTC_H__
 #define __RTL8723E_HAL_BTC_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index f783e4a8083d..b9afc34705e2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
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
 #include "../efuse.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
index c76e453f4f43..761a63ad99c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
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
 
 #ifndef __RTL8723E_HW_H__
 #define __RTL8723E_HW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
index d567b0df0e9f..ea1b60af78dc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
index c22b19f542a6..a097557024a6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
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
 
 #ifndef __RTL92CE_LED_H__
 #define __RTL92CE_LED_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index 3f3327878b51..e5518375303d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
index b85f5c7c5c01..c252cce6f111 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
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
 
 #ifndef __RTL92C_PHY_H__
 #define __RTL92C_PHY_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.c
index 2f7f81af8a55..3fa5a1e72ba0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.c
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
 
 #include "../pwrseqcmd.h"
 #include "pwrseq.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
index e6c3aac3e9fd..7453007a4ece 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
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
 
 #ifndef __RTL8723E_PWRSEQ_H__
 #define __RTL8723E_PWRSEQ_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
index 30938cd9fce5..72c3f239c6f7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
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
 
 #ifndef __RTL8723E_REG_H__
 #define __RTL8723E_REG_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
index 89958b64b52d..34bc46fd1762 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
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
 #include "reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.h
index 7b44ebc0fac9..2e1f59283367 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.h
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
 
 #ifndef __RTL8723E_RF_H__
 #define __RTL8723E_RF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 3103151dda2b..52d46cc5e793 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
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
 #include "../core.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
index 46478780d262..acf95f5f57e1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
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
 
 #ifndef __RTL8723E_SW_H__
 #define __RTL8723E_SW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
index 1bbee0bfac23..b10453a8c19f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
@@ -1,29 +1,5 @@
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
- * Created on  2010/ 5/18,  1:41
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "table.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
index a044f3c456fa..6036ccc066e3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
@@ -1,29 +1,5 @@
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
- * Created on  2010/ 5/18,  1:41
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL8723E_TABLE__H_
 #define __RTL8723E_TABLE__H_
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index d461d0c9631f..7c82c197fcb2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
index d592b08d4ac8..08d5ba933962 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
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
 
 #ifndef __RTL8723E_TRX_H__
 #define __RTL8723E_TRX_H__
-- 
2.20.1

