Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42489 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAOMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:09:27 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so808615eek.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:09:26 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/9] mac80211: treat IBSS CSA finish failure seriously
Date: Wed, 15 Jan 2014 13:04:47 +0100
Message-Id: <1389787494-7361-3-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130931_467842_501B2EDA)
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
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
index 8c78572..2ab5f49 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3040,7 +3040,9 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 			goto unlock;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		ieee80211_ibss_finish_csa(sdata);
+		err = ieee80211_ibss_finish_csa(sdata);
+		if (err < 0)
+			goto unlock;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
-- 
1.8.4.rc3

