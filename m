Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B83048F84B
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140500; cv=none; b=LgThWPLKvejJiWyN4EQS4h57/KzSPaPR3YMxF4b0Am3VYVTWX+vWqB2OluCOg4YLHtEFMRC707SX9zyiP2KDkkpAY2sRGR7rOJyGLt13i09YQAGT6j7Q2xVRzRF135klaPI+i+FhwevuSyhVLYxWm45CqmLlrD42uRZjmnf+w4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140500; c=relaxed/simple;
	bh=onXdVHi0ENNq9EkqT3iqbFYoFAoHXJSsNpm1G0SMVig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tC8mXJSMkVIHGIvsAZ6IKqRIGAbEcxPPPc4cPqzJRRFuq/hSJfmZCSiM7daLprYu5cP1HeTwQ9XGpujBDnmxigHXDKz+GUtUHC1x1V5/g7GjRuJOsyMBSsZKQjuqpKkxB3fQkw+mTn7R24/V4I/5oMaf6P2EHbH7zjeChlt6d5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=dyMym2ba; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="dyMym2ba"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=j+B4fao7XJ7kMq7Lc+pjD7P2svqTNAK3kj2+N2ujEpY=;
	t=1791140495; x=1792350095; b=dyMym2ba9x7v3eyxOBlNWxAJygGQUDq1q3P2KjD7z/BWoVG
	cqRlstTzO1xSi8iq782KRPwPHwOz9rM5jdcU2K3msgVeQsFD/mYTlRsFtTVQ91e9jU6QV6kzo1TaM
	NNNGAMnOjW2TCTdbIIJYq20o6hYehxdEXDYFZYrFuRGd9M1wLD1A4U6HZvH0QA+02Fhas2b+bb0V7
	fPVEa/OtHAYcWTqyWc4nXSnkouGl/NVHB8yo7ySX70U80RQ1x1yEExf8m5yBQufkkjRD8224hXGxr
	CduAnCwxrOiAUF/b/ff7b/ttCtK94SAsunu87+cabWY3sQamrwYomwuKppE5ceRw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSk-00000004Jlo-3aJs;
	Sun, 04 Oct 2026 21:01:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 08/18] wifi: mac80211_hwsim: call cfg80211 event with wiphy mutex
Date: Sun,  4 Oct 2026 21:01:22 +0200
Message-ID: <20261004210122.9115c6c1cc20.I4a45533cc3a020c472f7d90f33e854d7a89b2d3a@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

These functions really require the wiphy mutex (though
they're not yet documented as such), call them with it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 762f99eb15e4..59c540d2677b 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1133,6 +1133,8 @@ static ssize_t hwsim_background_cac_write(struct file *file,
 	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
+	guard(wiphy)(data->hw->wiphy);
+
 	/* Check if background radar channel is configured */
 	if (!data->radar_background_chandef.chan)
 		return -ENOENT;
-- 
2.55.0

