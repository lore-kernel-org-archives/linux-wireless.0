Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [129.187.255.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBAF32BF4B;
	Thu, 16 Jul 2026 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784218460; cv=none; b=u0MCOdWEe447yIfif22bo2XfX0ZTgpw3nC0cdaR7ayTsbfeepmVonOKBMoCMp6ClT8BrH3vCzfrZCfqjic96xFDmNega3tsmYtENQwXAND8Z1/RXVmWJjXSa6WjCtXotgTpEVKP2S0zRlFOojtbcF76UdegRl5uMvUuUOdSWldA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784218460; c=relaxed/simple;
	bh=lzYAKpJEV5unlgQKEDoKNlSHsWIylmWOrD5lWPsqAuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPqfabarlerKii69eTq+vlCj/7A9BKUGWZjeZ6C3JBBFz/RBXPh0Cp8xtJXE3Yamp1R4lpDi/SviODijP0fJVvhqMGGDnAeLLiNYIevg85sSb/0Nh6Vw4oorJnTQ1Hll9VHdVS3Q+vxoF17CMEAgSIsdFL6A3gaRJjwOQnm7qyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de; spf=pass smtp.mailfrom=hs-ansbach.de; dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b=i6p4E3lG; arc=none smtp.client-ip=129.187.255.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b="i6p4E3lG"
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
	by postout1.mail.lrz.de (Postfix) with ESMTP id 4h1J5F2T4wzyYp;
	Thu, 16 Jul 2026 18:14:09 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=hs-ansbach.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hs-ansbach.de;
	 h=content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=an-postout22; t=1784218448; bh=9bJn0piTTme
	n5iChO4X/e3OxjL1veiXLjXqZM3rDpqE=; b=i6p4E3lG0svoSoc0VYFKMpr8Owb
	+xwXTqfXaCC2HL/p3cwf/VNMxuJ99tHYaMkXX1kCIT9TGq9IBJoKg1Qh/cXrTAhd
	8wh+e9wvtLUTPv3oYxT+6NUg/PeE1qtDQH+2FHKgtSgGvs5JIV2vdnEHD/WaOAG0
	jSxethPqGfI6hlHZAFhWXCYcHzD3UPEq7RAVZYs1b2VBloC+XVoTS2cAJPyE0NWl
	oVpjOYEEeofT3gMFThmx1vkroLBCSdgRaBLvmA2QbzB2qSU1Dc2rZCOPmS+6xBOt
	K5TeReM8zgMIBx1VHTGiXX2flbudYmOrfPSsVW1n3CgWC5cXyRxSllUksmw==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs51.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.887
X-Spam-Level:
Received: from postout1.mail.lrz.de ([127.0.0.1])
 by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id l8nOoOwTyC_4; Thu, 16 Jul 2026 18:14:08 +0200 (CEST)
Received: from chimchar.fritz.box (p200300eeb7001900d36d09bcf7cd0c19.dip0.t-ipconnect.de [IPv6:2003:ee:b700:1900:d36d:9bc:f7cd:c19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout1.mail.lrz.de (Postfix) with ESMTPSA id 4h1J5C47YZzyVZ;
	Thu, 16 Jul 2026 18:14:07 +0200 (CEST)
From: Simon Dietz <dietz23838@hs-ansbach.de>
To: simon.dietz@plantwatch.de
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	dietz23838@hs-ansbach.de,
	edumazet@google.com,
	johannes@sipsolutions.net,
	kuniyu@google.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [RFC PATCH net-next v0 4/6] net: even further fix GeoNetworking
Date: Thu, 16 Jul 2026 18:12:13 +0200
Message-ID: <20260716161213.3567275-1-dietz23838@hs-ansbach.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716154909.3449985-1-dietz23838@hs-ansbach.de>
References: <20260716154909.3449985-1-dietz23838@hs-ansbach.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Dietz <simon.dietz@plantwatch.de>

Include another set of fixes, including:
- gn_find_interface improvements
- move of timer setup to gn_init
- fix for missing packets
- kfree_skb fixes
- fixed return value in gn_sendmsg
- fixed error handling near register_snap_client
- uses hlist_for_each_entry_safe
- support for NETDEV_UNREGISTER
- timer improvements

Signed-off-by: Simon Dietz <simon.dietz@plantwatch.de>
---
 include/linux/gn_routing.h |  1 +
 net/gn/gn_prot.c           | 67 +++++++++++++++++++++++++++-----------
 net/gn/gn_routing.c        |  4 +++
 3 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/include/linux/gn_routing.h b/include/linux/gn_routing.h
index 9384bbc4b288..64ccc80f5a90 100644
--- a/include/linux/gn_routing.h
+++ b/include/linux/gn_routing.h
@@ -55,6 +55,7 @@ struct loc_te {
 s64 gn_F(struct gn_coord self, struct gn_geo_scope scope);
 int gn_gxc_forward(struct gn_iface *gnif, s64 f, u8 *addr, struct gn_lpv *depv);
 
+struct gn_iface *gn_find_interface(gn_address_t addr);
 struct gn_iface *gn_find_interface_by_dev(struct net_device *dev);
 int gn_query_ll_address(gn_address_t addr, u8 *ll_address);
 int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_address);
diff --git a/net/gn/gn_prot.c b/net/gn/gn_prot.c
index 3c4e1157fbde..90ecbd67b64d 100644
--- a/net/gn/gn_prot.c
+++ b/net/gn/gn_prot.c
@@ -30,6 +30,7 @@
 
 struct datalink_proto *gn_dl;
 static const struct proto_ops gn_dgram_ops;
+static struct timer_list gn_beacon_timer;
 
 /* Handlers for the socket list. */
 
@@ -114,6 +115,9 @@ static struct gn_iface *gn_if_add_device(struct net_device *dev,
 	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
 		if (gnif->dev == dev) {
 			// Replace existing interface address
+			atomic_set(&new_gnif->local_sn,
+				   atomic_read(&gnif->local_sn));
+			memcpy(&new_gnif->pos, &gnif->pos, sizeof(gnif->pos));
 			hlist_replace_rcu(&gnif->hnode, &new_gnif->hnode);
 			spin_unlock_bh(&gn_interfaces_lock);
 			kfree_rcu(gnif, rcu);
@@ -135,12 +139,14 @@ static struct gn_iface *gn_if_add_device(struct net_device *dev,
 static void gn_if_drop_device(struct net_device *dev)
 {
 	struct gn_iface *gnif;
+	struct hlist_node *tmp;
 
 	spin_lock_bh(&gn_interfaces_lock);
-	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
+	hlist_for_each_entry_safe(gnif, tmp, &gn_interfaces, hnode) {
 		if (gnif->dev == dev) {
 			hlist_del_rcu(&gnif->hnode);
 			kfree_rcu(gnif, rcu);
+			break;
 		}
 	}
 	spin_unlock_bh(&gn_interfaces_lock);
@@ -162,7 +168,7 @@ static void gn_interfaces_clear(void)
 /*
  * find the interface to which the socketaddress is bound
  */
-static struct gn_iface *gn_find_interface(gn_address_t addr)
+struct gn_iface *gn_find_interface(gn_address_t addr)
 {
 	struct gn_iface *gnif;
 	bool found = false;
@@ -212,7 +218,7 @@ static int gn_device_event(struct notifier_block *this, unsigned long event,
 	if (dev->type != ARPHRD_ETHER)
 		return NOTIFY_DONE;
 
-	if (event == NETDEV_DOWN)
+	if (event == NETDEV_DOWN || event == NETDEV_UNREGISTER)
 		gn_if_drop_device(dev);
 
 	return NOTIFY_DONE;
@@ -475,7 +481,7 @@ void gn_fill_sopv(struct gn_iface *gnif, struct gn_lpv *sopv, gn_address_t addr)
 
 	ktime_t tst = ktime_set(gnif->pos.tst.tv_sec, gnif->pos.tst.tv_nsec);
 	// fill empty timestamp with current timestamp
-	if (tst == 0)
+	if (tst == 0 || ktime_before(tst, ms_to_ktime(1072915232000LLU)))
 		sopv->tst = cpu_to_be32(gn_timestamp_now());
 	else
 		sopv->tst = cpu_to_be32(gn_tai_to_gn(tst));
@@ -825,7 +831,7 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 			pr_warn("dropping packet");
 			goto drop;
 		}
-		fwd_gb_h = (struct gn_basic_header *)skb_transport_header(
+		fwd_gb_h = (struct gn_basic_header *)skb_network_header(
 			forward_skb);
 		fwd_gb_h->rhl--;
 
@@ -839,19 +845,24 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 			break;
 		case GN_FORWARD_BUFFER:
 			pr_warn("forwarding buffers not implemented");
+			kfree_skb(forward_skb);
 			break;
 		case GN_FORWARD_DISCARD:
+			kfree_skb(forward_skb);
 			break;
 		default:
 			WARN_ONCE(1, "internal error: unexpected return value");
+			kfree_skb(forward_skb);
 			goto drop;
 		}
 	}
 
 	// Local delivery
-	if (f_value >= 0 &&
-	    gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS) {
-		goto drop;
+	if (f_value >= 0) {
+		if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
+			goto drop;
+	} else {
+		kfree_skb(skb);
 	}
 
 	return NET_RX_SUCCESS;
@@ -938,6 +949,7 @@ static int gn_process_beacon_packet(struct sk_buff *skb, const u8 *llc)
 	}
 
 	gn_ls_flush(gh->beacon_h.sopv.addr);
+	kfree_skb(skb);
 	return NET_RX_SUCCESS;
 }
 
@@ -1029,6 +1041,11 @@ static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
 		goto drop;
 
 	eth = (struct ethhdr *)skb_mac_header(skb);
+	// TODO: validate
+	if (skb->pkt_type == PACKET_LOOPBACK ||
+	    ether_addr_equal(eth->h_source, dev->dev_addr))
+		goto drop;
+
 	skb_reset_network_header(skb);
 
 	if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE))
@@ -1274,7 +1291,8 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	dev = gnif->dev;
 
 	packet_subtype = CH_HST_UNSPECIFIED;
-	if (0 /* is usgn unicast address? */) {
+	if (usgn->sgn_addr != 0 && usgn->sgn_addr != GNADDR_BROADCAST &&
+	    gn->scope.scope_type == GN_SCOPE_UNSPECIFIED) {
 		packet_type = CH_HT_GUC;
 	} else {
 		switch (gn->scope.scope_type) {
@@ -1402,6 +1420,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		break;
 	default:
 		WARN_ONCE(1, "internal error");
+		kfree_skb(skb);
 		err = -EINVAL;
 		goto out;
 	}
@@ -1428,6 +1447,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 					   gn);
 		} else {
 			WARN_ONCE(1, "internal error");
+			kfree_skb(skb);
 			err = -EINVAL;
 			goto out;
 		}
@@ -1463,6 +1483,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			break;
 		case GN_QUEUE_ERROR:
 		default:
+			kfree_skb(skb);
 			err = -ENOMEM;
 			goto out;
 		}
@@ -1473,7 +1494,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 
 	/* Destination position vector routing handled via location service queue */
 
-	err = 0;
+	err = len;
 out:
 	release_sock(sk);
 	return err;
@@ -1578,17 +1599,19 @@ static int gn_send_beacon(struct gn_iface *gnif)
 static void gn_send_beacons(struct timer_list *tl)
 {
 	struct gn_iface *gnif;
+	bool empty = true;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
 		gn_send_beacon(gnif);
+		empty = false;
 	}
 	rcu_read_unlock();
 
-	mod_timer(tl, jiffies + msecs_to_jiffies(GN_BEACON_RETRANSMIT_TIME));
+	if (!empty)
+		mod_timer(tl, jiffies + msecs_to_jiffies(GN_BEACON_RETRANSMIT_TIME));
 }
 
-static DEFINE_TIMER(gn_beacon_timer, gn_send_beacons);
 
 static void gn_activate_beacon(void)
 {
@@ -1909,23 +1932,28 @@ static int __init gn_init(void)
 {
 	int rc;
 
+	timer_setup(&gn_beacon_timer, gn_send_beacons, 0);
+
 	rc = proto_register(&gn_proto, 0);
 	if (rc)
-		goto out;
+		return rc;
 
 	rc = sock_register(&gn_family_ops);
 	if (rc)
 		goto out_proto;
 
 	gn_dl = register_snap_client(gn_snap_id, gn_rcv);
-	if (!gn_dl)
+	if (!gn_dl) {
 		pr_crit("Unable to register GeoNetworking with SNAP.\n");
+		rc = -ENOMEM;
+		goto out_snap;
+	}
 
 	dev_add_pack(&gn_packet_type);
 
 	rc = register_netdevice_notifier(&gn_notifier);
 	if (rc)
-		goto out_sock;
+		goto out_dev;
 
 	rc = gn_proc_init();
 	if (rc)
@@ -1936,19 +1964,20 @@ static int __init gn_init(void)
 		goto out_proc;
 #endif
 
-out:
-	return rc;
+	return 0;
+
 out_proc:
 	gn_proc_exit();
 out_nd:
 	unregister_netdevice_notifier(&gn_notifier);
-out_sock:
+out_dev:
 	dev_remove_pack(&gn_packet_type);
 	unregister_snap_client(gn_dl);
+out_snap:
 	sock_unregister(PF_GN);
 out_proto:
 	proto_unregister(&gn_proto);
-	goto out;
+	return rc;
 }
 module_init(gn_init);
 
diff --git a/net/gn/gn_routing.c b/net/gn/gn_routing.c
index de1c77359e09..733ebd0d715a 100644
--- a/net/gn/gn_routing.c
+++ b/net/gn/gn_routing.c
@@ -333,6 +333,9 @@ int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour,
 	struct loc_te *entry;
 	bool found = false;
 
+	if (gn_find_interface(pv->addr))
+		return -EINVAL;
+
 	spin_lock_bh(&gn_loc_t_lock);
 	hash_for_each_possible(gn_loc_t, entry, hnode, pv->addr) {
 		if (entry->addr != pv->addr)
@@ -443,6 +446,7 @@ int gn_ls_queue(gn_address_t dest_addr, struct sk_buff *skb)
 		} else if (entry->ls_pending == 1) {
 			// Entry is stale, but we already sent a LS request
 			rc = GN_QUEUE_LS_PENDING;
+			__ls_queue(&entry->lsb, skb);
 		} else {
 			// Entry is stale, perform LS request
 			rc = GN_QUEUE_LS_STALE;
-- 
2.55.0

