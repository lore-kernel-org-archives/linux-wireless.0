Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4868 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161374Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 41/83] staging: brcm80211: add braces to SI_INFO macro
 definition
Date: Wed, 1 Jun 2011 13:45:26 +0200
Message-ID: <1306928768-7501-41-git-send-email-rvossen@broadcom.com> (sfid-20110601_134654_507659_5216AE11)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The additional braces allow the casted parameter to be indirected
immediately. Here is an example to clarify:
	x = SI_INFO(y);    => z = SI_INFO(y)->field_a;
	z = x->field_a;

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 2941537..a0fec83 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -271,7 +271,7 @@
 #define	CST4330_CBUCK_POWER_OK		0x00004000
 #define	CST4330_BB_PLL_LOCKED		0x00008000
 
-#define	SI_INFO(sih)	(si_info_t *)sih
+#define	SI_INFO(sih)	((si_info_t *)sih)
 
 #define	GOODCOREADDR(x, b) \
 	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
-- 
1.7.4.1


