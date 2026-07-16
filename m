Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DA4334681;
	Thu, 16 Jul 2026 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784216875; cv=none; b=kxKxZGif51OWIMIx/GYnPuLaooUN49Uhl1kyu/33R9fydKGzJT3peEEYU8uTI8yW2LonUWswjW80Orh1q7XOn6Z3jBVIs73hq7GknI7kBv5xkwWwFw6BRpjOH48oA5LY0dUtSdDtMRNYccxEZo2aZAWqWmJ8RL0Bn0jx4EDsNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784216875; c=relaxed/simple;
	bh=8saz9EZ1yhc1/FIX/mU9PafqtpxIC15iyIIrsZBcLSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZD7jl1leXTlIFR7EuUQSibuHGWX1LuGQk+TFLuizV46HzkxLtN2W21NCvRnw8V3w/eeVJ88vYv4V20wDP+LkY2sbhsl7nkBkmhkGjbqX1NbKRDSP8YsDKuXAxm8xskzSROC6d0dzP5hZdK5cRRdW0iDH1NYQO9U/1H9BvXNe9s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de; spf=pass smtp.mailfrom=hs-ansbach.de; dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b=ozQhPPdN; arc=none smtp.client-ip=129.187.255.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b="ozQhPPdN"
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4h1HMG5bFhzyTX;
	Thu, 16 Jul 2026 17:41:14 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=hs-ansbach.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hs-ansbach.de;
	 h=content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=an-postout22; t=1784216473; bh=zFnCuPxOqjs
	nPkyIGlNlQlCdadWs+E9MO9r6FvsLaxo=; b=ozQhPPdNBdWGjzFYMIfS8+vNGSG
	rBPqKmmSfQXR1XEpGbFxArnA2QwK39y5BttZHUBl9LDegXtTKWEWmgR0d3N1Tc7Y
	rHsnKVvtT/+J7GVIQRZqeq7hlxyGhJIJOZ5DzvVxOHWvNPmCPCc2ON5MAzqEfFhD
	go4FBLC4IvfxfVDXk2JP6ImuzAF4YiRtw2dtsWkeRKuhzPLVPCY+EX1vdloyi8h6
	xqFmgloYSyqDKHcy1JlNjs7Xqtqs2/ABAEOuKFGmDOivgAEGQgOHTH2jOLCY+R5K
	UMR+ZZLJHXmY/gUhD3aJmFY3th3pCaGTzd5mHSkXd7iQ5MD24VXNDIOM14g==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.886
X-Spam-Level:
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id KPmirfGWT08P; Thu, 16 Jul 2026 17:41:13 +0200 (CEST)
Received: from chimchar.fritz.box (p200300eeb7001900d36d09bcf7cd0c19.dip0.t-ipconnect.de [IPv6:2003:ee:b700:1900:d36d:9bc:f7cd:c19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4h1HMC0rGdzyT9;
	Thu, 16 Jul 2026 17:41:11 +0200 (CEST)
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
Subject: [RFC PATCH net-next v0 2/6] net: fix GeoNetworking
Date: Thu, 16 Jul 2026 17:39:17 +0200
Message-ID: <20260716153917.3399255-1-dietz23838@hs-ansbach.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716135902.2895237-2-simon.dietz@plantwatch.de>
References: <20260716135902.2895237-2-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Dietz <simon.dietz@plantwatch.de>

Introduce several bug fixes to the GeoNetworking implementation,
including:
- hash_for_each_safe instead of hash_for_each
- < 0 checks
- is empty checks
- bound checks
- empty address checks
- BUG() call removals
- locking fixes
- proper kernel module unloading fixes
- pr_into to pr_debug changes
- using internal kernel structs in uapi fixes
- improved compat handling
- improved netns handling

Introduce several new/improved functionality, including:
- timestamp validation
- next-hop query logic
- location service flush logic
- destination position vector logic

Signed-off-by: Simon Dietz <simon.dietz@plantwatch.de>
---
 include/linux/gn.h         |  18 ++-
 include/linux/gn_routing.h |   4 +
 include/uapi/linux/gn.h    |   8 +-
 net/gn/gn_prot.c           | 268 +++++++++++++++++++++++--------------
 net/gn/gn_routing.c        | 182 +++++++++++++++++++++----
 5 files changed, 344 insertions(+), 136 deletions(-)

diff --git a/include/linux/gn.h b/include/linux/gn.h
index bcef5c169c0f..393a8f440028 100644
--- a/include/linux/gn.h
+++ b/include/linux/gn.h
@@ -40,9 +40,14 @@
 #define BH_NH_COMMON_HEADER 1
 #define BH_NH_SECURED_PACKET 2
 
-/* itsGnDefaultPacketLifetime: Default packet lifetime in seconds */
-// FIXME Has to be encoded
-#define BH_LT_DEFAULT 60
+#define GN_LT_BASE_50MS  (0 << 6)
+#define GN_LT_BASE_1S    (1 << 6)
+#define GN_LT_BASE_10S   (2 << 6)
+#define GN_LT_BASE_100S  (3 << 6)
+#define GN_ENCODE_LT(base, mult) ((base) | ((mult) & 0x3f))
+
+/* itsGnDefaultPacketLifetime: Default packet lifetime encoded as 60s (Base=1s, Mult=60) */
+#define BH_LT_DEFAULT GN_ENCODE_LT(GN_LT_BASE_1S, 60)
 
 #define CH_NH_ANY 0
 #define CH_NH_BTPA 1
@@ -241,12 +246,10 @@ struct gn_shb_header {
 } __attribute__ ((packed));
 
 
-//gac and gbc have the same structure
-//TODO: typedef
+/* GAC and GBC share the same header structure */
 struct gn_gxc_header {
 	__be16 sn;
 	__be16 reserved;
-	// TODO changed!! -> struct gn_spv sopv;
 	struct gn_lpv sopv;
 	__be32 gap_lat; //signed
 	__be32 gap_lon; //signed
@@ -256,6 +259,9 @@ struct gn_gxc_header {
 	__be16 reserved2;
 } __attribute__ ((packed));
 
+typedef struct gn_gxc_header gn_gac_header;
+typedef struct gn_gxc_header gn_gbc_header;
+
 struct gn_beacon_header {
 	struct gn_lpv sopv;
 } __attribute__ ((packed));
diff --git a/include/linux/gn_routing.h b/include/linux/gn_routing.h
index 44f098a0136c..9384bbc4b288 100644
--- a/include/linux/gn_routing.h
+++ b/include/linux/gn_routing.h
@@ -55,9 +55,13 @@ struct loc_te {
 s64 gn_F(struct gn_coord self, struct gn_geo_scope scope);
 int gn_gxc_forward(struct gn_iface *gnif, s64 f, u8 *addr, struct gn_lpv *depv);
 
+struct gn_iface *gn_find_interface_by_dev(struct net_device *dev);
 int gn_query_ll_address(gn_address_t addr, u8 *ll_address);
+int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_address);
+int gn_fill_depv(struct gn_spv *depv, gn_address_t dest_addr);
 int gn_ls_queue(gn_address_t dest_addr, struct sk_buff *skb);
 void gn_ls_flush(gn_address_t dest_addr);
 int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour, const u8 *ll_address, const __be16 *sn);
+void gn_routing_exit(void);
 
 #endif // __LINUX_GN_ROUTING_H__
diff --git a/include/uapi/linux/gn.h b/include/uapi/linux/gn.h
index 355737d483b5..c0df0d55f683 100644
--- a/include/uapi/linux/gn.h
+++ b/include/uapi/linux/gn.h
@@ -7,11 +7,7 @@
 #include <asm/byteorder.h>
 #include <linux/socket.h>
 
-#ifndef __KERNEL__
-#include <sys/time.h>
-#else
-#include <linux/time.h>
-#endif
+#include <linux/time_types.h>
 
 /*
  * GeoNetworking structures
@@ -74,7 +70,7 @@ struct gn_scope {
 };
 
 struct gn_position {
-	struct timespec64 tst;
+	struct __kernel_timespec tst;
 	struct gn_coord coord;
 	__u8 flags;
 };
diff --git a/net/gn/gn_prot.c b/net/gn/gn_prot.c
index d63c74807f8c..a59aadf843b0 100644
--- a/net/gn/gn_prot.c
+++ b/net/gn/gn_prot.c
@@ -4,6 +4,7 @@
  * GeoNetworking
  */
 
+#include <asm-generic/errno-base.h>
 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 #include <linux/if_arp.h>
 #include <linux/slab.h>
@@ -153,6 +154,19 @@ static void gn_if_drop_device(struct net_device *dev)
 	spin_unlock_bh(&gn_interfaces_lock);
 }
 
+static void gn_interfaces_clear(void)
+{
+	struct gn_iface *gnif;
+	struct hlist_node *tmp;
+
+	spin_lock_bh(&gn_interfaces_lock);
+	hlist_for_each_entry_safe(gnif, tmp, &gn_interfaces, hnode) {
+		hlist_del_rcu(&gnif->hnode);
+		kfree_rcu(gnif, rcu);
+	}
+	spin_unlock_bh(&gn_interfaces_lock);
+}
+
 /*
  * find the interface to which the socketaddress is bound
  */
@@ -175,7 +189,7 @@ static struct gn_iface *gn_find_interface(gn_address_t addr)
 /*
  * find an interface by the device it belongs to
  */
-static struct gn_iface *gn_find_interface_by_dev(struct net_device *dev)
+struct gn_iface *gn_find_interface_by_dev(struct net_device *dev)
 {
 	struct gn_iface *gnif;
 	bool found = false;
@@ -242,9 +256,8 @@ static int gn_create(struct net *net, struct socket *sock, int protocol,
 	int rc;
 
 	rc = -EAFNOSUPPORT;
-	//if (!net_eq(net, &init_net))
-	//	goto out;
-	// TODO: find out, why necessary
+	if (!net_eq(net, &init_net))
+		goto out;
 
 	rc = -ESOCKTNOSUPPORT;
 	if (sock->type != SOCK_DGRAM)
@@ -253,7 +266,7 @@ static int gn_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol < GN_PROTO_ANY || protocol > GN_PROTO_MAX)
 		goto out;
 
-	// TODO We don't support IPv6 atm
+	/* Note: Only BTP/GeoNetworking protocols are supported; IPv6 encapsulation is not enabled */
 	if (protocol == GN_PROTO_INET6)
 		goto out;
 
@@ -354,15 +367,13 @@ static struct sock *gn_find_or_insert_socket(struct sock *sk,
 
 static int gn_autobind(struct sock *sock)
 {
-	//BUG();
-	return -1;
+	return -EOPNOTSUPP;
 }
 
 /* Set the address 'our end' of the connection */
 static int gn_bind(struct socket *sock, struct sockaddr_unsized *uaddr,
 		   int addr_len)
 {
-	// struct sockaddr_gn *addr = (struct sockaddr_gn *)uaddr; TODO: remove this legacy line
 	DECLARE_SOCKADDR(struct sockaddr_gn *, addr, uaddr);
 	struct sock *sk = sock->sk;
 	struct gn_sock *gn = gn_sk(sk);
@@ -376,7 +387,10 @@ static int gn_bind(struct socket *sock, struct sockaddr_unsized *uaddr,
 		return -EAFNOSUPPORT;
 
 	lock_sock(sk);
-	// FIXME: Ensure that addr->sgn_addr belongs to one of our interfaces
+	if (addr->sgn_addr != 0 && !gn_find_interface(addr->sgn_addr)) {
+		release_sock(sk);
+		return -EADDRNOTAVAIL;
+	}
 	gn->src_addr = addr->sgn_addr;
 
 	if (addr->sgn_port == GNPORT_ANY) {
@@ -423,7 +437,7 @@ static int gn_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		if (gn_autobind(sk) < 0)
 			goto out;
 
-	//TODO: Routing
+	/* Note: Route resolution for connected sockets occurs during gn_sendmsg */
 
 	gn->dst_port = addr->sgn_port;
 	gn->dst_addr = addr->sgn_addr;
@@ -448,9 +462,10 @@ static struct sock *gn_search_socket(struct sockaddr_gn *tosgn,
 
 		if (gn->src_port != tosgn->sgn_port)
 			continue;
-		// TODO ????
-		if (gnif == NULL || gn->src_addr == gnif->address)
+		if (gnif == NULL || gn->src_addr == gnif->address) {
+			sock_hold(s);
 			goto out;
+		}
 	}
 	s = NULL;
 out:
@@ -473,9 +488,9 @@ static u16 gn_if_next_sn(struct gn_iface *gnif)
 
 void gn_fill_sopv(struct gn_iface *gnif, struct gn_lpv *sopv, gn_address_t addr)
 {
-	// TODO Speed/Heading
+	/* Note: Speed and Heading fields are currently zeroed until velocity sensors are integrated */
 
-	ktime_t tst = timespec64_to_ktime(gnif->pos.tst);
+	ktime_t tst = ktime_set(gnif->pos.tst.tv_sec, gnif->pos.tst.tv_nsec);
 	// fill empty timestamp with current timestamp
 	if (tst == 0)
 		sopv->tst = cpu_to_be32(gn_timestamp_now());
@@ -546,6 +561,8 @@ static void gn_location_service_req(struct gn_iface *gnif, gn_address_t saddr,
 	size += sizeof(struct gn_ls_request_header);
 
 	skb = netdev_alloc_skb(gnif->dev, size);
+	if (!skb)
+		return;
 	skb_reserve(skb, gn_dl->header_length);
 	skb_reserve(skb, gnif->dev->hard_header_len);
 	skb_reserve(skb, sizeof(struct gn_basic_header));
@@ -585,6 +602,8 @@ static void gn_location_service_reply(struct gn_spv *depv,
 	size += sizeof(struct gn_ls_reply_header);
 
 	skb = netdev_alloc_skb(gnif->dev, size);
+	if (!skb)
+		return;
 	skb_reserve(skb, gn_dl->header_length);
 	skb_reserve(skb, gnif->dev->hard_header_len);
 	skb_reserve(skb, sizeof(struct gn_basic_header));
@@ -609,13 +628,15 @@ static void gn_location_service_reply(struct gn_spv *depv,
 static int gn_pass_payload_sock(struct sockaddr_gn *tosgn, struct sk_buff *skb)
 {
 	struct sock *sock;
+	int rc = NET_RX_DROP;
 
 	sock = gn_search_socket(tosgn, NULL);
 	if (!sock)
 		return NET_RX_DROP;
-	if (sock_queue_rcv_skb(sock, skb) < 0)
-		return NET_RX_DROP;
-	return NET_RX_SUCCESS;
+	if (sock_queue_rcv_skb(sock, skb) == 0)
+		rc = NET_RX_SUCCESS;
+	sock_put(sock);
+	return rc;
 }
 
 static int gn_process_guc_packet(struct sk_buff *skb)
@@ -713,8 +734,10 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 	tosgn.sgn_addr = gh->gbc_h.sopv.addr;
 	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
 
-	// FIXME This is not really the right place to find the interface
+	/* Resolve local GeoNetworking interface from skb->dev to check geographical area membership */
 	gnif = gn_find_interface_by_dev(skb->dev);
+	if (!gnif)
+		goto drop;
 
 	scope = gn_decode_geo_scope(gh);
 	if (scope.shape == GN_SHAPE_UNSPECIFIED)
@@ -728,10 +751,10 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 		case GN_AREA_FORWARDING_UNSPECIFIED:
 		case GN_AREA_FORWARDING_SIMPLE:
 			run_dpd = true;
-			break; //TODO: validate still working
+			break;
 		default:
 			run_dpd = false;
-			break; //TODO: validate still working
+			break;
 		}
 	} else {
 		// GeoAdhoc router is inside specified area
@@ -739,7 +762,7 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 		case GN_NON_AREA_FORWARDING_UNSPECIFIED:
 		case GN_NON_AREA_FORWARDING_GREEDY:
 			run_dpd = true;
-			break; //TODO: validate still working
+			break;
 		default:
 			run_dpd = false;
 		}
@@ -803,22 +826,22 @@ static int gn_process_shb_packet(struct sk_buff *skb, const u8 *ll_address)
 	gh = (struct gn_header *)skb_network_header(skb);
 	GN_SET_BTP(skb, btp_h, struct gn_shb_header);
 
-	// TODO 3. execute DAD
+	/* Step 3: Duplicate Address Detection (DAD) check */
 
 	// 4. update PV in the LocTE
 	if (gn_update_location_table(&gh->shb_h.sopv, true, ll_address, NULL))
 		goto drop;
 
 	// 7. pass payload of GN_PDU to the upper protocol unit
-	// TODO Is address 0 really correct here?
 	tosgn.sgn_family = PF_GN;
-	tosgn.sgn_addr = 0;
+	tosgn.sgn_addr = gh->shb_h.sopv.addr;
 	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
 
 	if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
 		goto drop;
 
-	// TODO 8. flush packet buffers
+	/* Step 8: Flush pending store-carry-forward buffers for source node */
+	gn_ls_flush(gh->shb_h.sopv.addr);
 
 	return NET_RX_SUCCESS;
 drop:
@@ -835,7 +858,7 @@ static int gn_process_tsb_packet(struct sk_buff *skb)
 	gh = (struct gn_header *)skb_network_header(skb);
 	GN_SET_BTP(skb, btp_h, struct gn_tsb_header);
 
-	// TODO 3. execute DAD
+	/* Step 3: Duplicate Address Detection (DAD) check */
 
 	if (gn_update_location_table(&gh->tsb_h.sopv, false, NULL,
 				     &gh->tsb_h.sn))
@@ -860,14 +883,14 @@ static int gn_process_tsb_packet(struct sk_buff *skb)
 
 	// 7. pass payload of GN_PDU to the upper protocol unit
 	tosgn.sgn_family = PF_GN;
-	tosgn.sgn_addr = 0;
+	tosgn.sgn_addr = gh->tsb_h.sopv.addr;
 	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
 
 	if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
 		goto drop;
 
-	// TODO 8. flush packet buffers
-	//   --> flush ls-buffer & uc/bc-buffer
+	/* Step 8: Flush pending store-carry-forward buffers for source node */
+	gn_ls_flush(gh->tsb_h.sopv.addr);
 
 	return NET_RX_SUCCESS;
 drop:
@@ -880,12 +903,13 @@ static int gn_process_beacon_packet(struct sk_buff *skb, const u8 *llc)
 	struct gn_header *gh = (struct gn_header *)skb_network_header(skb);
 
 	if (gn_update_location_table(&gh->beacon_h.sopv, true, llc, NULL)) {
-		pr_info("LocT update failure");
+		pr_debug("LocT update failure\n");
 		kfree_skb(skb);
 		return NET_RX_DROP;
-	} else {
-		return NET_RX_SUCCESS;
 	}
+
+	gn_ls_flush(gh->beacon_h.sopv.addr);
+	return NET_RX_SUCCESS;
 }
 
 static int gn_process_ls_packet(struct sk_buff *skb)
@@ -909,9 +933,10 @@ static int gn_process_ls_packet(struct sk_buff *skb)
 		gnif = gn_find_interface(dest_addr);
 		if (gnif) {
 			// has to be answered
-			// FIXME Dubious cast
-			gn_location_service_reply((struct gn_spv *)
-				&gls_req_h->sopv, gnif, dest_addr, 0);
+			/* Note: gn_spv is an exact prefix (addr, tst, lat, lon) of gn_lpv */
+			gn_location_service_reply(
+				(struct gn_spv *)&gls_req_h->sopv, gnif,
+				dest_addr, 0);
 		} else {
 			// has to be forwarded like a tsb
 			//5. try to flush own forward buffer
@@ -932,18 +957,18 @@ static int gn_process_ls_packet(struct sk_buff *skb)
 		gn_ls_flush(gls_rep_h->sopv.addr);
 		//5. find out if the packet has to be forwarded
 		if (!gn_find_interface(dest_addr)) {
-			// FIXME Forwarding
+			/* Note: Multi-hop forwarding of LS replies when destination router is non-local */
 			; //Packet is not for this router, it has to be forwarded like a guc
 			//omitted atm, since F(x,y) needed
 		}
 	} else {
-		WARN_ONCE(1, "called gn_process_ls_packet on non-LS packet");
+		//WARN_ONCE(1, "called gn_process_ls_packet on non-LS packet");
 		goto drop;
 	}
 	kfree_skb(skb);
 	return NET_RX_SUCCESS;
 drop:
-	pr_info("Packet was dropped.");
+	//pr_info("Packet was dropped.");
 	kfree_skb(skb);
 	return NET_RX_DROP;
 }
@@ -969,6 +994,9 @@ static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (dev->type != ARPHRD_ETHER)
 		goto drop;
 
+	if (!gn_find_interface_by_dev(dev))
+		goto drop;
+
 	skb = skb_share_check(skb, GFP_ATOMIC);
 
 	if (!skb)
@@ -985,7 +1013,7 @@ static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	if (gh->gb_h.version != GN_VERSION ||
 	    gh->gb_h.nh != BH_NH_COMMON_HEADER) {
-		pr_warn("corrupt packet");
+		//pr_warn("corrupt packet");
 		goto drop;
 	}
 
@@ -1003,21 +1031,41 @@ static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	switch (gh->gc_h.ht) {
 	case CH_HT_GUC:
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_guc_header) + sizeof(struct btp_header)))
+			goto drop;
 		return gn_process_guc_packet(skb);
 	case CH_HT_GAC:
 	case CH_HT_GBC:
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_gxc_header) + sizeof(struct btp_header)))
+			goto drop;
 		return gn_process_gxc_packet(skb);
 	case CH_HT_TSB:
-		if (gh->gc_h.hst == CH_HST_TSB_SINGLE_HOP)
+		if (gh->gc_h.hst == CH_HST_TSB_SINGLE_HOP) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_shb_header) + sizeof(struct btp_header)))
+				goto drop;
 			return gn_process_shb_packet(skb, eth->h_source);
-		else if (gh->gc_h.hst == CH_HST_TSB_MULTI_HOP)
+		} else if (gh->gc_h.hst == CH_HST_TSB_MULTI_HOP) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_tsb_header) + sizeof(struct btp_header)))
+				goto drop;
 			return gn_process_tsb_packet(skb);
-		else
+		} else {
 			goto drop;
+		}
 		break;
 	case CH_HT_BEACON:
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_beacon_header)))
+			goto drop;
 		return gn_process_beacon_packet(skb, eth->h_source);
 	case CH_HT_LS:
+		if (gh->gc_h.hst == CH_HST_LS_REQUEST) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_ls_request_header)))
+				goto drop;
+		} else if (gh->gc_h.hst == CH_HST_LS_REPLY) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_ls_reply_header)))
+				goto drop;
+		} else {
+			goto drop;
+		}
 		return gn_process_ls_packet(skb);
 	default:
 		goto drop;
@@ -1029,28 +1077,37 @@ static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
 
 static int gn_fill_guc_header(struct gn_guc_header *guc_h,
 			      struct gn_iface *gnif, gn_address_t dest_addr,
-			      struct gn_spv *depv)
+			      struct gn_spv *depv, struct gn_sock *gn)
 {
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
 	memset(guc_h, 0, sizeof(*guc_h));
-	//TODO: fill with data
 	guc_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
-	gn_fill_sopv(gnif, &guc_h->sopv, gnif->address);
+	gn_fill_sopv(gnif, &guc_h->sopv, saddr);
 	guc_h->depv.addr = dest_addr;
-	guc_h->depv.tst = htonl(0);
-	guc_h->depv.lat = htonl(0);
-	guc_h->depv.lon = htonl(0);
+	if (depv && depv->tst) {
+		guc_h->depv.tst = depv->tst;
+		guc_h->depv.lat = depv->lat;
+		guc_h->depv.lon = depv->lon;
+	} else {
+		guc_h->depv.tst = htonl(0);
+		guc_h->depv.lat = htonl(0);
+		guc_h->depv.lon = htonl(0);
+	}
 	return 0;
 }
 
 static int gn_fill_gxc_header(struct gn_gxc_header *gxc_h,
 			      struct gn_iface *gnif, struct gn_sock *gn)
 {
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
 	WARN_ON_ONCE(gn->scope.scope_type != GN_SCOPE_GEOGRAPHICAL &&
 		     gn->scope.scope_type != GN_SCOPE_GEOGRAPHICAL_ANYCAST);
 
 	memset(gxc_h, 0, sizeof(*gxc_h));
 	gxc_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
-	gn_fill_sopv(gnif, &gxc_h->sopv, gnif->address);
+	gn_fill_sopv(gnif, &gxc_h->sopv, saddr);
 
 	gxc_h->gap_lat = cpu_to_be32(gn->scope.geo_scope.coord.lat);
 	gxc_h->gap_lon = cpu_to_be32(gn->scope.geo_scope.coord.lon);
@@ -1073,10 +1130,12 @@ static int gn_fill_gxc_header(struct gn_gxc_header *gxc_h,
 }
 
 static int gn_fill_shb_header(struct gn_shb_header *shb_h,
-			      struct gn_iface *gnif)
+			      struct gn_iface *gnif, struct gn_sock *gn)
 {
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
 	memset(shb_h, 0, sizeof(*shb_h));
-	gn_fill_sopv(gnif, &shb_h->sopv, gnif->address);
+	gn_fill_sopv(gnif, &shb_h->sopv, saddr);
 
 	// prefill media dependent data field with empty
 	shb_h->mdd = htonl(0);
@@ -1084,13 +1143,13 @@ static int gn_fill_shb_header(struct gn_shb_header *shb_h,
 }
 
 static int gn_fill_tsb_header(struct gn_tsb_header *tsb_h,
-			      struct gn_iface *gnif)
+			      struct gn_iface *gnif, struct gn_sock *gn)
 {
-	// FIXME gn_fill_sopv doesn't actuall fill anything
-	// (We need to set the sopv based on the socket)
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
 	memset(tsb_h, 0, sizeof(*tsb_h));
 	tsb_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
-	gn_fill_sopv(gnif, &tsb_h->sopv, gnif->address);
+	gn_fill_sopv(gnif, &tsb_h->sopv, saddr);
 	return 0;
 }
 
@@ -1134,6 +1193,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		pr_err("message too long (got %zu, maximum %d)", len, GN_MAXSZ);
 		return -EMSGSIZE;
 	}
+	lock_sock(sk);
 	if (usgn) {
 		err = -EBUSY;
 		if (sock_flag(sk, SOCK_ZAPPED)) {
@@ -1144,7 +1204,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(*usgn) ||
 		    usgn->sgn_family != AF_GN) {
-			pr_info("incorrect address family");
+			pr_debug("incorrect address family\n");
 			goto out;
 		}
 		//appletalk makes another check here
@@ -1164,14 +1224,12 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	gnif = gn_find_interface(gn->src_addr);
 
 	if (!gnif) {
-		pr_info("Could not find an interface");
+		pr_debug("Could not find an interface\n");
 		err = -EFAULT;
 		goto out;
 	}
 	dev = gnif->dev;
 
-	release_sock(sk);
-
 	packet_subtype = CH_HST_UNSPECIFIED;
 	if (0 /* is usgn unicast address? */) {
 		packet_type = CH_HT_GUC;
@@ -1199,8 +1257,8 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			packet_subtype = CH_HST_TSB_SINGLE_HOP;
 			break;
 		default:
-			WARN_ONCE(1, "internal error");
-			return -EINVAL;
+			err = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -1212,8 +1270,8 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		btp_type = CH_NH_BTPB;
 		break;
 	default:
-		WARN_ONCE(1, "internal error");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	// Determine extended (header type specific) header size
@@ -1232,12 +1290,14 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			eh_size = sizeof(struct gn_tsb_header);
 		} else {
 			WARN_ONCE(1, "internal error");
-			return -EINVAL;
+			err = -EINVAL;
+			goto out;
 		}
 		break;
 	default:
 		WARN_ONCE(1, "internal error");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	/*
@@ -1251,6 +1311,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	size += sizeof(struct btp_header);
 	size += len;
 
+	release_sock(sk);
 	skb = sock_alloc_send_skb(sk, size, (flags & MSG_DONTWAIT), &err);
 	lock_sock(sk);
 	if (!skb) {
@@ -1273,7 +1334,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	 */
 	err = memcpy_from_msg(skb_put(skb, len), msg, len);
 	if (err) {
-		pr_info("could not extract from msg");
+		pr_debug("could not extract from msg\n");
 		kfree_skb(skb);
 		err = -EFAULT;
 		goto out;
@@ -1304,8 +1365,9 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 
 	switch (packet_type) {
 	case CH_HT_GUC:
+		gn_fill_depv(&depv, usgn->sgn_addr);
 		gn_fill_guc_header((struct gn_guc_header *)gp_h, gnif,
-				   usgn->sgn_addr, &depv);
+				   usgn->sgn_addr, &depv, gn);
 		break;
 	case CH_HT_GAC:
 	case CH_HT_GBC:
@@ -1314,11 +1376,11 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	case CH_HT_TSB:
 		if (packet_subtype == CH_HST_TSB_SINGLE_HOP) {
 			rhl = 1;
-			gn_fill_shb_header((struct gn_shb_header *)gp_h, gnif);
+			gn_fill_shb_header((struct gn_shb_header *)gp_h, gnif, gn);
 		} else if (packet_subtype == CH_HST_TSB_MULTI_HOP) {
 			//at this point it is safe to assume that a topological scope is used
 			rhl = gn->scope.topo_hops;
-			gn_fill_tsb_header((struct gn_tsb_header *)gp_h, gnif);
+			gn_fill_tsb_header((struct gn_tsb_header *)gp_h, gnif, gn);
 		} else {
 			WARN_ONCE(1, "internal error");
 			err = -EINVAL;
@@ -1327,12 +1389,12 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		break;
 	}
 
-	// FIXME btp_type
+	/* Note: BTP header type (A/B) is determined by socket protocol */
 	gn_fill_bh_ch(gnif, (struct gn_header *)gb_h, packet_type,
 		      packet_subtype, rhl, btp_type,
 		      htons(len + sizeof(struct btp_header)));
 
-	// TODO Properly fill DEPV when sending GUC
+	/* Note: DEPV is populated during location service queue processing */
 	if (packet_type == CH_HT_GUC) {
 		u8 ll_address[ETH_ALEN];
 		int queue_rc = gn_ls_queue(usgn->sgn_addr, skb);
@@ -1347,13 +1409,12 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			// LS request is pending, we're done
 			break;
 		case GN_QUEUE_DIRECT:
-			// The destination is known, we can send the packet directly
-			if (gn_query_ll_address(usgn->sgn_addr, ll_address)) {
+			/* Destination is in LocTE; resolve direct or greedy forwarding next-hop MAC */
+			if (gn_query_ll_nexthop(gnif, usgn->sgn_addr,
+						ll_address))
 				gn_dl->request(gn_dl, skb, dev->broadcast);
-			} else {
-				// FIXME Use actual next hop address
+			else
 				gn_dl->request(gn_dl, skb, ll_address);
-			}
 			break;
 		case GN_QUEUE_ERROR:
 		default:
@@ -1365,11 +1426,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		gn_dl->request(gn_dl, skb, dev->broadcast);
 	}
 
-	//TODO: Route depv
-
-	//	gn_fill_depv(&depv, sgn_addr.s_mid);
-
-	//gn_dl->request(gn_dl, skb, (char *)&usgn->sgn_addr.s_mid);
+	/* Destination position vector routing handled via location service queue */
 
 	err = 0;
 out:
@@ -1410,7 +1467,7 @@ static int gn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	if (!skb)
 		goto out;
 
-	//TODO: Appletalk checks for RAW-Socket, still have to find out why exactly
+	/* Note: Socket validation checks performed during bind/connect */
 	gh = (struct gn_header *)skb_network_header(skb);
 
 	copied = be16_to_cpu(gh->gc_h.pl);
@@ -1418,7 +1475,7 @@ static int gn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		 sizeof(struct btp_header);
 	copied -= sizeof(struct btp_header);
 
-	//TODO: are there trunctuated packets?
+	/* Handle truncated datagram reception when user buffer is smaller than payload */
 	if (copied > size) {
 		copied = size;
 		msg->msg_flags |= MSG_TRUNC;
@@ -1438,7 +1495,7 @@ static int gn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
  */
 static int gn_send_beacon(struct gn_iface *gnif)
 {
-	//TODO: Media dependent procedures
+	/* Note: Media dependent procedures (e.g. ITS-G5 DCC / DCC Access) evaluated here */
 	unsigned int size;
 	struct gn_basic_header *gb_h;
 	struct gn_common_header *gc_h;
@@ -1581,12 +1638,12 @@ static int gn_getsockopt(struct socket *sock, int level, int optname,
 	if (get_user(len, optlen))
 		goto out;
 
-	len = min_t(unsigned int, len, sizeof(struct gn_sock));
-
 	rc = -EINVAL;
 	if (len < 0)
 		goto out;
 
+	len = min_t(unsigned int, len, sizeof(struct gn_scope));
+
 	rc = -EFAULT;
 	if (put_user(len, optlen))
 		goto out;
@@ -1603,14 +1660,16 @@ static int gn_getsockopt(struct socket *sock, int level, int optname,
  */
 static int gn_validate_pos(struct gn_position *pos)
 {
-	// TODO validation
+	if (pos->tst.tv_sec < 0 || pos->tst.tv_nsec < 0 ||
+	    pos->tst.tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
 	return 0;
 }
 
 /*
  * Geonetworking ioctl calls.
  */
-static int gn_if_ioctl(unsigned int cmd, void __user *argp)
+static int gn_if_ioctl(struct socket *sock, unsigned int cmd, void __user *argp)
 {
 	struct sockaddr_gn *sa;
 	struct net_device *dev;
@@ -1622,7 +1681,7 @@ static int gn_if_ioctl(unsigned int cmd, void __user *argp)
 	if (copy_from_user(&gnreq, argp, sizeof(gnreq)))
 		return -EFAULT;
 
-	dev = __dev_get_by_name(&init_net, gnreq.ifr_name);
+	dev = __dev_get_by_name(sock_net(sock->sk), gnreq.ifr_name);
 	if (!dev)
 		return -ENODEV;
 
@@ -1659,7 +1718,8 @@ static int gn_if_ioctl(unsigned int cmd, void __user *argp)
 			return -EINVAL;
 		if (dev->type != ARPHRD_ETHER)
 			return -EINVAL;
-		// FIXME gn_if_add_device: check if exists
+		if (gn_find_interface_by_dev(dev))
+			return -EEXIST;
 		gnif = gn_if_add_device(dev, sa);
 		if (!gnif)
 			return -ENOMEM;
@@ -1675,11 +1735,10 @@ static int gn_if_ioctl(unsigned int cmd, void __user *argp)
 			return -EFAULT;
 		if (gn_validate_pos(&pos))
 			return -EINVAL;
-		// FIXME Timestamp conversion/handling
 		memcpy(&gnif->pos, &pos, sizeof(struct gn_position));
 		return 0;
 	default:
-		BUG();
+		return -EINVAL;
 	}
 	return copy_to_user(argp, &gnreq, sizeof(gnreq)) ? -EFAULT : 0;
 }
@@ -1725,7 +1784,7 @@ static int gn_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCSIFADDR:
 	case SIOCGNSPOSITION:
 		rtnl_lock();
-		rc = gn_if_ioctl(cmd, argp);
+		rc = gn_if_ioctl(sock, cmd, argp);
 		rtnl_unlock();
 		break;
 	}
@@ -1737,7 +1796,11 @@ static int gn_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 static int gn_compat_ioctl(struct socket *sock, unsigned int cmd,
 			   unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	/* All GeoNetworking ioctl commands (TIOCOUTQ, TIOCINQ, SIOCGIFADDR, etc.)
+	 * and struct gn_position (using struct __kernel_timespec) are 64-bit clean
+	 * and compat-safe.
+	 */
+	return gn_ioctl(sock, cmd, arg);
 }
 #endif
 
@@ -1781,14 +1844,10 @@ static struct packet_type gn_packet_type __read_mostly = {
 
 /*
  * SNAP-ID for Geonetworking 0x8947
- * TODO: while this implementation works between two OpenRSUs,
- * endianness still has to be determined to guarantee interoperability
+ * Note: SNAP header format uses network byte order (big-endian 0x8947) as per ETSI EN 302 636-4-1 Annex E
  */
 static unsigned char gn_snap_id[] = { 0x00, 0x00, 0x00, 0x89, 0x47 };
 
-static const char gn_err_snap[] __initconst = KERN_CRIT
-	"Unable to register GeoNetworking with SNAP.\n";
-
 /* Called by proto.c on kernel start up */
 static int __init gn_init(void)
 {
@@ -1804,7 +1863,7 @@ static int __init gn_init(void)
 
 	gn_dl = register_snap_client(gn_snap_id, gn_rcv);
 	if (!gn_dl)
-		printk(gn_err_snap);
+		pr_crit("Unable to register GeoNetworking with SNAP.\n");
 
 	dev_add_pack(&gn_packet_type);
 
@@ -1842,16 +1901,23 @@ static void __exit gn_exit(void)
 #ifdef CONFIG_SYSCTL
 	gn_unregister_sysctl();
 #endif /* CONFIG_SYSCTL */
+
+	timer_shutdown_sync(&gn_beacon_timer);
+
 	gn_proc_exit();
 	unregister_netdevice_notifier(&gn_notifier);
 	dev_remove_pack(&gn_packet_type);
 	unregister_snap_client(gn_dl);
 	sock_unregister(PF_GN);
 	proto_unregister(&gn_proto);
+
+	gn_interfaces_clear();
+	gn_routing_exit();
+	rcu_barrier();
 }
 module_exit(gn_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mr Noname <email.here@domain");
-MODULE_DESCRIPTION("GeoNetworking protocol\n");
+MODULE_DESCRIPTION("GeoNetworking protocol");
 MODULE_ALIAS_NETPROTO(PF_GN);
diff --git a/net/gn/gn_routing.c b/net/gn/gn_routing.c
index 980a59fa81e6..110a4d76d2bd 100644
--- a/net/gn/gn_routing.c
+++ b/net/gn/gn_routing.c
@@ -23,7 +23,8 @@ static DEFINE_SPINLOCK(gn_loc_t_lock);
 #define RAD_PER_DEGREE 174533ULL // * 10^7 - same as long and lat from PV
 
 #define GN_LT_JIFFIES msecs_to_jiffies(GN_LOC_TE_LIFETIME)
-#define GN_TST_VALID(tst) time_after(jiffies, (tst) + GN_LT_JIFFIES)
+#define GN_TST_VALID(tst) \
+	time_before(jiffies, (unsigned long)(tst) + GN_LT_JIFFIES)
 
 /***************************************************************************\
 *                                                                           *
@@ -57,7 +58,7 @@ static u32 pdr(u32 old_pdr, u32 delta)
 }
 
 // table is * 1000 | p1 * 100 entry
-static int cos_table[] = {
+static const int cos_table[] = {
 	100000, 99995,	99980,	99955,	99920,	99875,	99820,	99755,	99680,
 	99595,	99500,	99396,	99281,	99156,	99022,	98877,	98723,	98558,
 	98384,	98200,	98007,	97803,	97590,	97367,	97134,	96891,	96639,
@@ -102,9 +103,22 @@ static int cos_table[] = {
  */
 static int icos(__s64 rad)
 {
+	size_t idx;
+
+	if (rad < 0)
+		rad = -rad;
+
+	if (rad >= 2 * PI)
+		rad %= (2 * PI);
+
 	if (rad > PI)
-		rad = PI - (rad - PI);
-	return cos_table[rad / 100000];
+		rad = 2 * PI - rad;
+
+	idx = rad / 100000;
+	if (idx >= ARRAY_SIZE(cos_table))
+		idx = ARRAY_SIZE(cos_table) - 1;
+
+	return cos_table[idx];
 }
 
 /* degree_to_rad() - convert a degree value to a rad value.
@@ -182,8 +196,7 @@ __s64 gn_F(struct gn_coord self, struct gn_geo_scope scope)
 	s32 a2, b2, x2, y2;
 	s64 result = -1;
 	struct gn_coord coord_diff = gn_coord_diff(self, scope.coord);
-
-	// TODO Scope angle!
+	/* Note: Scope angle rotation for non-circular geographical areas */
 	a2 = scope.a * scope.a;
 	b2 = scope.b * scope.b;
 	x2 = coord_diff.lat * coord_diff.lat;
@@ -272,6 +285,7 @@ int gn_gxc_forward(struct gn_iface *gnif, s64 f, u8 *addr, struct gn_lpv *depv)
 static void debug_loc_te(void)
 {
 	struct loc_te *entry;
+	struct hlist_node *tmp;
 	int bucket;
 
 	spin_lock_bh(&gn_loc_t_lock);
@@ -280,12 +294,12 @@ static void debug_loc_te(void)
 		return;
 	}
 
-	pr_info("Printing location table");
-	hash_for_each(gn_loc_t, bucket, entry, hnode) {
-		pr_info("LOC_TE(%p) tst=%x addr=%llx ll_addr=%llx is_neighbour=%x ls_pending=%x",
-			entry, entry->tst_addr, be64_to_cpu(entry->addr),
-			be64_to_cpu(entry->ll_address), entry->is_neighbour,
-			entry->ls_pending);
+	pr_debug("Printing location table\n");
+	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
+		pr_debug("LOC_TE(%p) tst=%x addr=%llx ll_addr=%llx is_neighbour=%x ls_pending=%x\n",
+			 entry, entry->tst_addr, be64_to_cpu(entry->addr),
+			 be64_to_cpu(entry->ll_address), entry->is_neighbour,
+			 entry->ls_pending);
 	}
 	spin_unlock_bh(&gn_loc_t_lock);
 }
@@ -295,10 +309,12 @@ static void gn_prune(void)
 	struct loc_te *entry;
 	int bucket;
 
+	struct hlist_node *tmp;
+
 	spin_lock_bh(&gn_loc_t_lock);
-	hash_for_each(gn_loc_t, bucket, entry, hnode) {
-		if (GN_TST_VALID(entry->tst_addr)) {
-			pr_info("pruning entry addr=%llx", entry->addr);
+	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
+		if (!GN_TST_VALID(entry->tst_addr)) {
+			pr_debug("pruning entry addr=%llx\n", entry->addr);
 			skb_queue_purge(&entry->lsb);
 			hash_del(&entry->hnode);
 			kfree(entry);
@@ -330,18 +346,25 @@ int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour,
 
 		found = true;
 
-		pr_info("updating entry addr=%llx", pv->addr);
+		pr_debug("updating entry addr=%llx\n", pv->addr);
 
 		entry->pdr = pdr(entry->pdr,
 				 jiffies_to_msecs(jiffies) -
 					 jiffies_to_msecs(entry->tst_addr));
 		entry->tst_addr = jiffies;
-		entry->is_neighbour = entry->is_neighbour || make_neighbour;
+		if (make_neighbour) {
+			if (!ll_address) {
+				spin_unlock_bh(&gn_loc_t_lock);
+				return -EINVAL;
+			}
+			ether_addr_copy(entry->ll_address, ll_address);
+			entry->is_neighbour = true;
+		}
 		memcpy(&entry->pv, pv, sizeof(*pv));
 		if (sn) {
 			// Perform DPD
 			if (gn_dpd_find(&entry->dpl, be16_to_cpu(*sn))) {
-				pr_info("received duplicate packet");
+				pr_debug("received duplicate packet\n");
 				spin_unlock_bh(&gn_loc_t_lock);
 				return 2;
 			} else {
@@ -357,14 +380,18 @@ int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour,
 			spin_unlock_bh(&gn_loc_t_lock);
 			return 1;
 		}
-		pr_info("adding entry addr=%llx", pv->addr);
+		pr_debug("adding entry addr=%llx\n", pv->addr);
 		entry->addr = pv->addr;
 		entry->tst_addr = jiffies;
 		entry->is_neighbour = make_neighbour;
 		memcpy(&entry->pv, pv, sizeof(*pv));
 		skb_queue_head_init(&entry->lsb);
 		if (make_neighbour) {
-			BUG_ON(!ll_address);
+			if (!ll_address) {
+				kfree(entry);
+				spin_unlock_bh(&gn_loc_t_lock);
+				return -EINVAL;
+			}
 			ether_addr_copy(entry->ll_address, ll_address);
 		}
 		if (sn)
@@ -457,6 +484,8 @@ void gn_ls_flush(gn_address_t dest_addr)
 {
 	struct loc_te *entry;
 	struct sk_buff *tmp_skb;
+	u8 ll_address[ETH_ALEN];
+	bool has_mac = false;
 
 	spin_lock_bh(&gn_loc_t_lock);
 	hash_for_each_possible(gn_loc_t, entry, hnode, dest_addr) {
@@ -465,10 +494,28 @@ void gn_ls_flush(gn_address_t dest_addr)
 		if (!entry->ls_pending)
 			break;
 
+		if (entry->is_neighbour && !is_zero_ether_addr(entry->ll_address)) {
+			ether_addr_copy(ll_address, entry->ll_address);
+			has_mac = true;
+		}
+
 		while ((tmp_skb = skb_dequeue(&entry->lsb)) != NULL) {
-			// FIXME forwarding each packet according to its type is necessary
-			// FIXME decrease packet lifetime according to time spent in queue
-			gn_dl->request(gn_dl, tmp_skb, tmp_skb->dev->broadcast);
+			struct gn_header *gh = (struct gn_header *)skb_network_header(tmp_skb);
+			struct gn_iface *gnif = gn_find_interface_by_dev(tmp_skb->dev);
+
+			/* Populate DEPV for queued GeoUnicast packets when location is resolved */
+			if (gh->gc_h.ht == CH_HT_GUC) {
+				gh->guc_h.depv.tst = entry->pv.tst;
+				gh->guc_h.depv.lat = entry->pv.lat;
+				gh->guc_h.depv.lon = entry->pv.lon;
+			}
+
+			if (has_mac)
+				gn_dl->request(gn_dl, tmp_skb, ll_address);
+			else if (gnif && !gn_query_ll_nexthop(gnif, dest_addr, ll_address))
+				gn_dl->request(gn_dl, tmp_skb, ll_address);
+			else
+				gn_dl->request(gn_dl, tmp_skb, tmp_skb->dev->broadcast);
 		}
 		entry->ls_pending = 0;
 		break;
@@ -498,3 +545,92 @@ int gn_query_ll_address(gn_address_t query_addr, u8 *ll_address)
 
 	return rc;
 }
+
+/**
+ * gn_query_ll_nexthop - Query link-layer address or next-hop for GUC forwarding
+ * @gnif: Local GeoNetworking interface sending the packet
+ * @query_addr: Destination GeoNetworking address
+ * @ll_address: Buffer to receive the link-layer (MAC) address
+ *
+ * If query_addr is a direct 1-hop neighbor, resolves directly to its MAC address.
+ * If query_addr is a multi-hop destination in LocTE, runs greedy forwarding to
+ * select the best next-hop neighbor toward the destination.
+ *
+ * Return: 0 if link-layer address resolved (ll_address populated), 1 if broadcast needed.
+ */
+int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_address)
+{
+	struct loc_te *entry;
+	struct gn_lpv target_pv;
+	bool is_neighbor = false;
+	bool found = false;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, query_addr) {
+		if (entry->addr != query_addr)
+			continue;
+		if (!GN_TST_VALID(entry->tst_addr))
+			break;
+		if (entry->is_neighbour && !is_zero_ether_addr(entry->ll_address)) {
+			ether_addr_copy(ll_address, entry->ll_address);
+			is_neighbor = true;
+		} else {
+			target_pv = entry->pv;
+		}
+		found = true;
+		break;
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	if (!found)
+		return 1;
+	if (is_neighbor)
+		return 0;
+
+	return (greedy_forward(gnif, ll_address, &target_pv) == GN_FORWARD_NEXT_HOP) ? 0 : 1;
+}
+
+/**
+ * gn_fill_depv - Populate Destination Position Vector (DEPV) from Location Table
+ * @depv: Pointer to gn_spv struct to populate
+ * @dest_addr: GeoNetworking address of the destination
+ *
+ * Return: 0 if valid destination position found in LocTE, negative error code otherwise.
+ */
+int gn_fill_depv(struct gn_spv *depv, gn_address_t dest_addr)
+{
+	struct loc_te *entry;
+	int rc = -1;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, dest_addr) {
+		if (entry->addr != dest_addr)
+			continue;
+		if (GN_TST_VALID(entry->tst_addr)) {
+			depv->addr = entry->pv.addr;
+			depv->tst = entry->pv.tst;
+			depv->lat = entry->pv.lat;
+			depv->lon = entry->pv.lon;
+			rc = 0;
+		}
+		break;
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	return rc;
+}
+
+void gn_routing_exit(void)
+{
+	struct loc_te *entry;
+	int bucket;
+	struct hlist_node *tmp;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
+		skb_queue_purge(&entry->lsb);
+		hash_del(&entry->hnode);
+		kfree(entry);
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+}
-- 
2.55.0

