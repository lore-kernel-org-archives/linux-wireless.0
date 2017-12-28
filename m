Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:44708 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932451AbdL1R6l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 12:58:41 -0500
Received: by mail-it0-f67.google.com with SMTP id b5so28888200itc.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 09:58:41 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC 4/4] nl80211: Implement TX of control port frames
Date: Thu, 28 Dec 2017 11:58:32 -0600
Message-Id: <20171228175832.3253-5-denkenz@gmail.com> (sfid-20171228_185853_252453_1C65EE95)
In-Reply-To: <20171228175832.3253-1-denkenz@gmail.com>
References: <20171228175832.3253-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit implements the TX side of NL80211_CMD_CONTROL_PORT_FRAME.
Userspace provides the raw EAPoL frame using NL80211_ATTR_FRAME.  A
skbuf is built and then injected onto the netdev of the wireless device.
The CONTROL_PORT_ETHERTYPE_NO_ENCRYPT will still in theory be honored by
the underlying TX path code.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/nl80211.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 220fe5bc57fd..d6191579f044 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12464,6 +12464,64 @@ static int nl80211_del_pmk(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
+static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
+{
+	struct wireless_dev *wdev = info->user_ptr[1];
+	const u8 *buf;
+	u8 *dest;
+	size_t len;
+	struct ethhdr *ehdr;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_FRAME])
+		return -EINVAL;
+
+	wdev_lock(wdev);
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		if (wdev->current_bss)
+			break;
+		err = -ENOTCONN;
+		goto out;
+	default:
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
+	len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
+
+	skb = dev_alloc_skb(sizeof(struct ethhdr) + len);
+	if (!skb) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	skb_reserve(skb, sizeof(struct ethhdr));
+
+	dest = skb_put(skb, len);
+	memcpy(dest, buf, len);
+
+	ehdr = skb_push(skb, sizeof(struct ethhdr));
+	memcpy(ehdr->h_dest, wdev->current_bss->pub.bssid, ETH_ALEN);
+	memcpy(ehdr->h_source, wdev_address(wdev), ETH_ALEN);
+	ehdr->h_proto = cpu_to_be16(ETH_P_PAE); // TODO: How to get ethertype?
+
+	wdev_unlock(wdev);
+
+	skb->dev = wdev->netdev;
+	skb->protocol = htons(ETH_P_802_3);
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+	dev_queue_xmit(skb);
+	return 0;
+
+ out:
+	wdev_unlock(wdev);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13359,7 +13417,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
-
+	{
+		.cmd = NL80211_CMD_CONTROL_PORT_FRAME,
+		.doit = nl80211_tx_control_port,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
-- 
2.13.5
