Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58088 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752916AbeEOJPH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:15:07 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/8] brcmfmac: fix initialization of struct cfg80211_inform_bss variable
Date: Tue, 15 May 2018 11:14:44 +0200
Message-Id: <1526375691-31789-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180515_111559_788583_2F8C908C)
In-Reply-To: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

This patch fixes a sparse warning "Using plain integer as NULL pointer"
about cfg80211_inform_bss structure initialization.

Reported-by: kbuild test robot <lkp@intel.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 84135da..f5b405c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2737,7 +2737,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	u16 notify_interval;
 	u8 *notify_ie;
 	size_t notify_ielen;
-	struct cfg80211_inform_bss bss_data = { 0 };
+	struct cfg80211_inform_bss bss_data = {};

 	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
 		brcmf_err("Bss info is larger than buffer. Discarding\n");
--
1.9.1
