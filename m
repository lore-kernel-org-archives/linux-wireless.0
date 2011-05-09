Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3433 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab1EIOd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 8/9] staging: brcm80211: move functions only used by
 brcmsmac out of utils
Date: Mon, 9 May 2011 16:33:09 +0200
Message-ID: <1304951590-2411-9-git-send-email-arend@broadcom.com> (sfid-20110509_163742_843188_C8D5DD4F)
In-Reply-To: <1304951590-2411-1-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The functions gitvar() and getintvar() are only used by brcmsmac, so move them
out of the bcmutils.c file, which is shared by both brcmsmac and brcmfmac.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    1 +
 drivers/staging/brcm80211/brcmsmac/nvram.c         |   43 ++++++++++++++++++
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    1 +
 drivers/staging/brcm80211/include/bcmnvram.h       |    4 ++
 drivers/staging/brcm80211/include/bcmutils.h       |    3 -
 drivers/staging/brcm80211/util/bcmutils.c          |   47 --------------------
 13 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 5a127d2..18b844a 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -19,6 +19,7 @@
 #include <linux/pci.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
+#include <bcmnvram.h>
 #include <aiutils.h>
 #include <hndsoc.h>
 #include <bcmdevs.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/nvram.c b/drivers/staging/brcm80211/brcmsmac/nvram.c
index 0e93a55..830e30f 100644
--- a/drivers/staging/brcm80211/brcmsmac/nvram.c
+++ b/drivers/staging/brcm80211/brcmsmac/nvram.c
@@ -108,6 +108,49 @@ static char *findvar(char *vars, char *lim, const char *name)
 	return NULL;
 }
 
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
+	/* then query nvram */
+	return nvram_get(name);
+}
+
+/*
+ * Search the vars for a specific one and return its value as
+ * an integer. Returns 0 if not found.
+ */
+int getintvar(char *vars, const char *name)
+{
+	char *val;
+
+	val = getvar(vars, name);
+	if (val == NULL)
+		return 0;
+
+	return simple_strtoul(val, NULL, 0);
+}
+
 char *nvram_get(const char *name)
 {
 	char *v = NULL;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index 8fc1bef..a28633c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -22,6 +22,7 @@
 #include <linux/pci.h>
 #include <aiutils.h>
 #include <wlc_pmu.h>
+#include <bcmnvram.h>
 
 #include <bcmdevs.h>
 #include <sbhnddma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 9f2e5a2..2dd7c7b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -30,6 +30,7 @@
 #include <bcmdefs.h>
 #include <bcmwifi.h>
 #include <bcmutils.h>
+#include <bcmnvram.h>
 #include <pcicfg.h>
 #include <wlioctl.h>
 #include <sbhnddma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index a8037e9..3d9485a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -22,6 +22,7 @@
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
+#include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmdevs.h>
 #include <sbhnddma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 91d366d..cf0d2bf 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -29,6 +29,7 @@
 #include <bcmsrom.h>
 #include <bcmotp.h>
 #include <bcmutils.h>
+#include <bcmnvram.h>
 #include <wlioctl.h>
 #include <sbconfig.h>
 #include <sbchipc.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index bde82bd..fe3e392 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -21,6 +21,7 @@
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
+#include <bcmnvram.h>
 #include <aiutils.h>
 #include <sbhnddma.h>
 #include <wlioctl.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 4d8fa34..3eaabe9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -23,6 +23,7 @@
 #include <bcmdevs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
+#include <bcmnvram.h>
 #include <aiutils.h>
 #include <pcicfg.h>
 #include <bcmsrom.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 5b1697a..82986bd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -21,6 +21,7 @@
 #include <bcmdevs.h>
 #include <sbchipc.h>
 #include <bcmutils.h>
+#include <bcmnvram.h>
 #include "wlc_pmu.h"
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index aa8d42d..c4f5817 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -24,6 +24,7 @@
 #include <aiutils.h>
 #include <wlioctl.h>
 #include <bcmwifi.h>
+#include <bcmnvram.h>
 #include <sbhnddma.h>
 
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/include/bcmnvram.h b/drivers/staging/brcm80211/include/bcmnvram.h
index e194131..e58151c 100644
--- a/drivers/staging/brcm80211/include/bcmnvram.h
+++ b/drivers/staging/brcm80211/include/bcmnvram.h
@@ -147,6 +147,10 @@ u8 nvram_calc_crc(struct nvram_header *nvh);
 
 #endif				/* _LANGUAGE_ASSEMBLY */
 
+/* variable access */
+extern char *getvar(char *vars, const char *name);
+extern int getintvar(char *vars, const char *name);
+
 /* The NVRAM version number stored as an NVRAM variable */
 #define NVRAM_SOFTWARE_VERSION	"1"
 
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index d83a504..905e3ce 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -141,9 +141,6 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 	struct ipv4_addr;
 	extern char *bcm_ip_ntoa(struct ipv4_addr *ia, char *buf);
 
-/* variable access */
-	extern char *getvar(char *vars, const char *name);
-	extern int getintvar(char *vars, const char *name);
 #ifdef BCMDBG
 	extern void prpkt(const char *msg, struct sk_buff *p0);
 #else
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 95214cf..0c21e43 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -353,53 +353,6 @@ int bcm_ether_atoe(char *p, u8 *ea)
 	return i == 6;
 }
 
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
-#ifdef BRCM_FULLMAC
-	return NULL;
-#else
-	/* then query nvram */
-	return nvram_get(name);
-#endif
-}
-
-/*
- * Search the vars for a specific one and return its value as
- * an integer. Returns 0 if not found.
- */
-int getintvar(char *vars, const char *name)
-{
-	char *val;
-
-	val = getvar(vars, name);
-	if (val == NULL)
-		return 0;
-
-	return simple_strtoul(val, NULL, 0);
-}
-
 #if defined(BCMDBG)
 /* pretty hex print a pkt buffer chain */
 void prpkt(const char *msg, struct sk_buff *p0)
-- 
1.7.4.1


