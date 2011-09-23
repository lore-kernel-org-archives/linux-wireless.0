Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3983 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1IWAIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:09 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 17/19] staging: brcm80211: clarified fullmac io and
 event codes
Date: Thu, 22 Sep 2011 17:07:54 -0700
Message-ID: <1316736476-23725-18-git-send-email-frankyl@broadcom.com> (sfid-20110923_020815_509649_F8AC249B)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Added comments to make code more readable.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    4 ++++
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |    5 +++++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 ++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 7ca9172..7ab45d9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -27,6 +27,9 @@
 #define BRCMF_C_IOCTL_MEDLEN	1536	/* "med" ioctl buffer required */
 #define	BRCMF_C_IOCTL_MAXLEN	8192
 
+/*******************************************************************************
+ * IO codes that are interpreted by dongle firmware
+ ******************************************************************************/
 #define BRCMF_C_UP				2
 #define BRCMF_C_SET_PROMISC			10
 #define BRCMF_C_GET_RATE			12
@@ -171,6 +174,7 @@ struct dngl_stats {
 	unsigned long multicast;	/* multicast packets received */
 };
 
+/* event codes sent by the dongle to this driver */
 #define BRCMF_E_SET_SSID			0
 #define BRCMF_E_JOIN				1
 #define BRCMF_E_START				2
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 91b4d3c..4c171a3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -14,6 +14,11 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+/*******************************************************************************
+ * Communicates with the dongle by using Broadcom specific ioctl codes.
+ * For certain ioctl codes, the dongle interprets string data from the host.
+ ******************************************************************************/
+
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index d0ae2b6..45c9e78 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -14,6 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+/* Toplevel file. Relies on dhd_linux.c to send ioctls to the dongle. */
+
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
 #include <linux/sched.h>
-- 
1.7.1


