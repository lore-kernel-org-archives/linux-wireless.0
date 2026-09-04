Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507A2175A6B
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533854; cv=none; b=HAdgMfv1jjkaQhZR9mdvske5kothw/A9qfMic8zjykimuJ5awE7axfsbOuFTmceXuwCwzLleQ313yrtMz3JnNM+eTSac5mR+Zt3+nNfJQTE9nh8lyXo5Rg5+fr0Lp39SzZzkCxWVP86x+I3WzQ2QIBhJ7Zg9hHzp2WBz/0GY834=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533854; c=relaxed/simple;
	bh=bvr1cCTz/1yQuEROp2fh76GiLE4dV5Hb8EcMAfYU/j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6l5VPWwr5xRq/IjduSoVs8dpTKdT/ZoEsK/04zeUmZ6hchKNTIXT0D8zeJJi3UliTidsxNcCbEwLSGXI9aNaSKZA5fvPPycw+izWMJrM/4vGHyrGwVgtREV/EYMtXhCvQTTdj4ghUjPucc4bFmlorx+CIAeKno6kKZUIhL+Apk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qNTUAgEd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qNTUAgEd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=tX0VPO2bsBdAoWj9a2S8eMGRJEYzVVjoiYuiNYOsR5o=;
	t=1788533853; x=1789743453; b=qNTUAgEdLyi+eMh5sUKxkyVdbUOTpxADASDNN5UMLCDRiYz
	Dkmbduq05MBiHdhq78Jv3YFIGwf2dmfLsuQotV6lvd8q61mBcxpTO0KOZDfn0/PSY73igPisZx5u7
	i9trXYlUqHySVqVtvZs+K9NhePIBv688pJR4Wqd0dkaEzPdHSYCOzRP6m5PFAvC6GSHbcv2yXnx7P
	su0P5phpl0weGfQu2EEzx6Szy0Diw1QTYCarWTJYDuVdEf0feJvgTzDZlAwtL1nQYZ4UbhxiMpxUt
	jYaJ3aruMeEQS0pB+vDxwLo08bzElDPPjkZJ03hNfi80WNbyrMF/RgPo9HMBTs5Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VM9-00000001SWk-0m0R;
	Fri, 04 Sep 2026 16:57:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+1634c5399e29d8b66789@syzkaller.appspotmail.com
Subject: [PATCH wireless 04/10] wifi: mac80211: don't warn when an IBSS has no channel to scan
Date: Fri,  4 Sep 2026 16:57:08 +0200
Message-ID: <20260904165722.fe380c27fef4.I0e8bee2e12a40d240851a4bc724d47753af46159@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145722.424159-12-johannes@sipsolutions.net>
References: <20260904145722.424159-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_request_ibss_scan() warns when regulatory leaves no
allowed channel, but that can happen as the regdomain can change
while IBSS is operating, and it can continue to operate briefly
during the 60s grace period until it's shut down.

Just remove the warning in this case.

Assisted-by: LLM
Fixes: 34bcf7150241 ("mac80211: fix ibss scanning")
Reported-by: syzbot+1634c5399e29d8b66789@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1634c5399e29d8b66789
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index eeff230bd909..8e950ef6d1ea 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1242,7 +1242,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		if (WARN_ON_ONCE(n_ch == 0))
+		if (n_ch == 0)
 			return -EINVAL;
 
 		local->int_scan_req->n_channels = n_ch;
-- 
2.55.0

