Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42677 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0ENOyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 10:54:05 -0400
Received: by wwi18 with SMTP id 18so601796wwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 07:54:03 -0700 (PDT)
Date: Fri, 14 May 2010 16:53:46 +0200
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [patch -next] iwlwifi: testing the wrong variable in
	iwl_add_bssid_station()
Message-ID: <20100514145346.GG17487@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The intent here is to test that "sta_id_r" is a valid pointer.  We do
this same test later on in the function.

Btw iwl_add_bssid_station() is called from two places and "sta_id_r" is
a valid pointer from both callers.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 85ed235..83a2636 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -431,7 +431,7 @@ int iwl_add_bssid_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
 	struct iwl_link_quality_cmd *link_cmd;
 	unsigned long flags;
 
-	if (*sta_id_r)
+	if (sta_id_r)
 		*sta_id_r = IWL_INVALID_STATION;
 
 	ret = iwl_add_station_common(priv, addr, 0, NULL, &sta_id);
