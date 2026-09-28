Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2428B4E2
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790599446; cv=none; b=Y12npQSH4tOHAuvrjlio4ccmxkiLiOC84DoCY1Z9mVXhvGU1MfBxMbz2AEy3ikR2XMgRxCj0+PzT23zyTFe8f0wbQeP9BQWukZxay919x4ncm6+GY9ueY1v2b8OawjpIrFGDAT8t9DeaPzW3qWySyt4+qJLXKS92ehDACiYbe2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790599446; c=relaxed/simple;
	bh=7YJg3A7QqW7GAA5ajNDeuGBvfOARLPmHKRgYJmPVXLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iGWYRodyspg4UQQbsxcaXG2QZOdWQWK3SFhobUMAvsj63WfA2WRGsJ2/JVKS9yUXGnUzrHSYbt+a6/tGpzG7etM0dMSf+fX3WZosLE4+8uauJ9pKbqGpK/UxAyrInFHXKuWbnODPagSKoDLgA8DconzqcVGbT4uIXnYMNbi9L4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=frc0grqa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="frc0grqa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=iTw/aL1YcjUfWjoilbovyWqEtYNZ50pRDg7tt8Xevik=; t=1790599445; x=1791809045; 
	b=frc0grqazNe7NpzKlSmE8nYRUvjH0QpMuy+viJ6B132NGf7ry1c3MzM4GKBUDkvSxzu3MS4YfUm
	2sLvyGqc/isJp2aNeTD9Jafh1mgZZExhDBzH5kgopyY3aAmGqgvEWyDdDmFc9vcBNzl6JyQbmGB75
	TEWKGObaI2c4rohwJ1tqPlAz535eFFyzEp7glFp5XTnRvUavdGuaB/fogk1PoEaLXsJgxp1WdmKMN
	CrPkleLZIK6W+ogKhlTeoVWwXYRj2ThUR2RQaakNhf5JtGvCsarXk1Xfh1M3KNKUX9I8gBhGkTMmV
	b1/lyhcwOJz2inkei5fRtXK50x2/wjg30yaw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBAi9-0000000DYZt-0eaN;
	Mon, 28 Sep 2026 14:44:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: fix TPE in channel switch wrapper parsing
Date: Mon, 28 Sep 2026 14:43:58 +0200
Message-ID: <20260928144357.2e38718bb504.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

WLAN_EID_TX_POWER_ENVELOPE is a regular (non-extended) element,
but I accidentally used find_ext_elem() for it. Fix this.

Fixes: 4540568136fe ("wifi: mac80211: handle TPE element during CSA")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 3b66ca7d7a5c..4ff726eef453 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -692,8 +692,8 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 						IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
 			}
 
-			subelem = cfg80211_find_ext_elem(WLAN_EID_TX_POWER_ENVELOPE,
-							 pos, elen);
+			subelem = cfg80211_find_elem(WLAN_EID_TX_POWER_ENVELOPE,
+						     pos, elen);
 			if (subelem)
 				ieee80211_parse_tpe(&elems->csa_tpe,
 						    subelem->data + 1,
-- 
2.55.0

