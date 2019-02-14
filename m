Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6D8C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8C78222DA
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 17:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMJdibT9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437232AbfBNRBP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 12:01:15 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38092 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437230AbfBNRBO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 12:01:14 -0500
Received: by mail-ot1-f68.google.com with SMTP id m1so11692472otf.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 09:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JeRLAwRc2DTfTsGea1JKHh9Ofa0B41a3QwaPd6jd4mk=;
        b=dMJdibT9YLGtc6v8P0uYz+tk9w/R6rrs0Iu8O+ZVg+NGNPB+FzsywcEPiIcY+WHHdY
         IRx8R8/VhUww60QJ/ZcTtzBrCFDu6VXvtv5PEznczZY3EVxXUhXHnteAMEzm6c0+x+dm
         GQcDIHiEPIwQNcqdwShuupjQ4l44TuOuQ8Z7Rw8ApdysCmvuzB9CTBESAAeM/V26EHZw
         KvaVnLxDbQAi7iHGlWlin2bdFra90QBzrCw3fUV8PjzWP2njPgfge2gYVyL9StaDDjJu
         q5DatkHUfmdenSW/mQ+F7c7wOtq9eSwhEYgkCBAWjCFIp8ZVpZgiCJ2Lc2P/KqbCVpRR
         fqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=JeRLAwRc2DTfTsGea1JKHh9Ofa0B41a3QwaPd6jd4mk=;
        b=tfUTtayQ4X8onrJliGT9Wc5TSPc0+2OjCIz7WLJx5cHTDtF0Wadawf7aAn5eNVvIkk
         lXLSs0FKLKK6V+eQjcKWAPdiSBvqUrjDs/tGX5q/LOXyyp8k+vDk0dWMqie4jUSa/pQl
         f6sMi29T+feotqVJBu2K1WBZOqPV+2fCRs79jH0lnV7999oVS933iLRtcFcW0m4Fq4fD
         EkigvxKtrVZnNUZNCTGtDnx8CIivINFu2Imb0Mt6WAVwisGTY0nm9U8Jw6uCirpgw+Tn
         NMDWGHDD9ShyiK2SqNJtnss5P8hKAG6jkrFK/cMuq5it2J1aEQi7YNZQDJsbBa8cX38C
         akqA==
X-Gm-Message-State: AHQUAuZeUv8ubAfHa4AS9yFWlY0FmsnetRB5JJBkqFxwqmt3qlZUMWU5
        6DNGoTmXYV1DX12/n7o+hUo=
X-Google-Smtp-Source: AHgI3IbPkVlZ9BcbnKrCKhsf4yfy9zyOfPOBmYxgi1dFo1NInzAucbTw04ULG7kOVoCIqe/papbZKQ==
X-Received: by 2002:a9d:468:: with SMTP id 95mr2911074otc.312.1550163671650;
        Thu, 14 Feb 2019 09:01:11 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l5sm1158327oil.15.2019.02.14.09.01.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 09:01:10 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 08/13] rtlwifi: rtl8192ee: Replace old-style license information
Date:   Thu, 14 Feb 2019 11:00:38 -0600
Message-Id: <20190214170043.3705-9-Larry.Finger@lwfinger.net>
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
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
+// SPDX/-License-Identifier: GPL-2.0
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2014  Realtek Corporation.*/
 
 #ifndef __RTL92E_TRX_H__
 #define __RTL92E_TRX_H__
-- 
2.20.1

