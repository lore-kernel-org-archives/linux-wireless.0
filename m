Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4963 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 48/83] staging: brcm80211: remove phy_version.h
Date: Wed, 1 Jun 2011 13:45:33 +0200
Message-ID: <1306928768-7501-48-git-send-email-rvossen@broadcom.com> (sfid-20110601_134717_400912_8806C20C)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Removed the file phy_version.h from the driver sources. It was not
used. For keeping track of the phy version, which is a separately
developed component, one definition has been kept and placed in
wlc_phy_int.h.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/phy_version.h   |   36 --------------------
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    2 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    1 -
 3 files changed, 2 insertions(+), 37 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/phy/phy_version.h

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_version.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_version.h
deleted file mode 100644
index 51a2238..0000000
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_version.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef phy_version_h_
-#define phy_version_h_
-
-#define	PHY_MAJOR_VERSION		1
-
-#define	PHY_MINOR_VERSION		82
-
-#define	PHY_RC_NUMBER		8
-
-#define	PHY_INCREMENTAL_NUMBER	0
-
-#define	PHY_BUILD_NUMBER		0
-
-#define	PHY_VERSION			{ 1, 82, 8, 0 }
-
-#define	PHY_VERSION_NUM		0x01520800
-
-#define	PHY_VERSION_STR		"1.82.8.0"
-
-#endif				/* phy_version_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 51e37aa..92064ba 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -23,6 +23,8 @@
 
 #include <wlc_phy_hal.h>
 
+#define	PHY_VERSION			{ 1, 82, 8, 0 }
+
 #define PHYHAL_ERROR	0x0001
 #define PHYHAL_TRACE	0x0002
 #define PHYHAL_INFORM	0x0004
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 0f4a1cc..6856a60 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -36,7 +36,6 @@
 #include "d11.h"
 #include "wlc_types.h"
 #include "wlc_cfg.h"
-#include "phy/phy_version.h"
 #include "wlc_key.h"
 #include "wlc_channel.h"
 #include "wlc_scb.h"
-- 
1.7.4.1


