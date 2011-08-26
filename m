Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3692 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab1HZNTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/13] staging: brcm80211: remove macro definitions from
 brcmfmac Makefile
Date: Fri, 26 Aug 2011 15:19:31 +0200
Message-ID: <1314364780-9462-5-git-send-email-rvossen@broadcom.com> (sfid-20110826_151957_161812_07A0AEC5)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The Makefile for the brcmfmac driver contains macro definitions that
are always set. This patch removes those definitions from the Makefile
and source code.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile   |    5 -----
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h  |    7 +------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   15 ++-------------
 3 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index da3c805..826a2ba 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -15,11 +15,6 @@
 # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
-ccflags-y :=			\
-	-DBRCMF_FIRSTREAD=64	\
-	-DBRCMF_SDALIGN=64	\
-	-DMAX_HDR_READ=64
-
 ccflags-$(CONFIG_BRCMDBG)	+= -DSHOW_EVENTS
 
 ccflags-y += \
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 653cf0d..24f578a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -18,12 +18,7 @@
 #define _BRCMF_BUS_H_
 
 /* Packet alignment for most efficient SDIO (can change based on platform) */
-#ifndef BRCMF_SDALIGN
-#define BRCMF_SDALIGN	32
-#endif
-#if !ISPOWEROF2(BRCMF_SDALIGN)
-#error BRCMF_SDALIGN is not a power of 2!
-#endif
+#define BRCMF_SDALIGN	(1 << 6)
 
 /*
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8e59086..9b41891 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -130,13 +130,8 @@ struct rte_console {
 #define MAX_DATA_BUF	(32 * 1024)	/* Must be large enough to hold
 				 biggest possible glom */
 
-#ifndef BRCMF_FIRSTREAD
-#define BRCMF_FIRSTREAD	32
-#endif
+#define BRCMF_FIRSTREAD	(1 << 6)
 
-#if !ISPOWEROF2(BRCMF_FIRSTREAD)
-#error BRCMF_FIRSTREAD is not a power of 2!
-#endif
 
 /* SBSDIO_DEVICE_CTL */
 
@@ -362,13 +357,7 @@ struct rte_console {
 
 
 /* Space for header read, limit for data packets */
-#ifndef MAX_HDR_READ
-#define MAX_HDR_READ	32
-#endif
-#if !ISPOWEROF2(MAX_HDR_READ)
-#error MAX_HDR_READ is not a power of 2!
-#endif
-
+#define MAX_HDR_READ	(1 << 6)
 #define MAX_RX_DATASZ	2048
 
 /* Maximum milliseconds to wait for F2 to come up */
-- 
1.7.4.1


