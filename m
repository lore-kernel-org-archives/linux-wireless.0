Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43364 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaATOZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:25:41 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so2740811eaj.14
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:25:40 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/7] mac80211: treat IBSS CSA finish failure seriously
Date: Mon, 20 Jan 2014 15:21:05 +0100
Message-Id: <1390227670-19030-3-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152546_292607_2D2CA4A5)
In-Reply-To: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Other interface modes are checked against failure.
This should avoid false-positive channel switch
events where IBSS CSA actually failed.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 62bf6c4..76fe1f90 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3039,7 +3039,9 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 			return;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		ieee80211_ibss_finish_csa(sdata);
+		err = ieee80211_ibss_finish_csa(sdata);
+		if (err < 0)
+			return;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
-- 
1.8.4.rc3

