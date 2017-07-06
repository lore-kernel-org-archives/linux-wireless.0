Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:13996 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751943AbdGFWoh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 18:44:37 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/4] cfg80211: Check if NAN service ID is of expected size
Date: Fri, 7 Jul 2017 01:43:40 +0300
Message-ID: <1499381022-5389-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20170707_004441_743543_DDAE0441)
In-Reply-To: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
References: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@qti.qualcomm.com>

nla policy checks for only maximum length of the attribute data when the
attribute type is NLA_BINARY. If userspace sends less data than
specified, cfg80211 may access illegal memory. When type is NLA_UNSPEC,
nla policy check ensures that userspace sends minimum specified length
number of bytes.

Remove type assignment to NLA_BINARY from nla_policy of
NL80211_NAN_FUNC_SERVICE_ID to make these NLA_UNSPEC and to make sure
minimum NL80211_NAN_FUNC_SERVICE_ID_LEN bytes are received from
userspace with NL80211_NAN_FUNC_SERVICE_ID.

Fixes: a442b761b24 ("cfg80211: add add_nan_func / del_nan_func")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Dasari <dasaris@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 364291c..dcfeae0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -519,7 +519,7 @@ nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
 static const struct nla_policy
 nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
 	[NL80211_NAN_FUNC_TYPE] = { .type = NLA_U8 },
-	[NL80211_NAN_FUNC_SERVICE_ID] = { .type = NLA_BINARY,
+	[NL80211_NAN_FUNC_SERVICE_ID] = {
 				    .len = NL80211_NAN_FUNC_SERVICE_ID_LEN },
 	[NL80211_NAN_FUNC_PUBLISH_TYPE] = { .type = NLA_U8 },
 	[NL80211_NAN_FUNC_PUBLISH_BCAST] = { .type = NLA_FLAG },
-- 
2.7.4
