Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F754B514D
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791471436; cv=none; b=JS1qYXPU+AVlv79I91fjM7qIZLdFAkyhoUjLsvg0/hWx+qZOKOmeJrVPgdWJl7O7qVqdGE5tqgGtE0OG0Fv4yNpJ8rEYYLDrYomx/JW2fsx+oASqyqIlOLoyZk/LcKV/aTuwJdu067+q9tgwzC0JYLoGD3VLDns0Hl1dwdMzArg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791471436; c=relaxed/simple;
	bh=dytcDzqzwq4eQid6Zl1f5CtYK65543HIMjrU2qe/kbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UVckS772EBD+j1dPlwi8H7uK4yURu+bdMlNoJYeFopDliVADsAzYUmF+GGAOW+3IEzC3ADy9w8RXOEQrBwERLGY+N1fXswbFYHzMo156STlIH6TGgWNOm9JL5DDgvW79IcBO12Tatxfbh+F/isDSq7v1ufvgSHQdukZUh1n2WNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=WM8eInsA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="WM8eInsA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=LNxBtM6muh8FaBPtt9VNHX4+e54qhPQ6hZQ9jp5Sxzk=; t=1791471419; x=1792681019; 
	b=WM8eInsAfRX9GQF7vX41m8UyBXOrIuhPkWCZGRqwKpXymcYlGq+QUNg44pzdQ/ar+RV6lpghzl0
	h5my/LnBk/ScGm4rRJqJyUBjrnUTPrlaZFnqN7A9bp76UxzJoVZVtvE/mj5Nt5C4fpGoaeAJNLfWY
	qmXGWo7l+G0oLV8hq83OSUreZZx+2fCxGJhV1zrYd4fx269e6DUQ22c2U0LhYvhLbulv0bAWG3vpm
	QQCVYQ03rv5BVC9odormXFyN3PAcYO1NAXd9FPSaPBmmtZwCohyFp04O50YehRmACt2/PXoZfpEsV
	FUJwWFwRBAIfwc/7Bxidjgeuyiw9e7UX8+TQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEpYA-00000009RBt-1JBS;
	Thu, 08 Oct 2026 16:56:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH ath-next] wifi: ath6kl: don't take RTNL in del_virtual_intf
Date: Thu,  8 Oct 2026 16:56:45 +0200
Message-ID: <20261008165646.48866f0521af.I1c166be830384473f67677eeb187afa7e54106ea@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

cfg80211 already holds the RTNL here, so this will
just deadlock. Remove the extra RTNL acquisition.

Oddly enough this was all true even back when the
locking here was added, so this is just a revert
of a broken ~13 year old commit.

Fixes: bc52aab380c7 ("ath6kl: Protect ath6kl_cfg80211_vif_cleanup using rtnl_locks")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Since I was auditing RTNL usage anyway ...
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a9a35476fecd..65b7c68a9297 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1560,9 +1560,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 
-	rtnl_lock();
 	ath6kl_cfg80211_vif_cleanup(vif);
-	rtnl_unlock();
 
 	return 0;
 }
-- 
2.56.0

