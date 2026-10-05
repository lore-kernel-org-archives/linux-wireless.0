Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8E636AB77
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233409; cv=none; b=RhtNKW7Ncu8S8BkaOQiIifiwgeRoIFHWpJ1B02PJN1KMS6O09rlb73RUWG7+i53tzl4yga6QcQEKPkz0yXnB3JXH2vNvNqVPEmTWcmDbBxYgpxt/Q1rfO8LECqwtx4Q9dXkPQMnVDsjVA8jwW5ido7w2atNsFyGSztlGDU9QJfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233409; c=relaxed/simple;
	bh=m0EU4fapGtfGJJakTgf1M8rQN8PqMZ/MmszOwCHo628=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZmZaAT9JCXV/ravndcrl4WnJA2mUOvWg25D+1sVcR93/yS07ZUPw4WC+GW/ejd6GRYxesNrN8GRoQTGpZWERFvos3lYGME8AOzCAigzMyM2DBmxEFR86MhIeMe5zHzZwj7Jcizp1k/1pgDwuKGKTZK3I/X5ccgK9w5QKDwIsOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xpcya1nH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xpcya1nH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=W50Lo4BA8f++2prq+bcgSYLHiYcB5djdkhsjeZcYZbg=;
	t=1791233404; x=1792443004; b=xpcya1nHGi0W6tKRosoeRZuurTP9SGpnJbmNkW1PFjojCXh
	1UPWdQR4OeuDTm/lxq7znSJJKyauBbzIS/XHNvmrqDKqiHHxUjVU6cE3PRB9PD5an1bRfPDpp5So9
	Mh1qMR5OAF2JFKlOyJ2T50I2jWcS+PBWIPTOQ/GwIu4XVKt+w8N6LqHcN/EX+RAMU3Yn3Ge/vrcGQ
	7pDc0KSe4LAweqILhrAZ7pm6Ibaof8JVmVIC5rM4XoTmmpeHhni2vfAEAu3m9XxUXrGC0gtitmayD
	rZa6QiAGF7Z7pk+gc4Uckg6E86fC6rlcl8TYJpMOBN3ghrtvaq1KMhusrKpQDG0Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdD-00000005cw8-1RkJ;
	Mon, 05 Oct 2026 22:49:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/10] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Mon,  5 Oct 2026 22:47:54 +0200
Message-ID: <20261005224950.3fdb8d0ff377.I851e79ac625c4926e211642ee7a7e458728b0ad3@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We never kill the wake_txqs_tasklet so it could be running
while the hardware is being freed. Kill it, late enough to
never be able to restart afterwards.

Assisted-by: LLM
Fixes: 21a5d4c3a45c ("mac80211: add stop/start logic for software TXQs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b889d2a7ef75..ad7dfc07ee63 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1738,6 +1738,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&local->restart_work);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.55.0

