Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A1E476CC6
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194755; cv=none; b=JK8ME/VGN4mqe7Y/AEcUtksVH+9PHz5yjGNBfPzSQHZIwJyXjW7Vung0y5OCIZY3UvbxPla1dq3iNu1WsTnbZaXp+CktdJyVVDPUkK9cYLfv/QMQPkO19cdoV6rT72kD2qugud/SkGYobCMbXnAucpn9WF68HZFm/+ejR2SuhWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194755; c=relaxed/simple;
	bh=SYsIbVpj8zMak4oQ0BLVAJUXZ5qTkCXGwnYmN1oShlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMGEj7cNRAZcz00qAXvUDgfItlnC0tHOtFjVGdPoFFNVjsjgiUGH9zddwpv0QO3r29AAAmZVZKHPe/u4SG83k0HffKE+1QtMfT+xJx6mm5wxR4m/IU6ix7G9xhl5EufD7EZR7PGB0WlurVE+3BdI8iP0FBGtjAOjIfONsAULvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BsmYybt7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BsmYybt7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WSUbxP1NCRS8WP+r+2gIAQ7iEaPjCtuTSpAiSGKwSrc=;
	t=1791194753; x=1792404353; b=BsmYybt71wjPABUbQ6uFAH+dr4iXTkynXrjAuNeraTQkH66
	oc1agYP9NT5toTpCDrT7DGqkdw+/Jh6zt2AX1uTM0+JbJHcftxOuqC/RtAd0O+YTxvhP/4BoQIyI3
	Yzft0V+xMvl7pvT+pDrzoDV7xaJ+pRchFgCf0mzjlZYnsscX2SY1Bne2Zj/ANgBTi1fMQGOBHpRti
	geBp35PSa3XIbi1PbdU5uXzEa23d08/oybECpcqXnE0UWKTq5PFWCkYbpDOeA+Sn4mDAckBjgzhc3
	ZSsaPotCBAI7t+G/cTDXxUBuNMuKfN0mV1QaoIHXiXJD1ywq6M9YkvQQZ0Q9ItKw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZv-00000005Bml-1Gso;
	Mon, 05 Oct 2026 12:05:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 13/18] wifi: brcmsmac: use freq_reg_info() under RCU
Date: Mon,  5 Oct 2026 12:03:40 +0200
Message-ID: <20261005120526.fd701472eb8b.If1ffc9864b3557ec046c705286e974218a32d9cc@changeid>
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

This will soon be required, because there won't be the
RTNL to protect everything. Use RCU for freq_reg_info().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
index cdfe8635c012..5ca8a0735398 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
@@ -676,6 +676,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+				guard(rcu)();
+
 				rule = freq_reg_info(wiphy,
 						     MHZ_TO_KHZ(ch->center_freq));
 				if (IS_ERR(rule))
-- 
2.55.0

