Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62611 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaESI3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 04:29:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 12/13] brcmsmac: make return of 0 explicit
Date: Mon, 19 May 2014 10:29:29 +0200
Message-ID: <1400488169-6805-1-git-send-email-arend@broadcom.com> (sfid-20140519_102951_716119_50D2E59F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
[arend@broadcom.com: make brcms_b_detach() a void function]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Julia,

Thanks for running this over brcmsmac driver. I took it a
step further. So this replaces your patch with Message-ID:
 <1400473875-22228-13-git-send-email-Julia.Lawall@lip6.fr>

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9417cb5..af8ba64 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4870,14 +4870,11 @@ static void brcms_c_detach_module(struct brcms_c_info *wlc)
 /*
  * low level detach
  */
-static int brcms_b_detach(struct brcms_c_info *wlc)
+static void brcms_b_detach(struct brcms_c_info *wlc)
 {
 	uint i;
 	struct brcms_hw_band *band;
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	int callbacks;
-
-	callbacks = 0;
 
 	brcms_b_detach_dmapio(wlc_hw);
 
@@ -4900,9 +4897,6 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
 		ai_detach(wlc_hw->sih);
 		wlc_hw->sih = NULL;
 	}
-
-	return callbacks;
-
 }
 
 /*
@@ -4917,14 +4911,15 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
  */
 uint brcms_c_detach(struct brcms_c_info *wlc)
 {
-	uint callbacks = 0;
+	uint callbacks;
 
 	if (wlc == NULL)
 		return 0;
 
-	callbacks += brcms_b_detach(wlc);
+	brcms_b_detach(wlc);
 
 	/* delete software timers */
+	callbacks = 0;
 	if (!brcms_c_radio_monitor_stop(wlc))
 		callbacks++;
 
-- 
1.8.2.1

