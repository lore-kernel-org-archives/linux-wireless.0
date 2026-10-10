Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97CE364E98
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791642953; cv=none; b=RKMoy47F99vk5AY6gapwtCDWxNTbLt3qoZ915MvvkVcehWlsiJBTIAbLLTUszixJs/whBL9aJnHyRq9+GHR5ZfRAtkwdsTExLEfK1eCHIkt1+v3SlTPbx39FIwqbD213zor/Rsk6sparGRBoRLKAmIk/T8/MR+Yh8jn1lrfdD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791642953; c=relaxed/simple;
	bh=3zvndzYcS0SH3LsVr0tdb7RPaxOwPpjUpTnfYs8kkCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uIasKQF+4AgMFqGA0ORALvzJvbryqn/YhxyoDCZWpR9fs4KrGusBVk+T9Vk0YTb4HaeHLNbe5lOTfSsoIV9IIxvJCxEJhZkYIfFxBIXEEUfC9DbzQwhphGZvYuRjBYqVU3VZ8z4PkIqAUVBDCA9bensMIJjKObZj2Tli5CEzxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nJRoOatA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nJRoOatA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=RtzA4y4BeiZPss+47ZsK6K+1+0FNQOnNNtlAu4PsMa0=; t=1791642950; x=1792852550; 
	b=nJRoOatAJ0QY68BZuDLG3iNlCbs8GMGhj/Ypu5JimlZNbSLIf3kefz9ipMrQLvGsjxuI4QFaAoY
	nMYbvQ9dllJTD0LA16LVUGDRfXESTII/uRzdTEsazrA0bWMtS6ooGiF+FHujhGY7sW6IufNfo8zJR
	MjHSEtSGKHZe2cwnKDJt11BdPhd3vzyFNSuT5MKMjQmzdJDwYZgcjkTAvKkTmvZHO27phjMkKOlLW
	h+IzdMMzK7ZQ+laGl2HDaF7t1eUXYzHSlKcTZR1z3K3TST3NoCqS3QyUUbpdx8CMezYw0pckVmOUi
	DlMzcJDQ+Xl+MMxSCDpPa5JSGf0ejMbbd/ZQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFYAt-0000000CI5a-0ud8;
	Sat, 10 Oct 2026 16:35:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: nl80211: fix BSS reference leak
Date: Sat, 10 Oct 2026 16:35:43 +0200
Message-ID: <20261010143543.184032-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In case nl80211_process_links() returns an error during
a multi-link reconfiguration request, BSS entries might
leak (if it already has one but fails on a further link).
Fix it by jumping to the out label that handles this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a48bd4e4f4c7..98db2461b541 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19559,7 +19559,7 @@ static int nl80211_assoc_ml_reconf(struct sk_buff *skb, struct genl_info *info)
 					    IEEE80211_MLD_MAX_NUM_LINKS,
 					    NULL, 0, info);
 		if (err)
-			return err;
+			goto out;
 
 		for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS;
 		     link_id++) {
-- 
2.56.0

