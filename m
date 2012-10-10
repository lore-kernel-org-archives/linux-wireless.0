Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3968 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944Ab2JJSNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:25 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Dan Carpenter" <dan.carpenter@oracle.com>
Subject: [PATCH 7/7] brcmfmac: fix end of loop check (signedness bug)
Date: Wed, 10 Oct 2012 11:13:12 -0700
Message-ID: <1349892792-4792-8-git-send-email-frankyl@broadcom.com> (sfid-20121010_201330_182779_8F42DD0F)
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

The problem here is that we loop until "remained_buf_len" is less than
zero, but since it is unsigned, it never is.

"remained_buf_len" has to be large enough to hold the value from
"mgmt_ie_buf_len".  That variable is type u32, but it only holds small
values so I have changed to both variables to int.

Also I removed the bogus initialization from "mgmt_ie_buf_len" so that
GCC can detect if it is used unitialized.  I moved the declaration of
"remained_buf_len" closer to where it is used so it's easier to read.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5e51f15..1c83612 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3972,7 +3972,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	u8  *iovar_ie_buf;
 	u8  *curr_ie_buf;
 	u8  *mgmt_ie_buf = NULL;
-	u32 mgmt_ie_buf_len;
+	int mgmt_ie_buf_len;
 	u32 *mgmt_ie_len;
 	u32 del_add_ie_buf_len = 0;
 	u32 total_ie_buf_len = 0;
@@ -3982,7 +3982,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	struct parsed_vndr_ie_info *vndrie_info;
 	s32 i;
 	u8 *ptr;
-	u32 remained_buf_len;
+	int remained_buf_len;
 
 	WL_TRACE("bssidx %d, pktflag : 0x%02X\n", bssidx, pktflag);
 	iovar_ie_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
-- 
1.7.9.5


