Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66901B4F1F
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 09:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780478302; cv=none; b=Ps4Fm2+euf2iixAOdPdmHPT2M/inPrENDTcP/DrEmXIu23wi8MdzfZhXL353/r+zE9HY/ddjHqGa/S6jlczzB2BQNz8CADzCbrETsIEwSlOH1ALTEevor80z5z1aPYG81qRZ8Swwqa185vSlVuL+XBWF3tD0p1mpT0jsUcHRVy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780478302; c=relaxed/simple;
	bh=v+duPCsuZ0z3VcgHEhMreshgOODwaneT4cWvA1PQUgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F+gSdxC/mAtTAoSaf/f/fAwhGh0oD704eMm6BQ5iKuntXYixwenBVbu9OyVqcKqKwHibZEgusCVoK0P0fsJSy1RdvkLCRth3IXW7CuWfuZj0FXFHBFZB/R2tJmLnXRu+NA4Qf+vfoLmOZUKM9t6xeP7QUAKQhu+aBxDb+0L2Cc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=huVLm6vC; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="huVLm6vC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=+0ajxlammkhYH1LjGjfLvLWcAK5AAZ+xbjPuUUi7BL0=; t=1780478300; x=1781687900; 
	b=huVLm6vCfJYdlCA909wiI2776DriBurvDPI3pRiQJEK53Oq4LqCZ0TQ8bWUxPmSXmjXvgPfYEda
	GQD1u2CofSh79MxCMNS5nKiUpPaFddgf4GwfuKFLkJy7gei8F4eL9g+AXHIPWbKYHGf30waI5VKef
	ARnUUvnWYXuTX90uWXELeSMcivXIDGs+AqLF9U0JWYba7Sh4JVpW4DbZ6nqTttUYfya68hQOkCmMJ
	CemPMjm6ow75d3JOFjqe0jdom+MVYdXV70FdcYqc5MWtDiFaaRzWIE/jmQDJEWJo63TJKm5FeJVKO
	YlheCtBCwpKyplB/cTTvmux7lXjd2SLeskkw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wUhjt-0000000H12K-2vNv;
	Wed, 03 Jun 2026 11:18:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH] wifi: cfg80211: enforce HE/EHT cap/oper consistency
Date: Wed,  3 Jun 2026 11:18:11 +0200
Message-ID: <20260603091812.101894-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Xiang Mei reports that mac80211 could crash if eht_cap is set
but eht_oper isn't. Rather than fixing that for the individual
user(s), enforce that both HE/EHT have consistent elements.

Reported-by: Xiang Mei <xmei5@asu.edu>
Fixes: 22c64f37e1d4 ("wifi: mac80211: Update MCS15 support in link_conf")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dac2e8643c49..76c537a6e8b5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6714,6 +6714,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 			return -EINVAL;
 	}
 
+	if (!!params->he_cap != !!params->he_oper)
+		return -EINVAL;
+
+	if (!!params->eht_cap != !!params->eht_oper)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.53.0

