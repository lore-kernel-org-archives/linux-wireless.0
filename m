Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37961 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab2IBN0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 09:26:21 -0400
Received: by weyx8 with SMTP id x8so2490138wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 06:26:20 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 2 Sep 2012 15:22:26 +0200
Subject: [PATCH] p54: connect to 11w protected networks
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1T8ABt-0007Mx-CW@debian64.localnet> (sfid-20120902_152626_031643_E0FAEA94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, it was not possible to connect to
networks which requires 11w to be supported by
the stations.

This implementation relies on the mac80211
stack to do the actual crypto operations, as
there is no support for MFP in the firmware
as far as I can tell.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 5e91ad0..5333201 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -540,7 +540,8 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 				ret = -EOPNOTSUPP;
 				goto out_unlock;
 			}
-			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV |
+				IEEE80211_KEY_FLAG_SW_MGMT;
 			algo = P54_CRYPTO_AESCCMP;
 			break;
 		default:
@@ -736,6 +737,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_SUPPORTS_PS |
+		     IEEE80211_HW_MFP_CAPABLE |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
-- 
1.7.10.4

