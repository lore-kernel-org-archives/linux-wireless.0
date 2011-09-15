Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22730 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1IOJmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:42:20 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] wireless: Fix rate mask for scan request
Date: Thu, 15 Sep 2011 15:12:29 +0530
Message-ID: <1316079749-10509-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110915_114225_735245_8E0418E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan request received from cfg80211_connect do not
have proper rate mast. So the probe request sent on each
channel do not have proper the supported rates ie.

Cc: stable@kernel.org
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/wireless/sme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b7b6ff8..dec0fa2 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -118,6 +118,8 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 			     i++, j++)
 				request->channels[i] =
 					&wdev->wiphy->bands[band]->channels[j];
+			request->rates[band] =
+				(1 << wdev->wiphy->bands[band]->n_bitrates) - 1;
 		}
 	}
 	request->n_channels = n_channels;
-- 
1.7.6.1

