Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015513;
	b=Si5P0esH+vDj+DXHU6H6wayGpjXDzp1CuzyhUCNSVN9WNr2xetObKddVXUy9kUKsa6da
	 RB6W2Z0+B9bKWiV5kJGSSjj82tClGGM8tG8FBTapON6MVcd8PxawgJ+c9qfJU4uJxibe4
	 znd1V0b6Oz2QEw6QpthM1Ff2MyPDtObc3F0Wj1avJeeI9k9IgeEWyYg0kJznmHyagVL4P
	 gyH8szi1pWAsM98oGVWWE6EOUI7/APxKLAfAuPLFdQxzuR8KeIoARmqE8vFrm//+xa+Va
	 Tel8RXsiOh19zcJiYLC9aw5R6Sud5so34RcDk/KuncQzSgb15Z2JdCtmNENv5sNyaEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015513;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JfvkT5awYH+Zl7zefK97AgRup7yBoFJcS039yE1/niU=;
	b=eB0gHjDEyq4x+uqots/4vaidtvJg8DO2c7fH7TEHg8COQtJ+beO7RtA/ZyHgVR+azkbm
	 IkcUzkZWKUp2iXtYWaoD75CNmFAKMzS2ZB+iNFAkovletayz7+kc564pZfu3sE+LMzkl5
	 zUhMUuf4vlNuK6hw7H8rCGa4xg6jVnJngVETsn5YB7zW8kH/MMAV6VWCpguvyp6HMPxLH
	 hdTOtgB75FvuDh0ic2Bo7qpwDZNCi8eXigUw2Wc6BkduiBF3raBDBYhCBhzTeR6holPBk
	 CpJQvBGTXNs/Z+IeGAhST5tl4scDbJDJ6wBO+6fgEc63nw6bYXQ8E7q9a6qaDQde65w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=irqZiFzC;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F8C60A261E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=irqZiFzC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JfvkT5awYH+Zl7zefK97AgRup7yBoFJcS039yE1/niU=;
	t=1793015512; x=1794225112; b=irqZiFzCAl0sKdEbi0/O/dl592I9tZIgEsbdsoaEyc8YiOX
	CZ+gC+88/U/zFZuT+NKPrcykEkX/zJeo6g2OiDLyB3FEQt5c4rU0RRPtz9OGDZ8PVxM0LMf1GiW2Y
	ggiRFEgEfNuRZKBXKGvZtft8NV+ZwldaVMrtca3IYNVXgqJxqXrwUozfXsBqDBeO8wh5I5DU7ZWa7
	0Xs6Ul0wTYXa8x8w2FgY6mB/jfvFbhgKNYfG4eRArFH73uSImYRTeXRUfRanUPLFI5s/HQ+2WkxKp
	pXZbQEjLqUtyBcx8LV3aeedmTiNa15jK7mOy/xZ/2/757woWXuMH3Nkco3qippCw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLJF0-0000000BDPs-0P9W;
	Mon, 26 Oct 2026 12:51:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 2/6] wifi: mac80211: don't synchronize for key tailroom
Date: Mon, 26 Oct 2026 12:48:36 +0100
Message-ID: <20261026125145.df715456f217.I2c30a5d220d65f64a6ef9b8c82b4cc2af72d24df@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026115144.189706-8-johannes@sipsolutions.net>
References: <20261026115144.189706-8-johannes@sipsolutions.net>
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

When crypto_tx_tailroom_needed_cnt newly indicates tailroom is
needed, we currently flush the TX path so SW crypto never sees
frames without enough tailroom. This can be expensive when new
keys are installed, etc., and while it can be improved, doing
so would lead to quite a bit of complexity.

Since the previous patch the crypto code just expands tailroom
in the (unlikely) case this race happened, so we now no longer
need to account this as carefully and can remove the waiting.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d32c61a90d93..6904b519ef37 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -75,36 +75,10 @@ update_vlan_tailroom_need_count(struct ieee80211_sub_if_data *sdata, int delta)
 
 static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 {
-	/*
-	 * When this count is zero, SKB resizing for allocating tailroom
-	 * for IV or MMIC is skipped. But, this check has created two race
-	 * cases in xmit path while transiting from zero count to one:
-	 *
-	 * 1. SKB resize was skipped because no key was added but just before
-	 * the xmit key is added and SW encryption kicks off.
-	 *
-	 * 2. SKB resize was skipped because all the keys were hw planted but
-	 * just before xmit one of the key is deleted and SW encryption kicks
-	 * off.
-	 *
-	 * In both the above case SW encryption will find not enough space for
-	 * tailroom and exits with WARN_ON. (See WARN_ONs at wpa.c)
-	 *
-	 * Solution has been explained at
-	 * http://mid.gmane.org/1308590980.4322.19.camel@jlt3.sipsolutions.net
-	 */
-
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
 	update_vlan_tailroom_need_count(sdata, 1);
-
-	if (!sdata->crypto_tx_tailroom_needed_cnt++) {
-		/*
-		 * Flush all XMIT packets currently using HW encryption or no
-		 * encryption at all if the count transition is from 0 -> 1.
-		 */
-		synchronize_net();
-	}
+	sdata->crypto_tx_tailroom_needed_cnt++;
 }
 
 static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
-- 
2.56.0

