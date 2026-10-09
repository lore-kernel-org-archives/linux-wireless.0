Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF5D50E5AC
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569667; cv=none; b=UFY5yrcWTN9gnS0ecmsk6Q2LHWckJwjHmbXUIM3iQiTTK+GkVf8wlb8gKWZxKF/Jb406m3Yi9BhrEbudhzPZrPb82EPmVXSeWE4svoDQTenJnaR3SF39RdwTUI4+Mdgyc7USp3wLdmZ95x0FQ6HTpfFsMH2rmfWq3GSVTFHQUJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569667; c=relaxed/simple;
	bh=XN3Ao1TLQ4utfm3uIz200wT7eyen/E5vzpA45UEMiE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XugJCaxxAgWAhem8ufklevO9p3emuux22ktaX9RqjRASfH6D0i/gzYyaWhPmpglY3Wbo84pPhN7SgJKlFy7xDV03CyNOz1tJxfKURBpy2rKOWLxxzcThf6YIjhVdT8uUpbVH39fmjRgpObZBhaadplgvSq5OloX8OZ7FeLFGiLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=b+I0ITKh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="b+I0ITKh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=RPC0VmTL91GmsjWidHrPzKfoKHkhDUGb+vSTNc9fNPQ=;
	t=1791569665; x=1792779265; b=b+I0ITKhi6jR7rTMamVMGlicbz2GC4KZIUQyPFh3h8EfdVL
	Ksb0bYcIjdwGdN89owwDJmuDalmRtmQS21ScAWWc29n0j+Piz1QV2HosOJkAcXMn1+9EppjKGf/yP
	rXaNZ5USDucaCqks7wrKl5EKwDQ964HBOkxues5iJt4kpC0/kqSlOArEbil77beY8Lx1ATCpgFAbq
	xhpEUbzAvYhI3nwieIAbDtmhYgyE4U6lPSKTHyk5AnPLaKBALNnRfdUr5V5hy+KxBi5ibDl3ghBgI
	/CaSZtkSGY+Kcl/0DladivOgm05lngHOyOb36Ot8wqnqqJqNZU1L0NUAMEVxKgXw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6t-0000000AtGH-2VeW;
	Fri, 09 Oct 2026 20:14:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 05/17] wifi: mac80211_hwsim: support lockless beacon updates
Date: Fri,  9 Oct 2026 20:10:04 +0200
Message-ID: <20261009201417.b70fda659f6a.I811ea72fc189eb20bbc07b27cfaf9ffd420a70c9@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We just use ieee80211_beacon_get_template_ema_list() or
ieee80211_beacon_get() here to transmit the beacons, so
there's no need to implement update_beacon() and we can
just set NL80211_EXT_FEATURE_UPDATE_BEACON.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index ce06867ff01e..87f20d5ff0ee 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -6017,6 +6017,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			      NL80211_EXT_FEATURE_EXT_KEY_ID);
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_UPDATE_BEACON);
 
 	hw->wiphy->interface_modes = param->iftypes;
 
-- 
2.56.0

