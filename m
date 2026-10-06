Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD123D891C
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281236; cv=none; b=DM5Za2vsKNeisKyfRgTpi2QvhztB1ryK4/VlEwxF4t/PKq9BKgBkQ4l8WFILnnqhl5uP5hWXOeslUdgaMutBKqaqkgVq/tWNbeL4/Jy9OOA+8FLAZccFnR1W0TIamHXA1pBYG93hpDOVuIwtWMKiFUdzF2NssUYXUMDbfRTPZEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281236; c=relaxed/simple;
	bh=Brqi3d+sbklxDoWB9ZIQDOtmsaBgnA3dgLtruhJuETs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcJvzzZ9t+Y1ylNCrLm7LNOEoGhJR4gcvFoexCpP+7OGN5mEVbFs4sVBXz7HGjYRoW3A6cG5iy+BML31glYv48II4rRxTt6hITOObqWFHRmC6UWfKPzbbCOZntw+nqlPhePEeLlS3/ahEAe9WfFL8e6dTK0lvvxef2IrmXlf7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lMHVH5Be; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lMHVH5Be"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=C+D7dnrVlBYW0zMlMpohbhwPzfPuOeDoZhbyTVl+ipE=;
	t=1791281234; x=1792490834; b=lMHVH5BeNMNJr3ZgJ+l9+j1s2Kh7gqQN8abeQZ22A78B/5m
	Un7NYnyk+JGI9yVmkj0anrRFuHFevjDdnmrMOyO7iQZjy3vNVk/JFuL6HYOn9JfTDMOlNsGCLRgOC
	qnD80HHtAfnBRw9aATMUForo1e+6eErlsSQ5Bfm4fy2jItWGaOJ31ms5nTcfuD3bx34OLzurlgfwI
	VF6Vr+i14eUTOF2HkP7hBhUsS/5u4a2YFfgN/glEMBTStrp73fQZB0ljZxNxmiUNMWBr3U2pfNzEt
	mszHdVCkvpof3SnBkSISLrjBc9kC/WLWPrwsf9a6kMHYq1D4GHzhfBzsoRPvbQVg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24m-00000006XqW-0Egc;
	Tue, 06 Oct 2026 12:07:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 13/19] wifi: ath: use freq_reg_info() under RCU
Date: Tue,  6 Oct 2026 12:04:11 +0200
Message-ID: <20261006120655.b619ce4ac9a8.I44fbb6c36186a6b14a68d6f8f1010c30c69441bd@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
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
 drivers/net/wireless/ath/regd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index f15e7bd690b5..cedb5e43b9e4 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -268,6 +268,8 @@ static void ath_force_clear_no_ir_chan(struct wiphy *wiphy,
 {
 	const struct ieee80211_reg_rule *reg_rule;
 
+	guard(rcu)();
+
 	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
 	if (IS_ERR(reg_rule))
 		return;
-- 
2.55.0

