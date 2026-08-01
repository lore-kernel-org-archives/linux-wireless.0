Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F1C408614
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571120; cv=none; b=nKkuTcqw2ayhYYqzLLLNwbeCJzqv2FOXWO6aJUIzemGrW6R7FPvCn4y8FvjrCZ2HbB+ISkB5FWyP+rceDz1NVygo47WUM+iw/6FW8Ee/XxoFxNNEGlQUjZO/55nhCtinueD0oDvAVQnCGyHeOeqX1JfNBiHyxyPtjNFHv8LnIGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571120; c=relaxed/simple;
	bh=gjzhz4WZENFbhNbv00howrcjg9Ydat0FTJv4HLWoeMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KM2pr2ncq4mXPGthlcMjbZqm73HZLApP+MVYAecnxCd4dH4gPTl7JHFTetQgEOedyikzSznJj/8ZpL/RaXHh/nSi2jIdKJzYntZurW1JpzYBaOywphrI+ncDCOvjj4M9NZZ305toQqZ6iE5wE/seY70VTMHnmO17hnXDqvsXG7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Mss3GDI1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Mss3GDI1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ckVEDcn/uxdkmRXhFjV9lkYz9thOZDHYkBVR9iPmGj0=;
	t=1785571119; x=1786780719; b=Mss3GDI1RQT7H66SVwVphEuxveVJK6BuOGCuW15EAkEgmIT
	37T/PbJsh29EbViNFSwPtlZI5GUy0gN3yEQSN+zHa0CU3YzPRixj22r0vp6HmnNhCI8PPwtrc4kCX
	EYttuWLuXfda2bs0dKTHvznSg90Q7VvXbLebxVbPVsTmm0xD2PIN5RZS84ULg1Uf1TszpQO7vknnq
	tLrEFckhGSyDzO9oS22Hg8DDeV3vvfiTwAhZ2e+zbcDK0iMUILvFDN1nspp6EiuYqR1AXLkj1m4c1
	J/lchrnmp+i/K0z5hCEIlxtPx/pGfNzCsh4L2fUpqyxjLzg/gweijk8tFwUN416w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c3-0000000ErOv-2NCZ;
	Sat, 01 Aug 2026 09:58:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 07/12] wifi: mac80211: remove lookup_key() dead code
Date: Sat,  1 Aug 2026 09:58:23 +0200
Message-ID: <20260801095822.ff05a3ced550.I32022329526347cbf8a13b69a2ece1c2ee1b0261@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This code path can never be exercised because pairwise
requires mac_addr set, so the code exited prior to it
being reached here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 31c3b7481204..c0a5d9a7b1d0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -798,9 +798,6 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 		return NULL;
 	}
 
-	if (pairwise && key_idx < NUM_DEFAULT_KEYS)
-		return wiphy_dereference(local->hw.wiphy, sdata->keys[key_idx]);
-
 	if (cigtk)
 		return wiphy_dereference(local->hw.wiphy,
 					 link->tx_cigtk[key_idx]);
-- 
2.55.0

