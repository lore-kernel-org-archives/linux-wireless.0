Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2917 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1IUMgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:36:23 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 1/4] wireless: add new netlink attr to set tx rate for mgmt frame
Date: Wed, 21 Sep 2011 18:06:57 +0530
Message-ID: <1316608620-16483-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110921_143627_078188_803F8D89)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new nl80211 attribute that helps the user space
application to specify the rate for management frame transmission.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/linux/nl80211.h |    4 ++++
 net/wireless/nl80211.c  |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 460b12a..2666b23 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -919,6 +919,9 @@ enum nl80211_commands {
  *	rates based on negotiated supported rates information. This attribute
  *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
  *
+ * @NL80211_ATTR_TX_MGMT_RATE: User requested rate that used to
+ *	tranmit management frames
+ *
  * @NL80211_ATTR_FRAME_MATCH: A binary attribute which typically must contain
  *	at least one byte, currently used with @NL80211_CMD_REGISTER_FRAME.
  * @NL80211_ATTR_FRAME_TYPE: A u16 indicating the frame type/subtype for the
@@ -1222,6 +1225,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_COVERAGE_CLASS,
 
 	NL80211_ATTR_TX_RATES,
+	NL80211_ATTR_TX_MGMT_RATE,
 
 	NL80211_ATTR_FRAME_MATCH,
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3c6427a..a4ab044 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -164,6 +164,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
 	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_TX_MGMT_RATE] = { .type = NLA_U8 },
 	[NL80211_ATTR_FRAME] = { .type = NLA_BINARY,
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
-- 
1.7.6.3

