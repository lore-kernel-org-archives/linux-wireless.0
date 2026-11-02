Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651925;
	b=Q0ErDHdwFTOmY0p1r9p8LvywERBJOaDaaA6vED5KuRCJ7nDENDJZBQe9NIP2SIQ5GSYW
	 k+5R+kFCo2AsA1pthBzwDV3eYsc38h+ju7zzwdXlbsEEwyILFu0qH0LbUiJ0QNQe/ffCn
	 9ZBwEa3mW4FlRZpIxhxI8SAa6bUoIZWrIMcNCk/Qx1kUlueqf8rAMyJzMwYlTt0XSmxYH
	 WVnjI705xd1khf62furDa9PpNcmvAvz4aWjOaEUtnjJMLgjV5eS6RMgKk/gGI+I4bytVC
	 dUUYFoLSbiU9j/9U8y2VF5bXo1rrkSNZU5up58kaN4CJGAu1hFqZA/rdVJgWzYuvm2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651925;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=owTS4NyyeE7H5w1DOzvALK5faizMpQKpM1IlLs457+U=;
	b=merlVpKVAGtamKGH8ehaq5XuCwnjKe4M07R1vELWXHb8c+zf1JQbFGiGgnn4MAwNsrYf
	 Qcy/wYRej1knZA07grUzkS58nxp3XUy6pXtLvRPaUncrO0fuatnOwYIBjR2gQ3jSEwksX
	 JycbyaEEC4PLBUqILLawTocFUso5JzyH7WmGzuqEhwAeMO+0R/XHrNGlbVhPrC2PQ+AyR
	 9ofSzUeHVS63Q9+0Htdx2YjVViDf8GBQETbX1YaSc1Bhhmznf7uwvIBne63mXOGyBItE6
	 POorECxu23yvuELI3JXNhZsh329Er04pF8lU6+OWBAyFSkEJvQBZXx+4YjYNqin+mGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Xwm4Vqz7;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C914C606EE88
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Xwm4Vqz7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=owTS4NyyeE7H5w1DOzvALK5faizMpQKpM1IlLs457+U=;
	t=1793651924; x=1794861524; b=Xwm4Vqz7k2DImQVTFh6TH71Nu7gmZqec1+2wv8VqDFYI3Um
	SvIWI8XIIc47eJ4ZkKhMJcAJw1lVEswbAVWuji79yIFLekyP3P/nNVo0FK6zWErDk0/8bnkKgjMrX
	HObt1eNdkMmp7VEvZAN7iTxRxXFdNFJVimsnsmbnatGOgjuIZmFqYw2/x9rxnUflVM22ptczm+5Et
	6ljmMt1pOxwt7PCx42yhMphcgZjf0El2FHMAEgJFHey4QVuNXHohhwg7r+FPWMjyW3woMVlBvC0FT
	1Qe4rg5QWfxJAnPdZC2wahqSCmBFfJCyZHw3uF9I7bpfzQr62a1wtEKM9mjQqFaA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynh-00000001vzr-1xdD;
	Mon, 02 Nov 2026 21:38:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/30] wifi: mac80211: use vlan-aware station lookup for pending TX
Date: Mon,  2 Nov 2026 21:22:58 +0100
Message-ID: <20261102203831.1058362-40-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Frames on the pending queue that have been processed already
still need a station pointer, and we're looking that up with
sta_info_get(). That's fine now, but ieee80211_tx_dequeue()
switches AP_VLAN to AP interfaces, and for powersave I want
to release frames from TXQs via pending, so the lookup must
be vlan-aware.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3eff5e934f7e..25ab54a89235 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5011,7 +5011,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		__skb_queue_tail(&skbs, skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
-		sta = sta_info_get(sdata, hdr->addr1);
+		sta = sta_info_get_bss(sdata, hdr->addr1);
 
 		result = __ieee80211_tx(local, &skbs, sta, true);
 	}
-- 
2.56.0

