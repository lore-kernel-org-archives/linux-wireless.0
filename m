Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:38769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaKUNIF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 08:08:05 -0500
From: Patrik Flykt <patrik.flykt@linux.intel.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211_hwsim: Send alpha2 only if non-zero
Date: Fri, 21 Nov 2014 15:08:02 +0200
Message-Id: <1416575282-19966-1-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141121_140809_955796_2443695A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A properly set alpha2 value consists of two chars that both contain
letters or digits. If no value is set, both chars keep their initial
value zero. Therefore do not send the alpha2 parameter to user space
if either of the characters has been left at its initial zero value.

Signed-off-by: Patrik Flykt <patrik.flykt@linux.intel.com>
---

This is a fix for the issue Johannes noted with the patch adding
HWSIM_CMD_GET_RADIO support.

Cheers,

	Patrik


 drivers/net/wireless/mac80211_hwsim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e23a8d1..d399a73 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2541,7 +2541,9 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
 	if (cb)
 		genl_dump_check_consistent(cb, hdr, &hwsim_genl_family);
 
-	param.reg_alpha2 = data->alpha2;
+	if (data->alpha2[0] && data->alpha2[1])
+		param.reg_alpha2 = data->alpha2;
+
 	param.reg_strict = !!(data->hw->wiphy->regulatory_flags &
 					REGULATORY_STRICT_REG);
 	param.p2p_device = !!(data->hw->wiphy->interface_modes &
-- 
2.1.1

