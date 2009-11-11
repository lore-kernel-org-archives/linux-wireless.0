Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:15025 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbZKKKaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 05:30:46 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH, v2] cfg80211: introduce nl80211_get_ifidx()
Date: Wed, 11 Nov 2009 11:30:02 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911111130.02671.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... which get's rid of three indentical cut-n-paste sections.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
v2: moved setting of cb->args[0] in nl80211_dump_scan()
    changed to "diff -p"

--- linux-wl.orig/net/wireless/nl80211.c
+++ linux-wl/net/wireless/nl80211.c
@@ -151,6 +151,26 @@ nl80211_key_policy[NL80211_KEY_MAX + 1] 
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 };
 
+/* ifidx get helper */
+static int nl80211_get_ifidx(struct netlink_callback *cb)
+{
+	int res;
+
+	res = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+			  nl80211_fam.attrbuf, nl80211_fam.maxattr,
+			  nl80211_policy);
+	if (res)
+		return res;
+
+	if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
+		return -EINVAL;
+
+	res = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
+	if (!res)
+		return -EINVAL;
+	return res;
+}
+
 /* IE validation */
 static bool is_valid_ie_attr(const struct nlattr *attr)
 {
@@ -1682,20 +1702,10 @@ static int nl80211_dump_station(struct s
 	int sta_idx = cb->args[1];
 	int err;
 
-	if (!ifidx) {
-		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
-				  nl80211_policy);
-		if (err)
-			return err;
-
-		if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
-			return -EINVAL;
-
-		ifidx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
-		if (!ifidx)
-			return -EINVAL;
-	}
+	if (!ifidx)
+		ifidx = nl80211_get_ifidx(cb);
+	if (ifidx < 0)
+		return ifidx;
 
 	rtnl_lock();
 
@@ -2145,20 +2155,10 @@ static int nl80211_dump_mpath(struct sk_
 	int path_idx = cb->args[1];
 	int err;
 
-	if (!ifidx) {
-		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
-				  nl80211_policy);
-		if (err)
-			return err;
-
-		if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
-			return -EINVAL;
-
-		ifidx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
-		if (!ifidx)
-			return -EINVAL;
-	}
+	if (!ifidx)
+		ifidx = nl80211_get_ifidx(cb);
+	if (ifidx < 0)
+		return ifidx;
 
 	rtnl_lock();
 
@@ -3181,21 +3181,11 @@ static int nl80211_dump_scan(struct sk_b
 	int start = cb->args[1], idx = 0;
 	int err;
 
-	if (!ifidx) {
-		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
-				  nl80211_policy);
-		if (err)
-			return err;
-
-		if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
-			return -EINVAL;
-
-		ifidx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
-		if (!ifidx)
-			return -EINVAL;
-		cb->args[0] = ifidx;
-	}
+	if (!ifidx)
+		ifidx = nl80211_get_ifidx(cb);
+	if (ifidx < 0)
+		return ifidx;
+	cb->args[0] = ifidx;
 
 	dev = dev_get_by_index(sock_net(skb->sk), ifidx);
 	if (!dev)


-- 
http://www.holgerschurig.de
