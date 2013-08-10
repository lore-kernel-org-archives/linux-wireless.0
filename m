Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2732 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968551Ab3HJK14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/12] brcmfmac: ignore IF event if firmware indicates
 it
Date: Sat, 10 Aug 2013 12:27:24 +0200
Message-ID: <1376130450-29746-7-git-send-email-arend@broadcom.com> (sfid-20130810_123908_754531_8D6ABC8B)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not every IF event from the firmware needs to result in a
related interface, netdev or wdev, on the host. This is
indicated in the event message. Handle that flag and effectively
ignore the firmware event.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h  | 2 ++
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 1273dfd..2eb9e64 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -194,6 +194,8 @@
 #define BRCMF_E_IF_DEL				2
 #define BRCMF_E_IF_CHANGE			3
 
+#define BRCMF_E_IF_FLAG_NOIF			1
+
 #define BRCMF_E_IF_ROLE_STA			0
 #define BRCMF_E_IF_ROLE_AP			1
 #define BRCMF_E_IF_ROLE_WDS			2
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 83ee53a..fad77dd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -185,6 +185,10 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		  ifevent->action, ifevent->ifidx, ifevent->bssidx,
 		  ifevent->flags, ifevent->role);
 
+	if (ifevent->flags & BRCMF_E_IF_FLAG_NOIF) {
+		brcmf_dbg(EVENT, "event can be ignored\n");
+		return;
+	}
 	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
 		brcmf_err("invalid interface index: %u\n",
 			  ifevent->ifidx);
-- 
1.8.1.3


