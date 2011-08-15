Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3559 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab1HONen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:43 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/15] staging: brcm80211: fix off-by-one error in swap
 functions
Date: Mon, 15 Aug 2011 15:34:21 +0200
Message-ID: <1313415267-5264-10-git-send-email-arend@broadcom.com> (sfid-20110815_153457_279615_C97AF254)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The original implementation iterated over the data in buf+1 through buf+size,
whereas it should have been over the data in buf through buf+size-1.

Tested on Mac G5 PPC and BCM63281.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/srom.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 060f06f..7a17f59 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -880,13 +880,15 @@ int srom_var_init(struct si_pub *sih, void *curmap, char **vars, uint *count)
 
 static inline void ltoh16_buf(u16 *buf, unsigned int size)
 {
-	for (size /= 2; size; size--)
+	size /= 2;
+	while (size--)
 		*(buf + size) = le16_to_cpu(*(buf + size));
 }
 
 static inline void htol16_buf(u16 *buf, unsigned int size)
 {
-	for (size /= 2; size; size--)
+	size /= 2;
+	while (size--)
 		*(buf + size) = cpu_to_le16(*(buf + size));
 }
 
-- 
1.7.4.1


