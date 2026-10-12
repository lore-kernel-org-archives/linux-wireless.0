Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC4347255A
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.180.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814081; cv=pass; b=EfUkVhN/IjXoWV3lhI2JjVYEqk/bnH63xV33PGfS0XwTSec2vWWjTb3TB8Z+lfVjm8FcmgYjqoOkAxA0wHwwUXiEz7T8A4yTxTJFBnUv0ab5Ox6pNucKIQrzaXlLixbiOFCct9hQVqge5H5paxBraN4CKAxlD4eAtgx3rCOv+HI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814081; c=relaxed/simple;
	bh=V9aob3U/Coc0M7Vxd4u6RpOuNdITyWFIdWoczvoTSdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBt5HbWkuQxLj2x0VeJ6TMkUTuAknwuVyjDgpqnZSJs37DJGgLCQPzcZWIKx9YYeqdyW+87wb62mLQIkpcO2SS6PXan0A/eMMLfMz6fOST6yREoMhHVTcZDP+TtCClNpyW7CTmIGymWNUru3icKSK7rGM5l6OINxJ8NEfJnpkNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com; spf=pass smtp.mailfrom=xv97.com; dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b=FIdsSC8i; arc=pass smtp.client-ip=165.173.180.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xv97.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b="FIdsSC8i"
ARC-Seal: i=1; a=rsa-sha256; t=1791814072; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Pwze/Eru3hVywXA7TPeV4hEoA7LTkuUvteyM4fUsFubQ+0uzDnd+94WEd3eE62q2CGINZFFCF7XT8L9Pys0BcJOkcgilaCDJZtLgCV/kEw/S7dByGVvmRdbCrZh1h2hCIv6u2bVpHyBJL4thkB3gYTygqVOrcPIxrW6QqHIJtdQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791814072; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EJHU2VRWLZFA02W4l36WmWMvxqLob7rglc6uWW3Tg18=; 
	b=LGPDNpIaCRLKUJrBE6ptW5z/j3YSkD7j+8sEIKHEnXXGu6ya+w1JZk8MpFcbPJG0/qe1w3l96qatqXenogArO/6czHHNxvAR8WROFMTug3A/iSOqm61eVD4sjQsVU9s+rroROrU65UyX4w0GJaS5hMViYWjFRoltGc0uKe3Noqk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=xv97.com;
	spf=pass  smtp.mailfrom=m@xv97.com;
	dmarc=pass header.from=<m@xv97.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791814072;
	s=zmail; d=xv97.com; i=m@xv97.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EJHU2VRWLZFA02W4l36WmWMvxqLob7rglc6uWW3Tg18=;
	b=FIdsSC8iqKKn91y+mKGFX+3TuLPAP/0LM+1Bl+/OSpW4Dc1wRacf3vF7cO8iZRI+
	5tAQqcANap+NQlMtt8Qnpgm3lhLDcPbr1Dz6FtE+sUWtoVF74Et2w3QqSyPS8fEBXPP
	cSbEs7JpLzEnfxBA35iqoyyH5lzPkd0TooQIPSak=
Received: by smtp.zohomail.com with SMTPS id 1791814071019678.566311610669;
	Mon, 12 Oct 2026 07:07:51 -0700 (PDT)
From: Chien Wong <m@xv97.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	jouni.malinen@oss.qualcomm.com
Subject: [PATCH v2 2/2] wifi: mac80211: reserve MME tailroom for protected beacons
Date: Mon, 12 Oct 2026 22:07:37 +0800
Message-ID: <20261012140738.70178-3-m@xv97.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012140738.70178-1-m@xv97.com>
References: <20261012140738.70178-1-m@xv97.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Beacon protection appends an MME to beacons, but the skb
allocation does not reserve tailroom for it. If the available
tailroom is too small, the crypto path drops the beacon.

Two factors often mask this: the 256-byte TIM reservation is
rarely fully used, and dev_alloc_skb() may round up the
allocation, leaving extra tailroom. Neither guarantees enough
room for the MME.

Reserve enough room for the largest MME.

Fixes: 0a3a84360b37 ("mac80211: Beacon protection using the new BIGTK (AP)")
Signed-off-by: Chien Wong <m@xv97.com>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d51f810dd2c5..6aad90a55722 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5673,7 +5673,8 @@ __ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 
 	skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
 			    beacon->tail_len + 256 +
-			    local->hw.extra_beacon_tailroom + mbssid_len);
+			    local->hw.extra_beacon_tailroom + mbssid_len +
+			    IEEE80211_ENCRYPT_TAILROOM);
 	if (!skb)
 		return NULL;
 
-- 
2.56.0

