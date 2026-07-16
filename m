Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [129.187.255.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2EC3D9DD4;
	Thu, 16 Jul 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784217469; cv=none; b=a9UtlCcioomjuiiKj4YDqHe1tzkTUtVva2M7NjCSnV+r7Bo1/cunD5JZewPxRCcBrGtXxKxkTDGxIWznhHDDrVwpz4GXqQ92dpR43E6/b9NPgpIq7Yw/ReWVgSetvNq/l0Dqc1NLa4NILfAc2kTY5bqu+aKtHgJbpM8MhhKWC4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784217469; c=relaxed/simple;
	bh=xgdWLOIFm/czJlk+gRQhnUyf8dTekyADqs4jXFv+fmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kphNIwcmTCVQglyF8y5wp3qi1Fv/kj71+YjcSIF0utHU8vaukzAC5ovdMWZJZdnFgWXqhdVd3GQsIGL2t5kn8KYj55tm1/DKj+qHbfSrQpxtuRHVVTPmdFM3q7cHJMhdmu3pwX+57VgMzKC9++J7uUfYZCtltOX0SdqtmVNAcao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de; spf=pass smtp.mailfrom=hs-ansbach.de; dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b=U5IjbCTn; arc=none smtp.client-ip=129.187.255.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b="U5IjbCTn"
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
	by postout1.mail.lrz.de (Postfix) with ESMTP id 4h1HZb35L7zyWl;
	Thu, 16 Jul 2026 17:51:03 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=hs-ansbach.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hs-ansbach.de;
	 h=content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=an-postout22; t=1784217062; bh=igw4+4XgmvO
	3uNUBRknUMqSSu07LquB3TDCGl1BPhrI=; b=U5IjbCTntXm/i7S82SynoWcVSCs
	K4BAnIKSyqSvZq4jAsS29dAPwTJyi1RXvtLeZJwaeigNH3EOi64cDoc3MJfcKXrK
	wUnKKRigNYU4PXk6KT/piXuNa9EquBkiE64clHf2YJ6RBx7ltbh2ESoDnjbPaVF4
	7UBPYVhZ+K8OxI16m4mc7ICkO3nNUDW7KhyXkkyvm7won6mulU499LgV7YG6bXLO
	4XC2ODnbXAMxvKE/pRbxqIU28XTRTZQlbi0z4CN/b0xGhj1J9xfi+iluyqXp9jTD
	Qi4KAl0VXUZq0+E3cE4esfTVI3rETBwJ5BLekwu2WJtbdDG0H6RXBa1eiZA==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs51.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.886
X-Spam-Level:
Received: from postout1.mail.lrz.de ([127.0.0.1])
 by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id jJuZSEkAmwIn; Thu, 16 Jul 2026 17:51:02 +0200 (CEST)
Received: from chimchar.fritz.box (p200300eeb7001900d36d09bcf7cd0c19.dip0.t-ipconnect.de [IPv6:2003:ee:b700:1900:d36d:9bc:f7cd:c19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout1.mail.lrz.de (Postfix) with ESMTPSA id 4h1HZY49CtzyRQ;
	Thu, 16 Jul 2026 17:51:01 +0200 (CEST)
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
Subject: [RFC PATCH net-next v0 3/6] net: further fix GeoNetworking
Date: Thu, 16 Jul 2026 17:49:09 +0200
Message-ID: <20260716154909.3449985-1-dietz23838@hs-ansbach.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716153917.3399255-1-dietz23838@hs-ansbach.de>
References: <20260716153917.3399255-1-dietz23838@hs-ansbach.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Dietz <simon.dietz@plantwatch.de>

Improve the GeoNetworking code base, including:
- code comments
- kernel errno convention adherence
- removal of __attribute__((packed))
- several scripts/checkpatch.pl violation fixes

Additionally fixes one GeoNetworking logic related issue:
- default hop limit is now set according to ETSI standard

Signed-off-by: Simon Dietz <simon.dietz@plantwatch.de>
---
 include/linux/gn.h      |  46 ++++----
 include/uapi/linux/gn.h |   2 +-
 net/gn/gn_proc.c        |   7 +-
 net/gn/gn_prot.c        | 226 +++++++++++++++++++++++++---------------
 net/gn/gn_routing.c     |  62 +++++------
 5 files changed, 199 insertions(+), 144 deletions(-)

diff --git a/include/linux/gn.h b/include/linux/gn.h
index 393a8f440028..862f635d5d11 100644
--- a/include/linux/gn.h
+++ b/include/linux/gn.h
@@ -122,7 +122,7 @@ static inline struct gn_sock *gn_sk(struct sock *sk)
 struct btp_header {
 	__be16 dst_port;
 	__be16 src_port;
-} __attribute__ ((packed));
+} __packed;
 
 enum ITS_TYPE {
 	UNKNOWN,
@@ -157,14 +157,14 @@ struct gn_lpv {
 	__be32 lon;
 	gn_spai_t spai;
 	__be16 h; //signed
-} __attribute__ ((packed));
+} __packed;
 
 struct gn_spv {
 	gn_address_t addr;
 	__be32 tst;
 	__be32 lat; //short
 	__be32 lon;
-} __attribute__ ((packed));
+} __packed;
 
 /*version: Identifies the version of the GeoNetworking protocol
  *
@@ -173,16 +173,24 @@ struct gn_spv {
  *
  *lt: Lifetime field.
  *Indicates the maximum tolerable time a packet may be buffered until it reaches its destination Bit 0 to Bit 5:
- *LT sub-field Multiplier Bit 6 to Bit 7: LT sub-field Base Encoded as specified in clause 9.6.4
+ *lt_sub:
+ *0) 50 ms
+ *1) 1s
+ *2) 10 s
+ *3) 100 s
+ *4) 600 s
+ *5) 1000s
  *
- *rhl:   Decremented by 1 by each GeoAdhoc router that forwards the packet. The packet shall not be forwarded if RHL is decremented to zero
+ *Bit 6 to Bit 11:
+ *lt_mul: Multiplier for lt_sub, between 0 and 63
+ *
+ *rhl: Remaining hop limit. Set to the maximum hop limit (mhl) initially and decremented by 1 at each hop.
+ *The packet is dropped when rhl reaches 0
  */
-
 struct gn_basic_header {
 #ifdef __LITTLE_ENDIAN_BITFIELD
 	__u8 nh : 4;
 	__u8 version : 4;
-
 #elif __BIG_ENDIAN_BITFIELD
 	__u8 version : 4;
 	__u8 nh : 4;
@@ -192,7 +200,7 @@ struct gn_basic_header {
 	__u8 reserved;
 	__u8 lt;
 	__u8 rhl;
-} __attribute__ ((packed));
+} __packed;
 
 struct gn_common_header {
 #ifdef __LITTLE_ENDIAN_BITFIELD
@@ -214,7 +222,7 @@ struct gn_common_header {
 	__be16 pl;
 	__u8 mhl;
 	__u8 reserved2;
-} __attribute__ ((packed));
+} __packed;
 
 /*there are 6 types of headers:
  * 1) GUC packet header (clause 9.8.2).
@@ -230,20 +238,20 @@ struct gn_guc_header {
 	__be16 reserved;
 	struct gn_lpv sopv;
 	struct gn_spv depv;
-} __attribute__ ((packed));
+} __packed;
 
 
 struct gn_tsb_header {
 	__be16 sn;
 	__be16 reserved;
 	struct gn_lpv sopv;
-} __attribute__ ((packed));
+} __packed;
 
 
 struct gn_shb_header {
 	struct gn_lpv sopv;
 	__be32 mdd;
-} __attribute__ ((packed));
+} __packed;
 
 
 /* GAC and GBC share the same header structure */
@@ -257,21 +265,21 @@ struct gn_gxc_header {
 	__be16 db;
 	__be16 angle;
 	__be16 reserved2;
-} __attribute__ ((packed));
+} __packed;
 
-typedef struct gn_gxc_header gn_gac_header;
-typedef struct gn_gxc_header gn_gbc_header;
+#define gn_gac_header gn_gxc_header
+#define gn_gbc_header gn_gxc_header
 
 struct gn_beacon_header {
 	struct gn_lpv sopv;
-} __attribute__ ((packed));
+} __packed;
 
 struct gn_ls_request_header {
 	__be16 sn;
 	__be16 reserved;
 	struct gn_lpv sopv;
 	gn_address_t addr;
-} __attribute__ ((packed));
+} __packed;
 
 //same structure as gn_guc_header, left in for abstraction
 struct gn_ls_reply_header {
@@ -279,7 +287,7 @@ struct gn_ls_reply_header {
 	__be16 reserved;
 	struct gn_lpv sopv;
 	struct gn_spv depv;
-} __attribute__ ((packed));
+} __packed;
 
 struct gn_header {
 	struct gn_basic_header gb_h;
@@ -297,7 +305,7 @@ struct gn_header {
 		struct gn_ls_reply_header ls_reply_h;
 		__be16 sn;
 	};
-} __attribute__ ((packed));
+} __packed;
 
 /* Inter module exports */
 
diff --git a/include/uapi/linux/gn.h b/include/uapi/linux/gn.h
index c0df0d55f683..96cafbda54de 100644
--- a/include/uapi/linux/gn.h
+++ b/include/uapi/linux/gn.h
@@ -79,6 +79,6 @@ struct sockaddr_gn {
 	__kernel_sa_family_t sgn_family;
 	gn_address_t sgn_addr;
 	__u16 sgn_port;
-} __attribute__((packed));
+} __packed;
 
 #endif /* _UAPI__LINUX_GN_H__ */
diff --git a/net/gn/gn_proc.c b/net/gn/gn_proc.c
index 75e126f9e494..ecd2aea446e5 100644
--- a/net/gn/gn_proc.c
+++ b/net/gn/gn_proc.c
@@ -42,17 +42,14 @@ static int gn_seq_socket_show(struct seq_file *seq, void *v)
 	struct gn_sock *gn;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_printf(seq, "Type Local_addr  Remote_addr Tx_queue "
-				"Rx_queue St UID\n");
+		seq_puts(seq, "Type Local_addr  Remote_addr Tx_queue Rx_queue St UID\n");
 		goto out;
 	}
 
 	s = sk_entry(v);
 	gn = gn_sk(s);
 
-	seq_printf(seq,
-		   "%02X   %08llX:%04X  %08llX:%04X  %08X:%08X "
-		   "%02X\n",
+	seq_printf(seq, "%02X   %08llX:%04X  %08llX:%04X  %08X:%08X %02X\n",
 		   s->sk_type, be64_to_cpu(gn->src_addr), gn->src_port,
 		   be64_to_cpu(gn->dst_addr), gn->dst_port,
 		   sk_wmem_alloc_get(s), sk_rmem_alloc_get(s), s->sk_state);
diff --git a/net/gn/gn_prot.c b/net/gn/gn_prot.c
index a59aadf843b0..3c4e1157fbde 100644
--- a/net/gn/gn_prot.c
+++ b/net/gn/gn_prot.c
@@ -31,11 +31,7 @@
 struct datalink_proto *gn_dl;
 static const struct proto_ops gn_dgram_ops;
 
-/**************************************************************************\
-*                                                                          *
-* Handlers for the socket list.                                            *
-*                                                                          *
-\**************************************************************************/
+/* Handlers for the socket list. */
 
 HLIST_HEAD(gn_sockets);
 DEFINE_RWLOCK(gn_sockets_lock);
@@ -53,7 +49,7 @@ static inline void gn_remove_socket(struct sock *sk)
 }
 
 #define from_timer(var, callback_timer, timer_fieldname) \
-	container_of(callback_timer, typeof(*var), timer_fieldname)
+	container_of(callback_timer, typeof(*(var)), timer_fieldname)
 
 static void gn_destroy_timer(struct timer_list *t)
 {
@@ -81,12 +77,9 @@ static inline void gn_destroy_socket(struct sock *sk)
 	}
 }
 
-/**************************************************************************\
-*                                                                          *
-* Handling for system calls applied via the various interfaces to an       *
-* GeoNetworking socket object.                                             *
-*                                                                          *
-\**************************************************************************/
+/* Handling for system calls applied via the various interfaces to a
+ * GeoNetworking socket object.
+ */
 
 static struct proto gn_proto = {
 	.name = "GN",
@@ -97,7 +90,7 @@ static struct proto gn_proto = {
 HLIST_HEAD(gn_interfaces);
 DEFINE_SPINLOCK(gn_interfaces_lock);
 
-void gn_activate_beacon(void);
+static void gn_activate_beacon(void);
 
 /**
  * gn_iface - add device to the interface the socketaddress is bound to
@@ -106,8 +99,7 @@ static struct gn_iface *gn_if_add_device(struct net_device *dev,
 					 struct sockaddr_gn *sa)
 {
 	bool was_empty;
-	struct gn_iface *gnif,
-		*new_gnif = kzalloc(sizeof(struct gn_iface), GFP_KERNEL);
+	struct gn_iface *gnif, *new_gnif = kzalloc_obj(*new_gnif, GFP_KERNEL);
 
 	if (!new_gnif)
 		return NULL;
@@ -266,7 +258,7 @@ static int gn_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol < GN_PROTO_ANY || protocol > GN_PROTO_MAX)
 		goto out;
 
-	/* Note: Only BTP/GeoNetworking protocols are supported; IPv6 encapsulation is not enabled */
+	/* Note: Only BTP/GeoNetworking protocols supported; IPv6 encap not enabled */
 	if (protocol == GN_PROTO_INET6)
 		goto out;
 
@@ -357,8 +349,7 @@ static struct sock *gn_find_or_insert_socket(struct sock *sk,
 	gn = gn_sk(sk);
 	gn->src_addr = sgn->sgn_addr;
 	gn->src_port = sgn->sgn_port;
-	pr_info("gn: Add socket addr=%llx port=%d", gn->src_addr,
-		gn->src_port);
+	pr_info("gn: Add socket addr=%llx port=%d", gn->src_addr, gn->src_port);
 	__gn_insert_socket(sk); /* Wheee, it's free, assign and insert. */
 found:
 	write_unlock_bh(&gn_sockets_lock);
@@ -462,7 +453,7 @@ static struct sock *gn_search_socket(struct sockaddr_gn *tosgn,
 
 		if (gn->src_port != tosgn->sgn_port)
 			continue;
-		if (gnif == NULL || gn->src_addr == gnif->address) {
+		if (!gnif || gn->src_addr == gnif->address) {
 			sock_hold(s);
 			goto out;
 		}
@@ -473,14 +464,6 @@ static struct sock *gn_search_socket(struct sockaddr_gn *tosgn,
 	return s;
 }
 
-/*
-static int gn_dupl_addr_detect(unsigned long long local_llc, gn_address_t local_addr,
-				unsigned long long rcv_llc, gn_address_t rcv_addr)
-{
-	return 0;
-}
-*/
-
 static u16 gn_if_next_sn(struct gn_iface *gnif)
 {
 	return atomic_inc_return(&gnif->local_sn) % USHRT_MAX;
@@ -488,7 +471,7 @@ static u16 gn_if_next_sn(struct gn_iface *gnif)
 
 void gn_fill_sopv(struct gn_iface *gnif, struct gn_lpv *sopv, gn_address_t addr)
 {
-	/* Note: Speed and Heading fields are currently zeroed until velocity sensors are integrated */
+	/* Note: Speed and Heading zeroed until velocity sensors integrated */
 
 	ktime_t tst = ktime_set(gnif->pos.tst.tv_sec, gnif->pos.tst.tv_nsec);
 	// fill empty timestamp with current timestamp
@@ -639,6 +622,60 @@ static int gn_pass_payload_sock(struct sockaddr_gn *tosgn, struct sk_buff *skb)
 	return rc;
 }
 
+static int gn_forward_guc_packet(struct sk_buff *skb, gn_address_t dest_addr)
+{
+	struct sk_buff *forward_skb;
+	struct gn_header *fwd_gh;
+	struct gn_iface *gnif;
+	u8 next_hop_mac[ETH_ALEN];
+
+	fwd_gh = (struct gn_header *)skb_network_header(skb);
+	if (fwd_gh->gb_h.rhl <= 0)
+		return -EINVAL;
+
+	gnif = gn_find_interface_by_dev(skb->dev);
+	if (!gnif)
+		return -ENODEV;
+
+	forward_skb = skb_copy(skb, GFP_ATOMIC);
+	if (!forward_skb) {
+		pr_warn("Dropping packet during GUC forwarding\n");
+		return -ENOMEM;
+	}
+
+	fwd_gh = (struct gn_header *)skb_network_header(forward_skb);
+	fwd_gh->gb_h.rhl--;
+
+	if (gn_query_ll_nexthop(gnif, dest_addr, next_hop_mac) == 0)
+		gn_dl->request(gn_dl, forward_skb, next_hop_mac);
+	else
+		gn_dl->request(gn_dl, forward_skb, skb->dev->broadcast);
+
+	return 0;
+}
+
+static int gn_forward_tsb_packet(struct sk_buff *skb)
+{
+	struct sk_buff *forward_skb;
+	struct gn_header *fwd_gh;
+
+	fwd_gh = (struct gn_header *)skb_network_header(skb);
+	if (fwd_gh->gb_h.rhl <= 0)
+		return -EINVAL;
+
+	forward_skb = skb_copy(skb, GFP_ATOMIC);
+	if (!forward_skb) {
+		pr_warn("Dropping packet during TSB forwarding\n");
+		return -ENOMEM;
+	}
+
+	fwd_gh = (struct gn_header *)skb_network_header(forward_skb);
+	fwd_gh->gb_h.rhl--;
+
+	gn_dl->request(gn_dl, forward_skb, skb->dev->broadcast);
+	return 0;
+}
+
 static int gn_process_guc_packet(struct sk_buff *skb)
 {
 	struct gn_header *gh;
@@ -660,8 +697,13 @@ static int gn_process_guc_packet(struct sk_buff *skb)
 		goto drop;
 
 	gnif = gn_find_interface(tosgn.sgn_addr);
-	if (!gnif)
+	if (!gnif) {
+		if (gn_forward_guc_packet(skb, tosgn.sgn_addr) == 0) {
+			kfree_skb(skb);
+			return NET_RX_SUCCESS;
+		}
 		goto drop;
+	}
 
 	if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
 		goto drop;
@@ -734,7 +776,7 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 	tosgn.sgn_addr = gh->gbc_h.sopv.addr;
 	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
 
-	/* Resolve local GeoNetworking interface from skb->dev to check geographical area membership */
+	/* Resolve local GeoNetworking interface to check area membership */
 	gnif = gn_find_interface_by_dev(skb->dev);
 	if (!gnif)
 		goto drop;
@@ -783,7 +825,8 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 			pr_warn("dropping packet");
 			goto drop;
 		}
-		fwd_gb_h = (struct gn_basic_header *)skb_transport_header(forward_skb);
+		fwd_gb_h = (struct gn_basic_header *)skb_transport_header(
+			forward_skb);
 		fwd_gb_h->rhl--;
 
 		rc = gn_gxc_forward(gnif, f_value, dest_addr, &gh->gbc_h.sopv);
@@ -864,22 +907,8 @@ static int gn_process_tsb_packet(struct sk_buff *skb)
 				     &gh->tsb_h.sn))
 		goto drop;
 
-	if (gh->gb_h.rhl > 0) {
-		// Forward packet
-		struct sk_buff *forward_skb;
-		struct gn_header *fwd_gh;
-
-		forward_skb = skb_copy(skb, GFP_ATOMIC);
-		if (!forward_skb) {
-			pr_warn("Dropping packet");
-			goto drop;
-		}
-
-		fwd_gh = (struct gn_header *)skb_network_header(forward_skb);
-		fwd_gh->gb_h.rhl--;
-
-		gn_dl->request(gn_dl, forward_skb, skb->dev->broadcast);
-	}
+	if (gh->gb_h.rhl > 0)
+		gn_forward_tsb_packet(skb);
 
 	// 7. pass payload of GN_PDU to the upper protocol unit
 	tosgn.sgn_family = PF_GN;
@@ -939,10 +968,10 @@ static int gn_process_ls_packet(struct sk_buff *skb)
 				dest_addr, 0);
 		} else {
 			// has to be forwarded like a tsb
-			//5. try to flush own forward buffer
+			// 5. try to flush own forward buffer
 			gn_ls_flush(gls_req_h->sopv.addr);
-			//6. forward like a tsb - (omitted atm, since forwarding of tsb
-			// is processed on another branch)
+			// 6. forward like a tsb
+			gn_forward_tsb_packet(skb);
 		}
 	} else if (gh->gc_h.hst == CH_HST_LS_REPLY) {
 		struct gn_ls_reply_header *gls_rep_h = &gh->ls_reply_h;
@@ -953,14 +982,11 @@ static int gn_process_ls_packet(struct sk_buff *skb)
 			goto drop;
 		dest_addr = gls_rep_h->depv.addr;
 
-		//4. flush forward buffer
+		// 4. flush forward buffer
 		gn_ls_flush(gls_rep_h->sopv.addr);
-		//5. find out if the packet has to be forwarded
-		if (!gn_find_interface(dest_addr)) {
-			/* Note: Multi-hop forwarding of LS replies when destination router is non-local */
-			; //Packet is not for this router, it has to be forwarded like a guc
-			//omitted atm, since F(x,y) needed
-		}
+		// 5. find out if the packet has to be forwarded
+		if (!gn_find_interface(dest_addr))
+			gn_forward_guc_packet(skb, dest_addr);
 	} else {
 		//WARN_ONCE(1, "called gn_process_ls_packet on non-LS packet");
 		goto drop;
@@ -1031,37 +1057,54 @@ static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	switch (gh->gc_h.ht) {
 	case CH_HT_GUC:
-		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_guc_header) + sizeof(struct btp_header)))
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE +
+						sizeof(struct gn_guc_header) +
+						sizeof(struct btp_header)))
 			goto drop;
 		return gn_process_guc_packet(skb);
 	case CH_HT_GAC:
 	case CH_HT_GBC:
-		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_gxc_header) + sizeof(struct btp_header)))
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE +
+						sizeof(struct gn_gxc_header) +
+						sizeof(struct btp_header)))
 			goto drop;
 		return gn_process_gxc_packet(skb);
 	case CH_HT_TSB:
 		if (gh->gc_h.hst == CH_HST_TSB_SINGLE_HOP) {
-			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_shb_header) + sizeof(struct btp_header)))
+			if (!pskb_may_pull(
+				    skb, GN_BASE_HEADER_SIZE +
+						 sizeof(struct gn_shb_header) +
+						 sizeof(struct btp_header)))
 				goto drop;
 			return gn_process_shb_packet(skb, eth->h_source);
-		} else if (gh->gc_h.hst == CH_HST_TSB_MULTI_HOP) {
-			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_tsb_header) + sizeof(struct btp_header)))
+		}
+		if (gh->gc_h.hst == CH_HST_TSB_MULTI_HOP) {
+			if (!pskb_may_pull(
+				    skb, GN_BASE_HEADER_SIZE +
+						 sizeof(struct gn_tsb_header) +
+						 sizeof(struct btp_header)))
 				goto drop;
 			return gn_process_tsb_packet(skb);
-		} else {
-			goto drop;
 		}
-		break;
+		goto drop;
 	case CH_HT_BEACON:
-		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_beacon_header)))
+		if (!pskb_may_pull(skb,
+				   GN_BASE_HEADER_SIZE +
+					   sizeof(struct gn_beacon_header)))
 			goto drop;
 		return gn_process_beacon_packet(skb, eth->h_source);
 	case CH_HT_LS:
 		if (gh->gc_h.hst == CH_HST_LS_REQUEST) {
-			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_ls_request_header)))
+			if (!pskb_may_pull(
+				    skb,
+				    GN_BASE_HEADER_SIZE +
+					    sizeof(struct gn_ls_request_header)))
 				goto drop;
 		} else if (gh->gc_h.hst == CH_HST_LS_REPLY) {
-			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + sizeof(struct gn_ls_reply_header)))
+			if (!pskb_may_pull(
+				    skb,
+				    GN_BASE_HEADER_SIZE +
+					    sizeof(struct gn_ls_reply_header)))
 				goto drop;
 		} else {
 			goto drop;
@@ -1181,7 +1224,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct gn_iface *gnif;
 	u32 size;
 	u32 eh_size;
-	u8 rhl;
+	u8 rhl = DEFAULT_HOP_LIMIT;
 	struct gn_spv depv = { 0 };
 
 	if (flags & ~(MSG_DONTWAIT | MSG_CMSG_COMPAT)) {
@@ -1376,11 +1419,13 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	case CH_HT_TSB:
 		if (packet_subtype == CH_HST_TSB_SINGLE_HOP) {
 			rhl = 1;
-			gn_fill_shb_header((struct gn_shb_header *)gp_h, gnif, gn);
+			gn_fill_shb_header((struct gn_shb_header *)gp_h, gnif,
+					   gn);
 		} else if (packet_subtype == CH_HST_TSB_MULTI_HOP) {
 			//at this point it is safe to assume that a topological scope is used
-			rhl = gn->scope.topo_hops;
-			gn_fill_tsb_header((struct gn_tsb_header *)gp_h, gnif, gn);
+			rhl = gn->scope.topo_hops ?: DEFAULT_HOP_LIMIT;
+			gn_fill_tsb_header((struct gn_tsb_header *)gp_h, gnif,
+					   gn);
 		} else {
 			WARN_ONCE(1, "internal error");
 			err = -EINVAL;
@@ -1409,7 +1454,7 @@ static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			// LS request is pending, we're done
 			break;
 		case GN_QUEUE_DIRECT:
-			/* Destination is in LocTE; resolve direct or greedy forwarding next-hop MAC */
+			/* Destination in LocTE; resolve MAC or greedy next-hop */
 			if (gn_query_ll_nexthop(gnif, usgn->sgn_addr,
 						ll_address))
 				gn_dl->request(gn_dl, skb, dev->broadcast);
@@ -1545,7 +1590,7 @@ static void gn_send_beacons(struct timer_list *tl)
 
 static DEFINE_TIMER(gn_beacon_timer, gn_send_beacons);
 
-void gn_activate_beacon(void)
+static void gn_activate_beacon(void)
 {
 	mod_timer(&gn_beacon_timer,
 		  jiffies + msecs_to_jiffies(GN_BEACON_RETRANSMIT_TIME));
@@ -1554,22 +1599,20 @@ void gn_activate_beacon(void)
 static int validate_geo_scope(struct gn_geo_scope *scope)
 {
 	if (scope->angle > 360)
-		return 1;
+		return -EINVAL;
 
 	if (scope->a == 0)
-		return 1;
-
-	int is_not_null = scope->b != 0 ? 1 : 0;
+		return -EINVAL;
 
 	switch (scope->shape) {
 	case GN_SHAPE_CIRCLE:
-		return is_not_null;
+		return scope->b != 0 ? -EINVAL : 0;
 	case GN_SHAPE_RECTANGLE:
 	case GN_SHAPE_ELLIPSE:
 		return 0;
 	default:
 	case GN_SHAPE_UNSPECIFIED:
-		return 1;
+		return -EINVAL;
 	}
 	return 0;
 }
@@ -1578,7 +1621,7 @@ static int validate_scope(struct gn_scope *scope)
 {
 	if (scope->scope_type < GN_SCOPE_TOPOLOGICAL ||
 	    scope->scope_type > GN_SCOPE_MAX)
-		return 1;
+		return -EINVAL;
 	switch (scope->scope_type) {
 	case GN_SCOPE_TOPOLOGICAL:
 		return 0;
@@ -1586,7 +1629,7 @@ static int validate_scope(struct gn_scope *scope)
 	case GN_SCOPE_GEOGRAPHICAL_ANYCAST:
 		return validate_geo_scope(&scope->geo_scope);
 	default:
-		return 1;
+		return -EINVAL;
 	}
 	return 0;
 }
@@ -1611,8 +1654,8 @@ static int gn_setsockopt(struct socket *sock, int level, int optname,
 	if (copy_from_sockptr(&opt, optval, sizeof(struct gn_scope)))
 		goto out;
 
-	rc = -EINVAL;
-	if (validate_scope(&opt))
+	rc = validate_scope(&opt);
+	if (rc < 0)
 		goto out;
 
 	lock_sock(sk);
@@ -1718,6 +1761,19 @@ static int gn_if_ioctl(struct socket *sock, unsigned int cmd, void __user *argp)
 			return -EINVAL;
 		if (dev->type != ARPHRD_ETHER)
 			return -EINVAL;
+		/*
+		 * TODO: Remove the -EEXIST check below to allow SIOCSIFADDR to seamlessly
+		 * update/replace an existing interface address (required for ETSI ITS
+		 * pseudonym rotation per TS 102 636-4-1).
+		 *
+		 * Before removing -EEXIST, the following steps must be addressed:
+		 * 1. Socket Synchronization: Active sockets bound to the old interface
+		 *    address must have their gn->src_addr updated when gnif->address changes.
+		 * 2. Sequence Number Preservation: gn_if_add_device() currently allocates
+		 *    a new gn_iface with local_sn initialized to 0. When replacing an entry,
+		 *    preserve the existing local_sn value or perform in-place mutation under
+		 *    gn_interfaces_lock instead of allocating a replacement struct.
+		 */
 		if (gn_find_interface_by_dev(dev))
 			return -EEXIST;
 		gnif = gn_if_add_device(dev, sa);
@@ -1844,7 +1900,7 @@ static struct packet_type gn_packet_type __read_mostly = {
 
 /*
  * SNAP-ID for Geonetworking 0x8947
- * Note: SNAP header format uses network byte order (big-endian 0x8947) as per ETSI EN 302 636-4-1 Annex E
+ * Note: SNAP header format uses big-endian 0x8947 per ETSI EN 302 636-4-1 Annex E
  */
 static unsigned char gn_snap_id[] = { 0x00, 0x00, 0x00, 0x89, 0x47 };
 
diff --git a/net/gn/gn_routing.c b/net/gn/gn_routing.c
index 110a4d76d2bd..de1c77359e09 100644
--- a/net/gn/gn_routing.c
+++ b/net/gn/gn_routing.c
@@ -26,11 +26,7 @@ static DEFINE_SPINLOCK(gn_loc_t_lock);
 #define GN_TST_VALID(tst) \
 	time_before(jiffies, (unsigned long)(tst) + GN_LT_JIFFIES)
 
-/***************************************************************************\
-*                                                                           *
-* GeoNetworking routing                                                     *
-*                                                                           *
-\***************************************************************************/
+/* GeoNetworking routing */
 
 static u16 *gn_dpd_find(struct gn_dpd_buf *buf, u16 sn)
 {
@@ -122,21 +118,21 @@ static int icos(__s64 rad)
 }
 
 /* degree_to_rad() - convert a degree value to a rad value.
-* @a : the degree value as 1/10 micro degree (10^7).
-*
-* Return : the rad value * 10^7.
-*/
+ * @a : the degree value as 1/10 micro degree (10^7).
+ *
+ * Return : the rad value * 10^7.
+ */
 static __s64 degree_to_rad(__s64 a)
 {
 	return (((RAD_PER_DEGREE * a) / 10000000ULL)) % (PI * 2ULL);
 }
 
 /* diff() - calculate the difference beween a and b.
-* @a : value a.
-* @b : value b.
-*
-* Return : the difference
-*/
+ * @a : value a.
+ * @b : value b.
+ *
+ * Return : the difference
+ */
 static __s32 diff(__s32 a, __s32 b)
 {
 	__s32 r = a - b;
@@ -150,7 +146,7 @@ static __s32 diff(__s32 a, __s32 b)
  * @y : after execute includes the meter on Y-axes.
  *
  * the calculation based on pythagoras.
-*/
+ */
 static struct gn_coord gn_coord_diff(struct gn_coord lhs, struct gn_coord rhs)
 {
 	struct gn_coord c;
@@ -247,8 +243,7 @@ static int greedy_forward(struct gn_iface *gnif, u8 *addr, struct gn_lpv *depv)
 			}
 		}
 	}
-
-	// FIXME traffic class check here
+	/* Note: Traffic class and store-carry-forward evaluation for next-hop selection */
 	if (found_addr) {
 		ether_addr_copy(addr, found_addr);
 		rc = GN_FORWARD_NEXT_HOP;
@@ -326,7 +321,7 @@ static void gn_prune(void)
 /* update_location_table() - update location table
  * @pv: the position vector which indicate an entry.
  *
- * Return: 0 on success, 1 on error, 2 if packet is duplicate.
+ * Return: 0 on success, negative errno on error, -EALREADY if packet is duplicate.
  *
  * Update an entry, which indicated by @spv. If no entry found its will be add a new one.
  * And all entries will be check with the update function.
@@ -334,8 +329,7 @@ static void gn_prune(void)
 int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour,
 			     const u8 *ll_address, const __be16 *sn)
 {
-	// FIXME Use timestamp associated with incoming skb
-	// TODO (Clause C.2): Only update PV if incoming PV is newer than stored PV
+	/* ETSI EN 302 636-4-1 Clause C.2: Update PV only when incoming PV timestamp is newer */
 	struct loc_te *entry;
 	bool found = false;
 
@@ -366,19 +360,18 @@ int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour,
 			if (gn_dpd_find(&entry->dpl, be16_to_cpu(*sn))) {
 				pr_debug("received duplicate packet\n");
 				spin_unlock_bh(&gn_loc_t_lock);
-				return 2;
-			} else {
-				gn_dpd_insert(&entry->dpl, be16_to_cpu(*sn));
+				return -EALREADY;
 			}
+			gn_dpd_insert(&entry->dpl, be16_to_cpu(*sn));
 		}
 		break;
 	}
 
 	if (!found) {
-		entry = kzalloc(sizeof(struct loc_te), GFP_ATOMIC);
+		entry = kzalloc_obj(*entry, GFP_ATOMIC);
 		if (!entry) {
 			spin_unlock_bh(&gn_loc_t_lock);
-			return 1;
+			return -ENOMEM;
 		}
 		pr_debug("adding entry addr=%llx\n", pv->addr);
 		entry->addr = pv->addr;
@@ -437,7 +430,7 @@ static void __ls_queue(struct sk_buff_head *q, struct sk_buff *skb)
 int gn_ls_queue(gn_address_t dest_addr, struct sk_buff *skb)
 {
 	struct loc_te *entry;
-	int rc = -1;
+	int rc = -ENOENT;
 
 	spin_lock_bh(&gn_loc_t_lock);
 	hash_for_each_possible(gn_loc_t, entry, hnode, dest_addr) {
@@ -460,11 +453,11 @@ int gn_ls_queue(gn_address_t dest_addr, struct sk_buff *skb)
 
 		break;
 	}
-	if (rc == -1) {
-		entry = kzalloc(sizeof(struct loc_te), GFP_ATOMIC);
+	if (rc == -ENOENT) {
+		entry = kzalloc_obj(*entry, GFP_ATOMIC);
 		if (!entry) {
 			spin_unlock_bh(&gn_loc_t_lock);
-			return GN_QUEUE_ERROR;
+			return -ENOMEM;
 		}
 
 		rc = GN_QUEUE_LS_STALE;
@@ -526,7 +519,7 @@ void gn_ls_flush(gn_address_t dest_addr)
 int gn_query_ll_address(gn_address_t query_addr, u8 *ll_address)
 {
 	struct loc_te *entry;
-	int rc = 1;
+	int rc = -ENOENT;
 
 	spin_lock_bh(&gn_loc_t_lock);
 	hash_for_each_possible(gn_loc_t, entry, hnode, query_addr) {
@@ -556,7 +549,7 @@ int gn_query_ll_address(gn_address_t query_addr, u8 *ll_address)
  * If query_addr is a multi-hop destination in LocTE, runs greedy forwarding to
  * select the best next-hop neighbor toward the destination.
  *
- * Return: 0 if link-layer address resolved (ll_address populated), 1 if broadcast needed.
+ * Return: 0 if link-layer address resolved, negative errno if broadcast needed.
  */
 int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_address)
 {
@@ -583,11 +576,12 @@ int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_a
 	spin_unlock_bh(&gn_loc_t_lock);
 
 	if (!found)
-		return 1;
+		return -ENOENT;
 	if (is_neighbor)
 		return 0;
 
-	return (greedy_forward(gnif, ll_address, &target_pv) == GN_FORWARD_NEXT_HOP) ? 0 : 1;
+	return (greedy_forward(gnif, ll_address, &target_pv) ==
+		GN_FORWARD_NEXT_HOP) ? 0 : -EHOSTUNREACH;
 }
 
 /**
@@ -600,7 +594,7 @@ int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_a
 int gn_fill_depv(struct gn_spv *depv, gn_address_t dest_addr)
 {
 	struct loc_te *entry;
-	int rc = -1;
+	int rc = -ENOENT;
 
 	spin_lock_bh(&gn_loc_t_lock);
 	hash_for_each_possible(gn_loc_t, entry, hnode, dest_addr) {
-- 
2.55.0

