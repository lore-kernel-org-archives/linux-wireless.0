Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:58856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbYLPUic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 15:38:32 -0500
Received: by ug-out-1314.google.com with SMTP id 39so304033ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 12:38:31 -0800 (PST)
Message-ID: <eb3ff54b0812161238y1ffdff2blf383e5354fdd5232@mail.gmail.com> (sfid-20081216_213837_081698_0C74E741)
Date: Tue, 16 Dec 2008 22:38:29 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH] mac80211: fix an error in ieee80211_send_assoc() method.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an error in ieee80211_send_assoc(), net/mac80211/mlme.c.

The error is usage of a wrong member when building
the ie80211 management frame (it should be assoc_req, and not reassoc_req).

This error is due to commit ea95bba41e69c616bb1512cf59d22f33266b8568,
which dealt with configuring a listen interval , from Jul 18, 2008.

(wireless-testing)

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9a06905..829cdf8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -309,7 +309,7 @@ static void ieee80211_send_assoc(struct
ieee80211_sub_if_data *sdata,
 		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						  IEEE80211_STYPE_ASSOC_REQ);
 		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.reassoc_req.listen_interval =
+		mgmt->u.assoc_req.listen_interval =
 				cpu_to_le16(local->hw.conf.listen_interval);
 	}
