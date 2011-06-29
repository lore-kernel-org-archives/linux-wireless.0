Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4649 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 070/119] staging: brcm80211: define SHOW_EVENTS macro
 only for debugging
Date: Wed, 29 Jun 2011 16:47:34 -0700
Message-ID: <1309391303-22741-71-git-send-email-frankyl@broadcom.com> (sfid-20110630_014951_458743_0D8B03F4)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro SHOW_EVENTS will only be defined when Kconfig setting
BRCMDBG is set.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 7441649..2fcc409 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -20,10 +20,9 @@ ccflags-y :=			\
 	-DBRCM_FULLMAC		\
 	-DBRCMF_FIRSTREAD=64	\
 	-DBRCMF_SDALIGN=64	\
-	-DMAX_HDR_READ=64	\
-	-DSHOW_EVENTS
+	-DMAX_HDR_READ=64
 
-ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG
+ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG -DSHOW_EVENTS
 
 ccflags-y += \
 	-Idrivers/staging/brcm80211/brcmfmac	\
-- 
1.7.1


