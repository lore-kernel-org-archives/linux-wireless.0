Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:43112 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaJ1OAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:00:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/16] brcmfmac: (clean) Rename dhd_common.c in common.c
Date: Tue, 28 Oct 2014 14:56:15 +0100
Message-ID: <1414504579-12562-13-git-send-email-arend@broadcom.com> (sfid-20141028_150028_095987_F81FD3B1)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                   | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_common.c => common.c} | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_common.c => common.c} (99%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 1da9042..f6e35c9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -30,7 +30,7 @@ brcmfmac-objs += \
 		fwsignal.o \
 		p2p.o \
 		proto.o \
-		dhd_common.o \
+		common.o \
 		dhd_linux.o \
 		firmware.o \
 		feature.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/common.c
similarity index 99%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
rename to drivers/net/wireless/brcm80211/brcmfmac/common.c
index 7723994..75642e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.c
@@ -52,9 +52,9 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 	}
 
 	/* Determine precedence from which to evict packet, if any */
-	if (pktq_pfull(q, prec))
+	if (pktq_pfull(q, prec)) {
 		eprec = prec;
-	else if (pktq_full(q)) {
+	} else if (pktq_full(q)) {
 		p = brcmu_pktq_peek_tail(q, &eprec);
 		if (eprec > prec)
 			return false;
-- 
1.9.1

