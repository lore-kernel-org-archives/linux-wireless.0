Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30920 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932799AbcJZVqq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:46:46 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 7/9] mac80211: Add FILS auth alg mapping
Date: Thu, 27 Oct 2016 00:42:04 +0300
Message-ID: <1477518126-823-8-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234649_856819_B43AB932)
In-Reply-To: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/mlme.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b6222f2..b815f2d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2618,6 +2618,9 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	case WLAN_AUTH_LEAP:
 	case WLAN_AUTH_FT:
 	case WLAN_AUTH_SAE:
+	case WLAN_AUTH_FILS_SK:
+	case WLAN_AUTH_FILS_SK_PFS:
+	case WLAN_AUTH_FILS_PK:
 		break;
 	case WLAN_AUTH_SHARED_KEY:
 		if (ifmgd->auth_data->expected_transaction != 4) {
@@ -4479,6 +4482,15 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	case NL80211_AUTHTYPE_SAE:
 		auth_alg = WLAN_AUTH_SAE;
 		break;
+	case NL80211_AUTHTYPE_FILS_SK:
+		auth_alg = WLAN_AUTH_FILS_SK;
+		break;
+	case NL80211_AUTHTYPE_FILS_SK_PFS:
+		auth_alg = WLAN_AUTH_FILS_SK_PFS;
+		break;
+	case NL80211_AUTHTYPE_FILS_PK:
+		auth_alg = WLAN_AUTH_FILS_PK;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.9.1
