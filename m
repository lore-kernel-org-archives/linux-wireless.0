Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC879476CC7
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194754; cv=none; b=a6M7C/K4cXgdD4fLUo146+KZBEurgQtG9J1oCvbC/uJPQcLh0RLwuWsweGSU5Jn8lGGURkYAbgulq3PzC9toLMvw5WcpQR19ZTHfRyfwmSuEM9vCYStCodvldE+nutAFkyrs8LRN8B/HTYxIbj+MraMTK6AnrJfhpA9Ar4h/7WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194754; c=relaxed/simple;
	bh=Brqi3d+sbklxDoWB9ZIQDOtmsaBgnA3dgLtruhJuETs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNCQ4/d6Oc3BUI9VpWyoPQjan6N/dck+xYHh/K79YEm2ci7GX7tya5xdG2WAwkjc3WbP9fIwuQ9lYxwm9isqCsixqBVD5qIO6y9tO9G+/fx6/zkA9y1ipSo6d2LkigB1hCbHJf7X5XZoKF7NWrFifBnStUn6RyVld8AdB62IZcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uokdpnUX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uokdpnUX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=C+D7dnrVlBYW0zMlMpohbhwPzfPuOeDoZhbyTVl+ipE=;
	t=1791194752; x=1792404352; b=uokdpnUX+08BIveeWTXVO5bByWrTYCkIv7N2AWsiq6gW1rN
	hP73K2eLnfL3IrMk0AeLcBKM37tTwBr1egkctfdBmCUzZ6G9y6otXZR46Ff1iuFum/nSnXSFw1NHI
	U+SFeS1ywEJE7DeVAv8A3GBfXNemA47ieqXGXRwIzm5gdn75EC6N4vTeGlrITVc1PckDhurDOfdti
	7AHV/ZLHl/2p4nMdG6Myi7cNiNkWmI+iJuwkciVKzuch8R1eN/ZONYzfVi1k5lpgQXRBttdw8Dlmw
	A82P/eS83gwdf7+lhc2k+q5rfmaCRGf9jbYMvrrvX8h8EvhMZZAYxULr5RASC+UA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZt-00000005Bml-278b;
	Mon, 05 Oct 2026 12:05:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 12/18] wifi: ath: use freq_reg_info() under RCU
Date: Mon,  5 Oct 2026 12:03:39 +0200
Message-ID: <20261005120526.562e44b6138a.I44fbb6c36186a6b14a68d6f8f1010c30c69441bd@changeid>
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

