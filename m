Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA34F68C3
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897504; cv=none; b=PadsnAMEoWlseo4ym6E73oK4xEsvte25R63zyBt2fxLe60MvRoQAl7KZylQ2kyLZAOlfT8O1awaVG4Yuh3u6vj8baMTx4b4kvsycTcoQ5qAy8VL+RlKhRb3yOYw56VFs9sDYWaHnBxztojxhJGhawc4ShtQSZEkz3+XhEdA5tTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897504; c=relaxed/simple;
	bh=XnBFqOVw3OaqNr1A8qlzknhim0rF8MBcexp+UiauecY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p12RS2aszbiUu3ZYhEQ80K+YvBjbwiLnEFPO+R9cTMEO31CQ53LCBuDuiFaATMJHtuhz9Je5NYxNFvk36Hay8kSJXuM8cDOdey/2UUYXjf+H1WMYH3qLGsNPQXtz8kpCVlQPEaxepm9boNS9BuOo3myrY816BGFrjra6Vv7xqU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=KEe0gZ//; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="KEe0gZ//"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=FY5dQLYHvrhLmWsvYNEfnzoq8W5jHKRJqPnoCTHLHVw=; t=1791897502; x=1793107102; 
	b=KEe0gZ//SW2eg6RpqnVYR8nr9GHTgGPeXcwFPG7hHaAkrVU2F7ENuPXRKgTl3JgRqqOYN5RP/2K
	4j9grgbtfCAEc+NMIt3tmnYUpamQzaskTVk+ofVmUNq73LNYNrWNtbtzWaa7tRk5IzipwI+Fdt1IQ
	22/+qnw2StIBzICh7Nenw/w6HZo/MjzZz1Eo5rcYnhQoxin4Si6iH7zmXbmyTTapIgMcAt7K761qN
	Mbcz2KL3z0vFcZceIWrQGsXvsNzTBkQ05eL29VKUwxQbf8tr+pkqEpkEP1Lwiry7/xkBRMIhlKx0l
	RtcLcsMrEzvtJa9f2mj03NQ1rqxKFEA0obdQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcOZ-0000000HQ9h-2tme;
	Tue, 13 Oct 2026 15:18:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: fix potential requested_regd leak
Date: Tue, 13 Oct 2026 15:18:17 +0200
Message-ID: <20261013151817.9c197c4779d4.I983cf65a625fbc99e13b0a2710167157c34b6cd9@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If a custom regdomain is registered by a driver by
calling regulatory_set_wiphy_regd() (the async one)
before the wiphy is registered, and then registration
fails or it's unregistered before the worker ran, we
leak the regdomain. Free it on wiphy free.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d2931b9d7e58..f4153c249599 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1461,6 +1461,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 	 * can just free it here.
 	 */
 	kfree(rcu_dereference_raw(rdev->wiphy.regd));
+	kfree(rdev->requested_regd);
 
 	kfree(rdev);
 }
-- 
2.56.0

