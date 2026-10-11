Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B8424D46
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711203; cv=none; b=Dcl2oYREYclyqf7hCGALEa+CpljJIuMoFtnqTAjDFKuq+KSdOJJOexllJTstYnhPXhivpH/7RlX72l0zLqB849z58BrcFr8yFz9zi5OmZ4zjvIqO9tBroGwyMVAkb/0FGtrtG8++nEfhYDBSd9GR+FAXd1k7C/J58RkJP6X02ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711203; c=relaxed/simple;
	bh=xRbxoe1DEDeKb3I2wK7Rgdpj1hajMwfEHIJ387c/PJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X30qGkno54xlwrfg8AHdcdaxPFGeg5HQ0pbwCH7TyjTz1WpqiXxDb2nh1x+YDPRIs4elwDy4saR51r/2uGamMBDUyXk2RM1bqXW/aswwycnQ8lWd9ENYsfA3Q6TkmGMMIHd6zmwkrMq7S2AQY4ObB/Z0xQCAYuagBsOzKZVw3kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=w+O7ufSn; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="w+O7ufSn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qeSgPGcw63lwFWBf4TdhSGru71csjqpSUvdagyPeFg0=;
	t=1791711202; x=1792920802; b=w+O7ufSn0DtkhJ9I90vMHYioXPTX6L6XBWNAyoR4iYhrufb
	wwqEJHE/4wN/QvVG2Q1odwYjGIXRRtXHYc/x8Yuxlxon/ahE1hYpiABO7U7+h7N7Ic/bDU40f0AK2
	fxhnrwuFvhEmHfV+KxK/+Kr2uRvS+hUOyWomGb6OBWWiw2u77pJv6seqmKhheMgRyH5LOQvwu+6SM
	wAv/xLlaAHj6cBPW4RyMpPp08At7EC4tdE/lTBTxrJvyViUHW1cF+35tvWVGdnKFwfFUpyF3aOqYj
	BxHScFVB+ivB2pAuYLhoCz39LW9V9nx14XESWjeP36Ixj0UiUbgXEnPMEMtn5/vQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpvj-0000000Dk5j-1Unr;
	Sun, 11 Oct 2026 11:33:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 10/10] wifi: mac80211: fix interface registration error path order
Date: Sun, 11 Oct 2026 11:31:33 +0200
Message-ID: <20261011113308.c2cb32bf3160.Ib46993671ae3030950360ea378a507cef2bd4117@changeid>
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

If we fail to register the inet/inet6 address notifiers,
wiphy_unregister() is called before removing interface,
but the default interface already exists at this point.
This could also lead to a deadlock as wiphy_unregister()
then waits for the interface to go away.

Change the order to remove the interfaces first.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 28480f983932..76e85754deff 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1683,12 +1683,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
-	wiphy_unregister(local->hw.wiphy);
- fail_wiphy_register:
- fail_band:
 	rtnl_lock();
 	ieee80211_remove_interfaces(local);
 	rtnl_unlock();
+	wiphy_unregister(local->hw.wiphy);
+ fail_wiphy_register:
+ fail_band:
 	rate_control_deinitialize(local);
  fail_rate:
 	ieee80211_txq_teardown_flows(local);
-- 
2.56.0

