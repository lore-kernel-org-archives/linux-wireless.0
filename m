Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7692F42FCC9
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708783; cv=none; b=aAGoplUq3KjFNemVWxKaNOwtJpg4BlBUJoqEFEkHd3D02PLG2DdkpMLsZ43dtn6aQIYcIwIYmbHT4X2Ert+pLLZziCWJEqqE591zR686g0ljIgjjSozlofXaOsHPaPcR9b+0r7Nb3qidKuoouJ3U1lr0nMBrfdzAw5sqTnuxgvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708783; c=relaxed/simple;
	bh=5Vyhp/fkffSgvZE0s600WTMxiYAzJihyW5FE5riOz8Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZPpLGKEqQ7bG+1175SWo2HI2XnLXf+ju+T35CZc8js1vqz3jg9wWh10LANa7SUZscVmQBw9TUZoNrK02oWlSQeOp/WX/nWJFPVJP9KJFL0omxszrOvQ83zTha9S6Eqn+p3KcdfBbcUmM1/oqtHM1IilI3ZXC1YSTC1fUuit2uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=QuABFJpn; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="QuABFJpn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uhzqPnZOqjrGjsymOYQ+KebN9ilkAsXFVao8Pb0OvcY=; b=QuABFJpnoR9tFtqaehy/wQbex3
	6byEbsDii++GmKAMCgbrYRgt1HXsuz2Ve+PwPqb4SQMBvRsh0qgPJM4jtqTekK/0eHhpgZH6V7duj
	2GjH99N76GuP0UxR1XVhSkwl1g++Xb5y7QhZNzc1HNrMMv+j2CZsIN6zaiCyfJizXcxA=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHR-005AHx-2i
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 18/18] wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
Date: Wed, 22 Jul 2026 08:26:10 +0000
Message-ID: <20260722082610.2699628-18-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The clock enable path for the second adie sets MT_ADIE_SLP_CTRL_CK0(1)
but polled the busy bit of MT_ADIE_SLP_CTRL_CK0(0), so dual-adie
bring-up could proceed before the adie1 clock was stable.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index 54ff6de96f3e..13fba2a061c7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -908,7 +908,7 @@ static void mt7986_wmac_clock_enable(struct mt7915_dev *dev, u32 adie_type)
 
 		read_poll_timeout(mt76_rr, cur, !(cur & MT_SLP_CTRL_BSY_MASK),
 				  USEC_PER_MSEC, 50 * USEC_PER_MSEC, false,
-				  dev, MT_ADIE_SLP_CTRL_CK0(0));
+				  dev, MT_ADIE_SLP_CTRL_CK0(1));
 	}
 	mt76_wmac_spi_unlock(dev);
 
-- 
2.53.0

