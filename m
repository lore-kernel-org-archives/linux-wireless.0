Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212CB37106D
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533788; cv=none; b=oQjFDQ7t6kquEeDOUkTa32g1UlvvPATeVrdvLMd03RPprLh4eX6rC3k4VRxE7rVVhT1Oovgj7GEEz+ctKYHNH/rB/syEqFJnLHU07qVlLzu9FJ3gjr8UmiLgIik9hbUK2Ve5Y4r0q5TYp7x2bi6IaPpcDT1Afmk3wCFlA+x8pNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533788; c=relaxed/simple;
	bh=RF1ZEubO7HgC/GjoePHyipweyMjBHdQHidL+zgdU7aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPvdqbdPjHrqo4/ZZBskEj2a/iRk/DWb/j+NrGjBc87e1S5eJQqKcwTldzNPhRIdJwGQ/Sv/knOI2tcnYl5jJTttunaK3q4UoU3cSZRA8SDaufGG7IDJeF0W3YjoGjqunSnpK28m21ViF/PxHd7ynZLdzNBJdrBsFRpEKT8wNzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UCRYy3Jp; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UCRYy3Jp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cHGnCKsOdA2BC0TX8ARJYibszxeMCCoZfKEu/LhHyVM=;
	t=1788533786; x=1789743386; b=UCRYy3JpAPXCFVaeiwlhnvDVyRd5fQDiJJg/51uOi3svnU3
	XELYoBtnZpmaxA8HhChl/KV2ueu1PNugJz8HPOyKrvuujM8t2HsGyXt208TzMo9X2to4O+nxIHaxW
	Lplvz8i+VXrsdBPZ5yj4cd+b7LMFoef6B0zoruH5qkSO9QRrqMz3MWgsdK1UvUKRa3q6f392Jr2Sk
	BwwV99QyFL1V15KFTplHxhGAKgthMr5gmZPnoMoihKxTs6Wvn/YImz81Z/cAc0DRWB0cqrn3aqj8d
	LOLxq8RUYRuyURG1LOt1HmHdYY1v8pEkdqsei6/6vCu3CgKUTC3UDVelNZwZVRWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VL5-00000001SUL-13jE;
	Fri, 04 Sep 2026 16:56:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+878ddc3962f792e9af59@syzkaller.appspotmail.com
Subject: [PATCH wireless 2/8] wifi: cfg80211: check IP header size in cfg80211_classify8021d()
Date: Fri,  4 Sep 2026 16:55:02 +0200
Message-ID: <20260904165614.5e61a4c80b92.I37d68d3f406cb3b90b32e6943418d66070b65197@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145614.423902-10-johannes@sipsolutions.net>
References: <20260904145614.423902-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

A frame that looks like IP can be transmitted, but be too short, so
the DS field is read incorrectly:

  BUG: KMSAN: uninit-value in cfg80211_classify8021d+0x99d/0x12b0 net/wireless/util.c:1027
   cfg80211_classify8021d+0x99d/0x12b0 net/wireless/util.c:1027
   ieee80211_select_queue+0x37a/0x9e0 net/mac80211/wme.c:180
   __ieee80211_subif_start_xmit+0x60f/0x1d90 net/mac80211/tx.c:4304
   ieee80211_subif_start_xmit+0xa8/0x6d0 net/mac80211/tx.c:4538
   ...
   packet_sendmsg+0x9173/0xa2a0 net/packet/af_packet.c:3108

Use skb_header_pointer() like the MPLS case.

Assisted-by: LLM
Fixes: e31a16d6f64e ("wireless: move some utility functions from mac80211 to cfg80211")
Reported-by: syzbot+878ddc3962f792e9af59@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=878ddc3962f792e9af59
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 408ebb10924f..5429cf3cfd2f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1039,12 +1039,30 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 	}
 
 	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		dscp = ipv4_get_dsfield(ip_hdr(skb)) & 0xfc;
+	case htons(ETH_P_IP): {
+		const struct iphdr *iph;
+		struct iphdr _iph;
+
+		iph = skb_header_pointer(skb, sizeof(struct ethhdr),
+					 sizeof(*iph), &_iph);
+		if (!iph)
+			return 0;
+
+		dscp = ipv4_get_dsfield(iph) & 0xfc;
 		break;
-	case htons(ETH_P_IPV6):
-		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) & 0xfc;
+	}
+	case htons(ETH_P_IPV6): {
+		const struct ipv6hdr *ip6h;
+		struct ipv6hdr _ip6h;
+
+		ip6h = skb_header_pointer(skb, sizeof(struct ethhdr),
+					  sizeof(*ip6h), &_ip6h);
+		if (!ip6h)
+			return 0;
+
+		dscp = ipv6_get_dsfield(ip6h) & 0xfc;
 		break;
+	}
 	case htons(ETH_P_MPLS_UC):
 	case htons(ETH_P_MPLS_MC): {
 		struct mpls_label mpls_tmp, *mpls;
-- 
2.55.0

