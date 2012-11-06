Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1642 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 09/24] brcmfmac: fix pkt_filter sizeof calculation.
Date: Mon, 5 Nov 2012 16:22:17 -0800
Message-ID: <1352161352-30405-10-git-send-email-frankyl@broadcom.com> (sfid-20121106_012430_538646_09573FF5)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

sizeof calculation in setting pkt_filter was incorrect. This
patch fixes that and removes related defines which have become
obsolete.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 866b669..a70393a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -42,10 +42,6 @@
 
 #define MSGTRACE_VERSION	1
 
-#define BRCMF_PKT_FILTER_FIXED_LEN	offsetof(struct brcmf_pkt_filter_le, u)
-#define BRCMF_PKT_FILTER_PATTERN_FIXED_LEN	\
-	offsetof(struct brcmf_pkt_filter_pattern_le, mask_and_pattern)
-
 #ifdef DEBUG
 static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on "
@@ -686,8 +682,8 @@ static void brcmf_c_pktfilter_offload_set(struct brcmf_if *ifp, char *arg)
 	}
 
 	pkt_filter->u.pattern.size_bytes = cpu_to_le32(mask_size);
-	buf_len = sizeof(*pkt_filter);
-	buf_len -= sizeof(pkt_filter->u.pattern.mask_and_pattern);
+	buf_len = offsetof(struct brcmf_pkt_filter_le,
+			   u.pattern.mask_and_pattern);
 	buf_len += mask_size + pattern_size;
 
 	err = brcmf_fil_iovar_data_set(ifp, "pkt_filter_add", pkt_filter,
-- 
1.7.9.5


