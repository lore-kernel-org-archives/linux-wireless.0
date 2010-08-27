Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27914 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0H0LIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:08:13 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com
Subject: [PATCH 1/4] cfg80211: allow vendor specific cipher suites
Date: Fri, 27 Aug 2010 14:07:36 +0300
Message-Id: <1282907259-30825-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1282907259-30825-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1282907259-30825-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

cfg80211 currently rejects all cipher suites it
doesn't know about for key length checking
purposes. This can lead to inconsistencies when
a driver advertises an algorithm that cfg80211
doesn't know about. Remove this rejection so
drivers can specify any algorithm they like.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/wireless/util.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8d961cc..bca32eb 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -183,7 +183,14 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 		break;
 	default:
-		return -EINVAL;
+		/*
+		 * We don't know anything about this algorithm,
+		 * allow using it -- but the driver must check
+		 * all parameters! We still check below whether
+		 * or not the driver supports this algorithm,
+		 * of course.
+		 */
+		break;
 	}
 
 	if (params->seq) {
-- 
1.6.3.3

