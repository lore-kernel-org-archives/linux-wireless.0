Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2F2279DAF
	for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2026 12:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776428176; cv=none; b=e+JQI+wbpGBH1egGbp4yO8VQ5HsYuFAzR+N57zKkJ46Y/aKN/TMD6SFJ0vZ/h9H9wP7U6oQFJ6WCDBX8qbvHJVZemccZXRg3b/wXs50msxj+R7aZsJIDzfnnTUg4C3up2+IZcKqV9to6YliGRx4lYdYVRywJ+IB8TKn9eXs09kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776428176; c=relaxed/simple;
	bh=rcJl1JQcEtu6wl0Xys6KmfnkHJEVJiGYN2rdhsbXOTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lt8nj2S3gZ3KRyyYZJH/WF2uYcBrzLkzI4faiS8Gcl0Ql0IPcQy04Yv99w37aGF4RPYM8cBu6K8Dq4q4hELFCWZ3EYdF7rP13hoWL6149B5OyMXuk+gQbyh1F8GdsY5X/pFwzjaWHkQJcgu9bjBbIuSj7w5sy5RnUVtVADH8poI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PKy2vmY4; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PKy2vmY4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=GJhbiTunaNvldj6lA9w33/8FEE+Vc3fQFf0iyOfMpE4=; t=1776428175; x=1777637775; 
	b=PKy2vmY4jheYER8vVKlkZM/KLDCecLcgzKe58tLTgf5h1gSdOcfC1P8h0ucmvSoCRC3mGpVcV0B
	exdmB0AHGleWY6lWDzEXMJ0zXtg8DmjJYrHXUWDDkIzbAcUUbtHP37Rd9+IzTN9N/MdYvlseLhCrW
	QBBvMfs9Im4o9R0jbVu1joNufPlV6KqNg671EmU6h185St5dCLAF+3d28qXJFs8P1hjjZxod/HirE
	1ssbcFpB9TaNdGNFZEtabKd7s7wZtgcFItG63fZgQQDKrS4zC1ZrciSP1yom0ppWQqrvh6aJAoyoO
	XeRioDpq4ASGRhIQYHBmbkSjFRnyR0Z9CoqA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wDi79-00000008Ttf-345c;
	Fri, 17 Apr 2026 14:16:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Jouni Malinen <j@w1.fi>
Subject: [PATCH wireless-next] wifi: mac80211: always allow transmitting null-data on TXQs
Date: Fri, 17 Apr 2026 14:16:01 +0200
Message-ID: <20260417141601.851ddf4adb59.I3d668c0e1bdca9cd98f2fc46f84a066e68cc7a62@changeid>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Jouni reported that certain sequences of tests caused some
WDS tests to fail after applying the upcoming hwsim changes
for NAN. I bisected that down to converting hwsim to TXQs,
and after a long debug session found that the 4-addr NDP was
getting dropped, because it goes out via a (management) TXQ
and is a data frame.

It's unclear to me now why this only happens in some test
sequences (e.g. "sigma_dut_sae_h2e_ap_loop ap_wds_sta" and
"sigma_dut_eap_ttls_all_akm_suites ap_wds_sta_open"), maybe
that affects timing and the frame is otherwise delayed in
some way.

Correct the check to only drop frames that actually carry
data, not NDPs.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 230826960721..933c86ca21c3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3916,7 +3916,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		 * injected frames or EAPOL frames from the local station.
 		 */
 		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-			     ieee80211_is_data(hdr->frame_control) &&
+			     ieee80211_is_data_present(hdr->frame_control) &&
 			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
-- 
2.53.0

