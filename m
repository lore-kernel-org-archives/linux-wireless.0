Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34094 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbcFSQjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2016 12:39:39 -0400
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
Subject: [PATCH V2 RFC 1/2] brcmfmac: delete interface directly in code that sent fw request
Date: Sun, 19 Jun 2016 18:23:24 +0200
Message-Id: <1466353420-30998-1-git-send-email-zajec5@gmail.com> (sfid-20160619_183943_148193_7333077D)
In-Reply-To: <1466273932-11554-1-git-send-email-zajec5@gmail.com>
References: <1466273932-11554-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far when receiving event about in-firmware-interface removal our
event worker was notifying listener and afterwards it was removing Linux
interface.

First of all it was resulting in slightly unexpected order. The listener
(del_virtual_intf callback) was (usually) returning with success before
we even called unregister_netdev(ice).

Please note this couldn't be simply fixed by changing order of calls in
brcmf_fweh_handle_if_event as unregistering interface earlier could free
struct brcmf_if.

Another problem of current implementation are possible lockups. Focus on
the time slot between calling event handler and removing Linux
interface. During that time original caller may leave (unlocking rtnl
semaphore) *and* another call to the same code may be done (locking it
again). If that happens our event handler will stuck at removing Linux
interface, it won't handle another event and will block process holding
rtnl lock.

This can be simply solved by unregistering interface in a proper
callback, right after receiving confirmation event from firmware. This
only required modifying worker to don't unregister on its own if there
is someone waiting for the event.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Modification of brcmf_fweh_handle_if_event done in V1 was a wrong
    idea as it could result in use-after-free regarding struct brcmf_if.
    Thanks Arend for noticing that!
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 10 ++++++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c  |  3 +--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 9da7a4c..79c081f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -18,6 +18,7 @@
 #include "brcmu_wifi.h"
 #include "brcmu_utils.h"
 
+#include "cfg80211.h"
 #include "core.h"
 #include "debug.h"
 #include "tracepoint.h"
@@ -182,8 +183,13 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
-	if (ifp && ifevent->action == BRCMF_E_IF_DEL)
-		brcmf_remove_interface(ifp, false);
+	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
+		bool armed = brcmf_cfg80211_vif_event_armed(drvr->config);
+
+		/* Default handling in case no-one waits for this event */
+		if (!armed)
+			brcmf_remove_interface(ifp, false);
+	}
 }
 
 /**
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index f6241fd..66f942f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2288,8 +2288,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 		else
 			err = 0;
 	}
-	if (err)
-		brcmf_remove_interface(vif->ifp, true);
+	brcmf_remove_interface(vif->ifp, true);
 
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (vif->wdev.iftype != NL80211_IFTYPE_P2P_DEVICE)
-- 
1.8.4.5

