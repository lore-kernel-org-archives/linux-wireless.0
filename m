Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2484 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab1FIOpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:17 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/21] staging: brcm80211: remove checkpatch errors
 found in fullmac
Date: Thu, 9 Jun 2011 16:44:58 +0200
Message-ID: <1307630701-9170-19-git-send-email-rvossen@broadcom.com> (sfid-20110609_164531_983891_E23B9CAB)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

A checkpatch run was done over the complete source files to determine
how much coding style issues there are in the driver. This patch fixes
the checkpatch errors in fullmac driver brcmfmac listed below.

ERROR: do not initialise globals to 0 or NULL
+uint dhd_poll = false;
--
ERROR: do not use assignment in if condition
+       if (!ifp && !(ifp = kmalloc(sizeof(dhd_if_t), GFP_ATOMIC))) {
--
ERROR: do not use assignment in if condition
+       if (unlikely(!(wl_cfg80211_dev &&                               \
--
ERROR: do not initialise statics to 0 or NULL
+       static bool iscan_pass_abort = false;
--

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   11 +++++++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   11 +++++++----
 drivers/staging/brcm80211/brcmfmac/wl_iw.c       |    2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index be6ac30..9c9b8ba 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -339,7 +339,7 @@ int dhd_idletime = DHD_IDLETIME_TICKS;
 module_param(dhd_idletime, int, 0);
 
 /* Use polling */
-uint dhd_poll = false;
+uint dhd_poll;
 module_param(dhd_poll, uint, 0);
 
 /* Use cfg80211 */
@@ -1817,9 +1817,12 @@ dhd_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 	ASSERT(dhd && (ifidx < DHD_MAX_IFS));
 
 	ifp = dhd->iflist[ifidx];
-	if (!ifp && !(ifp = kmalloc(sizeof(dhd_if_t), GFP_ATOMIC))) {
-		DHD_ERROR(("%s: OOM - dhd_if_t\n", __func__));
-		return -ENOMEM;
+	if (!ifp) {
+		ifp = kmalloc(sizeof(dhd_if_t), GFP_ATOMIC);
+		if (!ifp) {
+			DHD_ERROR(("%s: OOM - dhd_if_t\n", __func__));
+			return -ENOMEM;
+		}
 	}
 
 	memset(ifp, 0, sizeof(dhd_if_t));
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 399d7a8..235cc59 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -323,9 +323,8 @@ static void wl_debugfs_remove_netdev(struct wl_priv *wl);
 
 #define WL_PRIV_GET() 							\
 	({								\
-	struct wl_iface *ci;						\
-	if (unlikely(!(wl_cfg80211_dev && 				\
-		(ci = wl_get_drvdata(wl_cfg80211_dev))))) {		\
+	struct wl_iface *ci = wl_get_drvdata(wl_cfg80211_dev);		\
+	if (unlikely(!ci)) {						\
 		WL_ERR("wl_cfg80211_dev is unavailable\n");		\
 		BUG();							\
 	} 								\
@@ -4298,7 +4297,11 @@ static void wl_set_drvdata(struct wl_dev *dev, void *data)
 
 static void *wl_get_drvdata(struct wl_dev *dev)
 {
-	return dev->driver_data;
+	void *data = NULL;
+
+	if (dev)
+		data = dev->driver_data;
+	return data;
 }
 
 s32 wl_cfg80211_read_fw(s8 *buf, u32 size)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index cb8d614..df32d38 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -1172,7 +1172,7 @@ static int _iscan_sysioc_thread(void *data)
 {
 	u32 status;
 	iscan_info_t *iscan = (iscan_info_t *) data;
-	static bool iscan_pass_abort = false;
+	static bool iscan_pass_abort;
 
 	allow_signal(SIGTERM);
 	status = WL_SCAN_RESULTS_PARTIAL;
-- 
1.7.4.1


