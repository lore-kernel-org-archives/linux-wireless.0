Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC9B435504
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.180.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791553094; cv=pass; b=EfasH3U8xyalkvsPXKkK7WltlOxaz7Bnfj5/LengEsjsfHpnRB/XM7aXcMyUiQU+UjFg74WmSYb54CkD9IDqY6MProUMSuwBpzZ5qRIre/sk1beM7mjvEM1KiharTAIQoJ32Us1Ic677prqtx10I4DYUeXCU7IFJDqTV3F4WyRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791553094; c=relaxed/simple;
	bh=JjMiSFJpESjWNWam9zxDR1pow88FabOKyUQV1UV6Tag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I+Xm4lUFP7cEE2tJmvU3LyUKxIqQT1LSQDoBESOje0rXOkTaEzO1nhA6koD6WPgqaJHQPnddBBD6q4IKYHOR8XyRIxsv6YjcXyNoLuw6M8D0P/CFL6TlEIpzDyntAhIFp2rJg+L0RgK4i/6H4w5VX6ORm7fZ2BkQN73ul7j4ixM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com; spf=pass smtp.mailfrom=xv97.com; dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b=Yx1Tj8qw; arc=pass smtp.client-ip=165.173.180.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xv97.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b="Yx1Tj8qw"
ARC-Seal: i=1; a=rsa-sha256; t=1791553092; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Y0SU+zJKp9iEwrX2834t6Wt186dagkl1jVvQin60EtqYy9bhVae23cLMqbTim/rKVt8XK+YoTnLJOd+taWx8x3RKdfuK5V2B6y9j3T04a/t/koPWT9ePfZgkv9vckQThGlMjlY2RgPX5kDMjsQhefoZA0jRIoRCtkfzBnWN8XjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791553092; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=65TgzqrmBxZ0C/zjO5qmiBtO9N1XV2Y2XWD6TIVoimQ=; 
	b=Kbi2eNh9FCSwnrhlBs48x4qG5C3k895DjEb0eBGd1VnkzFtXO76kgHenqJg8GYsEi7B0A0JCwh81KX3yxpdYZcNB6OCII1QcLpGTM2YlwkL0I3/kS0CjIOJWeakSJ4Cmjr9UUKsEqgZ5h/pUPCfiFdtCLAIDWie2mBghJut/4jY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=xv97.com;
	spf=pass  smtp.mailfrom=m@xv97.com;
	dmarc=pass header.from=<m@xv97.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791553092;
	s=zmail; d=xv97.com; i=m@xv97.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=65TgzqrmBxZ0C/zjO5qmiBtO9N1XV2Y2XWD6TIVoimQ=;
	b=Yx1Tj8qwmydqC1Ek7J/h9qXUZy9Lo1U7kotI7IAIdaZjJ73tPzSfV1YzkzktDpg9
	EDHvjXIxM92Vbk3/nU5Ri0fPguGLL7y7py/5NhCeASe7tJn+Rqrlpt1YPs7+Bk2zBo+
	pdnL2KJY/xeP9Q19pjw3spIZeutvQ/NpWhW1gHI8=
Received: by smtp.zohomail.com with SMTPS id 1791553091390154.21083267898257;
	Fri, 9 Oct 2026 06:38:11 -0700 (PDT)
From: Chien Wong <m@xv97.com>
To: linux-wireless@vger.kernel.org
Cc: jouni@qca.qualcomm.com
Subject: [PATCH 1/2] wifi: mac80211: fix encryption tailroom
Date: Fri,  9 Oct 2026 21:38:04 +0800
Message-ID: <20261009133805.158418-1-m@xv97.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

BIP-CMAC-256 and BIP-GMAC append a 26-byte MMIE but mac80211
currently reserves only 18 bytes of encryption tailroom.

This may happen to work because the actual skb tailroom can exceed
the requested amount. For example, dev_alloc_skb() rounds the
allocation to kmalloc size buckets or alignment boundaries, and
the extra space may cover the 8-byte shortfall.

Reserve enough tailroom for the 26-byte MMIE.

Fixes: 56c52da2d554 ("mac80111: Add BIP-CMAC-256 cipher")
Signed-off-by: Chien Wong <m@xv97.com>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9374c2942489..d37ff335205c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -52,7 +52,7 @@ struct ieee80211_mesh_fast_tx;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MMIE */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.56.0

