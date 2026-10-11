Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5B23368BF
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711198; cv=none; b=oWK96PiIrnhXW1D6Bw7cIqZBum0jO5vG3GBv/V54Z9FkjBTnHKlujVtTUJ9UjhNwtbxVFSznLg0e124ijkiUzS/tzmmSplS5Xc2EdU0ze2PzBtAA93RuEqfEpKoWD2am87IprE9mLKhX+PDBISgQjV1trFEGjHbVCk7vSw/atrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711198; c=relaxed/simple;
	bh=S1JNzYKho0MkMYf4g58KgcyJWy5ifrCOy+Gz5m9J8Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pv5AaXVcKC6JXKp7g2XVO7B6NZtoYg+0JU54qNkPGf+v4D/7QuKba6gVHimIMLWsgvLGUdj01EITh91m6XePmLERean24Foalq2T1wOACz7FLTU+AHbKpuo7jsGcQdNQYBOQLyBuIlGAxnGbHJD8Hmu1uEyLxU/ipRdLn6xpHUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Wp5sJ4yj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Wp5sJ4yj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=phM5zf/E/SH3DZzeGWufkdGzNsIxz/2RHK9wwEhFkGk=;
	t=1791711197; x=1792920797; b=Wp5sJ4yjkFUIrudM/CqAll9l88XfRCJT56QOt9XTRi1y2sm
	kj+AfdvR/RaCWvwl5UBiBQKOVaZ//sInxbBGEomepz9o4JM9NXpoDukF1glu9zaCwMzamC/UWF4mJ
	JFqHYwRh5znG6aUCL3UI2noEOSLxFjyn3sz++Uj5dnppkrgTc7TZz6FyjkPm4VjiGjMyRrm2McaKw
	iSI00VQb604ZD4wEnUxyWiZcfZnTQyFcDbQ3i7qgQB0cqKFosZevyAOp8NZ1N0V1tFAFumG0xHj5f
	OkDn2ektJ+onwPC5rHjzEGFkkEJeUPZkmxoaFA42QSS8NYvbNWJEU4JhvrjPcgxQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpve-0000000Dk5j-1QSu;
	Sun, 11 Oct 2026 11:33:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 03/10] wifi: nl80211: don't hold RTNL for SET_SAR_SPECS
Date: Sun, 11 Oct 2026 11:31:26 +0200
Message-ID: <20261011113308.5a374e7bc350.I638c842c1639a8aa5d8207f784110b4a583aa7db@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011093308.49945-12-johannes@sipsolutions.net>
References: <20261011093308.49945-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

There's no need for the RTNL for setting SAR specs, it
seems to have just been added while I was removing the
RTNL from most places. Just drop it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5b9d8830af5..46b72f3b5ea4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20826,8 +20826,7 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_sar_specs,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WIPHY |
-					 NL80211_FLAG_NEED_RTNL),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WIPHY),
 	},
 	{
 		.cmd = NL80211_CMD_COLOR_CHANGE_REQUEST,
-- 
2.56.0

