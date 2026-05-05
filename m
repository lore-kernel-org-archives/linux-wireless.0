Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0DD38B12B
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 11:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777981125; cv=none; b=L+9wjoQvGJMDMV30Ny08Q3nBQaqmWmZ5pXjlqebe0YjIVJJymwJcx/QACwuu9aXUqatAOg7mNsex/bmwDB6JJl4/+SR4nddbx8ALTaeAms8kQM/6ehPXDC7Km6LcMRcXTwChQm7waS2O0bTS+dO9GEr731ftRkhtFpZjokqG4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777981125; c=relaxed/simple;
	bh=WSONmTWnXOatoqLSwJaaOwwg5goaewl8Un8DpBHjZuI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a5P4gP5ySVyUpjtANaTsNc2D9umF+U/KbzYx5TaBcKYFqDX5KZ4U+A4tptgPVJ4jVIDptOuFDyA72h1PIBVTwvQ/ne9zVV9xg0/OvmaD2Myk34QGTCQcTelHM90SEFixi9UUQ+CxDjMbHjs9xDZ7lKyiiF9g5V3kTeDIZ+QxgwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tDiit1ka; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tDiit1ka"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=AjOpKwY2LUPfK7eN1W20sGI0XspuMR94dLhg41nvJJg=; t=1777981123; x=1779190723; 
	b=tDiit1kax4r7WmkvVaNH/e0t8g539PTEomY6yy5D3utvq3XWJ14D+xfD0dRREDBkv4kFArZ4lVl
	Vn+AcCGGyvUVHHlZX3sK0XjPA5skpPzo8m2hm42gNq3n3Cyk7vntGEPiwRQ04IIX5nDynAi4c/seM
	5KQahgQASFYXWtozMa/3NauQT++pzDq3VAsSuvh1CgMQOGLKijmPqaVU/EwEtqgxHW+F3XN9FqiO2
	gw6R50FV9JDSPLY62LPa+XqPUrq7lEOwyvYV1+fnRBzt7/DU+DKtvyqx5V/bjHLv85wOv0aHQAEQu
	fsvi6afUygYGXwIzrGnT7ZZngUO7NjvN76eg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wKE6q-0000000G5vU-0bxO;
	Tue, 05 May 2026 13:38:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless] wifi: nl80211: fix NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST usage
Date: Tue,  5 May 2026 13:38:37 +0200
Message-ID: <20260505113837.260159-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is documented as a u8 and has a policy of NLA_U8, but uses
nla_get_u32() which means it's completely broken on big-endian.
Fix it to use nla_get_u8().

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/pmsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 951ba0b96da2..ca1229b93bb9 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -88,7 +88,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 	out->ftm.ftms_per_burst = 0;
 	if (tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST])
 		out->ftm.ftms_per_burst =
-			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST]);
+			nla_get_u8(tb[NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST]);
 
 	if (capa->ftm.max_ftms_per_burst &&
 	    out->ftm.ftms_per_burst > capa->ftm.max_ftms_per_burst) {
-- 
2.53.0

