Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24727 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbaIWJwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 05:52:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: <stable@vger.kernel.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH for-3.12] brcmfmac: handle IF event for P2P_DEVICE interface
Date: Tue, 23 Sep 2014 11:52:26 +0200
Message-ID: <1411465946-27161-1-git-send-email-arend@broadcom.com> (sfid-20140923_115240_212930_7346430D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

upstream: 87c4790330810fe5caf0172d9320cf24ef19cebe

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

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index fad77dd..3f9cb89 100644
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
-- 
1.9.1

