Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9343A47CA81
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 21:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792101268; cv=none; b=SbQQTv6MLxZc8nYHcoJ5m1YjgbhIjEOut1cUiygnMSrqaAyZU/mq/uoAiXE7vI9zSlcoNbqsimllF/Fk3aE9TD3t7pca9JUlIim5BE/4YZetgH5gWmSkADNh01baeCZF8SEeQL1uFwfEd7ZnUbDk2+hOorItcZJ3K2ayWZwoCNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792101268; c=relaxed/simple;
	bh=gaNWCzeBlx+8iBLCXy8xVncbBWfAae6JANYjymkPTLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F96qUXitupedN/4DW872jU84niWesMg2u7LvUOgp9xVSm/zDzM0jyVQ4bSVZzH39b+64aoVo3v6GtWocF27txJGXMxqxHX72iBptF03zbEc7Ap9wzSWoIm5hWkDRlChUegOcAHUmxjlLrycWsPlAOL3RmPgfGZT1n77yUwkHM2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQYrJWYb; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQYrJWYb"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-398b3c37877so2964535a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792101266; x=1792706066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p3k1c/Q3C6vUcXTQA5+QfiwE0HRRy16g2NLX4mv2FEY=;
        b=PQYrJWYbLVuZ1MXqZN0pzWGdK3oFkAQAU6xOm8S/G7zr6eSVKbh0cipvzI3WTXUH4d
         QsfkyZSfwMplRhlOMIwZsbwdUg7/Ao8HzZjyr2IoF6wda0O8KyFgP5jQeyxnvpDveOW4
         PwEaQvs42Lzk9Myfs56jjmX1Kdma9W46b3Jl9tpELqAz4rXc1IpVSohY5Zfjm0Ju/Cbm
         wqeOEXlfxC372FY2xHyjepv2Ho1obfSJoeFpEid50P4aHer6rLsRlNyWsiJqzS9knkxo
         1r65j5ZdgWbySLUVIHV0bFtvZB9XiaNEHzj326iQMA3PHiiBLFBQGVl86ImuEMYPlXc5
         +13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792101266; x=1792706066;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p3k1c/Q3C6vUcXTQA5+QfiwE0HRRy16g2NLX4mv2FEY=;
        b=2P3eBPAacBfpbQWhKH0CIAL9Hs1HUlTsYm2kGE7DO5xGTbhwpBrcsgsx9oDwRkfA38
         3RBDfZ23prmkFXK34lr4Kx1ZWwqpt7NoSGI2kpCZRUKJWRHUw3cH4xn9aFDVkStL+DiW
         QwjbQM7oiSozMkILvf6Nzp1fl/m5RPPUNMMkX90awCbvBVplZD95QdpelW36afxmtiSt
         NJ/to8yseEhJ8WgPQbCZe19/HnMp4aO+Ds+rFh1sdiiIFWoUKquvDLF0liQFBqwdSTkR
         mxgUbo7vEc1vJWhXoN4QbqgM5Ul/4Ft2GdMpAoxsLAjgqL/gHIuXBJKOfFbhPxZ+bomv
         pZxw==
X-Gm-Message-State: AFq9FYLyCAF6xQD3TpDDK9CQdEJsSwAvb/ciDEhtXltq9awTbLp5eWz/
	ljvpIckJZxJSVc4X0Dxvk1IdlnDA+RsHYA7iTRrzl/H2n3JQUcfelgoOX7Ws41lE
X-Gm-Gg: AYBFou3iD+GuoKzhBvKXZSV7HpQey/Wq3P6MBKy3+zKRskXtAldk+O5RYBUfnwNJmUf
	SWYO7bD09kfSNMgpd2yNtfw9Xl9r6RBIyKwmZYATEoCh+ECWHcbaydBdI0HGcQ0d4IqLDLx8+uD
	qBQfKYIhVZE11F2zFGO2BYIHrdTkEvoy6jFaQi1EeubNm6I3zpbb0fYQkMQivyubPpBcIiVN7M/
	ER2puRBCuw83k16CQWxiNwwR/A5mt7y+j0c3F7fFZShhYi/fZOVbbSBnxfBPSOv+MHp5+s4ke+u
	nZHTQFKfPGREy0LRSkgDayZeZ2Q0Pm27rumIwM4CC4mO8stvy7aATTILYXkfAkvwWTPh4g4cJRE
	kNBf1d7/Ma5fUEYlDsVQevIO1dWmCzZjzj3yHGUymjvpLJiL3b8kM1dSm9Ag1v+tNOPgI1J1q3n
	Hnd2ftNQkmzZJTi4NnIAEdRaLJjZSdbpR8ZYBPjFqdDpg8dmY9KEwq6uFjVAnb+5pGrlhMCnzjn
	ouaZhvwqdzGtB9L53J6G0zTLUb3fVr3MguiKhTGi1JTkH5E5amm+OGS7C7srQeUy3lqn1AODtmy
	l47Kf22t0wuE1nRqMGPPb1sXQqfRvDCZCMy8ZpjHb9CZlbDf
X-Received: by 2002:a17:90b:384a:b0:3ac:b3c7:de14 with SMTP id 98e67ed59e1d1-3acb3c7e4a0mr1809389a91.61.1792101266438;
        Thu, 15 Oct 2026 14:54:26 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc487e509sm925307a91.9.2026.10.15.14.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:54:25 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: load the N-PHY SPROM power limits for the current band
Date: Thu, 15 Oct 2026 14:54:23 -0700
Message-ID: <20261015215423.195788-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

b43_nphy_op_recalc_txpower() always builds the per-rate power limits
from the 2.4 GHz SPROM entries (maxpwr_2g, ofdm2gpo, mcs2gpo), even on
5 GHz channels. The resulting maximum then overrides the per-band
target b43_nphy_tx_power_ctl_setup() reads from the SPROM, so 5 GHz
transmits aim at the 2.4 GHz limit.

Pick the SPROM band from the current channel, splitting 5 GHz the same
way b43_nphy_tx_power_ctl_setup() does.

Fixes: 8615eb2870f1 ("b43: N-PHY: support setting custom TX power")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 22359bd9db47..a8dc7c12a5a9 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5833,6 +5833,7 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 	struct b43_phy_n *nphy = dev->phy.n;
 	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
 	struct b43_ppr *ppr = &nphy->tx_pwr_max_ppr;
+	enum b43_band band;
 	u8 max; /* qdBm */
 
 	if (nphy->tx_pwr_last_recalc_freq == channel->center_freq &&
@@ -5843,7 +5844,15 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 	b43_ppr_clear(dev, ppr);
 
 	/* HW limitations */
-	b43_ppr_load_max_from_sprom(dev, ppr, B43_BAND_2G);
+	if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
+		band = B43_BAND_2G;
+	else if (channel->center_freq < 5100)
+		band = B43_BAND_5G_LO;
+	else if (channel->center_freq < 5500)
+		band = B43_BAND_5G_MI;
+	else
+		band = B43_BAND_5G_HI;
+	b43_ppr_load_max_from_sprom(dev, ppr, band);
 
 	/* Regulatory & user settings */
 	max = INT_TO_Q52(phy->chandef->chan->max_power);
-- 
2.56.0

