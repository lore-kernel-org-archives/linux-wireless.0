Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:48662 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaILOTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 10:19:40 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	<stable@vger.kernel.org>
Subject: [PATCH for-3.17] brcmfmac: handle IF event for P2P_DEVICE interface
Date: Fri, 12 Sep 2014 16:19:30 +0200
Message-ID: <1410531570-9360-1-git-send-email-arend@broadcom.com> (sfid-20140912_161944_870552_608A01FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware notifies about interface changes through the IF event
which has a NO_IF flag that means host can ignore the event. This
behaviour was introduced in the driver by:

  commit 2ee8382fc6c763c76396a6aaff77a27089eed3aa
  Author: Arend van Spriel <arend@broadcom.com>
  Date:   Sat Aug 10 12:27:24 2013 +0200

      brcmfmac: ignore IF event if firmware indicates it

It turns out that the IF event for the P2P_DEVICE also has this
flag set, but the event should not be ignored in this scenario.
The mentioned commit caused a regression in 3.12 kernel in creation
of the P2P_DEVICE interface.

Cc: <stable@vger.kernel.org> # 3.14, 3.16
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Here is another straggling patch. This patch is intended for the
3.17 and some stable kernels. It applies to the master branch of
the wireless repository.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 12 +++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |  2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 4f1daab..44fc85f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -185,7 +185,13 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		  ifevent->action, ifevent->ifidx, ifevent->bssidx,
 		  ifevent->flags, ifevent->role);
 
-	if (ifevent->flags & BRCMF_E_IF_FLAG_NOIF) {
+	/* The P2P Device interface event must not be ignored
+	 * contrary to what firmware tells us. The only way to
+	 * distinguish the P2P Device is by looking at the ifidx
+	 * and bssidx received.
+	 */
+	if (!(ifevent->ifidx == 0 && ifevent->bssidx == 1) &&
+	    (ifevent->flags & BRCMF_E_IF_FLAG_NOIF)) {
 		brcmf_dbg(EVENT, "event can be ignored\n");
 		return;
 	}
@@ -210,12 +216,12 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 				return;
 	}
 
-	if (ifevent->action == BRCMF_E_IF_CHANGE)
+	if (ifp && ifevent->action == BRCMF_E_IF_CHANGE)
 		brcmf_fws_reset_interface(ifp);
 
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
-	if (ifevent->action == BRCMF_E_IF_DEL) {
+	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
 		brcmf_fws_del_interface(ifp);
 		brcmf_del_if(drvr, ifevent->bssidx);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index dd20b18..cbf033f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -172,6 +172,8 @@ enum brcmf_fweh_event_code {
 #define BRCMF_E_IF_ROLE_STA			0
 #define BRCMF_E_IF_ROLE_AP			1
 #define BRCMF_E_IF_ROLE_WDS			2
+#define BRCMF_E_IF_ROLE_P2P_GO			3
+#define BRCMF_E_IF_ROLE_P2P_CLIENT		4
 
 /**
  * definitions for event packet validation.
-- 
1.9.1

