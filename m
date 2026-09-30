Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E8F35AC1C
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758057; cv=none; b=QgxrNSmfDEX2fG4fWYWeTK1FTCQwf6rrSwYsOo7sHI7dzJyzThWVoJf4c65mcHeIUIPJLmLuDqxvF4rMelJWp0owCogoevnDtRI319A7KgVrUsZ2RzPrng596uIo1fdUoqx0xwC3Bd2s3u3ujaW633aV6MDW90s5Fypr9V4G2UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758057; c=relaxed/simple;
	bh=9mo2j5ebg7lf333f0rUwb61fbp+yJJ55XaBBgGJLR3I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NGaZjBn7aQZen6djwmn2IGgeX70ix78QKsm4jE9LeyQG6if2T25zAliT9rce7jj9HAqe+bp4JNxCErzeu8yNNTvPK1mKPwMKV9h3RG+XR2pe1sEGcuMnZFvtWRUrnqpOPJsbs4Mi3F5nTGv3F3m0NVCcCFfEMD5lko6Qn6yw1eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=l1pF7nG9; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="l1pF7nG9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UEWF1WVIpG1QppevXZ34VlhwwNM6vg++gG0TVKxijgg=; b=l1pF7nG9cvByWa9Nv7Fk5QVOxl
	SvvSBhoYMLIPXhaTx1yQAvaZ2BNVCtWe0gAq726AW0HTzuE/QSXMMTtwOq5zDP9ZjztTsTg9XAWRa
	2l0xP2PzDTADg+L6q3OTTaPKmGFtDJWbh83hwsfdCnd73EqQVoECvfk4F66wCzhCQBus=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xBpyP-00DQsA-1F;
	Wed, 30 Sep 2026 10:47:33 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next] wifi: mac80211_hwsim: reserve headroom for software encryption
Date: Wed, 30 Sep 2026 10:47:29 +0200
Message-ID: <20260930084729.3000295-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211_hwsim accepts CCMP and GCMP keys in mac80211_hwsim_set_key()
and encrypts unicast data frames itself in mac80211_hwsim_tx(), through
ieee80211_encrypt_tx_skb(). It asks mac80211 to reserve tailroom for the
MIC, but not headroom for the CCMP or GCMP header.

Reserve the header as driver headroom.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index b9446577ff49..c98c862678a2 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -5906,6 +5906,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	hw->queues = 5;
 	hw->offchannel_tx_hw_queue = 4;
+	hw->extra_tx_headroom = IEEE80211_CCMP_HDR_LEN;
 
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
-- 
2.47.3

