Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3475 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYBORnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 12:43:18 -0500
Subject: [PATCH] net/8021q/vlan_dev.c - Use print_mac
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>
Cc: bruno@thinktube.com, netdev@vger.kernel.org, jgarzik@pobox.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20080215.025855.202184003.davem@davemloft.net>
References: <20080215104804.9870.15722.stgit@one>
	 <20080215.025855.202184003.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 09:42:50 -0800
Message-Id: <1203097370.21308.18.camel@localhost> (sfid-20080215_174323_227056_8DF878F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-15 at 02:58 -0800, David Miller wrote:
> From: Bruno Randolf <bruno@thinktube.com>
> Date: Fri, 15 Feb 2008 19:48:05 +0900
> > is there any chance to include a macro like this for printing mac
> addresses?
> > its advantage is that it can be used without the need to declare
> buffers for
> > print_mac(), for example:
> We specifically removed this sort of thing, please don't
> add it back.

Remove direct use of MAC_FMT

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 77f04e4..839c70e 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -366,7 +366,8 @@ static int vlan_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_device_stats *stats = &dev->stats;
 	struct vlan_ethhdr *veth = (struct vlan_ethhdr *)(skb->data);
-
+	DECLARE_MAC_BUF(mac);
+	DECLARE_MAC_BUF(mac2);
 	/* Handle non-VLAN frames if they are sent to us, for example by DHCP.
 	 *
 	 * NOTE: THIS ASSUMES DIX ETHERNET, SPECIFICALLY NOT SUPPORTING
@@ -404,11 +405,8 @@ static int vlan_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	pr_debug("%s: about to send skb: %p to dev: %s\n",
 		__FUNCTION__, skb, skb->dev->name);
-	pr_debug("  " MAC_FMT " " MAC_FMT " %4hx %4hx %4hx\n",
-		 veth->h_dest[0], veth->h_dest[1], veth->h_dest[2],
-		 veth->h_dest[3], veth->h_dest[4], veth->h_dest[5],
-		 veth->h_source[0], veth->h_source[1], veth->h_source[2],
-		 veth->h_source[3], veth->h_source[4], veth->h_source[5],
+	pr_debug("  %s %s %4hx %4hx %4hx\n",
+		 print_mac(mac, veth->h_dest), print_mac(mac2, veth->h_source),
 		 veth->h_vlan_proto, veth->h_vlan_TCI,
 		 veth->h_vlan_encapsulated_proto);
 


