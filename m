Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC3C4F4058
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617120; cv=none; b=K3g4HNQl/BWogf9mD40JKTpislWuU/Kn2GUlBFO4m5lBIKiwnvP+ylsqpge5X6VmGhMzVlS8Prw6vo5uK0tdG7XO2Xu07mWmuf9ew3ojCbYSMhM2bEY3AMc+s3LEt/iAaHZrh5eyf0aeI/Fh5TpyOG2PdygaeX9WTXiG+vcxovk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617120; c=relaxed/simple;
	bh=oD9OYo4HtrAlEwSiz3GSzfjSQKbsbRxMQz561qygKfc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ipa8LdIrIARKM8SlHzZRnXnn6J4J5mifB6kPCa3OCCkFYpHDPUP+6HBT3V7rkwHobLeB6pSLKrhYhxppM4H6OhShJcEkTh68JsYQwOuR8zBVreIEKjkGgw9kextuHJZ7f9NuoP7NyYaRNkFTZgaWz2IoVBTYgEJRcuyKTVx5S6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=GuVcIYIk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="GuVcIYIk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=t68ErhD2e+flhhEBh/QipCJSSLgmlU2eSBZtWHPDkIc=; t=1790617119; x=1791826719; 
	b=GuVcIYIkW5lxMXJGuLtpk14oL/hl8zF7mUFAiz3Z0lspzRBhL+nTDrS59MGszloYS+gsl4WDmYM
	XNFmzcVu0OO+xnCWA4wwPcZGqQOjF9CtBE5WzEolw/HZLP1MFBnyYGqgBk+6M2tB0w/JxPnY3javk
	Fi5501qIoZZrxCEAAjWfMRPPDUYCOU6w85sSjT9g7LP0vSijJTMbZuN4jwLPKTeArmrdXnc/3q9To
	AqNyMUnzMhMfeuOEJn8p0NuBjTXbTrH/A3qb+0gXEhwG9dV3bWd8yuLr/EFjRMGvNtGWX3M7GBmkJ
	HUccW7obKEgtk/WXpGwYIeA+AK+Ao4WyKIPA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBFJE-0000000Dl7I-0bBJ;
	Mon, 28 Sep 2026 19:38:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 1/2] wifi: mac80211: fix TPE in channel switch wrapper parsing
Date: Mon, 28 Sep 2026 19:38:31 +0200
Message-ID: <20260928193832.a3deb0415eaf.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
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
but I accidentally used cfg80211_find_ext_elem for it, and it
should be a loop since multiple can be given. Fix both issues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: loop all subelements
---
 net/mac80211/parse.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 3b66ca7d7a5c..030da4679ca3 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -692,9 +692,8 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 						IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
 			}
 
-			subelem = cfg80211_find_ext_elem(WLAN_EID_TX_POWER_ENVELOPE,
-							 pos, elen);
-			if (subelem)
+			for_each_element_id(subelem, WLAN_EID_TX_POWER_ENVELOPE,
+					    pos, elen)
 				ieee80211_parse_tpe(&elems->csa_tpe,
 						    subelem->data + 1,
 						    subelem->datalen - 1);
-- 
2.55.0

