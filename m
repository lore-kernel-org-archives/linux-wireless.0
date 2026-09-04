Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDC14E8E02
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534149; cv=none; b=pQJpvI6BM+QjfnYlIxg4k+YVmKA9coOpHMD+Kt6O4VCPPb/Dg/QQ0vU0HExKokkpBRwLUu9sS3qsIYSGKS7m985nKBDm5hYIbzEftRCMh1P7iw7nWqBZygQ6OeMvXw+XyssCo1RRe6373HTjKE7STQLGqh23rNob3XAvx+XjKpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534149; c=relaxed/simple;
	bh=f40i8SGlPup73B9cc3SDs5No7aN290wY7mEkPXI+s7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGYOqMUw1oCveRwCoMKD24df2SQLgfbY0WRje/wVcB9CcYYnGJOlou3Q8TuvLK4ohBbSRMzmG2T5ui4dsPMfbWfq51rF47CT9bDwBGWDmk5vbnjPKhMekt0r+QiIW7Ars8vh1/lGgFiLmzXuu+9OxxmgRu7W7y+xwzBm8LEl3v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Ebudl0Z8; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Ebudl0Z8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=vhOu3lPBvdSpNuiF2ahegFauB3p67QKSU+0t9gEumKE=;
	t=1788534147; x=1789743747; b=Ebudl0Z8KWRUwEQ/AB9hbVkbJgOwnRvBHohKcTxo7UsCChg
	Pft2P48CzTdy1+ovtTd6U/FNE006qgDVyy0b4rb+y71j0Pg8IDSYJVIIwDPqEppS4pbYnyK2tmu8U
	YPZj5ZnwGu2SDVN2ln1M2sie1MxLVBm78MPcroGJCCtx9sIT756FAUhG0mQ+niine8bxRKuqbpuPj
	8vNAlcSvf3mcRf1P64teHKKDLpatLA6bYl7X8o875ElDBjZgKOgmBvY2j4f//T/aVyolsiPw7jYMh
	NUnCKSh4Z9KUWxRKOW//RZog2nKbuf6hAbGUcmic/Zr5SwWYzV0P+bz5dJcxPWlg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VQu-00000001Sh8-2GHG;
	Fri, 04 Sep 2026 17:02:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless 1/4] wifi: cfg80211: restore netns_immutable on failures
Date: Fri,  4 Sep 2026 17:01:59 +0200
Message-ID: <20260904170220.7ea88157dcbc.Id868585a790be8b9ece9b39b0db464a5963faaf3@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150220.427345-6-johannes@sipsolutions.net>
References: <20260904150220.427345-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Switching a wiphy's netns has to clear netns_immutable before moving
interfaces, but then if any of the interfaces fails to move, it gets
netns_immutable cleared forever. Then userspace can move it by itself,
breaking the assumption that they all move together.

Fix the order here and always reset netns_immutable after attempting
the move.

Assisted-by: LLM
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 668380deec7d..043bb57b0556 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -167,9 +167,9 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			continue;
 		wdev->netdev->netns_immutable = false;
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
+		wdev->netdev->netns_immutable = true;
 		if (err)
 			break;
-		wdev->netdev->netns_immutable = true;
 	}
 
 	if (err) {
-- 
2.55.0

