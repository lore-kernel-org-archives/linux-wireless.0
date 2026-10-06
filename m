Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44CD3B27E7
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281236; cv=none; b=aU4Cfhi0q4tYIZ5LTvHxtiNxX2/umH6oU+JyOT/gup6yOtnCEggm+JbJkD2iK/4t1n39Z56vAmXnT86rwASVFtRgnQPb4tbqlkMyGFOaboSV+pZXOGXVEl+77zZliZkVuK0h/jipz0ryGPx+yUFm6B1UcnbNJXbQTdYZ7LVKmY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281236; c=relaxed/simple;
	bh=SYsIbVpj8zMak4oQ0BLVAJUXZ5qTkCXGwnYmN1oShlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEljc08ye7xRwz7cDvq4Tu5ZCNAUhUNAPc+3xhTdVoEuPoGd7eAXVN+n29bSKxa448bwJqbT5zX1ZoYHIY59fvsTQvdKAL6YWwYUeMIrPTaBMQeIwTTOJu7hvWsuvSkHxMAZ5jd2e0M4+a5c8sMW57zfHVk8fMz5iCaDDNFBGAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Qm8t4NJm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Qm8t4NJm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WSUbxP1NCRS8WP+r+2gIAQ7iEaPjCtuTSpAiSGKwSrc=;
	t=1791281235; x=1792490835; b=Qm8t4NJm+FbmYZkjspoAJnELzYVwdWecHZ/udWlKlvh2UAb
	msWJ8fVLsvI8RuyDmjQa97Mz1wzaDmKT2AYkEtHLSSYdSKUaDcO/3BG1Nulne2nVL4c/uZo9txhAj
	TVxqqx9mXH8cIC4ShON4byoxEqbHXvojy9Ct2IuexvhG8xM+/Fs/k2X680CTM8wtIs2W/Z+jhbz4v
	juG3c/qplgkJ/RL9uHVP6nFjdhGg+VyyKn2EHKmJaX5e4dobyflMpuOY+EcgVjXmc74zmi4BttGEo
	XvIJeFlfofzLgeMb/lwTF7inVsHe7sT66zEfXkJS/FQwAA2yn/az2rDAemkYEKTA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24m-00000006XqW-2ZBc;
	Tue, 06 Oct 2026 12:07:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 14/19] wifi: brcmsmac: use freq_reg_info() under RCU
Date: Tue,  6 Oct 2026 12:04:12 +0200
Message-ID: <20261006120655.d7994c4ac0dc.If1ffc9864b3557ec046c705286e974218a32d9cc@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This will soon be required, because there won't be the
RTNL to protect everything. Use RCU for freq_reg_info().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
index cdfe8635c012..5ca8a0735398 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
@@ -676,6 +676,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+				guard(rcu)();
+
 				rule = freq_reg_info(wiphy,
 						     MHZ_TO_KHZ(ch->center_freq));
 				if (IS_ERR(rule))
-- 
2.55.0

