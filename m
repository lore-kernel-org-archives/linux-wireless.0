Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4613 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221Ab1F2Xth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 072/119] staging: brcm80211: remove unnecessary macro
 defintions
Date: Wed, 29 Jun 2011 16:47:36 -0700
Message-ID: <1309391303-22741-73-git-send-email-frankyl@broadcom.com> (sfid-20110630_015249_290277_2D17854E)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The common makefile and the fullmac makefile contained a few
macro definitions that are not or no longer used. These are
removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/Makefile          |    2 +-
 drivers/staging/brcm80211/brcmfmac/Makefile |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
index db9a57e..8b01f5e 100644
--- a/drivers/staging/brcm80211/Makefile
+++ b/drivers/staging/brcm80211/Makefile
@@ -17,7 +17,7 @@
 
 # common flags
 subdir-ccflags-y					:= -DBCMDMA32
-subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DBCMDBG -DBCMDBG_ASSERT
+subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DBCMDBG
 
 obj-$(CONFIG_BRCMUTIL)	+= brcmutil/
 obj-$(CONFIG_BRCMFMAC)	+= brcmfmac/
diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index a54a7d3..f097246 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -16,8 +16,6 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y :=			\
-	-DBCMSDIO		\
-	-DBRCM_FULLMAC		\
 	-DBRCMF_FIRSTREAD=64	\
 	-DBRCMF_SDALIGN=64	\
 	-DMAX_HDR_READ=64
-- 
1.7.1


