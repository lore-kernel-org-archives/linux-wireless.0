Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:2467 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751619AbdGFWph (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 18:45:37 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 4/4] cfg80211: Validate frequencies nested in NL80211_ATTR_SCAN_FREQUENCIES
Date: Fri, 7 Jul 2017 01:43:42 +0300
Message-ID: <1499381022-5389-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20170707_004539_903339_684FD612)
In-Reply-To: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
References: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@qti.qualcomm.com>

validate_scan_freqs() retrieves frequencies from attributes
nested in the attribute NL80211_ATTR_SCAN_FREQUENCIES with
nla_get_u32(), which reads 4 bytes from each attribute
without validating the size of data received. Attributes
nested in NL80211_ATTR_SCAN_FREQUENCIES don't have an nla policy.

Validate size of each attribute before parsing to avoid potential buffer
overread.

Fixes: 2a519311926 ("cfg80211/nl80211: scanning (and mac80211 update to use it)")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Dasari <dasaris@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0a63b95..740d3c1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6469,6 +6469,9 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	struct nlattr *attr1, *attr2;
 	int n_channels = 0, tmp1, tmp2;
 
+	nla_for_each_nested(attr1, freqs, tmp1)
+		if (nla_len(attr1) != sizeof(u32))
+			return 0;
 	nla_for_each_nested(attr1, freqs, tmp1) {
 		n_channels++;
 		/*
-- 
2.7.4
