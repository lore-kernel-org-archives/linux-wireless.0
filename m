Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74321501F4D
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896777; cv=none; b=o9hO3WpluCXu9+mmrSjjRW7bint7xVNmWu+lxIIc+2c0vINCyJaPGEUflxuU10hSAnak6Ttj/q0NmJxD41X4kiXL1cJxd2nRHypzR/ujYakQWt5FicEKh1CPlxIHCAq5GhkgF/Ds5nLBs9vFqVnDJTobWymB6TZ1mtHDvpdGLTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896777; c=relaxed/simple;
	bh=z9H6ab7A4O88Kxtb/w987K6R3mIUoWub4M22eNjpOP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9wS2pu+O6ocuQQ6fSgh6hFPFZX9QbDbWKLu/bhsHH+L5U3n6aLr8kcoNPt7ttUNcs0rHz4KPzTeotXzsiREXRvnA7Zgko/Ahhj0GATwaSwgNzJYMWiGmYypYFKQ/T3XimeS2u7WAJKmDPI/kvUGCYbR0uu5g9GJUp7MxOFZzJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vNXm15es; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vNXm15es"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=C2ZPk+iP0I9nGOUaVNy89kajeVW2O+fv17GvHdfNkrg=;
	t=1791896775; x=1793106375; b=vNXm15esiBK1j8fC7xUgxnApa6nx1Jy3BHRFQtl6hxgeNKX
	tHVPFwfIJUsSObPzG/3VUPO+Tb116yFfX2EbuIS9Ao/bUQU3OVSWg3P2Tcli6RVNclLZN/5kR64lw
	cJUjFvdGJ+RyQKHp1P64jVTXUYWyG0hZrq9LYg7tYK2awTBUsEI6d8NzCWIa42hGH6L0dBNDGem9s
	CEiITGjJefYrte311lG8hbHxWOsNbO/bJtymwd58Lvf9k9xW8OrfdQuLj1mu1mXNnMvGO/6JVIVwc
	a20yq051DoRB1laTEwocmO40JH6Xc8U4R6XJbFlOQ3s6rr5gLPaGeqI4EK1lehaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCr-0000000HPRi-27m3;
	Tue, 13 Oct 2026 15:06:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/11] wifi: mac80211: remove lookup_key() dead code
Date: Tue, 13 Oct 2026 14:59:09 +0200
Message-ID: <20261013150604.98ab96f2a15c.I32022329526347cbf8a13b69a2ece1c2ee1b0261@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
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
index b6d759f38c6c..a8d6ff1af717 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -803,9 +803,6 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 		return NULL;
 	}
 
-	if (pairwise && key_idx < NUM_DEFAULT_KEYS)
-		return wiphy_dereference(local->hw.wiphy, sdata->keys[key_idx]);
-
 	if (cigtk)
 		return wiphy_dereference(local->hw.wiphy,
 					 link->tx_cigtk[key_idx]);
-- 
2.56.0

