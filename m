Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54810 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0LEPo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 10:44:29 -0500
Received: by wwa36 with SMTP id 36so11925377wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Dec 2010 07:44:28 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: comes@naic.edu, sedat.dilek@googlemail.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 1/2] orinoco: fix TKIP countermeasure behaviour
Date: Sun,  5 Dec 2010 15:43:55 +0000
Message-Id: <1291563835-300-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <AANLkTi=nS+Du=CEk4=zqekJty=XnBjTUAj49L0Njz5BP@mail.gmail.com>
References: <AANLkTi=nS+Du=CEk4=zqekJty=XnBjTUAj49L0Njz5BP@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the port when disabling countermeasures, and disable it on
enabling countermeasures.

This bug causes the response of the system to certain attacks to be
ineffective.

It also prevents wpa_supplicant from getting scan results, as
wpa_supplicant disables countermeasures on startup - preventing the
hardware from scanning.

wpa_supplicant works with ap_mode=2 despite this bug because the commit
handler re-enables the port.

The log tends to look like:

State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 5 seconds
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
Scan timeout - try to get results
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.

Reported by: Giacomo Comes <comes@naic.edu>
Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/wext.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 519e01e..9caec9f 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -912,10 +912,10 @@ static int orinoco_ioctl_set_auth(struct net_device *dev,
 		 */
 		if (param->value) {
 			priv->tkip_cm_active = 1;
-			ret = hermes_enable_port(hw, 0);
+			ret = hermes_disable_port(hw, 0);
 		} else {
 			priv->tkip_cm_active = 0;
-			ret = hermes_disable_port(hw, 0);
+			ret = hermes_enable_port(hw, 0);
 		}
 		break;
 
-- 
1.7.2.2

