Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55947 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab1KWPlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:41:19 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so572756vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:41:19 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 5/5] wireless: annotate drivers that do not support NL80211_TX_POWER_REG
Date: Wed, 23 Nov 2011 10:40:58 -0500
Message-Id: <1322062858-15276-6-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_164122_733147_1F64C5F5)
In-Reply-To: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcm80211, iwmc3200wifi and mwifiex lack support for
NL80211_TX_POWER_REG.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 ++
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    2 ++
 drivers/net/wireless/mwifiex/cfg80211.c            |    3 +++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f23b0c3..678849e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1454,6 +1454,8 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 			goto done;
 		}
 		break;
+	case NL80211_TX_POWER_REG:
+		return -EOPNOTSUPP;
 	}
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 48e8218..d84390f 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -710,6 +710,8 @@ static int iwm_cfg80211_set_txpower(struct wiphy *wiphy,
 			return ret;
 
 		return iwm_tx_power_trigger(iwm);
+	case NL80211_TX_REG:
+		return -EOPNOTSUPP;
 	default:
 		IWM_ERR(iwm, "Unsupported power type: %d\n", type);
 		return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 0db97cc..136841b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -126,6 +126,9 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 	struct mwifiex_power_cfg power_cfg;
 	int dbm = MBM_TO_DBM(mbm);
 
+	if (type == NL80211_TX_POWER_REG)
+		return -EOPNOTSUPP;
+
 	if (type == NL80211_TX_POWER_FIXED) {
 		power_cfg.is_power_auto = 0;
 		power_cfg.power_level = dbm;
-- 
1.7.4.15.g7811d

