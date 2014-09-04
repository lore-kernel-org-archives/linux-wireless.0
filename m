Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22880 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbaIDTlb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 15:41:31 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix broken use of VHT/20Mhz with some APs
Date: Thu,  4 Sep 2014 22:37:55 +0300
Message-Id: <1409859475-10364-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140904_214146_514329_A0D429C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

commit "mac80211: disable 40MHz support in case of 20MHz AP"
broke working VHT in 20Mhz with APs like Netgear R6300v2 which
do not publish support for 40Mhz but allow use of VHT in 20Mhz.
The break is because VHT is disabled once no HT cap doesn't indicate
support for 40Mhz. This causes the assoc request to be sent without
any VHT IE and the association is only HT due to this.

For more details check out commit 4a817aa7
"mac80211: allow VHT with peers not capable of 40MHz"

Fixes: 53b954ee4a71 ("mac80211: disable 40MHz support in case of 20MHz AP")
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c22448c..125d0d4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -173,7 +173,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 
 	if (!(ht_cap->cap_info &
 	      cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40))) {
-		ret = IEEE80211_STA_DISABLE_40MHZ | IEEE80211_STA_DISABLE_VHT;
+		ret = IEEE80211_STA_DISABLE_40MHZ;
 		goto out;
 	}
 
-- 
1.9.1

