Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f170.google.com ([209.85.212.170]:51390 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab1ECX5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:33 -0400
Received: by pxi19 with SMTP id 19so426563pxi.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:33 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 02/13] mac80211: Let userspace send action frames over mesh interfaces
Date: Tue,  3 May 2011 16:57:08 -0700
Message-Id: <1304467039-7730-3-git-send-email-javier@cozybit.com> (sfid-20110504_015738_091198_818DEA62)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/wireless/mlme.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 16881fe..493b939 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -963,6 +963,16 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			if (memcmp(mgmt->bssid, dev->dev_addr, ETH_ALEN))
 				err = -EINVAL;
 			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			if (memcmp(mgmt->sa, mgmt->bssid, ETH_ALEN)) {
+				err = -EINVAL;
+				break;
+			}
+			/*
+			 * check for mesh DA must be done by driver as
+			 * cfg80211 doesn't track the stations
+			 */
+			break;
 		default:
 			err = -EOPNOTSUPP;
 			break;
-- 
1.7.1

