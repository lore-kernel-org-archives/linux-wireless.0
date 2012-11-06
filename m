Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4439 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2KFAWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:44 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/24] brcmfmac: restrict error condition in
 brcmf_inform_bss()
Date: Mon, 5 Nov 2012 16:22:11 -0800
Message-ID: <1352161352-30405-4-git-send-email-frankyl@broadcom.com> (sfid-20121106_012308_615629_91569CA2)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function brcmf_inform_bss() validates the version received
from the device, before processing the individual bss entries.
This error condition is only applicable when the list contains
entries. A specific scan, ie. for a specific ssid, can result
in a scan completion without finding any bss entries. No need
to flag it as an error in the log when this happens.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f05ab77..c979ce1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2345,7 +2345,8 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 	int i;
 
 	bss_list = cfg->bss_list;
-	if (bss_list->version != BRCMF_BSS_INFO_VERSION) {
+	if (bss_list->count != 0 &&
+	    bss_list->version != BRCMF_BSS_INFO_VERSION) {
 		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
 		       bss_list->version);
 		return -EOPNOTSUPP;
-- 
1.7.9.5


