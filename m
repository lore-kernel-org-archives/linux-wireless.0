Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20113 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3CMMN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:27 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/14] wil6210: use WLAN_CAPABILITY_DMG_TYPE_MASK
Date: Wed, 13 Mar 2013 14:12:47 +0200
Message-ID: <1363176771-10082-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131344_932190_94880CE0)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 19d8d14..39404a8 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -292,7 +292,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 
 	/* WMI_CONNECT_CMD */
 	memset(&conn, 0, sizeof(conn));
-	switch (bss->capability & 0x03) {
+	switch (bss->capability & WLAN_CAPABILITY_DMG_TYPE_MASK) {
 	case WLAN_CAPABILITY_DMG_TYPE_AP:
 		conn.network_type = WMI_NETTYPE_INFRA;
 		break;
-- 
1.7.10.4

