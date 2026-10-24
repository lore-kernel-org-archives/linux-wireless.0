Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=1tvo+eSfDi8bozHmvETIWHMHTiu+7vBFHYAls4KAg8S2ibmX9wBiqTPLpFuNwanYfOoZ
	 5MOo/EjliW8Ft12pOgMqFbOI1J0xf2fGkajHWpC3Upsb87TBGxF2kHW7JBdiIz01dyiUV
	 cxyWstVlUssEAkU7NvhPGEliVnk+5SpJ3O+yE1zwc3Rx7XHLWERCBOcAIeAHQoFjif73h
	 5xcqh9iYSvWuCCIJPiLmXAKoN+/pwsMrYGJaZhZ/VWw0niMpGcQDDLB8dFW5dLNhzWVV+
	 SKPgKf8mENsDegot8rBhiF5vpjbhrn6+HHfc7az+qZ4ALCW/LBOpAfVs028l+9eIThQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=NV8ifvPTI5I/E7xmWuEPPmaH58KCqCJ3SeISTtoYR2M=;
	b=rYnIRYxNfV08X1dDnAMvIIwxDyMMv1D7ZUhNmJ5nLbxIYgOak1rlkGi1OkZuhKbG8H3z
	 AyFQ1tGR8f+OB0coCfdMzIBTas2XmssjravqN5ZjtKoKkvV1hr5TBHDP2t3QY6SS8Qrsp
	 KcXuFMGjrd2fPEtaB0NF8NKJnzBSJMW92M0m7adQPoRoyJdqV0VYYXRyCfxbZwBATH/dm
	 kVhw3v4MDhncrdpyRJ9+/ycyKVCkzYkgZevLWJwldcFWIGwKy5G2hjCCFM9yt6ghMBNAz
	 0J0jSGTPwFRshmSjvprI+zAdjNg5UZvCUHay06qrAryZiFpw9PuxBcOlcbqGA2su6Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=KTxhXAh5;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEAB606A31D
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EEAB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=KTxhXAh5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NV8ifvPTI5I/E7xmWuEPPmaH58KCqCJ3SeISTtoYR2M=; b=KTxhXAh5D0Gv433nVYjpDv4G3k
	RgCrnEJrxtixspibCHgmBbvIhLymVBpqb1zEuGvwsDILyzIfgBgffSPqtRbUmJ16dp+My8EUitqto
	AntAFkhaIkzrjqa64uXEeZkVjegpn5qgymmUopxHO8kObDz99b3QZIOUpb5YWdZgRODQ=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2P-009vQq-0O
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:33 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 01/11] wifi: mt76: mt7921: validate CLC event length
Date: Sat, 24 Oct 2026 09:19:17 +0200
Message-ID: <20261024071927.2279668-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CLC_CAP_EVT_EN set, __mt7921_mcu_set_clc() reads chan_conf from the
SET_CLC response without checking the response length. A truncated
response causes an out-of-bounds read.

Reject a response that is too short for the CLC info TLV.

Fixes: 4fc8df50fd41 ("wifi: mt76: mt7921: get regulatory information from the clc event")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 89d2c11b97ee..79fead3ccce1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1446,6 +1446,12 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		if (ret_skb) {
 			struct mt7921_clc_info_tlv *info;
 
+			if (ret_skb->len < 4 + offsetofend(struct mt7921_clc_info_tlv,
+							   chan_conf)) {
+				dev_kfree_skb(ret_skb);
+				return -EINVAL;
+			}
+
 			info = (struct mt7921_clc_info_tlv *)(ret_skb->data + 4);
 			dev->phy.clc_chan_conf = info->chan_conf;
 			dev_kfree_skb(ret_skb);
-- 
2.47.3

