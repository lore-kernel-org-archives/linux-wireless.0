Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719636;
	b=Dj/AN4WlGkySq00EflXL7We+mkeaUPuPmGLgWepr9dMhAWQuJhw78N2JidLx0gDIFrmc
	 nxgNEKBBh7PUfJdj5AaE8QGYOKTHx200Bm67zvjEexHbEaWgd9gCsws1olXjl0y7svpW0
	 W+gHZIEzsbZ1/Dcc77D7rsHpylWC2ErQyFBOvqDe3vhsILot+eLI0ZispIxaUxVHR1LR4
	 lVxRA6fQkYVQ84QTgp7qI3a2mRD7jlDyE9IDP0Gm49RjQv3k+hhq6Y5qwCAyCJgmr8J71
	 OlZAHDoouJXxbbcQ8V8DNOMDfgRK7DRBOGvbYDj6pVxJVqgBR+EYqSHePXOhmygP9gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719636;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k7xqzXhCMgTfhld78oEw33LqY/63UKOJOAEByeA2VjI=;
	b=Pkp8wzaLikx2jZ1/Ih67ehJEvv480AsOIVClNwl8QsaH3vqhWU9R0ejRkvzyZgacjaU8
	 wRql87GbESnU2w/xNjd/J/e2yLoxRFunQfzvedYeI15eu5LquR4+kij+dTYLDMpSSpOwp
	 gfyUOj3spNfkHasX5WoPzkwH9JUDTElLHmmOmeuuUNcoAI9pkGxBnZidai05dm7RorrRM
	 Q3UN8Zwc+yl4K76A6hJgrPhyRTZvShFzqw7uO0NX1KPWsXFsBHJkn1eANVVyZp2lCX18W
	 rKaUyAHpyPL5mWxh+nMJGkAh01luynW68sAhIyzoV7RW9u+lLqp+Am4CPapXW6dxQQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=W4OGcM5Z;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082DA606A328
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=W4OGcM5Z
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=k7xqzXhCMgTfhld78oEw33LqY/63UKOJOAEByeA2VjI=; t=1793719635; x=1794929235; 
	b=W4OGcM5ZXB8dKaID7dKJ9CTJw3dmOqCcYlK1xQ4phJaLPgISb3pOrfG5u2LWnbgq0AF653PJfBk
	T1Ta4j2fSBIWxnKSALLSdDnmNmzlfWVe9DqnZLsgRaFBLyo6GihR3iztwbk8fNCcVAY800suczECw
	YFA9aCngDChvjZ1zj0ltKumYDd4EEyOL6NvX8OKTpkvNKgkqpl6AR+VaEUPCnwBMz50kfnPx5ffKm
	yOn9/2rFRrZ11YmZyr9qIjUGO+MGKuYTxZ/GFWqHKss+TeH8l1O5UVorC6PN4XRuexFrd+6qEZ0Qd
	v+zw2RwPCVXtErvHncG/wbWV9/X7o/IC+djA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGPo-00000003eNu-1o7C;
	Tue, 03 Nov 2026 16:27:12 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: brcmsmac: remove unused wlc_info_dbg variable
Date: Tue,  3 Nov 2026 16:27:10 +0100
Message-ID: <20261103162709.8a0da8a7970c.Ic047db7b9f9a30522a8d0756c70b446003aec915@changeid>
X-Mailer: git-send-email 2.56.0
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

clang complains this is unused, and it really shouldn't
exist as a global anyway. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index ec3aeaa7bab9..7d000a2d033b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -313,11 +313,6 @@ static const char * const fifo_names[] = {
 static const char fifo_names[6][1];
 #endif
 
-#ifdef DEBUG
-/* pointer to most recently allocated wl/wlc */
-static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
-#endif
-
 /* Mapping of ieee80211 AC numbers to tx fifos */
 static const u8 ac_to_fifo_mapping[IEEE80211_NUM_ACS] = {
 	[IEEE80211_AC_VO]	= TX_AC_VO_FIFO,
@@ -7875,10 +7870,6 @@ brcms_c_attach(struct brcms_info *wl, struct bcma_device *core, uint unit,
 	wlc->wiphy = wl->wiphy;
 	pub = wlc->pub;
 
-#if defined(DEBUG)
-	wlc_info_dbg = wlc;
-#endif
-
 	wlc->band = wlc->bandstate[0];
 	wlc->core = wlc->corestate;
 	wlc->wl = wl;
-- 
2.56.0

