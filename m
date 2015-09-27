Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35486 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbbI0ISU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 04:18:20 -0400
Received: by wicge5 with SMTP id ge5so67939719wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2015 01:18:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6656: implement TSF counter
Date: Sun, 27 Sep 2015 09:17:40 +0100
Message-Id: <1443341864-2756-2-git-send-email-tvboxspy@gmail.com> (sfid-20150927_101849_830511_AD34FA22)
In-Reply-To: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
References: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TSF counter is presently unused on driver in infrastructure mode.

It is needed to implement power saving functions and wireless stats that
are passed in interrupt handling.

Ensuring counter is synced with access point beacon.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index af572d7..7246c76 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -757,6 +757,26 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			vnt_mac_reg_bits_off(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
 		}
 	}
+
+	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_BEACON_INFO) &&
+	    priv->op_mode != NL80211_IFTYPE_AP) {
+		if (conf->assoc && conf->beacon_rate) {
+			vnt_mac_reg_bits_on(priv, MAC_REG_TFTCTL,
+					    TFTCTL_TSFCNTREN);
+
+			vnt_adjust_tsf(priv, conf->beacon_rate->hw_value,
+				       conf->sync_tsf, priv->current_tsf);
+
+			vnt_mac_set_beacon_interval(priv, conf->beacon_int);
+
+			vnt_reset_next_tbtt(priv, conf->beacon_int);
+		} else {
+			vnt_clear_current_tsf(priv);
+
+			vnt_mac_reg_bits_off(priv, MAC_REG_TFTCTL,
+					     TFTCTL_TSFCNTREN);
+		}
+	}
 }
 
 static u64 vnt_prepare_multicast(struct ieee80211_hw *hw,
-- 
2.5.0

