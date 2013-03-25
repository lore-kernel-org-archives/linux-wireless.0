Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:38902 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758304Ab3CYJ6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 05:58:14 -0400
Date: Mon, 25 Mar 2013 11:15:59 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Document update_ft_ies() cfg80211_ops
Message-ID: <20130325091559.GA30599@w1.fi> (sfid-20130325_105826_820103_5A13880D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was forgotten from the commit that added support for FT
operations with drivers that implement SME.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 include/net/cfg80211.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bdba9b6..57870b6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1998,6 +1998,10 @@ struct cfg80211_update_ft_ies_params {
  *	advertise the support for MAC based ACL have to implement this callback.
  *
  * @start_radar_detection: Start radar detection in the driver.
+ *
+ * @update_ft_ies: Provide updated Fast BSS Transition information to the
+ *	driver. If the SME is in the driver/firmware, this information can be
+ *	used in building Authentication and Reassociation Request frames.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
