Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1537453CA9A
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 17:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792087177; cv=none; b=XyESGLPBmfMklC/ZnJxS3FY7UKHyeTgYp7g+MvXn+WuVQkjpka/r9O9a6SWsBPlx++0+3f7600jAGepZ3Rf06yLdH2BsAzn5GVV9Ym3OM6564uzSQQwQTtTgly3ymctI+qlDtu8Xw8kx6A/scnH7H64YxNNPBg/FuGKAC61NLQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792087177; c=relaxed/simple;
	bh=CGAkxIf5rvcgYx1NepWWxjZaDr+izSAUpecBFVIruvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lk3gFRQEQadb1aXk4GDDuNzpGpKGv8H0j7zfnb8byxkUtKxCLpEVG86cMSW61IokfGP1N6FQJba1UArbsXpwyjpm7KRq+PatqTEEvkp6WoxIMge8RWBH+OmEPlxI0wxL7z8chsRe20bec9wYT2Wmp4PXvHMB69We4VeJjwM1/4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EbbTDhZH; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbbTDhZH"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso4435267a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 10:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792087170; x=1792691970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8tNWr37CC42Ka+uvECNVbGDgTVEoQtysQmgz0bCFrXs=;
        b=EbbTDhZH1lDai6A07DcAjcsjcao7CxlizyqLp1+7drUd3La6yz6zb1I1cwfyknp6ID
         Yi/grkjb1tYw5xihLM0pOdcTj/kiew2Ucv1/Y0NQHWdUpzxEJLrsSpFH6sJ55Z36RjjZ
         JPVKO8QZd/h4jWL/OUFx/4tfr9FbMSOoyDf0rPV9FiQCd/F6BEM3c0jicPheV5P8iys3
         Qe/L64CjRCLcyD94Wbe9n9WhPP16KCXswDKZKlCz4mNZRW5MO+c3ivYpqCsMQDUgrmxe
         OiEw4ykAYl8hjdfCZY46udIJGbmFHwwtPpZbxlVfSOdxPnPCXW88WPSEglbO1BTpqxgF
         zV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792087170; x=1792691970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8tNWr37CC42Ka+uvECNVbGDgTVEoQtysQmgz0bCFrXs=;
        b=xJwFCbC25+QSWq/zwAxC60P4YFZbs28cQvQ0Kkst7FOD+HSIpLVLzMhcQqg2BcRYpC
         4xTRxVC4jo9PSpK2IK5bgDX5TMHIH6SJ0TmCNw7HPx6oaA+7alqBm0wpK9Lxq/NA1SrS
         VvUSmeAQtW9xf8hTH4KF0HFFMp2RfdLZe2Pm4q+ct9jxQnQh5jT7ETXFKbOA6knQeRIm
         Pwd8fpC4u+Dehm7IBdxK4YJFVk71FtJ2v17OdFPs3c0tEh6+gnvKn1yTofzsRoUXohwD
         ltPDZgzX59tnZreHVVEUhamQKsSQaoeAujAjlTtZ5TXVBHzJC8FyuDtPBtnPH33I5z6B
         aY4w==
X-Forwarded-Encrypted: i=1; AKwUvBzZ4tbU0Tpr2RwLJWg0ADBaSZ3N1Tmc94zWPPjbGCVjB0LQ87QbXl277iIb/El4rx9X5cyIzFFTS7KGZ+eGOg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIdUDnrfCyqTJgek9DvKJZRjEGpB4sqBCClLQvveqXj6r5wFITx
	ON2ARD7VA5ewma3okfIvqNYBw8KKjq8ZNHrf/NqDNLgq7Yx0OWpHbbD5
X-Gm-Gg: AYBFou0chP3Y0fw3oxB/qaiocxYBFniLv9D4lz9Ja64Jvk1JBsg+edMA7Z3rvswDhMK
	xENjgKYOdG58cqhgQk+9I8MnAdnDQPe1QQPlljXSp0PRJx5dhPWrwfX4+1nrwMGIq9PByre6lsv
	qcU2wbrKRy66KX+iHezYIIjsjLnmJFQj04q88wnROD+V6gx5BOqFShrEKTqfpaDlcu/JKA4fV8B
	355690NbljbLc6OOd00Ws+nQBISJL98S2/PrXT5u+jxH/00HHoEal7Bt5GmiWPK93Y9gX57qBTo
	eyCYfNth05UCDOlUh/0iPjnWwYDwgljuHxHcuEX0ICkJrvcpBS1F5o1RWSpcLFNvcm55HrgM3aJ
	51D3sdf5sz/JUw9vPiuzCg18Y/eamC41pXY2HMO9An3KwmeKrUi2XmT6TR/bGjGZjlp1zOLpHE/
	lQtvxV+PJqA/19X3YsF1/m4ANgvJwxotReD5QN9mbzCJqT6p7Z/UM3te87IvR2DP8LBAK+TDtOK
	kDZRHfRJLMigWw44MNJkHL7Tatl0TcGH3t08m+QdGgmEedh4/7o/eUAD/kh9ciT4Y/mXnqkmmXf
	x7OP9pFN1IGGfPzwqeLE35bGGYY43IaYSpdXk1uWmtI5Z1tT
X-Received: by 2002:a17:90b:1a87:b0:3ac:a6a5:5743 with SMTP id 98e67ed59e1d1-3aca6a55a10mr2003749a91.32.1792087170220;
        Thu, 15 Oct 2026 10:59:30 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947928b4sm5075835a91.11.2026.10.15.10.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:59:29 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org (open list:B43 WIRELESS DRIVER),
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER)
Subject: [PATCH wireless] wifi: b43: back off the N-PHY TX power per rate
Date: Thu, 15 Oct 2026 10:59:28 -0700
Message-ID: <20261015175928.3558057-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On N-PHY rev 3+ the hardware TX power control aims at the highest
per-rate target, and an adjusted power table backs each rate group off
from it. b43 fills that table from nphy->tx_power_offset[], but never
sets the offsets, so they stay zero and every rate is sent at the power
allowed for CCK.

The SPROM power offsets exist to avoid this: on boards with external
PAs, OFDM and MCS rates have to be sent a few dB lower than CCK to
keep the PA linear. Sent at full power, 16-QAM and 64-QAM frames are
too distorted to decode. On an ASUS RT-N16 (BCM4718, N-PHY rev 5,
radio 2056, ofdm2gpo 0x66666666) the router could only send at 6-18
Mbit/s and MCS 0-2, even at -50 dBm, and 24 Mbit/s and up or MCS 3 and
up delivered nothing.

Set the offsets from the per-rate targets b43 already computes from
the SPROM, as brcmsmac does, before the table is built.

With this, the RT-N16 sends at 54 Mbit/s, and at MCS 7 with HT
enabled, and TCP from the router to a client goes from 9 to 17-18
Mbit/s.

Fixes: 8615eb2870f1 ("b43: N-PHY: support setting custom TX power")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 22359bd9db47..c9b2b7496983 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5834,6 +5834,7 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
 	struct b43_ppr *ppr = &nphy->tx_pwr_max_ppr;
 	u8 max; /* qdBm */
+	int i;
 
 	if (nphy->tx_pwr_last_recalc_freq == channel->center_freq &&
 	    nphy->tx_pwr_last_recalc_limit == phy->desired_txpower)
@@ -5868,6 +5869,16 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 	/* Make sure we didn't go too low */
 	b43_ppr_apply_min(dev, ppr, INT_TO_Q52(8));
 
+	/*
+	 * The hardware power control aims at the highest per-rate target.
+	 * The adjusted power table backs other rates off from it, so that
+	 * e.g. 64-QAM isn't sent at the power allowed for CCK.
+	 */
+	max = b43_ppr_get_max(dev, ppr);
+	memset(nphy->tx_power_offset, 0, sizeof(nphy->tx_power_offset));
+	for (i = 0; i < B43_PPR_RATES_NUM; i++)
+		nphy->tx_power_offset[i] = max - ppr->__all_rates[i];
+
 	/* Apply */
 	b43_mac_suspend(dev);
 	b43_nphy_tx_power_ctl_setup(dev);
-- 
2.56.0

