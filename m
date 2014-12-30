Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaL3OUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/33] iwlwifi: mvm: support 2 different channels
Date: Tue, 30 Dec 2014 16:18:56 +0200
Message-Id: <1419949148-24046-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154350_286880_2D851041)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver and the firmware now support 2 different channels
at the same time. Advertise this capability to the stack.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9ccecbc..4db051d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -106,7 +106,7 @@ static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
 
 static const struct ieee80211_iface_combination iwl_mvm_iface_combinations[] = {
 	{
-		.num_different_channels = 1,
+		.num_different_channels = 2,
 		.max_interfaces = 3,
 		.limits = iwl_mvm_limits,
 		.n_limits = ARRAY_SIZE(iwl_mvm_limits),
-- 
1.9.1

