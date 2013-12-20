Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48501 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3LTIlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 03:41:51 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so2349802pbc.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Dec 2013 00:41:50 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: enable WME for peer mesh STA
Date: Fri, 20 Dec 2013 16:39:52 +0800
Message-Id: <1387528792-27198-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131220_094156_992477_4F41EEA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the WME for peer mesh STA so that the driver, 
such as wcn36xx, will pick this up and enabling it in HW.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_plink.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index cf83217..e8f60aa 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -437,6 +437,7 @@ __mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *hw_addr)
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTHORIZED);
 
 	set_sta_flag(sta, WLAN_STA_WME);
+	sta->sta.wme = true;
 
 	return sta;
 }
-- 
1.7.9.5

