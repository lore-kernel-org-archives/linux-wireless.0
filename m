Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2162 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1EXLfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 07:35:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	frankyl@broadcom.com
Subject: [PATCH] staging: brcm80211: fix for 'multiple definition of
 wl_msg_level' build err
Date: Tue, 24 May 2011 13:35:21 +0200
Message-ID: <1306236921-30522-1-git-send-email-rvossen@broadcom.com> (sfid-20110524_133535_941166_69FBCB65)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Linus.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_iw.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 929ceaf..15e1b05 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -64,8 +64,6 @@ wl_iw_extra_params_t g_wl_iw_params;
 extern bool wl_iw_conn_status_str(u32 event_type, u32 status,
 				  u32 reason, char *stringBuf, uint buflen);
 
-uint wl_msg_level = WL_ERROR_VAL;
-
 #define MAX_WLIW_IOCTL_LEN 1024
 
 #ifdef CONFIG_WIRELESS_EXT
-- 
1.7.4.1


