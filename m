Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:60388 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3JBHnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 03:43:18 -0400
Received: by mail-ea0-f169.google.com with SMTP id k11so190086eaj.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 00:43:17 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] nl80211: Provide per channel maximum regulatory transmit power
Date: Wed,  2 Oct 2013 09:43:09 +0200
Message-Id: <1380699789-3765-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20131002_094323_674346_3F3B87DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases its not only required to know the maximum transmit power
the hw is capable of. Instead, userspace (hostapd) might want to know
the maximum transmit power as defined in the current regulatory domain
(for example for 802.11d country IEs).

Hence, provide that information to user space via nl80211.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 include/uapi/linux/nl80211.h |    3 +++
 net/wireless/nl80211.c       |    4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..6130278 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2230,6 +2230,8 @@ enum nl80211_band_attr {
  *	isn't possible
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
+ * @NL80211_FREQUENCY_ATTR_MAX_REG_TX_POWER: Maximum regulatory transmission
+ *	power in mBm (100 * dBm).
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_frequency_attr {
@@ -2246,6 +2248,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_MAX_REG_TX_POWER,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 626dc3b..7c22355 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -584,6 +584,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 			DBM_TO_MBM(chan->max_power)))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_REG_TX_POWER,
+			DBM_TO_MBM(chan->max_reg_power)))
+		goto nla_put_failure;
+
 	return 0;
 
  nla_put_failure:
-- 
1.7.10.4

