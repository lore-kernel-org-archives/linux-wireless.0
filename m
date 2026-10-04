Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF02348FF83
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140501; cv=none; b=WvKnzf3/cea2YbIOZAuLprbAe1DxJyndVOdivmfs9Q4RHMYtDcf+JW+68+GtlJwm00twoMdQgTa7TUBWGmRMUdFSk1u+Kew+HinbNow4QxNapnxLKf9sHs4qofdTVtYbZA5dw4QGlWuAhicRawQkmJM/EipnLc5jvluyzsFFsTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140501; c=relaxed/simple;
	bh=Brqi3d+sbklxDoWB9ZIQDOtmsaBgnA3dgLtruhJuETs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLRSZaptG++3mFaOIxnIwo3XslUZ/q/0dJvlpyFf74I7qu7vVKoychaozvx5amHDkLFa4jBrOZ9N2jgVuS09f9Vxx/FRE1YTA2NzJkkrg/r+YtMqAp/Lf0Xv1d8tq95Gt7iLLq8sZP9FJimdeMn+oqT165vwS45k079A2irFuL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OYvPQ8oF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OYvPQ8oF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=C+D7dnrVlBYW0zMlMpohbhwPzfPuOeDoZhbyTVl+ipE=;
	t=1791140496; x=1792350096; b=OYvPQ8oFeqxNfW1CvUXYT5dBJo8SZGENUKiAvUYMWXVDtjT
	oYyDal6RChuFbdLrY8HoxYaPoRm7GXIl5pQkaXem32rpiRYmVrAkSrQhL25ACSWIIVR6gR1tqPHSz
	lr+Cug8uYrYOwgBdaNjq0TUpHu7qBvZ6na+AlhX5JYvSxBZK8EAEVNguj5atoQY3PQhsEg9jhsG3U
	NH0Z7w1oGFdo7wlOClWC5COFA6BVgsjnHbICD73aPaK6tTKrt3BxQcHwrd27imz0iigYgPOeppzr2
	Cmo0qISSVusHncClfz7FUxFH3XsGMmnjKcDFO3nvfhRreceLp68KPVKY7CnAA33Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSn-00000004Jlo-2XfG;
	Sun, 04 Oct 2026 21:01:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 12/18] wifi: ath: use freq_reg_info() under RCU
Date: Sun,  4 Oct 2026 21:01:26 +0200
Message-ID: <20261004210122.b7978a289e36.I44fbb6c36186a6b14a68d6f8f1010c30c69441bd@changeid>
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

