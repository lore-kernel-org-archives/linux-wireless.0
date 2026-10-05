Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE237F8C7
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194746; cv=none; b=qBpTqEqJcfFX8JMUkIarlUtcl6WCQh4TPMIMShbAw2ajLiAbAjtec6zbhoZAgkAwVDHMfFKsKnB/DFcEf6p4OC4j27peVHjsSX2oSTTLujE+/Lo2KdHFb0sV3oxqxxUTVrtwuT7S9m0K1+tK/WQ0IlRM/oh4xgILhxgsg5gx084=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194746; c=relaxed/simple;
	bh=onXdVHi0ENNq9EkqT3iqbFYoFAoHXJSsNpm1G0SMVig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcuUrmW34MkkLeCCfjQT6ryTm6xWN8QKYHcjOFZjXW+MhfGFIFh+mcY677RkRKSw3W8uyQnLxy66qtgW+CPOkZW1afZ0jaJ2GP78l6Qgqmr5CMev8hvNHomeyKWK6cyo0XEmzJZfkECiOzIvEKCWHmzhvJPDhD9WUvmIaKcblN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UfyfuzHc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UfyfuzHc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=j+B4fao7XJ7kMq7Lc+pjD7P2svqTNAK3kj2+N2ujEpY=;
	t=1791194744; x=1792404344; b=UfyfuzHcdmT2gN71wQawiEgQ/N3ymT4uZHnecMCk9QRjKbV
	2m/vQdui/hP7PH10dI52YWdl0i+5ikN5+lV+BXb3i9lqmxJY+sa2y/pYuRIrArk1EvovyTe6AhNwv
	5JL5qzPQ9SqL2E4lqwl+nmkxcnsK63gPpsizoRvmuAhOWaBsQo1G5cu4ovfSxoDFR6Dnpv/cVX/7+
	iqz1msFFALdQMM8SWu3p9lVjXPg35uZTP2iaMps/htIGvHQEYTVgFXmV7lQRdqjMEZlyGPhr0QA6N
	kV2Vc3C4fvl/erGOeP7YOAfIMRumD10HX0sqM7KzCPX0S5H0TIWkQ1AGsqUJ4BXg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZk-00000005Bml-0rmL;
	Mon, 05 Oct 2026 12:05:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 08/18] wifi: mac80211_hwsim: call cfg80211 event with wiphy mutex
Date: Mon,  5 Oct 2026 12:03:35 +0200
Message-ID: <20261005120526.101742a4bd66.I4a45533cc3a020c472f7d90f33e854d7a89b2d3a@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005100525.1991059-20-johannes@sipsolutions.net>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
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

