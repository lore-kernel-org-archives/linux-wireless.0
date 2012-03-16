Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36476 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031672Ab2CPOzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 10:55:40 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC] cfg80211: Indicate the automatic channel selection capability
Date: Fri, 16 Mar 2012 20:25:32 +0530
Message-ID: <1331909733-16767-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120316_155551_647367_7F3C7BB8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let the driver automatically select the channel based on the
channel conditions when it is not explicitly set.
The drivers which have this capability in the firmware can set
the WIPHY_FLAG_SUPPORTS_ACS flag to indicate that to the
userspace.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    3 +++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be35a68..8d15101 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1197,6 +1197,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_ACS: Indicates whether the firmware is capable of doing
+ *      automatic channel selection if the channel is not explicitly set.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1442,6 +1445,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_ACS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0178c74..aa93a2c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1760,6 +1760,7 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_SUPPORTS_ACS: Device supports automatic channel selection.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1783,6 +1784,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_SUPPORTS_ACS			= BIT(22),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1998c36..3a876326 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_ACS] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -749,6 +750,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_FLAG(msg, NL80211_ATTR_TDLS_SUPPORT);
 	if (dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_ACS)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_ACS);
 
 	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
-- 
1.7.9

