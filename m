Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2924 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 21/32] staging: brcm80211: Fixed wl_assoc_params
 structure miss match in brcmfmac driver
Date: Fri, 13 May 2011 11:59:41 +0200
Message-ID: <1305280792-9475-21-git-send-email-arend@broadcom.com> (sfid-20110513_120058_072559_5D86CF24)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

There is a mismatch in the structure definition of wl_assoc_params structure
in driver & FW code. With this patch, it is corrected

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/wlioctl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 40016b9..2876bd9 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -259,6 +259,7 @@ typedef struct wl_u32_list {
 /* used for association with a specific BSSID and chanspec list */
 typedef struct wl_assoc_params {
 	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
+	u16 bssid_cnt;
 	s32 chanspec_num;	/* 0: all available channels,
 				 * otherwise count of chanspecs in chanspec_list
 				 */
-- 
1.7.4.1


