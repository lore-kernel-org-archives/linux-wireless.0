Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:48388 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaAPNHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:07:03 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so2460818lab.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 05:07:00 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Don't touch split_start when split dump is not used
Date: Thu, 16 Jan 2014 14:06:47 +0100
Message-Id: <1389877607-3162-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20140116_140707_908376_BDAA8E32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the netlink skb is exhausted split_start is left set. In the
subsequent retry, with a larger buffer, the dump is continued from the
failing point instead of from the beginning.

This was causing my rt28xx based USB dongle to now show up when
running "iw list" with an old iw version without split dump support.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 net/wireless/nl80211.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0afd82..32745e9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1184,6 +1184,12 @@ struct nl80211_dump_wiphy_state {
 	bool split;
 };
 
+static void split_start_inc(struct nl80211_dump_wiphy_state *state)
+{
+	if (state->split)
+		state->split_start++;
+}
+
 static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			      struct sk_buff *msg, u32 portid, u32 seq,
 			      int flags, struct nl80211_dump_wiphy_state *state)
@@ -1255,7 +1261,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if ((dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
-		state->split_start++;
+		split_start_inc(state);
 		if (state->split)
 			break;
 	case 1:
@@ -1300,14 +1306,14 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			}
 		}
 
-		state->split_start++;
+		split_start_inc(state);
 		if (state->split)
 			break;
 	case 2:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 					dev->wiphy.interface_modes))
 				goto nla_put_failure;
-		state->split_start++;
+		split_start_inc(state);
 		if (state->split)
 			break;
 	case 3:
@@ -1385,7 +1391,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 
 		/* if bands & channels are done, continue outside */
 		if (state->band_start == 0 && state->chan_start == 0)
-			state->split_start++;
+			split_start_inc(state);
 		if (state->split)
 			break;
 	case 4:
@@ -1479,7 +1485,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		}
 
 		nla_nest_end(msg, nl_cmds);
-		state->split_start++;
+		split_start_inc(state);
 		if (state->split)
 			break;
 	case 5:
@@ -1496,18 +1502,18 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 
 		if (nl80211_send_mgmt_stypes(msg, mgmt_stypes))
 			goto nla_put_failure;
-		state->split_start++;
+		split_start_inc(state);
 		if (state->split)
 			break;
 	case 6:
 #ifdef CONFIG_PM
 		if (nl80211_send_wowlan(msg, dev, state->split))
 			goto nla_put_failure;
-		state->split_start++;
+		split_start_inc(state);
 		if (state->split)
 			break;
 #else
-		state->split_start++;
+		split_start_inc(state);
 #endif
 	case 7:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
@@ -1518,7 +1524,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 						   state->split))
 			goto nla_put_failure;
 
-		state->split_start++;
+		split_start_inc(state);
 		if (state->split)
 			break;
 	case 8:
@@ -1560,7 +1566,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		 * case we'll continue with more data in the next round,
 		 * but break unconditionally so unsplit data stops here.
 		 */
-		state->split_start++;
+		split_start_inc(state);
 		break;
 	case 9:
 		if (dev->wiphy.extended_capabilities &&
@@ -1578,7 +1584,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			    dev->wiphy.vht_capa_mod_mask))
 			goto nla_put_failure;
 
-		state->split_start++;
+		split_start_inc(state);
 		break;
 	case 10:
 		if (nl80211_send_coalesce(msg, dev))
@@ -1588,7 +1594,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		    (nla_put_flag(msg, NL80211_ATTR_SUPPORT_5_MHZ) ||
 		     nla_put_flag(msg, NL80211_ATTR_SUPPORT_10_MHZ)))
 			goto nla_put_failure;
-		state->split_start++;
+		split_start_inc(state);
 		break;
 	case 11:
 		if (dev->wiphy.n_vendor_commands) {
-- 
1.8.3.2

