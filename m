Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37504 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1VjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:39:05 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so4193335vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 13:39:04 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 4/5] brcm80211: avoid code duplication on set tx power
Date: Mon, 28 Nov 2011 16:38:49 -0500
Message-Id: <1322516330-4007-5-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223908_641728_86481456)
In-Reply-To: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both cases are doing the same so treat the switch cases
for both as an "or".

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index fc98981..f23b0c3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1447,12 +1447,6 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	case NL80211_TX_POWER_AUTOMATIC:
 		break;
 	case NL80211_TX_POWER_LIMITED:
-		if (dbm < 0) {
-			WL_ERR("TX_POWER_LIMITED - dbm is negative\n");
-			err = -EINVAL;
-			goto done;
-		}
-		break;
 	case NL80211_TX_POWER_FIXED:
 		if (dbm < 0) {
 			WL_ERR("TX_POWER_FIXED - dbm is negative\n");
-- 
1.7.4.15.g7811d

