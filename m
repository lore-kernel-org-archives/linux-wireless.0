Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35787 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaCGNiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 08:38:13 -0500
Received: by mail-ea0-f175.google.com with SMTP id d10so2321292eaj.34
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 05:38:12 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Subject: [RFC PATCH 6/8] nl80211: Support for 5/10 MHz channels when reporting BW restrictions
Date: Fri,  7 Mar 2014 14:37:53 +0100
Message-Id: <1394199475-5208-7-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143819_394258_5B9C5937)
In-Reply-To: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48040cd..8b40a3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -606,6 +606,12 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
+			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_10MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_10MHZ))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-- 
1.8.5.1

