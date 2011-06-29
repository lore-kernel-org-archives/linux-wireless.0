Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4613 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 042/119] staging: brcm80211: replace macro
 BCM_MSG_IFNAME_MAX with IFNAMSIZ
Date: Wed, 29 Jun 2011 16:47:06 -0700
Message-ID: <1309391303-22741-43-git-send-email-frankyl@broadcom.com> (sfid-20110630_014933_818855_34F04BAA)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In dhd.h the macro BCM_MSG_IFNAME_MAX was defined and used. As this
is used to carry the interface name we might as well use IFNAMSIZ
which results in the same size.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 9b27982..55cbd8a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -136,8 +136,6 @@ struct dhd_info;
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
 
-#define BCM_MSG_IFNAME_MAX		16
-
 #define WLC_EVENT_MSG_LINK		0x01
 #define WLC_EVENT_MSG_FLUSHTXQ		0x02
 #define WLC_EVENT_MSG_GROUP		0x04
@@ -151,7 +149,7 @@ typedef struct {
 	u32 auth_type;
 	u32 datalen;
 	u8 addr[ETH_ALEN];
-	char ifname[BCM_MSG_IFNAME_MAX];
+	char ifname[IFNAMSIZ];
 } __attribute__((packed)) wl_event_msg_t;
 
 typedef  struct bcmeth_hdr {
-- 
1.7.1


