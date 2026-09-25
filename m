Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CB2377A80;
	Fri, 25 Sep 2026 02:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790304266; cv=none; b=O74UyxnEXGaQd1SihTPanrtKgqMZ10yMoOedC/7IM0OMb9AoEm4Y0vFVNPdW6x+HHybyFPprSUPOtYOteg8QgRUQ/ItlUrck3XFKqS/zsIWhyFeB+GbwW2DhEy+Er1MHPJMosJCGhReQU74ZFzZFA9tyhpjoMr01NcqBmdIJao8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790304266; c=relaxed/simple;
	bh=FFfkv3pRQG0Ce7YKWVPO8S5wGExHAbabu+5vkIcRWD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r+H0QtfQodbr1mqymE937i3iXQA2HF6V0RwB9LGrTlZje3sQGIlXk1HF0IX8h0/a9zHdf6gVz2NUzh0RFY5VxvdoINnssUwy87rg+SvwQYLK3S/HmdK6adRzvcFqqW8QK4wDqWHUR6Y2mhBLq1n+BWKP3k48ANIGRjsAtg196Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=jVCNC7Zn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="jVCNC7Zn"
Received: from mac.lan (unknown [4.194.122.162])
	by linux.microsoft.com (Postfix) with ESMTPSA id CBFFD20B7167;
	Thu, 24 Sep 2026 19:43:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CBFFD20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790304214;
	bh=TEVgHX/b40HLqi6u1s15jjNnZ9MIsG6iUH/zWE8aSqM=;
	h=From:To:Cc:Subject:Date:From;
	b=jVCNC7ZnGjgqesCkSHVuh6eSQsT4aE+XuIt/EolMyIEeirAlAsM42UsUr/a+ZlkZP
	 lk2Z8/k6IFb18/u6Yvja/+64RQeVzLvQ5QzpuRTN5ETiosbUsBa0QliBrHWkB2xMOC
	 fKpJiksb0lG3x4PQJicHP66r1vRCSk9jfOvmDkJ0=
From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+610e40369bc02181bad0@syzkaller.appspotmail.com,
	syzbot+878643e0580bc580f883@syzkaller.appspotmail.com,
	AutonomousCodeSecurity@microsoft.com,
	Francis Perron <francis@akrites.dev>,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	Cen Zhang <cenzhang@linux.microsoft.com>
Subject: [PATCH wireless] wifi: mac80211: fix slab-out-of-bounds read in ieee80211_monitor_select_queue()
Date: Thu, 24 Sep 2026 22:44:08 -0400
Message-ID: <20260925024408.32143-1-cenzhang@linux.microsoft.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_monitor_select_queue() validates the skb length using skb->len
before dereferencing pointers into skb->data to access the 802.11 header.
However, skb->len includes data in both the linear head buffer and
non-linear fragments/pages. When AF_PACKET sends a packet large enough to
become non-linear, the 802.11 header at skb->data + len_rthdr may extend
past the linear head buffer even though skb->len appears sufficient.

This leads to a slab-out-of-bounds read when accessing hdr->frame_control,
as the kernel reads beyond the allocated skb head buffer:

  BUG: KASAN: slab-out-of-bounds in ieee80211_monitor_select_queue+0x1ed/0x220

syzbot has hit the same issues.

Fix this by checking skb_headlen(skb) (which gives the length of the
linear data region) instead of skb->len before dereferencing skb->data
pointers. This ensures the required bytes are actually present in the
linear portion of the skb.

Apply the same fix to ieee80211_validate_radiotap_len() which has the
same class of bug: it uses skb->len to validate accesses to skb->data,
and to the corresponding checks in ieee80211_monitor_start_xmit(): for
drivers advertising NETIF_F_SG the skb is not linearized before
ndo_start_xmit, so the 802.11 header can be read past the linear
buffer there as well.

Fixes: cf0277e714a0 ("mac80211: fix skb buffering issue")
Fixes: 9b8a74e3482f ("[MAC80211]: Improve sanity checks on injected packets")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: syzbot+610e40369bc02181bad0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=610e40369bc02181bad0
Reported-by: syzbot+878643e0580bc580f883@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=878643e0580bc580f883
Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Reviewed-by: Francis Perron <francis@akrites.dev>
---
 net/mac80211/iface.c |  4 ++--
 net/mac80211/tx.c    | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 889c32fd8de1..88942317fec8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -998,8 +998,8 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 
 	len_rthdr = ieee80211_get_radiotap_len(skb->data);
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
-	if (skb->len < len_rthdr + 2 ||
-	    skb->len < len_rthdr + ieee80211_hdrlen(hdr->frame_control))
+	if (skb_headlen(skb) < len_rthdr + 2 ||
+	    skb_headlen(skb) < len_rthdr + ieee80211_hdrlen(hdr->frame_control))
 		return 0; /* doesn't matter, frame will be dropped */
 
 	return ieee80211_select_queue_80211(sdata, skb, hdr);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c8217f6d146e..487cddd09388 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2091,7 +2091,7 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
 		(struct ieee80211_radiotap_header *)skb->data;
 
 	/* check for not even having the fixed radiotap header part */
-	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
+	if (unlikely(skb_headlen(skb) < sizeof(struct ieee80211_radiotap_header)))
 		return false; /* too short to be possibly valid */
 
 	/* is it a header version we can trust to find length from? */
@@ -2099,7 +2099,7 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
 		return false; /* only version 0 is supported */
 
 	/* does the skb contain enough to deliver on the alleged length? */
-	if (unlikely(skb->len < ieee80211_get_radiotap_len(skb->data)))
+	if (unlikely(skb_headlen(skb) < ieee80211_get_radiotap_len(skb->data)))
 		return false; /* skb too short for claimed rt header extent */
 
 	return true;
@@ -2388,13 +2388,13 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	skb_set_network_header(skb, len_rthdr);
 	skb_set_transport_header(skb, len_rthdr);
 
-	if (skb->len < len_rthdr + 2)
+	if (skb_headlen(skb) < len_rthdr + 2)
 		goto fail;
 
 	hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if (skb->len < len_rthdr + hdrlen)
+	if (skb_headlen(skb) < len_rthdr + hdrlen)
 		goto fail;
 
 	/*
@@ -2402,7 +2402,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * carrying a rfc1042 header
 	 */
 	if (ieee80211_is_data(hdr->frame_control) &&
-	    skb->len >= len_rthdr + hdrlen + sizeof(rfc1042_header) + 2) {
+	    skb_headlen(skb) >= len_rthdr + hdrlen + sizeof(rfc1042_header) + 2) {
 		u8 *payload = (u8 *)hdr + hdrlen;
 
 		if (ether_addr_equal(payload, rfc1042_header))

base-commit: 2445e83a434a1964e574f792bd4b8e921cb9d54d
-- 
2.53.0

