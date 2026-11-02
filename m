Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655024;
	b=XQNUBEXQNwGKyFF6wJB/VSbMgPVGv1WC05aEbkMykJS9PhRPL6niYupDPxfOEwTMuQQ3
	 ck9NvM+t6/a8xHO6xnuS3MOefo3nOpefw2BQev2kaAbiUgXmsMrNHM45x445N4NjXFbhL
	 YKbZ4Ikk5n2Un7wdABWcss46PKEbuyU8P7m1J+XOuMIXudA/HYuUEj2nJEJM4ghAcngQt
	 SnLy4fhrdbhjxsDScj/DtVmrmjJmVyTh52d5EGNmGOdWnRtPp46xS1ipn8vh8F65OwTra
	 x58uJZuLXrCZCMZnbDaEKwRhUESpftgcbhtAcWrbTGR5QGK4kMvvwWPXJv42R477zDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655024;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zz+rc/TGkCdEksOEIu36cv9BMP10WC4lD9L2wKfnIHw=;
	b=nCstaDSvTx0KXCQtfMODwz2z6QPDOQ5sBkX6W3Sy0tToWvtawsUS3pqXnO80rPUkpsgZ
	 5vTdmJ8YiSmUox4Vl1gUKff+v/zWd6oH0iNQo8AO4KayPw3vGjF2gOCMiMegFs4I1ubFA
	 vAYO6j+b/Kp2gH63edRbLEvNP3Mw9POQt7jnWyPIxyIC5RqWl1swj62F3Wt5s8kQfSCEo
	 Yhhrrzj/ItHkFETLsrhfkc5vaysRTouPWvLAjx6iv723LT4ZH/gDcWCpOW7Ytija5dLEU
	 0fq3FALYOnA1VeLYVU2qmDt7mmHj0NVpW4y+egMYq/IarvQ2XznMeIOQwQujk8LXFuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=uurLLdiz;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE727606EEA3
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=uurLLdiz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zz+rc/TGkCdEksOEIu36cv9BMP10WC4lD9L2wKfnIHw=;
	t=1793655023; x=1794864623; b=uurLLdiz64MyJ7yU+aikcpWgw21TDnbacqwpafyx8tGT8sW
	zzcgU4a9fUM1w0Cfqhx4m9gMmCPxTX1tAHuPcQqo0gA9nwXJgRuTbc8qJsReiYOseXDvgiRJ7j36v
	YXr+h0KwjvhtnLHbxRROCvn2E6MQ8SBOU5mYCS+/uy5CFoa8hKcNwJuHsSJVGm9C31UYRg3QRVy2I
	uXqzDlp0zYZOYcOGqweB2a6dY+jr9yuHYIEFbDfh3EQuChrOjznFoXyVBLT5hK1NtfyrNn8QjqxnL
	Kz+mewHlR81DAnY6kjTSbIrBr6p5U3jnNBTvcZbbtTPLHsPr8JWf0DVA2GJARMpQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzbh-00000001zui-2xT9;
	Mon, 02 Nov 2026 22:30:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next 3/4] wifi: ieee80211: remove struct ieee80211_smd_info
Date: Mon,  2 Nov 2026 22:26:30 +0100
Message-ID: <20261102223017.3ab2c212af04.Ice3b65acb5f44fb4fdc02ed1751a0a99c42e8e33@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102213017.1095413-6-johannes@sipsolutions.net>
References: <20261102213017.1095413-6-johannes@sipsolutions.net>
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

From: Johannes Berg <johannes.berg@intel.com>

This struct is wrong against the latest draft, but it
should be handled by the supplicant and isn't used,
so just remove it.

Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index c6c89e4562f4..5c9a074ef7ef 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -612,17 +612,6 @@ ieee80211_uhr_dbe_cap(const struct ieee80211_uhr_cap *cap)
 	return (const void *)cap->variable;
 }
 
-#define IEEE80211_SMD_INFO_CAPA_DL_DATA_FWD		0x01
-#define IEEE80211_SMD_INFO_CAPA_MAX_NUM_PREP		0x0E
-#define IEEE80211_SMD_INFO_CAPA_TYPE			0x10
-#define IEEE80211_SMD_INFO_CAPA_PTK_PER_AP_MLD		0x20
-
-struct ieee80211_smd_info {
-	u8 id[ETH_ALEN];
-	u8 capa;
-	__le16 timeout;
-} __packed;
-
 enum ieee80211_protected_uhr_action {
 	IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_REQUEST	= 0,
 	IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_RESPONSE	= 1,
-- 
2.56.0

