Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [129.187.255.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330237BE78;
	Thu, 16 Jul 2026 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784219022; cv=none; b=GrNUPcOJeUPMQjR0pKGAk8aVc2ZHjW9K9FsgeF7qwzZD+VhR/gVrr0+F86nIY739MSfpoPOA13fP92DupGI88GYT/FPBHq6GDSekUnPNspJKGimY/aRBr2Ctv6gNqoAvCyz6PMakz40FrQizrwP0/pGoDR4wYO4WrO9PWTJuJxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784219022; c=relaxed/simple;
	bh=XiIVJZqXs4htEsK1/Gc5OmFrqfLUL6MRogRzku27jT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYnbtkfQDhvQuNZAxCxgjktVF3TSq7xYtjUKRrrUP1CBVWz2Hg4Zmb4QzPr2KZqgfqVNaLB9AGife9fiEIb9ub0wiVr4fgt+XtBDO8lW/gpSwY62IxcO+e4Hgp/DqR2zQotmzlfvjw7Fkr1o+z2ePAH9FQP0iqwGIj/Dmw0kQjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de; spf=pass smtp.mailfrom=hs-ansbach.de; dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b=yeAYsmkh; arc=none smtp.client-ip=129.187.255.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b="yeAYsmkh"
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
	by postout1.mail.lrz.de (Postfix) with ESMTP id 4h1JJ86cy1zyWS;
	Thu, 16 Jul 2026 18:23:36 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=hs-ansbach.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hs-ansbach.de;
	 h=content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=an-postout22; t=1784219016; bh=s/JeyjKv01w
	nG8T00VBk4Dzsjsc5kyYzQCnlgZRIkoA=; b=yeAYsmkhhLgK5bqnqR7xI5wVL0S
	IDXW2hW/QOd6d6NBsZnmzfoUUbxDCFe68fa2Hg7fkBuypxn1UeQeyqn4bTGLP2Nn
	5z1NtTyi7M6+lmIkWoEYT+/uUyvkBldDP+yxgl24W5LIMxPHhCGDx+PYxmPs6/6q
	Xnn8dAgGZywWeWv/hiQ+z9P0LTW1XDGjbACnwnserj9zR8Xz5sX8xSE5s5lv3zHo
	wcaE8XdS8ntTa241F1zL2lDbi6K093/XtfFhSqyUqTDQ6PgTh39SYf10chOKCJhP
	j3/CLPnbwUgG7+bWxus51ABimcGDFDyepGmR9Earhg2kVignLATxeB+2/ew==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs51.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.887
X-Spam-Level:
Received: from postout1.mail.lrz.de ([127.0.0.1])
 by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id lsGVAy89tKNg; Thu, 16 Jul 2026 18:23:36 +0200 (CEST)
Received: from chimchar.fritz.box (p200300eeb7001900d36d09bcf7cd0c19.dip0.t-ipconnect.de [IPv6:2003:ee:b700:1900:d36d:9bc:f7cd:c19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout1.mail.lrz.de (Postfix) with ESMTPSA id 4h1JJ74m0CzyZ4;
	Thu, 16 Jul 2026 18:23:35 +0200 (CEST)
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
Subject: [RFC PATCH net-next v0 6/6] net: apply RCS to GeoNetworking
Date: Thu, 16 Jul 2026 18:21:52 +0200
Message-ID: <20260716162152.3616762-1-dietz23838@hs-ansbach.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716161605.3587079-1-dietz23838@hs-ansbach.de>
References: <20260716161605.3587079-1-dietz23838@hs-ansbach.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Dietz <simon.dietz@plantwatch.de>

Signed-off-by: Simon Dietz <simon.dietz@plantwatch.de>
---
 net/gn/gn_proc.c    |   2 +-
 net/gn/gn_prot.c    | 123 +++++++++++++++++++++++---------------------
 net/gn/gn_routing.c |  24 ++++-----
 3 files changed, 76 insertions(+), 73 deletions(-)

diff --git a/net/gn/gn_proc.c b/net/gn/gn_proc.c
index ecd2aea446e5..bc1280079695 100644
--- a/net/gn/gn_proc.c
+++ b/net/gn/gn_proc.c
@@ -38,8 +38,8 @@ static void gn_seq_socket_stop(struct seq_file *seq, void *v)
 
 static int gn_seq_socket_show(struct seq_file *seq, void *v)
 {
-	struct sock *s;
 	struct gn_sock *gn;
+	struct sock *s;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq, "Type Local_addr  Remote_addr Tx_queue Rx_queue St UID\n");
diff --git a/net/gn/gn_prot.c b/net/gn/gn_prot.c
index 1599dc0aa185..c8a6d4a78771 100644
--- a/net/gn/gn_prot.c
+++ b/net/gn/gn_prot.c
@@ -99,8 +99,9 @@ static void gn_activate_beacon(void);
 static struct gn_iface *gn_if_add_device(struct net_device *dev,
 					 struct sockaddr_gn *sa)
 {
+	struct gn_iface *new_gnif = kzalloc_obj(*new_gnif, GFP_KERNEL);
+	struct gn_iface *gnif;
 	bool was_empty;
-	struct gn_iface *gnif, *new_gnif = kzalloc_obj(*new_gnif, GFP_KERNEL);
 
 	if (!new_gnif)
 		return NULL;
@@ -138,8 +139,8 @@ static struct gn_iface *gn_if_add_device(struct net_device *dev,
 
 static void gn_if_drop_device(struct net_device *dev)
 {
-	struct gn_iface *gnif;
 	struct hlist_node *tmp;
+	struct gn_iface *gnif;
 
 	spin_lock_bh(&gn_interfaces_lock);
 	hlist_for_each_entry_safe(gnif, tmp, &gn_interfaces, hnode) {
@@ -154,8 +155,8 @@ static void gn_if_drop_device(struct net_device *dev)
 
 static void gn_interfaces_clear(void)
 {
-	struct gn_iface *gnif;
 	struct hlist_node *tmp;
+	struct gn_iface *gnif;
 
 	spin_lock_bh(&gn_interfaces_lock);
 	hlist_for_each_entry_safe(gnif, tmp, &gn_interfaces, hnode) {
@@ -341,8 +342,8 @@ try_next_port:;
 static struct sock *gn_find_or_insert_socket(struct sock *sk,
 					     struct sockaddr_gn *sgn)
 {
-	struct sock *s;
 	struct gn_sock *gn;
+	struct sock *s;
 
 	write_lock_bh(&gn_sockets_lock);
 	sk_for_each(s, &gn_sockets) {
@@ -373,9 +374,11 @@ static int gn_bind(struct socket *sock, struct sockaddr_unsized *uaddr,
 {
 	DECLARE_SOCKADDR(struct sockaddr_gn *, addr, uaddr);
 	struct sock *sk = sock->sk;
-	struct gn_sock *gn = gn_sk(sk);
+	struct gn_sock *gn;
 	int err;
 
+	gn = gn_sk(sk);
+
 	if (!sock_flag(sk, SOCK_ZAPPED) ||
 	    addr_len != sizeof(struct sockaddr_gn))
 		return -EINVAL;
@@ -413,10 +416,12 @@ static int gn_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		      int addr_len, int flags)
 {
 	struct sock *sk = sock->sk;
-	struct gn_sock *gn = gn_sk(sk);
 	struct sockaddr_gn *addr;
+	struct gn_sock *gn;
 	int err;
 
+	gn = gn_sk(sk);
+
 	sk->sk_state = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
@@ -450,8 +455,8 @@ static int gn_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 static struct sock *gn_search_socket(struct sockaddr_gn *tosgn,
 				     struct gn_iface *gnif)
 {
-	struct sock *s;
 	struct gn_sock *gn;
+	struct sock *s;
 
 	read_lock_bh(&gn_sockets_lock);
 	sk_for_each(s, &gn_sockets) {
@@ -537,11 +542,11 @@ static void gn_fill_bh_ch_nopayload(struct gn_iface *gnif,
 static void gn_location_service_req(struct gn_iface *gnif, gn_address_t saddr,
 				    gn_address_t daddr)
 {
-	int size = 0;
-	struct sk_buff *skb;
-	struct gn_basic_header *gb_h;
-	struct gn_common_header *gc_h;
 	struct gn_ls_request_header *gls_h;
+	struct gn_common_header *gc_h;
+	struct gn_basic_header *gb_h;
+	struct sk_buff *skb;
+	int size = 0;
 
 	size += gn_dl->header_length;
 	size += gnif->dev->hard_header_len;
@@ -577,11 +582,11 @@ static void gn_location_service_reply(struct gn_spv *depv,
 				      struct gn_iface *gnif, gn_address_t addr,
 				      u64 llc)
 {
-	int size;
-	struct sk_buff *skb;
-	struct gn_basic_header *gb_h;
-	struct gn_common_header *gc_h;
 	struct gn_ls_reply_header *gls_h;
+	struct gn_common_header *gc_h;
+	struct gn_basic_header *gb_h;
+	struct sk_buff *skb;
+	int size;
 
 	size = 0;
 	size += gn_dl->header_length;
@@ -616,8 +621,8 @@ static void gn_location_service_reply(struct gn_spv *depv,
 
 static int gn_pass_payload_sock(struct sockaddr_gn *tosgn, struct sk_buff *skb)
 {
-	struct sock *sock;
 	int rc = NET_RX_DROP;
+	struct sock *sock;
 
 	sock = gn_search_socket(tosgn, NULL);
 	if (!sock)
@@ -631,9 +636,9 @@ static int gn_pass_payload_sock(struct sockaddr_gn *tosgn, struct sk_buff *skb)
 static int gn_forward_guc_packet(struct sk_buff *skb, gn_address_t dest_addr)
 {
 	struct sk_buff *forward_skb;
+	u8 next_hop_mac[ETH_ALEN];
 	struct gn_header *fwd_gh;
 	struct gn_iface *gnif;
-	u8 next_hop_mac[ETH_ALEN];
 
 	fwd_gh = (struct gn_header *)skb_network_header(skb);
 	if (fwd_gh->gb_h.rhl <= 0)
@@ -684,10 +689,10 @@ static int gn_forward_tsb_packet(struct sk_buff *skb)
 
 static int gn_process_guc_packet(struct sk_buff *skb)
 {
-	struct gn_header *gh;
 	struct btp_header *btp_h;
 	struct sockaddr_gn tosgn;
 	struct gn_iface *gnif;
+	struct gn_header *gh;
 
 	gh = (struct gn_header *)skb_network_header(skb);
 	GN_SET_BTP(skb, btp_h, struct gn_guc_header);
@@ -764,14 +769,14 @@ static struct gn_geo_scope gn_decode_geo_scope(struct gn_header *gh)
 
 static int gn_process_gxc_packet(struct sk_buff *skb)
 {
-	struct gn_header *gh;
+	unsigned long long next_hop_addr;
+	struct gn_geo_scope scope;
 	struct btp_header *btp_h;
 	struct sockaddr_gn tosgn;
 	struct gn_iface *gnif;
-	s64 f_value;
-	struct gn_geo_scope scope;
+	struct gn_header *gh;
 	bool run_dpd;
-	unsigned long long next_hop_addr;
+	s64 f_value;
 
 	next_hop_addr = GN_BROADCAST_ADDR;
 
@@ -821,8 +826,8 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 	// Forwarding
 	if (gh->gb_h.rhl > 0 && ((gh->gc_h.ht == CH_HT_GAC && f_value >= 0) ||
 				 gh->gc_h.ht == CH_HT_GBC)) {
-		struct sk_buff *forward_skb;
 		struct gn_basic_header *fwd_gb_h;
+		struct sk_buff *forward_skb;
 		u8 dest_addr[ETH_ALEN];
 		int rc;
 
@@ -873,9 +878,9 @@ static int gn_process_gxc_packet(struct sk_buff *skb)
 
 static int gn_process_shb_packet(struct sk_buff *skb, const u8 *ll_address)
 {
-	struct gn_header *gh;
 	struct btp_header *btp_h;
 	struct sockaddr_gn tosgn;
+	struct gn_header *gh;
 
 	gh = (struct gn_header *)skb_network_header(skb);
 	GN_SET_BTP(skb, btp_h, struct gn_shb_header);
@@ -905,9 +910,9 @@ static int gn_process_shb_packet(struct sk_buff *skb, const u8 *ll_address)
 
 static int gn_process_tsb_packet(struct sk_buff *skb)
 {
-	struct gn_header *gh;
 	struct btp_header *btp_h;
 	struct sockaddr_gn tosgn;
+	struct gn_header *gh;
 
 	gh = (struct gn_header *)skb_network_header(skb);
 	GN_SET_BTP(skb, btp_h, struct gn_tsb_header);
@@ -955,9 +960,9 @@ static int gn_process_beacon_packet(struct sk_buff *skb, const u8 *llc)
 
 static int gn_process_ls_packet(struct sk_buff *skb)
 {
-	struct gn_header *gh;
 	gn_address_t dest_addr;
 	struct gn_iface *gnif;
+	struct gn_header *gh;
 
 	gh = (struct gn_header *)skb_network_header(skb);
 
@@ -1221,28 +1226,27 @@ static int gn_fill_tsb_header(struct gn_tsb_header *tsb_h,
  */
 static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
-	int packet_type, packet_subtype, btp_type;
-	int err = -EINVAL;
-	struct sock *sk = sock->sk;
-	struct gn_sock *gn = gn_sk(sk);
-
-	/*
-	 * usgn will contain address and port of the destination
-	 */
 	DECLARE_SOCKADDR(struct sockaddr_gn *, usgn, msg->msg_name);
-	int flags = msg->msg_flags;
-	struct sockaddr_gn local_sgn;
-	struct sk_buff *skb;
-	struct net_device *dev;
-	struct btp_header *btp_h;
-	void *gp_h;
+	int packet_type, packet_subtype, btp_type;
 	struct gn_common_header *gc_h;
 	struct gn_basic_header *gb_h;
+	struct sockaddr_gn local_sgn;
+	struct gn_spv depv = { 0 };
+	u8 rhl = DEFAULT_HOP_LIMIT;
+	int flags = msg->msg_flags;
+	struct btp_header *btp_h;
+	struct net_device *dev;
 	struct gn_iface *gnif;
-	u32 size;
+	struct sk_buff *skb;
+	struct gn_sock *gn;
+	int err = -EINVAL;
+	struct sock *sk;
 	u32 eh_size;
-	u8 rhl = DEFAULT_HOP_LIMIT;
-	struct gn_spv depv = { 0 };
+	void *gp_h;
+	u32 size;
+
+	sk = sock->sk;
+	gn = gn_sk(sk);
 
 	if (flags & ~(MSG_DONTWAIT | MSG_CMSG_COMPAT)) {
 		pr_warn("unsupported sendmsg flags");
@@ -1514,13 +1518,12 @@ static int gn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		      int flags)
 {
 	struct sock *sk = sock->sk;
+	struct gn_header *gh;
 	struct sk_buff *skb;
-	int err = 0;
 	u16 copied = 0;
+	int err = 0;
 	u32 offset;
 
-	struct gn_header *gh;
-
 	/* It is necessary to find the actual length of the payload, which,
 	 * in case of an unsecured package, resides in the commonheader and
 	 * still has to be calculated without the length of the btp-header
@@ -1562,11 +1565,11 @@ static int gn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 static int gn_send_beacon(struct gn_iface *gnif)
 {
 	/* Note: Media dependent procedures (e.g. ITS-G5 DCC / DCC Access) evaluated here */
-	unsigned int size;
-	struct gn_basic_header *gb_h;
-	struct gn_common_header *gc_h;
 	struct gn_beacon_header *gbe_h;
+	struct gn_common_header *gc_h;
+	struct gn_basic_header *gb_h;
 	struct sk_buff *skb;
+	unsigned int size;
 
 	size = gn_dl->header_length;
 	size += gnif->dev->hard_header_len;
@@ -1660,11 +1663,12 @@ static int validate_scope(struct gn_scope *scope)
 static int gn_setsockopt(struct socket *sock, int level, int optname,
 			 sockptr_t optval, unsigned int optlen)
 {
-	struct gn_scope opt;
 	struct sock *sk = sock->sk;
-	struct gn_sock *gn = gn_sk(sk);
-
 	int rc = -ENOPROTOOPT;
+	struct gn_scope opt;
+	struct gn_sock *gn;
+
+	gn = gn_sk(sk);
 
 	if (level != SOL_GN || optname != GN_SCOPE)
 		goto out;
@@ -1693,9 +1697,11 @@ static int gn_setsockopt(struct socket *sock, int level, int optname,
 static int gn_getsockopt(struct socket *sock, int level, int optname,
 			 char __user *optval, int __user *optlen)
 {
-	struct sock *sk = sock->sk;
-	struct gn_sock *gn = gn_sk(sk);
 	int len, rc = -ENOPROTOOPT;
+	struct sock *sk = sock->sk;
+	struct gn_sock *gn;
+
+	gn = gn_sk(sk);
 
 	if (level != SOL_GN || optname != GN_SCOPE)
 		goto out;
@@ -1737,12 +1743,11 @@ static int gn_validate_pos(struct gn_position *pos)
  */
 static int gn_if_ioctl(struct socket *sock, unsigned int cmd, void __user *argp)
 {
+	struct gn_iface *gnif = NULL;
 	struct sockaddr_gn *sa;
 	struct net_device *dev;
-	struct ifreq gnreq;
 	struct gn_position pos;
-
-	struct gn_iface *gnif = NULL;
+	struct ifreq gnreq;
 
 	if (copy_from_user(&gnreq, argp, sizeof(gnreq)))
 		return -EFAULT;
@@ -1824,9 +1829,9 @@ static int gn_if_ioctl(struct socket *sock, unsigned int cmd, void __user *argp)
 
 static int gn_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
-	int rc = -ENOIOCTLCMD;
-	struct sock *sk = sock->sk;
 	void __user *argp = (void __user *)arg;
+	struct sock *sk = sock->sk;
+	int rc = -ENOIOCTLCMD;
 
 	switch (cmd) {
 	/* Protocol layer */
diff --git a/net/gn/gn_routing.c b/net/gn/gn_routing.c
index 3672a345530f..c438c6ab6666 100644
--- a/net/gn/gn_routing.c
+++ b/net/gn/gn_routing.c
@@ -189,9 +189,9 @@ static inline u64 dist(struct gn_coord c)
  */
 __s64 gn_F(struct gn_coord self, struct gn_geo_scope scope)
 {
+	struct gn_coord coord_diff = gn_coord_diff(self, scope.coord);
 	s32 a2, b2, x2, y2;
 	s64 result = -1;
-	struct gn_coord coord_diff = gn_coord_diff(self, scope.coord);
 	/* Note: Scope angle rotation for non-circular geographical areas */
 	a2 = scope.a * scope.a;
 	b2 = scope.b * scope.b;
@@ -223,12 +223,11 @@ __s64 gn_F(struct gn_coord self, struct gn_geo_scope scope)
 
 static int greedy_forward(struct gn_iface *gnif, u8 *addr, struct gn_lpv *depv)
 {
+	struct gn_coord dest_coord = pv_to_coord(depv);
+	u64 min_dist, curr_dist, ego_dist;
+	u8 *found_addr = NULL;
 	struct loc_te *curr;
 	int bkt, rc;
-	u8 *found_addr = NULL;
-
-	u64 min_dist, curr_dist, ego_dist;
-	struct gn_coord dest_coord = pv_to_coord(depv);
 
 	ego_dist = dist(gn_coord_diff(dest_coord, gnif->pos.coord));
 	min_dist = ego_dist;
@@ -279,8 +278,8 @@ int gn_gxc_forward(struct gn_iface *gnif, s64 f, u8 *addr, struct gn_lpv *depv)
 
 static void debug_loc_te(void)
 {
-	struct loc_te *entry;
 	struct hlist_node *tmp;
+	struct loc_te *entry;
 	int bucket;
 
 	spin_lock_bh(&gn_loc_t_lock);
@@ -301,11 +300,10 @@ static void debug_loc_te(void)
 
 static void gn_prune(void)
 {
+	struct hlist_node *tmp;
 	struct loc_te *entry;
 	int bucket;
 
-	struct hlist_node *tmp;
-
 	spin_lock_bh(&gn_loc_t_lock);
 	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
 		if (!GN_TST_VALID(entry->tst_addr)) {
@@ -406,8 +404,8 @@ int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour,
 
 static void __ls_queue(struct sk_buff_head *q, struct sk_buff *skb)
 {
-	struct sk_buff *curr;
 	u32 qlen = skb_queue_len(q);
+	struct sk_buff *curr;
 
 	while (qlen-- > GN_LSB_SIZE) {
 		curr = skb_dequeue(q);
@@ -479,9 +477,9 @@ int gn_ls_queue(gn_address_t dest_addr, struct sk_buff *skb)
 
 void gn_ls_flush(gn_address_t dest_addr)
 {
-	struct loc_te *entry;
 	struct sk_buff *tmp_skb;
 	u8 ll_address[ETH_ALEN];
+	struct loc_te *entry;
 	bool has_mac = false;
 
 	spin_lock_bh(&gn_loc_t_lock);
@@ -557,9 +555,9 @@ int gn_query_ll_address(gn_address_t query_addr, u8 *ll_address)
  */
 int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_address)
 {
-	struct loc_te *entry;
-	struct gn_lpv target_pv;
 	bool is_neighbor = false;
+	struct gn_lpv target_pv;
+	struct loc_te *entry;
 	bool found = false;
 
 	spin_lock_bh(&gn_loc_t_lock);
@@ -620,9 +618,9 @@ int gn_fill_depv(struct gn_spv *depv, gn_address_t dest_addr)
 
 void gn_routing_exit(void)
 {
+	struct hlist_node *tmp;
 	struct loc_te *entry;
 	int bucket;
-	struct hlist_node *tmp;
 
 	spin_lock_bh(&gn_loc_t_lock);
 	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
-- 
2.55.0

