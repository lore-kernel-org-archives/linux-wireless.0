Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD89F4D8DAB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533792; cv=none; b=C0DBOWXgZ4Zv7jNtn3Ju+LuDLzOw8nD0LXFu6ATGJRLK2mOvKsX5c0OiFJo4ztfU+XfpLYZIs/GboV866cauixI+oQtdMDgq25LqmXq0WMVT7qLmUUypIQGJ/Y91Z4O1wPn2/PsEgnbXOTw0gJpog+eMvl15dlzsXqXmQqoyco8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533792; c=relaxed/simple;
	bh=bZaxFTXqoD9k8G9dChnNYXHZupNjAQdahtqJPZMmELs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl9wjc6j1pChavlYrlNMSpNBU3YHlOD4sjom1TL9Kv0WfHP5EGT9cDC15GejNv7PfDCN/rYUlSL7yDAs2vL+6tqjtcs0anJjX5ARBdNUps7L5HQ5oHH37EnENmh8pw11vFxfxkhEJOgH1w1XmbAWNf9IIrYzyirPyaTI+mdVIJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=wuDbV4W7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="wuDbV4W7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=dVvTlyOFfYE/meQFpApUSQl83lg54QDltuf5noAQVKQ=;
	t=1788533790; x=1789743390; b=wuDbV4W7uZX39hYE3KGX7QZROa/6M/G8854kHgAGWParzNb
	glYJhxLe4V6cbVq2Sb5sjmN9Iyvni7cyGnqec85ptfvLpxYac73LHciQwt9GVT8LAiI5wrI/uMWVc
	jVFZfpONd5JUS67hIW00K83crNyCp/tNYDsRvXdVh0XTHnPsZSJ1uuU3P2b5Gmle7Cy6P3yj/o9/K
	5vVqs3pL14wHx19I5lLlO4WWQIAs8bYzgPFECPAhTCgYOaM7fLvS4DPVVK6YsFHGURiG8CSYq1V1D
	x+WZlrtOToS54AbuNhnGJgeOryoKg2+WnDKqG43lo56LxtHUbOgODprqTIwqOefA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VLA-00000001SUL-12Tq;
	Fri, 04 Sep 2026 16:56:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless 7/8] wifi: cfg80211: fix NAN regulatory enforcement
Date: Fri,  4 Sep 2026 16:55:07 +0200
Message-ID: <20260904165614.6abc075b5401.Ib90696e3fa49b1698c27d64db5360d51f6f187a9@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145614.423902-10-johannes@sipsolutions.net>
References: <20260904145614.423902-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

reg_wdev_chan_valid() returns early for any wdev that has no netdev,
which is fine for P2P originally (and later PD still), but NAN has
no netdev and yet enforcement code was added and is needed, but is
dead code right now.

Use wdev_running() instead so that netdev-less wdevs aren't skipped.
P2P/PD don't do anything in the later switch, but NAN code can now
be reached.

Assisted-by: LLM
Fixes: 0e8ec738a71e ("wifi: cfg80211: add support for NAN data interface")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a8336baf85dc..9910b080b402 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2345,7 +2345,7 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	iftype = wdev->iftype;
 
 	/* make sure the interface is active */
-	if (!wdev->netdev || !netif_running(wdev->netdev))
+	if (!wdev_running(wdev))
 		return true;
 
 	/* NAN doesn't have links, handle it separately */
-- 
2.55.0

