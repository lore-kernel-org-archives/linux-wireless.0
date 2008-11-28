Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:47482 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYK1Wpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 17:45:50 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211_hwsim: add trivial switch cases
Date: Fri, 28 Nov 2008 23:45:56 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>, j@w1.fi,
	Stefan Steuerwald <salsasepp@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200811282345.56970.chunkeey@web.de> (sfid-20081128_234553_134350_99BEB447)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following warnings:

In function =E2=80=98mac80211_hwsim_sta_notify=E2=80=99:
warning: enumeration value =E2=80=98STA_NOTIFY_SLEEP=E2=80=99 not handl=
ed in switch
warning: enumeration value =E2=80=98STA_NOTIFY_AWAKE=E2=80=99 not handl=
ed in switch

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
index f43da1c..e2c50ed 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -524,6 +524,10 @@ static void mac80211_hwsim_sta_notify(struct ieee8=
0211_hw *hw,
 	case STA_NOTIFY_REMOVE:
 		hwsim_clear_sta_magic(sta);
 		break;
+	case STA_NOTIFY_AWAKE:
+	case STA_NOTIFY_SLEEP:
+		/* TODO: make good use of these callbacks */
+		break;
 	}
 }
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
