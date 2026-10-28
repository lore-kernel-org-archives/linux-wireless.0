Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190255;
	b=xOm+QLAYjoUgNEg38jnPNqHR4ljq/jTEIRu3cVBIJlwso0ecjXE+3ww/dh1JFnp2sTAh
	 NvpOZRrg8+w37ZzjO+hUE/RXly4xaGWW0expB8QD3JP0mrDv+r6Q6ZO5q54PKcMqFLlOg
	 We6iXsrcYNEzxbpe9yfmNoPo048/6Ef/EpZeiv3sPq2KBHSuvE0Mx4DKQwxeTZXYUO4N7
	 0PbkjLM2ZyFjCOMOLkBFNBgg9VAqA/pbgsrk4cCnHbWhO2VjDyrRyQouXrmUB64qCMo3+
	 hP7huYIgtQZ7wB5I0SlhYq6eNiheVzBpuh1mn2Zs4xoggD9fAv++8yXjgi8KTGBUFsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190255;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xTMyL+mEeXmxJg+7bI6tLKa90jdIVCtn73wZiQikOGk=;
	b=TOU6jUYlw98/4SKIHvhxkE6bk4Nr52H5KteZ84FBGkvFpy05tqB/6lL4rq9lwsHJEot3
	 LQU3WTjIeuByxUxFXCVXHPVl+0mUQRo3Bd3TSOtYXiWDJ/kNEGtUm8VqTJciV621kUhod
	 BSgz8gwXlMVKaN68aierVA5V9/SVbDFThaAH7E5yXZ8dLr+5aqajw4RQZ6BF17v1H07Z9
	 N8yIir7jvfD45OGsB53W31b0vQXKERXREZochiF3gWNKoP0Efhk/l5SpHxtQqTWqtSB/f
	 fqG/5/yxK7XXdGf2eemKF8NP9xv3y43I4ukHAj32mjGbooUd57kfiByMr1b/2J+GjhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=gerDY4+S;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205BF606A323
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 205BF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=gerDY4+S
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xTMyL+mEeXmxJg+7bI6tLKa90jdIVCtn73wZiQikOGk=; b=gerDY4+SQWK4ParNhpSGh7qb6E
	BnxT7TY/LQacdA5UkWuxEo0n1l67Odso5ydLnK+Ze1dQ47N6Q+3Tz72Ef5lSdOUtt/3T8c57PxCnL
	VWfG74XSvdrvpDiyzmjwtCXU+3RsPtw2e7F2PIFrTdmbuNnCLs99b0XzBZgldp3M7T3U=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hL-00C8Bw-0L
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:07 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 06/25] wifi: mt76: set the channel again when the chanctx puncturing changes
Date: Wed, 28 Oct 2026 13:23:44 +0100
Message-ID: <20261028122403.796394-6-nbd@nbd.name>
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

mt76_change_chanctx() ignores a change that only sets
IEEE80211_CHANCTX_CHANGE_PUNCTURING, so the driver keeps the old
puncturing bitmap. mac80211 sends such a change from
ieee80211_link_change_chanreq(), for example when a station follows a
new Disabled Subchannel Bitmap of its AP without a channel switch.

Set the channel again on a puncturing change, as for a width change, so
that the driver programs the new bitmap. Only mt7996 uses
mt76_change_chanctx(), and mt7996_set_channel() sends the bitmap to the
firmware.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 115117a19b5c..39a5dca4ca7d 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -85,7 +85,8 @@ void mt76_change_chanctx(struct ieee80211_hw *hw,
 	struct mt76_dev *dev = phy->dev;
 
 	if (!(changed & (IEEE80211_CHANCTX_CHANGE_WIDTH |
-			 IEEE80211_CHANCTX_CHANGE_RADAR)))
+			 IEEE80211_CHANCTX_CHANGE_RADAR |
+			 IEEE80211_CHANCTX_CHANGE_PUNCTURING)))
 		return;
 
 	if (mt76_phy_scanning(phy))
-- 
2.47.3

