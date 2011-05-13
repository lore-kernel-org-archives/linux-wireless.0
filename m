Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4903 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab1EMKAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:15 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 31/32] staging: brcm80211: Corrected sdpcm_shared_t
 structure definition
Date: Fri, 13 May 2011 11:59:51 +0200
Message-ID: <1305280792-9475-31-git-send-email-arend@broadcom.com> (sfid-20110513_120028_951663_913E75C6)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

There is a mismatch in structure definition of 'sdpcm_shared_t' structure
in driver & FW code. With this patch, it is corrected

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/bcmsdpcm.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/include/bcmsdpcm.h b/drivers/staging/brcm80211/include/bcmsdpcm.h
index 4869947..5175e67 100644
--- a/drivers/staging/brcm80211/include/bcmsdpcm.h
+++ b/drivers/staging/brcm80211/include/bcmsdpcm.h
@@ -186,7 +186,7 @@ typedef volatile struct {
  * Shared structure between dongle and the host.
  * The structure contains pointers to trap or assert information.
  */
-#define SDPCM_SHARED_VERSION       0x0001
+#define SDPCM_SHARED_VERSION       0x0002
 #define SDPCM_SHARED_VERSION_MASK  0x00FF
 #define SDPCM_SHARED_ASSERT_BUILT  0x0100
 #define SDPCM_SHARED_ASSERT        0x0200
@@ -200,6 +200,7 @@ typedef struct {
 	u32 assert_line;
 	u32 console_addr;	/* Address of hndrte_cons_t */
 	u32 msgtrace_addr;
+	u8 tag[32];
 } sdpcm_shared_t;
 
 extern sdpcm_shared_t sdpcm_shared;
-- 
1.7.4.1


