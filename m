Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA56C3905E0
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 13:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.180.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791553098; cv=pass; b=o15lhCQqnbqQ2AVglWbcPjktrGal/QRyz6j63h5NgwKJQHe0k6vSU7EIfMoEeVpSy5MzbGfopSEE2T+IuZZkQfIdHUUyagCL/GJ4YwLMGXXZ+037IJ2CiN3uJGV7Hsdco3CQzDGRP1qBASYPI81kSek8Bo6CXHHwDIrWO/atQJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791553098; c=relaxed/simple;
	bh=sIINl/f62ev+47aT2tyTnjAlFqiSDSx+a/WtOjDzMFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQFSWXPm42LPUqUI4z3GygXWZeH1HOjJBlFUs9YkcqPO7IgBhvDS20TCnPUfJApOjghe2xPMzMaGylQ9C1Scx8hY2pm4LVeOzyn4RIcj56ZSl9sIIK5PiPp77m0U+niSKBHNxAA6eLSCcuwyNk3v2g4RLLGyeBcExsFAfrGauj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com; spf=pass smtp.mailfrom=xv97.com; dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b=Hnpb+Vw2; arc=pass smtp.client-ip=165.173.180.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xv97.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b="Hnpb+Vw2"
ARC-Seal: i=1; a=rsa-sha256; t=1791553096; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=a8stw10kOIET6lt2Q1It9cSlJbeU43hoAh2s25PEEpZC/yrOkL9ql9YzXArSOSTxLWAPDdamBBSu5mC97OBGkp/CjR/Kle2eM8b2CDirQV74Omu1cOIm7ZeaZHCQsVulqLng5ytCayW+WCPYXfYGZXWGe6LtQY5mO+iAFbuwY0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791553096; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lHgnOPfn5YEXnz/KkDMe8SEVJWNqfKzovwh/sLCpeiI=; 
	b=FpWMbi0Q1WyTV0pTsgOuaAqs1wWVGLR2Rh1wYn9MEPWKokw+P8/ETX0GFQ6+0EcRKgCgtARAhBt6ZlH/CdHC9mGByUg0Sswx+shEQdcYv2hi7L/L7ZDH4Ym/FB+rHVm7S5zoMJyq1yt3OxpDItQAbEKkF4Gnc9XIT9ZFxvB9ukM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=xv97.com;
	spf=pass  smtp.mailfrom=m@xv97.com;
	dmarc=pass header.from=<m@xv97.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791553096;
	s=zmail; d=xv97.com; i=m@xv97.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=lHgnOPfn5YEXnz/KkDMe8SEVJWNqfKzovwh/sLCpeiI=;
	b=Hnpb+Vw297ywGGeJvaQlYVlHu7FUys/hVQ2SXhBcKlqDj3SuQIUldLXcrzzxKbkM
	uPHWBXQcNQ61IpU+7G0lnxKE20m4OoNT7Y+Jmpgp0R5gE4tJiNP6XDPg7VOUzyzba2f
	7tot5gPfjyFYeuJhKx+p5Wv5AS7SG6jydT3YYKcE=
Received: by smtp.zohomail.com with SMTPS id 1791553094120507.81649703605683;
	Fri, 9 Oct 2026 06:38:14 -0700 (PDT)
From: Chien Wong <m@xv97.com>
To: linux-wireless@vger.kernel.org
Cc: jouni@qca.qualcomm.com
Subject: [PATCH 2/2] wifi: mac80211: reserve MMIE tailroom for protected beacons
Date: Fri,  9 Oct 2026 21:38:05 +0800
Message-ID: <20261009133805.158418-2-m@xv97.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009133805.158418-1-m@xv97.com>
References: <20261009133805.158418-1-m@xv97.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Beacon protection appends an MMIE to beacons, but the skb
allocation does not reserve tailroom for it. If the available
tailroom is too small, the crypto path drops the beacon.

Two factors often mask this: the 256-byte TIM reservation is
rarely fully used, and dev_alloc_skb() may round up the
allocation, leaving extra tailroom. Neither guarantees enough
room for the MMIE.

Reserve enough room for the largest MMIE.

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

