Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DF5C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 718B3222DA
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTkW3PTG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395508AbfBNRBA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:01:00 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45052 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbfBNRBA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 12:01:00 -0500
Received: by mail-ot1-f66.google.com with SMTP id g1so11610477otj.11
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 09:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NKHhVDX6WH7ApNrX/4/FqziRoUoFJxkoJQqNhbZX2Ms=;
        b=cTkW3PTGiDsgumCJcCfKX6fnMnHgMcnpsu6N12cgtF9SS7paISbaxArJdx65hutjY3
         N8U9e4eBnuAHIawuWB311jgJ70/5XQ6hZt0V7I2PSdpYGPe6PCaA9c+6a6Aaf5Q3dw40
         lmIHdr0GJREQkIOgnTqr3XRT60UezwmvU7t34IulVM2Rz7o/W7h/EVqd2R/KVJOEqweS
         nGjoaujZRUNEYWhwkHUDloDhcKp6JT+Vqp5sCzixjRVaWvRBunm+rMeL2Y9LJZrRNYJn
         F5AqAT5T6wPnVgvWzxvljixSPzg6McT33ND6umylAakZ5tuHxaP93KNgX4WRYNalLvWw
         XDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=NKHhVDX6WH7ApNrX/4/FqziRoUoFJxkoJQqNhbZX2Ms=;
        b=IPJd7nynjyGKsixO+fyi6u80Z2Te9dzI5dV5af02vFqf+Zcuk2IS1E6oJpEdc/9Tb5
         3WXwHH5IxfFraagzi+dnYyL7YO3H85SpVeJcGcqoJQ1hBGUg+nADfsQjhM46qJWG2JbB
         L2SW5BQkwThZCPxFQwO9utC24lP19hGnX+WK0Zk//QH3Z7Lwq8Lh+vGo3u5FFXLqy0XL
         WHLjtqnMt2cxIygZ9rPYy0DcDJ7GrGHquZM51wTVC/ugQOacz8cFqoDcL4tqK6mOby36
         VjQZLgn4d+L73LFmm1KeJR5wWhnnc/DHyPEA6Oks+JLH5MNfjRXBh+fiZm33oOQXEUc/
         Mz/g==
X-Gm-Message-State: AHQUAub2/LeSIAKhIN8NGSr2rVSiLrrLxPl3QtCbEvw4SGpVcFPbOgyz
        8e+h1bwdlKWDjzJQUtiNdsc=
X-Google-Smtp-Source: AHgI3Ibf5iGoti4nog6LDO5wcrrFrVhoPLjLgVXC0QTOqUeki6Fpw7j1WCwQ5DnxBGq4ZcOFlVMfug==
X-Received: by 2002:aca:e544:: with SMTP id c65mr3050748oih.75.1550163658218;
        Thu, 14 Feb 2019 09:00:58 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l5sm1158327oil.15.2019.02.14.09.00.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 09:00:57 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 02/13] rtlwifi: btcoex: Replace old-style license information
Date:   Thu, 14 Feb 2019 11:00:32 -0600
Message-Id: <20190214170043.3705-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190214170043.3705-1-Larry.Finger@lwfinger.net>
References: <20190214170043.3705-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The old-style license information is replaced by the SPDX form. There
are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
v2 - C++ comment style used for SPDX line in .c files, and GPL 2.0+ changed to 2.0.
---

 .../realtek/rtlwifi/btcoexist/halbt_precomp.h | 25 ++-----------
 .../rtlwifi/btcoexist/halbtc8192e2ant.c       | 35 ++-----------------
 .../rtlwifi/btcoexist/halbtc8192e2ant.h       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8723b1ant.c       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8723b1ant.h       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8723b2ant.c       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8723b2ant.h       | 27 ++------------
 .../rtlwifi/btcoexist/halbtc8821a1ant.c       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8821a1ant.h       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8821a2ant.c       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8821a2ant.h       | 26 ++------------
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c   | 17 ++-------
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h   |  3 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c  | 26 ++------------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h  | 27 ++------------
 .../realtek/rtlwifi/btcoexist/rtl_btc.c       | 27 ++------------
 .../realtek/rtlwifi/btcoexist/rtl_btc.h       | 25 ++-----------
 17 files changed, 42 insertions(+), 381 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 02dff4c3f664..8705c85c2693 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -1,26 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
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
- ******************************************************************************/
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2007-2011  Realtek Corporation.*/
 
 #ifndef	__HALBT_PRECOMP_H__
 #define __HALBT_PRECOMP_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index f22fec093f1d..d5f20d3c420b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -1,36 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
-/**************************************************************
- * Description:
- *
- * This file is for RTL8192E Co-exist mechanism
- *
- * History
- * 2012/11/15 Cosa first check in.
- *
- **************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2012  Realtek Corporation.*/
 
 /**************************************************************
  *   include files
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
index b8c95c7afc06..7e008fca8bd0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
@@ -1,27 +1,6 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
+
 /*****************************************************************
  *   The following is for 8192E 2Ant BT Co-exist definition
  *****************************************************************/
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 59553db020ef..134a139f6149 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
 
 /***************************************************************
  * Description:
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 934f27893c16..4fada28a83f5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -1,27 +1,6 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
+
 /**********************************************************************
  * The following is for 8723B 1ANT BT Co-exist definition
  **********************************************************************/
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 6597f7cb3411..0949b4ff0889 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1,27 +1,6 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
+
 /***************************************************************
  * Description:
  *
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index aa24da402fb9..ce85965c74e8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -1,27 +1,6 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
+
 #ifndef _HAL8723B_2_ANT
 #define _HAL8723B_2_ANT
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index b5d65872db84..d8028f6e0cab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
 
 /**************************************************************
  * Description:
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index a498ff5b1b9c..8478a87b89ee 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
 
 /*===========================================
  * The following is for 8821A 1ANT BT Co-exist definition
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 01a9d303603b..579702bae759 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
 
 /************************************************************
  * Description:
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index ce3e58c4e660..810ccfa7b37f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2012  Realtek Corporation.
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
+/* Copyright(c) 2012  Realtek Corporation.*/
 
 /*===========================================
  * The following is for 8821A 2Ant BT Co-exist definition
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
index 951b8c1e0153..dfb5060ffc7b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
@@ -1,17 +1,6 @@
-/******************************************************************************
- *
- * Copyright(c) 2016-2017  Realtek Corporation.
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
- *****************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2016-2017  Realtek Corporation.*/
+
 #include "halbt_precomp.h"
 
 void ex_hal8822b_wifi_only_hw_config(struct wifi_only_cfg *wifionlycfg)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h
index 6ec356542eea..fa4f6034f7d7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h
@@ -1,3 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2016-2017  Realtek Corporation.*/
+
 /******************************************************************************
  *
  * Copyright(c) 2016-2017  Realtek Corporation.
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index d748aab66aa2..adcec94acee8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1,27 +1,5 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2013 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
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
- ******************************************************************************/
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2007-2013  Realtek Corporation.*/
 
 #include "halbt_precomp.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 9eae87d19120..de4575700757 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
+
 #ifndef	__HALBTC_OUT_SRC_H__
 #define __HALBTC_OUT_SRC_H__
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index cce4a37ea408..d9c9bfe38399 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -1,27 +1,6 @@
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
+// SPDX/-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2013  Realtek Corporation.*/
+
 #include "../wifi.h"
 #include <linux/vmalloc.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index 8c996055de71..622586d5f7c3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
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
 
 #ifndef __RTL_BTC_H__
 #define __RTL_BTC_H__
-- 
2.20.1

