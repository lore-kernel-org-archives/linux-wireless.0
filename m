Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190254;
	b=rZcWxiLfxyzX3FXjxka6DeMecqracH/7PslZ0DDap7vml+Uy5x5x14PXlawbj0uQgO7V
	 6Gc1JLXf9DknRXM2C00N3/+mfmFaZaVcqGIAY+uZUkJz3o6wdiZYtXEnb6jTeWddnJSwl
	 JbAp3YKHt2enR6aPOS6nev5yduQPqNScfp+4mwh3c+sF0QLEwTq9Lizq2caq+qCgBQb29
	 DGJO1Ug/uK4DtYdAMDb+ubPs0giq32NC0jg7gEl5R1n4O9LXVUwvRftZjjToIDv18o5zu
	 jkwytL3tGA4DTsHA3TAqro047LKReI/uKB1Gc/oMMnmDliq4BNx7PALMt2fpYGE8htA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190254;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wc6Bw09zfJt+cOZtJJfbjluQyhispF9v2sCllY6mcEM=;
	b=UsvRDZho4+1p/Q9zw+wArhGuYcCAq3Stv0LHhfFrm5JjevmFXQcT1okrnTWYqRTulvub
	 3R15YrmoYN6PHGLMeLTvkzsrF21MXuqn0V7nwSG7nWeYy1nYb4flNugR3zQSAUPfXoY3l
	 6i3+CQMNNXWjOfSbjSvA20ze0AISkVhn6IgQZANaH5QHfJmG7qrBXmzYgIRHWUU4qnwgT
	 5+L1z9Vb/3w90ujlfygI5iCKkcwWLpyekT/0TlH2bl+l2cp/KVrSRu4zkcl9JzbrrmfJI
	 ILBxNcX5N1N4qb0g3gpdLoadNARpbQvYL5ls4jY9f/hJMFESJmurcX+ttPwBWw/xaTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=CJacAn4I;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206A0606A324
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 206A0606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=CJacAn4I
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wc6Bw09zfJt+cOZtJJfbjluQyhispF9v2sCllY6mcEM=; b=CJacAn4ItCyfe2ZWDTDiWpAaVi
	RMFJ9jXdJNrTe82BF1L9VyFN9u30S7C1W6JNkkEXvniNl5+uDpTpjJJ9Kd5XsgyR+qJ4m+G84JQao
	uiJarxWFuksy4jN4klSw+C9xmPi4M/DRZqW43OSU2DNgQcV/PTpWhs5o+EbO6kkaF05U=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hK-00C8Bw-31
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:07 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 05/25] wifi: mt76: abort a scan when the chanctx changes
Date: Wed, 28 Oct 2026 13:23:43 +0100
Message-ID: <20261028122403.796394-5-nbd@nbd.name>
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

mt76_change_chanctx() sets the channel of the chanctx again while a scan
can still run on the phy. During the dwell on an offchannel scan
channel, the phy thus returns to the operating channel without the
mt76_offchannel_notify() that ends the power save period towards the
AP.

Abort the scan before the channel is set again, like
mt76_add_chanctx() and mt76_remove_chanctx() do.

Fixes: 82334623af0c ("wifi: mt76: add chanctx functions for multi-channel phy support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 192276cf19fd..115117a19b5c 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -88,6 +88,9 @@ void mt76_change_chanctx(struct ieee80211_hw *hw,
 			 IEEE80211_CHANCTX_CHANGE_RADAR)))
 		return;
 
+	if (mt76_phy_scanning(phy))
+		mt76_abort_scan(dev);
+
 	if (phy->roc_vif)
 		mt76_abort_roc(phy);
 
-- 
2.47.3

