Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:51914 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeAVRE6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 12:04:58 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v4 2/3] mac80211_hwsim: add nl_err_msg in hwsim_new_radio in netlink case
Date: Mon, 22 Jan 2018 18:04:36 +0100
Message-ID: <20180122170437.14213-3-benjamin.beichler@uni-rostock.de> (sfid-20180122_180502_529853_60CC6D58)
In-Reply-To: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de>
References: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a NL_ERR_MSG in case of creating a radio by a netlink message to give
clear output to the creating process instead of creating only a debug
message in kernel log. The same function is used for the creation while
module load, so keep the old message, although it should never be thrown
while load, because the module controls all mac addresses.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e9c92f70b97d..8baf61dea961 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2796,8 +2796,13 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
 				     hwsim_rht_params);
 	if (err < 0) {
-		pr_debug("mac80211_hwsim: radio index %d already present\n",
-			 idx);
+		if(!info)
+			pr_debug("mac80211_hwsim: radio index %d already present\n",
+				 idx);
+		else
+			GENL_SET_ERR_MSG(info,"perm addr already present");
+			NL_SET_BAD_ATTR(info->extack,
+					info->attrs[HWSIM_ATTR_PERM_ADDR]);
 		spin_unlock_bh(&hwsim_radio_lock);
 		goto failed_final_insert;
 	}
-- 
2.15.1
