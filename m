Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F06C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A2621872
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 19:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bI0iT7N2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502920AbfBNT7f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 14:59:35 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38687 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437150AbfBNT7e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 14:59:34 -0500
Received: by mail-ot1-f68.google.com with SMTP id m1so12677438otf.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 11:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FGDS75QqSBSJuB8oH7wueiG2kVtWqF/nwUQ2AeMG8Ow=;
        b=bI0iT7N2NlGccrr1V+1i5lv7ZuTESRPstyChBsSOLxLtEARh5gd86ucC3N3xC52Nlt
         Naygaag31a+hwbm9vYf4Y1/ggq2i//XQ+E4EZwW25XuQPipKNMmS2Ay7TkkFfV/6+7I4
         +TXALPAFwrou16Ik2UKSM5i3DO+Xl5lb42fqTj8EP4SpZSd3cKiO7/rlieNrKaJ8FSlL
         svY/pKZcs2QgGid/u8KicYCY1Gj1/YCFic5rr0yU5CRNfHyEmoSG3NQQMUPWVfnhyu9i
         pJuLM65lXCjGq7ej3+YqOiYIYLG190svk0H8AwvIhZp3KmnRBhXhKu/POvsDbBdMi4vG
         OJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=FGDS75QqSBSJuB8oH7wueiG2kVtWqF/nwUQ2AeMG8Ow=;
        b=tEorLlcWIoNqcvPRkq2xuMuFt8RbFq3J6k3uFbrAc78e2OUWypS3imWWzOh4pEDVrI
         lXxWfQrgiNK6IjaKdrS+oJAeBWGKq6rmyXW6qOMHzKN8Xru2xk1212rWUfy74JbuFvJ8
         Z4HhOI3rG1ZatYyD6tmoETVfVbo/OGCIeJ92mMqUClGauBgEF6A7bYuMmIetthal5Z2L
         Nu8ZOIycBUeLCgWD76Ti3RyorON0tO6LfrO3Fq2+4QVxZYIkKaBjdyf76y0BTBmKeWQh
         dB4ERfR25G59q4BK7k//s3eQuXyXTwS4Rzd6sTMEdtvj55Kdn0BJCwRoeF8r3D6skQTL
         fPCw==
X-Gm-Message-State: AHQUAuYAu1LrsQNoJoPFmBnnjqNwyd1EUpUQYDu4XgcJogzyhkMtszWo
        6SXQsnE71agvpl8Doh3b5o8=
X-Google-Smtp-Source: AHgI3Ib7OtZn7GG0Mcezm31Bpws1wfZGCc9sLcgVJfGB2UcA2vBGJvFXyceCqNe2vcpC1Py3+WXmZQ==
X-Received: by 2002:aca:1117:: with SMTP id 23mr3278390oir.55.1550174373429;
        Thu, 14 Feb 2019 11:59:33 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v20sm873519oto.31.2019.02.14.11.59.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 11:59:32 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v3 05/13] rtlwifi: rtl8192ce: Replace old-style license information
Date:   Thu, 14 Feb 2019 13:59:12 -0600
Message-Id: <20190214195920.1504-6-Larry.Finger@lwfinger.net>
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

 .../wireless/realtek/rtlwifi/rtl8192ce/def.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/dm.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/dm.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/led.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/led.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/reg.h  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/rf.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/rf.h   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/sw.c   | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/sw.h   | 26 ++---------------
 .../realtek/rtlwifi/rtl8192ce/table.c         | 28 ++-----------------
 .../realtek/rtlwifi/rtl8192ce/table.h         | 28 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  | 26 ++---------------
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.h  | 26 ++---------------
 18 files changed, 36 insertions(+), 436 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
index d2005d7e9ad2..698adf9ba783 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
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
 
 #ifndef __RTL92C_DEF_H__
 #define __RTL92C_DEF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.c
index 2c8205e46be4..12cfbd424845 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.c
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
 #include "../base.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
index 9761d0ca31b0..7132696a4f50 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
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
 
 #ifndef	__RTL92C_DM_H__
 #define __RTL92C_DM_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 543b6dfb5279..2602e384fa94 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
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
 #include "../efuse.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
index 6711ea1a75d9..2eae561f4538 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
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
 
 #ifndef __RTL92CE_HW_H__
 #define __RTL92CE_HW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
index 7edf5af9046e..ec09d55bb8f8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.h
index f6edb9cd9b67..f9e92cc4a82a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.h
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
 
 #ifndef __RTL92CE_LED_H__
 #define __RTL92CE_LED_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index 7c6d7fc1ef9a..f9a86a5d74e0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
index 93f3bc0197b4..f86dcd7cfe1c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
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
 
 #ifndef __RTL92C_PHY_H__
 #define __RTL92C_PHY_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
index 9e3b58a5d2bb..4f003ff83630 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
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
 
 #ifndef __RTL92C_REG_H__
 #define __RTL92C_REG_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
index e68ed7f37c79..cf150e6f6d75 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
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
 #include "reg.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.h
index 22c5e6f51331..fcc682cfa0e1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.h
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
 
 #ifndef __RTL92C_RF_H__
 #define __RTL92C_RF_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index 71a6761d3648..032134aac686 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
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
 #include "../core.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
index 9a1c89cbbda1..c3dd5e3a21d6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
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
 
 #ifndef __RTL92CE_SW_H__
 #define __RTL92CE_SW_H__
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
index 98b06d48a2dd..2131c237bed9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
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
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #include "table.h"
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.h
index 51e4e07396a6..a89f0e954f29 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.h
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
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2009-2012  Realtek Corporation.*/
 
 #ifndef __RTL92CE_TABLE__H_
 #define __RTL92CE_TABLE__H_
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index d36e0060cc7a..2e8f77876a81 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.h
index 91f0bd6b752f..4daba7b367eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.h
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
 
 #ifndef __RTL92CE_TRX_H__
 #define __RTL92CE_TRX_H__
-- 
2.20.1

