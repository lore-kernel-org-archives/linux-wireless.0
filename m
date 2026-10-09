Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D722C81ACD
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557838; cv=none; b=pil/NiIs8BH3IjQ97tYw4e8N178CGbsBrxhA7V3v/wpdUycSI0sjxuKBzPnug3NpWE4yX9ah0tj3aR4KY5v2sH310JgOLwPq0tdj0wo5ZIUi6ngdgbVVZZYUn/lT3u6dIOfae9x7phw759Z//sxtaQxYRf34oVgs3dcuqwHN+Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557838; c=relaxed/simple;
	bh=xRbxoe1DEDeKb3I2wK7Rgdpj1hajMwfEHIJ387c/PJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTL8g26aBrMTm1VhNEeEyRYvXKorfrW2M/Uz2k9mPKOIWUmZGG3mWHOP1P/YdyX+iUn4cuzVYWXrgtpm6CVtD/jurL5O6wUN67o1ArqR3IEDc14xJzcrtB6xyLwEe4vkni/vj6vDvT3EavMOzKQ2QTJAYsD7Bs1hlWqFpfqQMDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=QvqAkEtj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="QvqAkEtj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qeSgPGcw63lwFWBf4TdhSGru71csjqpSUvdagyPeFg0=;
	t=1791557836; x=1792767436; b=QvqAkEtjUg9aa858R0n56j9abHD0xsSmOCHk7jiNR87wLiN
	8u2OCFMzB8FDxkTKLa31woVxfCbUPMCU0jpWhiNTzGz6ZNlDtOWI0NWmU4EAsvnB93T2I9endGpzF
	SQErH+vcQnWIoBKxjQsuVrAXRn1y2iFP8IcwYwrGRn6t9zTfYWxoB2DtapW8itQnpj4l/fB5rclQr
	MlAQB1ryBBuCooWghdaxG7KdgdLrSEexMuIgk3yRZZ+D6ULGoWhb+vnUpv7/RP3VbQhsjYKqSeetR
	2zqF1EzQ+AtlOSQBGaOspBLvTD7581QyZ8hFXG40lttI8Ya/ulmKEBsJlVCjx3oQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFC25-0000000AlEW-3XiQ;
	Fri, 09 Oct 2026 16:57:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 9/9] wifi: mac80211: fix interface registration error path order
Date: Fri,  9 Oct 2026 16:56:24 +0200
Message-ID: <20261009165703.62a57bb0461e.Ib46993671ae3030950360ea378a507cef2bd4117@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009145703.243031-11-johannes@sipsolutions.net>
References: <20261009145703.243031-11-johannes@sipsolutions.net>
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

