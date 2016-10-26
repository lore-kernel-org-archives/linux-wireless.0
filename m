Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42186 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933183AbcJZVnA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:43:00 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 2/9] mac80211: Allow AUTH_DATA to be used for FILS
Date: Thu, 27 Oct 2016 00:41:59 +0300
Message-ID: <1477518126-823-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234314_971969_2E23935E)
In-Reply-To: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The special SAE case should be limited only for SAE since the more
generic AUTH_DATA can now be used with other authentication algorithms
as well.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/mlme.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 32fd295..b6222f2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4491,9 +4491,11 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	auth_data->bss = req->bss;
 
 	if (req->auth_data_len >= 4) {
-		__le16 *pos = (__le16 *) req->auth_data;
-		auth_data->sae_trans = le16_to_cpu(pos[0]);
-		auth_data->sae_status = le16_to_cpu(pos[1]);
+		if (req->auth_type == NL80211_AUTHTYPE_SAE) {
+			__le16 *pos = (__le16 *) req->auth_data;
+			auth_data->sae_trans = le16_to_cpu(pos[0]);
+			auth_data->sae_status = le16_to_cpu(pos[1]);
+		}
 		memcpy(auth_data->data, req->auth_data + 4,
 		       req->auth_data_len - 4);
 		auth_data->data_len += req->auth_data_len - 4;
-- 
1.9.1
