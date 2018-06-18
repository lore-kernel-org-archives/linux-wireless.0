Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.179.26]:20505 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751868AbeFRMli (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 08:41:38 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id A580D40153B82
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2018 07:41:37 -0500 (CDT)
Date: Mon, 18 Jun 2018 07:41:34 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] mac80211: fix potential null pointer dereference
Message-ID: <20180618124134.GA13487@embeddedor.com> (sfid-20180618_144158_228320_63BABC9D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

he_op is being dereferenced before it is null checked, hence there
is a potential null pointer dereference.

Fix this by moving the pointer dereference after he_op has been
properly null checked.

Notice that, currently, he_op is already being null checked before
calling this function at 4593:

4593	if (!he_oper ||
4594	    !ieee80211_verify_sta_he_mcs_support(sband, he_oper))
4595		ifmgd->flags |= IEEE80211_STA_DISABLE_HE;

but in case ieee80211_verify_sta_he_mcs_support is ever called
without verifying he_oper is not null, we will end up having a
null pointer dereference. So, we better don't take any chances.

Addresses-Coverity-ID: 1470068 ("Dereference before null check")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/mac80211/mlme.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0322d78..f451303 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4458,12 +4458,14 @@ ieee80211_verify_sta_he_mcs_support(struct ieee80211_supported_band *sband,
 {
 	const struct ieee80211_sta_he_cap *sta_he_cap =
 		ieee80211_get_he_sta_cap(sband);
-	u16 ap_min_req_set = le16_to_cpu(he_op->he_mcs_nss_set);
+	u16 ap_min_req_set;
 	int i;
 
 	if (!sta_he_cap || !he_op)
 		return false;
 
+	ap_min_req_set = le16_to_cpu(he_op->he_mcs_nss_set);
+
 	/* Need to go over for 80MHz, 160MHz and for 80+80 */
 	for (i = 0; i < 3; i++) {
 		const struct ieee80211_he_mcs_nss_supp *sta_mcs_nss_supp =
-- 
2.7.4
