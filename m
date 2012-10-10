Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3433 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950Ab2JJSNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:25 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Dan Carpenter" <dan.carpenter@oracle.com>
Subject: [PATCH 2/7] brcmfmac: Using zero instead of NULL
Date: Wed, 10 Oct 2012 11:13:07 -0700
Message-ID: <1349892792-4792-3-git-send-email-frankyl@broadcom.com> (sfid-20121010_201334_573652_E934BB37)
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

Sparse complains that we use zero instead of NULL here.  In fact, the
initialization is wrong and should be removed.  Doing these kinds of
bogus initializations means that GCC can't detect unitialized variables
and leads to bugs.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c1abaa6..b1c9be7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3972,8 +3972,8 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	u8  *iovar_ie_buf;
 	u8  *curr_ie_buf;
 	u8  *mgmt_ie_buf = NULL;
-	u32 mgmt_ie_buf_len = 0;
-	u32 *mgmt_ie_len = 0;
+	u32 mgmt_ie_buf_len;
+	u32 *mgmt_ie_len;
 	u32 del_add_ie_buf_len = 0;
 	u32 total_ie_buf_len = 0;
 	u32 parsed_ie_buf_len = 0;
@@ -3995,8 +3995,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 		case VNDR_IE_PRBRSP_FLAG:
 			mgmt_ie_buf = cfg->ap_info->probe_res_ie;
 			mgmt_ie_len = &cfg->ap_info->probe_res_ie_len;
-			mgmt_ie_buf_len =
-				sizeof(cfg->ap_info->probe_res_ie);
+			mgmt_ie_buf_len = sizeof(cfg->ap_info->probe_res_ie);
 			break;
 		case VNDR_IE_BEACON_FLAG:
 			mgmt_ie_buf = cfg->ap_info->beacon_ie;
-- 
1.7.9.5


