Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36513 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbcFRSTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 14:19:15 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RFC 1/2] brcmfmac: remove interface before notifying listener
Date: Sat, 18 Jun 2016 20:18:34 +0200
Message-Id: <1466273932-11554-1-git-send-email-zajec5@gmail.com> (sfid-20160618_202007_774465_4D841A40)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far when receiving event about in-firmware-interface removal we were
notifying our listener and afterwards we were removing Linux interface.

This order was most likely a try to avoid a lockup. Removing in-firmware
interface could be requested by a driver code holding rtnl lock. Such
code waits for a corresponding event (still holding rtnl lock) which
prevents us from calling unregister_netdev. Notifying listener first
allowed it to release rtnl lock and removing interface succesfully.

Please note we couldn't switch to unregister_netdevice as interface
removal event could also occur in other (unpredictable) moments.

Unfortunately above workaround doesn't work in some corner cases. Focus
on the time slot between calling event handler and removing Linux
interface. During that time original caller may leave (unlocking rtnl
semaphore) *and* another call to the same code may be done (locking it
again). If that happens our event handler will stuck at removing Linux
interface, it won't handle another event and will block process holding
rtnl lock.

So the real solution is to remove interface before notifying listener.
We just need to know if rtnl is hold by a caller that triggered our
event.

Moreover this changes makes sure we call unregister_netdevice before
del_virtual_intf leaves which isn't critical but it makes a bit more of
sense to handle it this way.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 9da7a4c..5fd1886 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -18,6 +18,7 @@
 #include "brcmu_wifi.h"
 #include "brcmu_utils.h"
 
+#include "cfg80211.h"
 #include "core.h"
 #include "debug.h"
 #include "tracepoint.h"
@@ -180,10 +181,16 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 	if (ifp && ifevent->action == BRCMF_E_IF_CHANGE)
 		brcmf_fws_reset_interface(ifp);
 
-	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
+	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
+		bool rtnl_locked = brcmf_cfg80211_vif_event_armed(drvr->config);
+
+		brcmf_remove_interface(ifp, rtnl_locked);
+	}
 
-	if (ifp && ifevent->action == BRCMF_E_IF_DEL)
-		brcmf_remove_interface(ifp, false);
+	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
+	if (err)
+		brcmf_err("event %d handler failed (%d)\n", emsg->event_code,
+			  err);
 }
 
 /**
-- 
1.8.4.5

