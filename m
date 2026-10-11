Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC71433046
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711200; cv=none; b=Cb9GjMVw5xEILrXnH4uM3OsmTNeR3G5Fjy3zvanmmeO7akv8cMMI2p+BUOzOlMmwjwj7bR3fJdErARFUnU1JXY02gTLQ7ZHTqANdKeQmuToeGR9xNFYEk1SFO2CKbPnFqb29x39Lz8cK5R9O1/KA2c9gt4DZS2uJrZFZGxNGp44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711200; c=relaxed/simple;
	bh=p80SxsBnubt+c1MudliTqcV+2CWOG9lSydQ/15Y0crQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCJnK5luYwgPEW8D/S8XEhDDiG8rjXO0JkEStY4bVH/+PsD7L6k1ZWg1eoWJFgLfxMbV6dPS+C104y5C9BdGX7mBEB3lJd3BAQ79VyQs7zWQvzknyvci6iFqHFTpRAUynGrgrjksizm2UpPk9cPm+2dBQUcOvudi2olS7VYGz4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=FE7PQS+R; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="FE7PQS+R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=4P4nC9eJ88JLoPYwZ3Y9DhpW0bRCpH9YEewZ5FOXSbM=;
	t=1791711199; x=1792920799; b=FE7PQS+R3q9tTikNF9h/CRcKFmk8g5aJXvdBbxHoWLrgoi4
	Jhv0dSG8zbvZzBD8k0CFYXu8axxQ25n5IWDsKY8cJlok2RVuirBQVGDqrPAQ33Yb/XYeGpWO2WJgU
	cujpTDHcYv/6+4zT6NbEm/j/7c1vRv+5e9MBaCye/DPe9AeHuPuQj9uoiC1UNys0qSbYaIBM6j1lW
	5TCR269VTOS77oBLUXjqSHWApCx5viAwA3FLHDR74uVIRP8nWdd/J8VBKi5PS/ogrpXrIsmvITywB
	enTHd968TjZBQ7Bbjd3kBxtbWW9g0d+i1KcKrsWnzeDIZKwiO3gLPvBZaP346g1w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpvg-0000000Dk5j-2GTn;
	Sun, 11 Oct 2026 11:33:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 07/10] wifi: mac80211_hwsim: get wiphy_name() after registration
Date: Sun, 11 Oct 2026 11:31:30 +0200
Message-ID: <20261011113308.13b74d285682.I738d8363368771b442c3d9c683fef2c7e6c39da1@changeid>
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

The wiphy name registration is (or at least looks, since hwsim
is the only user and doesn't have parallel ops) currently racy.
In preparation for fixing that, grab wiphy_name() after the
new radio is registered, since registration might change it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index ce06867ff01e..e80b816468d9 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -5751,9 +5751,6 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		goto failed;
 	}
 
-	/* ieee80211_alloc_hw_nm may have used a default name */
-	param->hwname = wiphy_name(hw->wiphy);
-
 	if (info)
 		net = genl_info_net(info);
 	else
@@ -6240,6 +6237,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hwsim_radios_generation++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
+	/* alloc/register can change the name, we want the right one */
+	param->hwname = wiphy_name(hw->wiphy);
+
 	hwsim_mcast_new_radio(idx, wiphy_net(data->hw->wiphy), info, param);
 
 	return idx;
-- 
2.56.0

