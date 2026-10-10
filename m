Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B113F8246
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648312; cv=none; b=NIGu6/FwklivcEaxo0s+gqYVjzf/TyDjS0Y1zcL2neuvByDRwATA/9wd3Ot8vMUMkRdFYbXt9WikcEQQtQ4xVfWQf3sMNQAczA5bw3uEM3LhNjiCmZuFhG6EFpcnXkTEpwCZejTmwNSkwx3XUjaNBiUxCWa5h+qIR8nOysQMNMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648312; c=relaxed/simple;
	bh=S1JNzYKho0MkMYf4g58KgcyJWy5ifrCOy+Gz5m9J8Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9/p0TiAe3vVCZDcIdhu+CJy3nTovRVkOLlqoFTVFnCDZ1mYYqycbYEHCJPwMn69QU6EzjLn/OjKl4B9KBfIGo/L6XDau5esNbqycPK1yENRVTDGuZzWPcss+Cf4SqNmoPkQAzvnVu5NxfOaSS0x7xh5dVOE1/SjgXrH0egu0I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=eDsjdVAu; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="eDsjdVAu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=phM5zf/E/SH3DZzeGWufkdGzNsIxz/2RHK9wwEhFkGk=;
	t=1791648311; x=1792857911; b=eDsjdVAupBPMIId3q4BUB4LOXKJIZA5/gvkIjDgYLhq6VCf
	t/S0OIjOybuk1K8jVFE2zmWDkn/cUSJ361mZixkDHHuuDE1ZnBi/M35oYHWijps1VO5bmk4CvbgBY
	YxsZ2adwOeXMk3urS1vunK6P6XmTwE+GWddOxG7HCthCO+RatfStYL6yRHbdKxgS0auaMP3r+BLcf
	S+JXX7+GQAiv6SbCI4LvXCJdP7fS5sZG3blQtyHnzefVmRL87rWGLCkNr6O8K1JTzo+Nn62HNeVRd
	wqOBHWeJ0Kgq77zjUa79T0oM1SPdMD/D7zLFfDec6jvvLmUaGAi9ByrYmkDEoDGg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFZZH-0000000CP1z-12Dg;
	Sat, 10 Oct 2026 18:05:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH RESEND wireless-next 3/9] wifi: nl80211: don't hold RTNL for SET_SAR_SPECS
Date: Sat, 10 Oct 2026 18:04:15 +0200
Message-ID: <20261010180459.5a374e7bc350.I638c842c1639a8aa5d8207f784110b4a583aa7db@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261010160459.229064-11-johannes@sipsolutions.net>
References: <20261010160459.229064-11-johannes@sipsolutions.net>
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

