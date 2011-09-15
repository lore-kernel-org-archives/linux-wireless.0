Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6748 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab1IOJON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:14:13 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [RFC] wireless: Fix rate mask for scan request
Date: Thu, 15 Sep 2011 14:44:49 +0530
Message-ID: <1316078089-7221-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110915_111417_007159_2607F6D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan request received from cfg80211_connect do not
have proper rate mast. So the probe request sent on each
channel do not have proper the supported rates ie.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/wireless/sme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b7b6ff8..8b6ef34 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -118,6 +118,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 			     i++, j++)
 				request->channels[i] =
 					&wdev->wiphy->bands[band]->channels[j];
+			request->rates[band] = (u32) -1;
 		}
 	}
 	request->n_channels = n_channels;
-- 
1.7.6.1

