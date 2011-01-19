Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab1ASWfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:35:08 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:35:07 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 8/8] staging: brcm80211: Remove proto/ethernet.h.
Date: Wed, 19 Jan 2011 23:35:32 +0100
Message-Id: <1295476532-21130-9-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-8-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-4-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-5-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-6-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-7-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-8-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since proto/ethernet.h now is empty except for one include, delete it and add
the single include where necessary.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    1 -
 drivers/staging/brcm80211/include/proto/802.11.h   |    2 +
 drivers/staging/brcm80211/include/proto/bcmevent.h |    2 +
 drivers/staging/brcm80211/include/proto/ethernet.h |   22 --------------------
 drivers/staging/brcm80211/include/proto/wpa.h      |    2 -
 drivers/staging/brcm80211/include/wlioctl.h        |    1 -
 drivers/staging/brcm80211/util/bcmsrom.c           |    2 -
 drivers/staging/brcm80211/util/bcmutils.c          |    1 -
 13 files changed, 4 insertions(+), 34 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/include/proto/ethernet.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 71c5203..cdeed33 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -36,7 +36,6 @@
 #include <bcmutils.h>
 #include <bcmendian.h>
 
-#include <proto/ethernet.h>
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <dhd_bus.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 3edce44..383416d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -44,7 +44,6 @@
 #include <sbsdpcmdev.h>
 #include <bcmsdpcm.h>
 
-#include <proto/ethernet.h>
 #include <proto/802.1d.h>
 #include <proto/802.11.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index c7e3837..f27524c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -20,7 +20,6 @@
 
 #include <bcmutils.h>
 #include <bcmendian.h>
-#include <proto/ethernet.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 482691b..b4734d1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -20,7 +20,6 @@
 #include <linux/wireless.h>
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
-#include <proto/ethernet.h>
 #include <wlioctl.h>
 
 struct wl_conf;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 346b190..85a2884 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -23,7 +23,6 @@
 
 #include <bcmutils.h>
 #include <bcmendian.h>
-#include <proto/ethernet.h>
 
 #include <linux/if_arp.h>
 #include <asm/uaccess.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index c8637c5..ef5c72d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -19,7 +19,6 @@
 
 #include <linux/wireless.h>
 
-#include <proto/ethernet.h>
 #include <wlioctl.h>
 
 #define WL_SCAN_PARAMS_SSID_MAX	10
diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index 11940fe..6bb1802 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -17,6 +17,8 @@
 #ifndef _802_11_H_
 #define _802_11_H_
 
+#include <linux/if_ether.h>
+
 #include <proto/wpa.h>
 #include <packed_section_start.h>
 
diff --git a/drivers/staging/brcm80211/include/proto/bcmevent.h b/drivers/staging/brcm80211/include/proto/bcmevent.h
index 5802ea0..68d30c9 100644
--- a/drivers/staging/brcm80211/include/proto/bcmevent.h
+++ b/drivers/staging/brcm80211/include/proto/bcmevent.h
@@ -17,6 +17,8 @@
 #ifndef _BCMEVENT_H_
 #define _BCMEVENT_H_
 
+#include <linux/if_ether.h>
+
 #include <packed_section_start.h>
 
 #define BCM_EVENT_MSG_VERSION		1
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
deleted file mode 100644
index f52f430..0000000
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ /dev/null
@@ -1,22 +0,0 @@
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
-#ifndef _NET_ETHERNET_H_
-#define _NET_ETHERNET_H_
-
-#include <linux/if_ether.h>
-
-#endif				/* _NET_ETHERNET_H_ */
diff --git a/drivers/staging/brcm80211/include/proto/wpa.h b/drivers/staging/brcm80211/include/proto/wpa.h
index 10c2fb6..5ffcffd 100644
--- a/drivers/staging/brcm80211/include/proto/wpa.h
+++ b/drivers/staging/brcm80211/include/proto/wpa.h
@@ -17,8 +17,6 @@
 #ifndef _proto_wpa_h_
 #define _proto_wpa_h_
 
-#include <proto/ethernet.h>
-
 #define WPA2_PMKID_LEN	16
 #define RSN_CAP_1_REPLAY_CNTR		0
 #define RSN_CAP_2_REPLAY_CNTRS		1
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 9b85f31..06989fa 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -17,7 +17,6 @@
 #ifndef _wlioctl_h_
 #define	_wlioctl_h_
 
-#include <proto/ethernet.h>
 #ifdef BRCM_FULLMAC
 #include <proto/bcmeth.h>
 #endif
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 79038e0..fa696ee 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -44,8 +44,6 @@
 #include <sbsdpcmdev.h>
 #endif
 
-#include <proto/ethernet.h>	/* for sprom content groking */
-
 #define	BS_ERROR(args)
 
 #define SROM_OFFSET(sih) ((sih->ccrev > 31) ? \
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index caab133..258fd90 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -28,7 +28,6 @@
 #include <bcmnvram.h>
 #include <bcmendian.h>
 #include <bcmdevs.h>
-#include <proto/ethernet.h>
 #include <proto/802.1d.h>
 #include <proto/802.11.h>
 
-- 
1.5.6.5

