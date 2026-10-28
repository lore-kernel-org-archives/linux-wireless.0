Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190254;
	b=bKgyC9ucT3oVoAt65xTyjTUCLPCCcaYUAcod9/m/oeOX8JbSvK1KgubdBNPTyDFAr0nK
	 djm4xPr4PymzlBbil5qCmuUEjPZupthrN3ZnxrcmaVVXvTxRutGuutcNK0ltqz4HfJaSw
	 INddxHntMpkp1yWafSdCZI+CHsGE4seQYsyjRpLz0w/uyXWI9qe1Mx1N8hsBd4CoZ/J6L
	 4phH14NSN17WSNU9wVf5XCeOW+5jU1pKiXayNGmy8KL806eR+ZYqgWbohIhBC9vq9YC+t
	 vIeJbDjXqyhw0oBvLrl9DzqKtXsfibVGP8Tw1byUEEhduEobgc2x19GA3IKOaLvUlwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190254;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XkUaFaX8dgtvP4E4czSp/u2Ibnpo4CbVc5NNzmAICOg=;
	b=0X+vzMBaK1puXZ98QQR1tBV0+aS0c+m+oSICXO/af8AWUVjJXShKUgWFHhQzmieYcD3j
	 SbEJ9KwQgQXlpWv7maZ8+MC60PWtKDZJaNEINhk5xhck0c8i3uPbutXxA0shdVk7NxiQx
	 RuwVvxZOa1eCKi8orXQwJRPTOL67dItDgM1VV1Hu1BQDE0MsJzeXV7DpyCdufNLiAK6ZR
	 Bb3jSjsWoYr3isII6ccfSD2X5TNBV3fCqCrGlxAL43vQ569FY4yOB9u2CWvztw2ODAehd
	 pTfgEZ16mrTVnBd0PY0T0SZGLKrmncoqX+to3fXL0B2bHVPUcQ6cHjzzOQcssgigjWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=HM6p7H+C;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444BF606A325
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 444BF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=HM6p7H+C
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XkUaFaX8dgtvP4E4czSp/u2Ibnpo4CbVc5NNzmAICOg=; b=HM6p7H+CFBcI0AF9CUeiimC2of
	skQVyulo8PFjT0E55oPDYFZI3D6b/MSB0ISfRbefAqJJ9lxlUuuk+X+6dVyFg2gyEpTTQkGHy+nvL
	brD5wbBCTlkC2ZCjbjAn/MddE/B4edtk7NUVZnyelPLbrfmaVhu6KTQ8iN5eMqy0Q++Y=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hL-00C8Bw-1T
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:07 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 08/25] wifi: mt76: mt7996: keep scan and ROC links out of the MLD group
Date: Wed, 28 Oct 2026 13:23:46 +0100
Message-ID: <20261028122403.796394-8-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
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

When an MLD vif scans or does ROC on a radio where it has no link,
mt76_get_vif_phy_link() adds an offchannel link with &vif->bss_conf.
mt7996_mcu_bss_mld_tlv() registers that link in the firmware as a
member of the vif's MLD group, with the group and remap index, the MLD
address and link_id 0. The group then holds link 0 twice if the MLD has
a real link 0, and once more for each other radio the scan visits. The
removal of the offchannel link sends a BSS_INFO without an MLD TLV, so
the firmware gets no command that takes it out of the group again.

Register an offchannel link like the link of a non-MLD vif. It only
carries scan and ROC management frames, which need no MLD address
translation.

Fixes: ed01c310eca9 ("wifi: mt76: mt7996: Fix mt7996_mcu_bss_mld_tlv routine")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index f35250430383..ce37b6b65918 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1172,7 +1172,7 @@ mt7996_mcu_bss_mld_tlv(struct sk_buff *skb,
 	mld->own_mld_id = link->mld_idx;
 	mld->link_id = link_conf->link_id;
 
-	if (ieee80211_vif_is_mld(vif)) {
+	if (ieee80211_vif_is_mld(vif) && !link->mt76.offchannel) {
 		mld->group_mld_id = mvif->mld_group_idx;
 		mld->remap_idx = mvif->mld_remap_idx;
 		memcpy(mld->mac_addr, vif->addr, ETH_ALEN);
-- 
2.47.3

