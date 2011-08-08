Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3078 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab1HHN7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 42/82] staging: brcm80211: replace simple_strtoul
 usage in brcmsmac
Date: Mon, 8 Aug 2011 15:58:26 +0200
Message-ID: <1312811946-16713-43-git-send-email-arend@broadcom.com> (sfid-20110808_155940_617726_1C72C1C2)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The usage of simple_strtoul is not preferred. Instead kstrtoul
should be used. This patch fixes this for the brcmsmac driver.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c        |   16 +++++++++-------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    7 ++++---
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 5c97778..001a1f7 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4287,16 +4287,17 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 #endif
 	if (bustype != SI_BUS) {
 		char *var;
+		unsigned long res;
 
 		var = getvar(vars, "vendid");
-		if (var) {
-			vendor = (u16) simple_strtoul(var, NULL, 0);
+		if (var && !kstrtoul(var, 0, &res)) {
+			vendor = (u16)res;
 			wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
 				  vendor);
 		}
 		var = getvar(vars, "devid");
-		if (var) {
-			u16 devid = (u16) simple_strtoul(var, NULL, 0);
+		if (var && !kstrtoul(var, 0, &res)) {
+			u16 devid = (u16)res;
 			if (devid != 0xffff) {
 				device = devid;
 				wiphy_err(wiphy, "Overriding device id = 0x%x"
@@ -9596,10 +9597,11 @@ char *getvar(char *vars, const char *name)
 int getintvar(char *vars, const char *name)
 {
 	char *val;
+	unsigned long res;
 
 	val = getvar(vars, name);
-	if (val == NULL)
-		return 0;
+	if (val && !kstrtoul(val, 0, &res))
+		return res;
 
-	return simple_strtoul(val, NULL, 0);
+	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 582df4a..22f7bfc 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -174,12 +174,13 @@ char *phy_getvar(struct brcms_phy *pi, const char *name)
 int phy_getintvar(struct brcms_phy *pi, const char *name)
 {
 	char *val;
+	unsigned long res;
 
 	val = PHY_GETVAR(pi, name);
-	if (val == NULL)
-		return 0;
+	if (val && !kstrtoul(val, 0, &res))
+		return res;
 
-	return simple_strtoul(val, NULL, 0);
+	return 0;
 }
 
 void wlc_phyreg_enter(struct brcms_phy_pub *pih)
-- 
1.7.4.1


