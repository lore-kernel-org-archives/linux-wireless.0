Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97796377ECC;
	Thu, 16 Jul 2026 16:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784218681; cv=none; b=Ssf6P0f+oDPniYO5T2JD+2Dk/3Au+Zl1ZQVj11QVrrzW4VzXoFcsO3rNvgA84KbRSBPHWuPfV2eMbUOsAWJJeUERKydGAJaCxzYD30vEOkEM8at9vQzoBqRY/y7P0eYjxG1ea18GYpuDIip3tmwuqZsCkdrmBsjtBr1p3dVF/Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784218681; c=relaxed/simple;
	bh=Bmt1XDAeHwXlze66dtuR3uC2CyVfh2yWF1/JS1oG3YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWPSDqU9tEzDJCEqPSr1bhuxWh4EjGKedJMzcwoKRY4zwU+9CnbEFjVcg+jixDlxmj29MmZpfcMJ4IWIewuoZIt33A7O683rSOKvs0ZTZEvuyQQzQuFwPKMOu/V93WQMbpazBfrvw8B9eWp4VE0dwD0GBUST+TlrNNVubnXmJg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de; spf=pass smtp.mailfrom=hs-ansbach.de; dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b=rdeBuI9Q; arc=none smtp.client-ip=129.187.255.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hs-ansbach.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hs-ansbach.de header.i=@hs-ansbach.de header.b="rdeBuI9Q"
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4h1J9T61fYzySq;
	Thu, 16 Jul 2026 18:17:49 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=hs-ansbach.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hs-ansbach.de;
	 h=content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=an-postout22; t=1784218669; bh=yV31D5fgTQS
	4Yg9HBJcYW6O3aWTOaoV8Qx4k5z2ZhPY=; b=rdeBuI9QiK+e/oXLTZe6GwcZ4sy
	+KvWTJ0K960HAjnEBTMGUxnCmmjDrLTxl0R7W5B+SJPzReqL/oD86R/Hjy8ZL0xu
	65RRXrPZarfRutCKxBAoOpryTnGSvv7I5AzChCjWVjVNheJNt3JcDvID9bcX8iYY
	7u+C1LId8xby6oxQZLOt+04Kxzan03yW/3qkIu/gltXgOuoWn2W3DgrVBucOHgKN
	TCTiIbXfhufjOgU5KM6B5/ALNLsKwH59yvOVosP850waUqpe+r61B1TFE/Bg6Fan
	4SoRk7KyKxs1aMi5MypGVk4jxqX78QE/cPm+IMHvVo7+HzveP4dzb8oqNVQ==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.887
X-Spam-Level:
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id 681gNY2BqJ23; Thu, 16 Jul 2026 18:17:49 +0200 (CEST)
Received: from chimchar.fritz.box (p200300eeb7001900d36d09bcf7cd0c19.dip0.t-ipconnect.de [IPv6:2003:ee:b700:1900:d36d:9bc:f7cd:c19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4h1J9S6zJ5zySc;
	Thu, 16 Jul 2026 18:17:48 +0200 (CEST)
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
Subject: [RFC PATCH net-next v0 5/6] net: add ppc64 support for GeoNetworking
Date: Thu, 16 Jul 2026 18:16:05 +0200
Message-ID: <20260716161605.3587079-1-dietz23838@hs-ansbach.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716161213.3567275-1-dietz23838@hs-ansbach.de>
References: <20260716161213.3567275-1-dietz23838@hs-ansbach.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Dietz <simon.dietz@plantwatch.de>

make GeoNetworking (cross-)compile under ppc64 (big endian)

Signed-off-by: Simon Dietz <simon.dietz@plantwatch.de>
---
 include/linux/gn.h  |  8 ++++----
 net/gn/gn_prot.c    | 11 +++++------
 net/gn/gn_routing.c |  4 ++--
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/linux/gn.h b/include/linux/gn.h
index 862f635d5d11..94239897ad40 100644
--- a/include/linux/gn.h
+++ b/include/linux/gn.h
@@ -188,10 +188,10 @@ struct gn_spv {
  *The packet is dropped when rhl reaches 0
  */
 struct gn_basic_header {
-#ifdef __LITTLE_ENDIAN_BITFIELD
+#if defined(__LITTLE_ENDIAN_BITFIELD)
 	__u8 nh : 4;
 	__u8 version : 4;
-#elif __BIG_ENDIAN_BITFIELD
+#elif defined(__BIG_ENDIAN_BITFIELD)
 	__u8 version : 4;
 	__u8 nh : 4;
 #else
@@ -203,12 +203,12 @@ struct gn_basic_header {
 } __packed;
 
 struct gn_common_header {
-#ifdef __LITTLE_ENDIAN_BITFIELD
+#if defined(__LITTLE_ENDIAN_BITFIELD)
 	__u8 reserved : 4;
 	__u8 nh : 4;
 	__u8 hst : 4;
 	__u8 ht : 4;
-#elif __BIG_ENDIAN_BITFIELD
+#elif defined(__BIG_ENDIAN_BITFIELD)
 	__u8 nh : 4;
 	__u8 reserved : 4;
 	__u8 ht : 4;
diff --git a/net/gn/gn_prot.c b/net/gn/gn_prot.c
index 90ecbd67b64d..1599dc0aa185 100644
--- a/net/gn/gn_prot.c
+++ b/net/gn/gn_prot.c
@@ -495,7 +495,7 @@ void gn_fill_sopv(struct gn_iface *gnif, struct gn_lpv *sopv, gn_address_t addr)
 
 static void gn_fill_bh_ch(struct gn_iface *gnif, struct gn_header *gh,
 			  u8 packet_type, u8 packet_subtype, u8 rhl,
-			  u8 next_header, u16 payload_size)
+			  u8 next_header, __be16 payload_size)
 {
 	const u8 mhl = DEFAULT_HOP_LIMIT;
 	/* rhl should never be greater than mhl */
@@ -1851,11 +1851,10 @@ static int gn_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		rc = put_user(amount, (int __user *)argp);
 		break;
 	}
-	case SIOCGSTAMP:
-		//rc = sock_get_timestamp(sk, argp);
-		break;
-	case SIOCGSTAMPNS:
-		//rc = sock_get_timestampns(sk, argp);
+	case SIOCGSTAMP_OLD:
+	case SIOCGSTAMP_NEW:
+	case SIOCGSTAMPNS_OLD:
+	case SIOCGSTAMPNS_NEW:
 		break;
 	case SIOCGIFBRDADDR:
 	case SIOCDIFADDR:
diff --git a/net/gn/gn_routing.c b/net/gn/gn_routing.c
index 733ebd0d715a..3672a345530f 100644
--- a/net/gn/gn_routing.c
+++ b/net/gn/gn_routing.c
@@ -293,8 +293,8 @@ static void debug_loc_te(void)
 	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
 		pr_debug("LOC_TE(%p) tst=%x addr=%llx ll_addr=%llx is_neighbour=%x ls_pending=%x\n",
 			 entry, entry->tst_addr, be64_to_cpu(entry->addr),
-			 be64_to_cpu(entry->ll_address), entry->is_neighbour,
-			 entry->ls_pending);
+			 ether_addr_to_u64(entry->ll_address),
+			 entry->is_neighbour, entry->ls_pending);
 	}
 	spin_unlock_bh(&gn_loc_t_lock);
 }
-- 
2.55.0

