Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1814 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1HWMOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 6/8] staging: brcm80211: bugfix for exception on Sparc
 platforms
Date: Tue, 23 Aug 2011 14:13:58 +0200
Message-ID: <1314101640-4229-7-git-send-email-arend@broadcom.com> (sfid-20110823_141433_646723_1D961D7D)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Problem would pop up during driver load on a Sun Fire V120 and manifested
itself as an exception. This was caused by int* pointers provided to memcpy()
that were not aligned on an int boundary. The pointer type provided to
memcpy() is used by the compiler for optimization purposes. Fix was to cast
the int* pointers to void* pointers.

Bernhard R. Link and David S. Miller provided valuable feedback, thanks gents.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index c625c25..7e729d29 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -6111,9 +6111,12 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 	/* default argument is generic integer */
 	pval = arg ? (int *)arg : NULL;
 
-	/* This will prevent the misaligned access */
+	/*
+	 * This will prevent misaligned access. The (void *) cast prevents a
+	 * memcpy alignment issue on e.g. Sparc64 platforms.
+	 */
 	if (pval && (u32) len >= sizeof(val))
-		memcpy(&val, pval, sizeof(val));
+		memcpy((void *)&val, (void *)pval, sizeof(val));
 	else
 		val = 0;
 
-- 
1.7.4.1


