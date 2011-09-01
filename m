Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2936 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/30] staging: brcm80211: consolidate SHOW_EVENTS code
 under BCMDBG in fullmac
Date: Thu, 1 Sep 2011 11:17:03 +0200
Message-ID: <1314868640-9425-14-git-send-email-rvossen@broadcom.com> (sfid-20110901_111823_739902_86732734)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use unify config marco for debug info. Related event debug print out can be
enabled/disabled by the dedicated event message level.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile     |    2 --
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    8 ++++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 826a2ba..3d0878f 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -15,8 +15,6 @@
 # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
-ccflags-$(CONFIG_BRCMDBG)	+= -DSHOW_EVENTS
-
 ccflags-y += \
 	-Idrivers/staging/brcm80211/brcmfmac	\
 	-Idrivers/staging/brcm80211/include
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 059289a..e5214b2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -411,7 +411,7 @@ int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc, void *buf,
 	return bcmerror;
 }
 
-#ifdef SHOW_EVENTS
+#ifdef BCMDBG
 static void
 brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 {
@@ -705,7 +705,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		brcmf_dbg(EVENT, "\n");
 	}
 }
-#endif				/* SHOW_EVENTS */
+#endif				/* BCMDBG */
 
 int
 brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
@@ -796,9 +796,9 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 		break;
 	}
 
-#ifdef SHOW_EVENTS
+#ifdef BCMDBG
 	brcmf_c_show_host_event(event, event_data);
-#endif				/* SHOW_EVENTS */
+#endif				/* BCMDBG */
 
 	return 0;
 }
-- 
1.7.4.1


