Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CCD367B8F
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557839; cv=none; b=JRFTPBXBRDLHNYhQ7/nuHkom628s+35JYk5MwjwaXw4eVnT+9fJaZCoVJe80ea4um11BYPwTgAaSEiSqGzNMMemuV780AZsQ/sP7QeTG7gUZOaCbvUU0OBy3VQs4Hd6vYh7X5tMB80fPjPqBt4E56hHwTMwiZcmiuptUFCaBfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557839; c=relaxed/simple;
	bh=S1JNzYKho0MkMYf4g58KgcyJWy5ifrCOy+Gz5m9J8Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEtEweyR3gRt3Dp4Wf1Vzwj5kQfv2IeJXfHjWr4mFqaO+Ks2l0mTJ7N8bIeaD9J6QzC/3ceOzqjmWB+2g9b5yAd1vlw40Kf3aAwT+KII+e8d13DC/VRn1X1awuPqVDYudyLgy4L51Cm6Pv+xcwP4pewP8nt2Yg8mNBqFtYUUAN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=p1WLgd+W; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="p1WLgd+W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=phM5zf/E/SH3DZzeGWufkdGzNsIxz/2RHK9wwEhFkGk=;
	t=1791557838; x=1792767438; b=p1WLgd+Wj08vxleyapJ8Nq63+3D9VrnTS5sw1Pt9PoZ55XL
	U3K8hBicltfxTgbu5Bqe63Sl0MLSrlfE7KPoFs2ozdmqkg31QSEcR2mhn9pQENoMiHjmIOGNtlm/U
	tXY4+BCrkoXnF0/HXUlaCQKKhDgvo2AxtWgqDPUvJ7AGodsKqOrHQTVI3rP56MGn3ZTnrcjHOB0X1
	MGlzzHKpbvVcjzwJqsfmOATQgM8tN1G1sfFq+DOgsAxhMbr0UVj1U5ACkGeVNq7RkySO27/hVEwoP
	D2mxnMfegOgdnNhl3n0IOW7kQgZbXzv02M9pD3MdtKQzmgga3PqIFpaSHW+4MxQQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFC22-0000000AlEW-04DI;
	Fri, 09 Oct 2026 16:57:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 3/9] wifi: nl80211: don't hold RTNL for SET_SAR_SPECS
Date: Fri,  9 Oct 2026 16:56:18 +0200
Message-ID: <20261009165703.b1ecae86e60e.I638c842c1639a8aa5d8207f784110b4a583aa7db@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009145703.243031-11-johannes@sipsolutions.net>
References: <20261009145703.243031-11-johannes@sipsolutions.net>
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

