Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaEVJUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 05:20:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: set new interfaces as idle upon init
Date: Thu, 22 May 2014 12:17:47 +0300
Message-Id: <1400750267-2259-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140522_112048_539540_B017332A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Mark new interfaces as idle to allow operations that require that
interfaces are idle to take place. Interface types that are always
not idle (like AP interfaces) will be set as not idle when they are
assigned a channel context.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach<emmanuel.grumbach@intel.com>
---
 net/mac80211/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 69b656b..7552db2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1296,6 +1296,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
 	sdata->control_port_no_encrypt = false;
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
+	sdata->vif.bss_conf.idle = true;
 
 	sdata->noack_map = 0;
 
-- 
1.8.3.2

