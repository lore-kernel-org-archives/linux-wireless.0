Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F93AEB5C
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648311; cv=none; b=P1Iu4cJHkSrsHzgPAyDRn5efGC1q8X1U/4ubNSRXAHmY/P98ZJXTn/nxwHarGQ8XfSyVtWKh2dDx3Tfr+S3iEyr3yEiGORqfqhYzhyVgWlpLf/HKsa5jSlynXHmxIHTP62nCZmHi5k+1lNHkKxLU4U5Pdv8S1y2c6dzoAVz9kJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648311; c=relaxed/simple;
	bh=xRbxoe1DEDeKb3I2wK7Rgdpj1hajMwfEHIJ387c/PJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaYTeXbhRJnJQHKdqAq+fWtrH3XNb9SpE7icYhePOgbGBx/QIe6Bfx+EeQgMlhZvA5niY5AikWQ5WZNie38OFcBuAHxf2no+yQiDYEGKTmrNC+QNTos1EoPlpxBpyPoVBXIa4D8OS545khaAAZp27kb0VkD3/rSyWqKkKfGZklM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=J1+eTMDf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="J1+eTMDf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qeSgPGcw63lwFWBf4TdhSGru71csjqpSUvdagyPeFg0=;
	t=1791648310; x=1792857910; b=J1+eTMDfMLPNkn+YBdD0Yvd3Ln+RHOS7y38/3IdMnVcR8y6
	OBUvTkyZJ/BZKVIArTjPrQTDQ+yp/g73WiBpFqK+dlBujoVsVPEXQqUjZkRx+Mv/8SBFP8f9Zc5cg
	vWiJ3jPYxQknTHVQzX6tRnpQwdOTbH1zNa+I1nIhOmgEAYM8W0XaZSZXNCdSZZbW61xJMGCZ/mMNp
	yIHWHfkbzaCgjVxjhYjGlX9KfsGaEE0JgAzEmCDLeLy56JXRJ4/mLtlB4H1jb5s2LLdjjbYh1lDo+
	8BRpEtiCw7170yJPc+MgaWGhSGon3mVlN+Oaa9NvEJRFE9HjR0scfpsYQo8UbKrQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFZZL-0000000CP1z-1GhR;
	Sat, 10 Oct 2026 18:05:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH RESEND wireless-next 9/9] wifi: mac80211: fix interface registration error path order
Date: Sat, 10 Oct 2026 18:04:21 +0200
Message-ID: <20261010180459.08860cf2b02b.Ib46993671ae3030950360ea378a507cef2bd4117@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261010160459.229064-11-johannes@sipsolutions.net>
References: <20261010160459.229064-11-johannes@sipsolutions.net>
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

