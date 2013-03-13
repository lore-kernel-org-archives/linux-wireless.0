Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17329 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMMNP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:15 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/14] wil6210: do not set IE's for beacon
Date: Wed, 13 Mar 2013 14:12:41 +0200
Message-ID: <1363176771-10082-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131320_074572_ED51F5D3)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the DMG band, there is no 'normal' beacon frame.
Instead, transmitted is short 'DMG beacon' frame, that do not include IE's
So, beacon IE's are not relevant for the DMG band.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 9ecc196..19d8d14 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -446,8 +446,13 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 
 	/* IE's */
 	/* bcon 'head IE's are not relevant for 60g band */
-	wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->beacon_ies_len,
-		   bcon->beacon_ies);
+	/*
+	 * FW do not form regular beacon, so bcon IE's are not set
+	 * For the DMG bcon, when it will be supported, bcon IE's will
+	 * be reused; add something like:
+	 * wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->beacon_ies_len,
+	 * bcon->beacon_ies);
+	 */
 	wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, bcon->proberesp_ies_len,
 		   bcon->proberesp_ies);
 	wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP, bcon->assocresp_ies_len,
-- 
1.7.10.4

