Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1869 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758253Ab1JFOKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 10:10:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/15] staging: brcm80211: move driver variable
 functions to srom.c
Date: Wed, 5 Oct 2011 15:20:00 +0200
Message-ID: <1317820814-7083-2-git-send-email-arend@broadcom.com> (sfid-20111006_161023_314944_4F32C4D1)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver uses variables which are stored in string format. Using
strings as variable identifiers is disliked by the community. The
driver has been cleaned up and the only module providing these
variables is srom.c. The variable retrieval functions have been
moved to srom.c in preparation of a more likable way to store and
lookup these driver variables.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   44 -----------------------------
 drivers/staging/brcm80211/brcmsmac/srom.c |   44 +++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 9fa8485..100e6ec 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -8881,47 +8881,3 @@ void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc)
 	wlc->mpc = mpc;
 	brcms_c_radio_mpc_upd(wlc);
 }
-
-/*
- * Search the name=value vars for a specific one and return its value.
- * Returns NULL if not found.
- */
-char *getvar(char *vars, const char *name)
-{
-	char *s;
-	int len;
-
-	if (!name)
-		return NULL;
-
-	len = strlen(name);
-	if (len == 0)
-		return NULL;
-
-	/* first look in vars[] */
-	for (s = vars; s && *s;) {
-		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
-			return &s[len + 1];
-
-		while (*s++)
-			;
-	}
-	/* nothing found */
-	return NULL;
-}
-
-/*
- * Search the vars for a specific one and return its value as
- * an integer. Returns 0 if not found.
- */
-int getintvar(char *vars, const char *name)
-{
-	char *val;
-	unsigned long res;
-
-	val = getvar(vars, name);
-	if (val && !kstrtoul(val, 0, &res))
-		return res;
-
-	return 0;
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 13d17eb..02dbd98 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1242,3 +1242,47 @@ int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
 
 	return -EINVAL;
 }
+
+/*
+ * Search the name=value vars for a specific one and return its value.
+ * Returns NULL if not found.
+ */
+char *getvar(char *vars, const char *name)
+{
+	char *s;
+	int len;
+
+	if (!name)
+		return NULL;
+
+	len = strlen(name);
+	if (len == 0)
+		return NULL;
+
+	/* first look in vars[] */
+	for (s = vars; s && *s;) {
+		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
+			return &s[len + 1];
+
+		while (*s++)
+			;
+	}
+	/* nothing found */
+	return NULL;
+}
+
+/*
+ * Search the vars for a specific one and return its value as
+ * an integer. Returns 0 if not found.
+ */
+int getintvar(char *vars, const char *name)
+{
+	char *val;
+	unsigned long res;
+
+	val = getvar(vars, name);
+	if (val && !kstrtoul(val, 0, &res))
+		return res;
+
+	return 0;
+}
-- 
1.7.4.1


