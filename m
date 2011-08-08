Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3095 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1HHN7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 12/82] staging: brcm80211: removed function
 declaration typedefs from main.h,pub.h
Date: Mon, 8 Aug 2011 15:57:56 +0200
Message-ID: <1312811946-16713-13-git-send-email-arend@broadcom.com> (sfid-20110808_155931_456807_5A20DC7C)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.h |   46 +++++++++++++++++++++-------
 drivers/staging/brcm80211/brcmsmac/pub.h  |   27 ++---------------
 3 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index bd3d5f0..66de7ef 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -6265,8 +6265,8 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
  * register watchdog and down handlers.
  */
 int brcms_c_module_register(struct brcms_pub *pub,
-			const char *name, void *hdl,
-			watchdog_fn_t w_fn, down_fn_t d_fn)
+		const char *name, void *hdl,
+		int (*w_fn)(void *handle), int (*d_fn)(void *handle))
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) pub->wlc;
 	int i;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index bf36f10..e61f047 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -408,11 +408,11 @@ struct brcms_band {
 	u16 bcntsfoff;	/* beacon tsf offset */
 };
 
-/* tx completion callback takes 3 args */
-typedef void (*pkcb_fn_t) (struct brcms_c_info *wlc, uint txstatus, void *arg);
-
 struct pkt_cb {
-	pkcb_fn_t fn;		/* function to call when tx frame completes */
+	/* function to call when tx frame completes */
+	/* tx completion callback takes 3 args */
+	void (*fn)(struct brcms_c_info *wlc, uint txstatus, void *arg);
+
 	void *arg;		/* void arg for fn */
 	u8 nextidx;		/* index of next call back if threading */
 	bool entered;		/* recursion check */
@@ -423,19 +423,41 @@ struct modulecb {
 	char name[32];		/* module name : NULL indicates empty array member */
 	const struct brcmu_iovar *iovars;	/* iovar table */
 	void *hdl;		/* handle passed when handler 'doiovar' is called */
-	watchdog_fn_t watchdog_fn;	/* watchdog handler */
-	iovar_fn_t iovar_fn;	/* iovar handler */
-	down_fn_t down_fn;	/* down handler. Note: the int returned
-				 * by the down function is a count of the
-				 * number of timers that could not be
-				 * freed.
-				 */
+	int (*watchdog_fn)(void *handle);	/* watchdog handler */
+
+	/* IOVar handler
+	 *
+	 * handle - a pointer value registered with the function
+	 * vi - iovar_info that was looked up
+	 * actionid - action ID, calculated by IOV_GVAL() and IOV_SVAL()
+	 *    based on varid.
+	 * name - the actual iovar name
+	 * params/plen - parameters and length for a get, input only.
+	 * arg/len - buffer and length for value to be set or retrieved,
+	 *      input or output.
+	 * vsize - value size, valid for integer type only.
+	 * wlcif - interface context (brcms_c_if pointer)
+	 *
+	 * All pointers may point into the same buffer.
+	 */
+	int (*iovar_fn)(void *handle, const struct brcmu_iovar *vi,
+			u32 actionid, const char *name, void *params,
+			uint plen, void *arg, int alen, int vsize,
+			struct brcms_c_if *wlcif);
+
+	int (*down_fn)(void *handle); /* down handler. Note: the int returned
+				       * by the down function is a count of the
+				       * number of timers that could not be
+				       * freed.
+				       */
+
 };
 
 /* dump control blocks */
 struct dumpcb_s {
 	const char *name;	/* dump name */
-	dump_fn_t dump_fn;	/* 'wl dump' handler */
+	/* 'wl dump' handler */
+	int (*dump_fn)(void *handle, struct brcmu_strbuf *b);
 	void *dump_fn_arg;
 	struct dumpcb_s *next;
 };
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 01d7460..8ec398a 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -203,29 +203,6 @@ struct brcms_bss_info {
 #define IOVF_GET_BAND	(1<<13)	/* get requires fixed band */
 #define IOVF_OPEN_ALLOW	(1<<14)	/* set allowed iovar for opensrc */
 
-/* watchdog down and dump callback function proto's */
-typedef int (*watchdog_fn_t) (void *handle);
-typedef int (*down_fn_t) (void *handle);
-typedef int (*dump_fn_t) (void *handle, struct brcmu_strbuf *b);
-
-/* IOVar handler
- *
- * handle - a pointer value registered with the function
- * vi - iovar_info that was looked up
- * actionid - action ID, calculated by IOV_GVAL() and IOV_SVAL() based on varid.
- * name - the actual iovar name
- * params/plen - parameters and length for a get, input only.
- * arg/len - buffer and length for value to be set or retrieved, input or output.
- * vsize - value size, valid for integer type only.
- * wlcif - interface context (brcms_c_if pointer)
- *
- * All pointers may point into the same buffer.
- */
-typedef int (*iovar_fn_t) (void *handle, const struct brcmu_iovar *vi,
-			   u32 actionid, const char *name, void *params,
-			   uint plen, void *arg, int alen, int vsize,
-			   struct brcms_c_if *wlcif);
-
 #define MAC80211_PROMISC_BCNS	(1 << 0)
 #define MAC80211_SCAN		(1 << 1)
 
@@ -635,7 +612,9 @@ extern void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val);
 
 extern int brcms_c_module_register(struct brcms_pub *pub,
 			       const char *name, void *hdl,
-			       watchdog_fn_t watchdog_fn, down_fn_t down_fn);
+			       int (*watchdog_fn)(void *handle),
+			       int (*down_fn)(void *handle));
+
 extern int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
 				 void *hdl);
 extern void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc);
-- 
1.7.4.1


