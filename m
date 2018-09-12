Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:55100 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeILNjw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 09:39:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 2/2] netlink: add ethernet address policy types
Date: Wed, 12 Sep 2018 10:36:10 +0200
Message-Id: <20180912083610.20857-2-johannes@sipsolutions.net> (sfid-20180912_103626_323977_496053AC)
In-Reply-To: <20180912083610.20857-1-johannes@sipsolutions.net>
References: <20180912083610.20857-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Commonly, ethernet addresses are just using a policy of
	{ .len = ETH_ALEN }
which leaves userspace free to send more data than it should,
which may hide bugs.

Introduce NLA_ETH_ADDR which checks for exact size, and rejects
the attribute if the length isn't ETH_ALEN.

Also add NLA_ETH_ADDR_COMPAT which can be used in place of the
policy above, but will, in addition, warn on an address that's
too long.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 4 ++++
 lib/nlattr.c          | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 04e40fcc70d6..1139163c0db0 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -181,6 +181,8 @@ enum {
 	NLA_S64,
 	NLA_BITFIELD32,
 	NLA_REJECT,
+	NLA_ETH_ADDR,
+	NLA_ETH_ADDR_COMPAT,
 	__NLA_TYPE_MAX,
 };
 
@@ -213,6 +215,8 @@ enum {
  *                         data must point to a u32 value of valid flags
  *    NLA_REJECT           Reject this attribute, validation data may point
  *                         to a string to report as the error in extended ACK.
+ *    NLA_ETH_ADDR         Ethernet address, rejected if not exactly 6 octets.
+ *    NLA_ETH_ADDR_COMPAT  Ethernet address, only warns if not exactly 6 octets.
  *    All other            Minimum length of attribute payload
  *
  * Example:
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 9ec0cc151148..3165b6d0baaa 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -29,6 +29,8 @@ static const u8 nla_attr_len[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_ETH_ADDR]	= ETH_ALEN,
+	[NLA_ETH_ADDR_COMPAT] = ETH_ALEN,
 };
 
 static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
@@ -42,6 +44,7 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
 	[NLA_S16]	= sizeof(s16),
 	[NLA_S32]	= sizeof(s32),
 	[NLA_S64]	= sizeof(s64),
+	[NLA_ETH_ADDR_COMPAT] = ETH_ALEN,
 };
 
 static int validate_nla_bitfield32(const struct nlattr *nla,
@@ -93,6 +96,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			extack->_msg = pt->validation_data;
 		return -EINVAL;
 
+	case NLA_ETH_ADDR:
+		if (attrlen != ETH_ALEN)
+			return -ERANGE;
+		break;
+
 	case NLA_FLAG:
 		if (attrlen > 0)
 			return -ERANGE;
-- 
2.14.4
