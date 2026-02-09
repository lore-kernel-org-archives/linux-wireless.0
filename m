Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406BB388855
	for <linux-wireless@vger.kernel.org>; Mon,  9 Feb 2026 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770660746; cv=none; b=faENctBKtTO5Bo9PFhp4iIaqEt3EmH6YcrfIkiTgCp5O5MRU0cdPNV1idDQLgDQ8gwl3KCnKUzA8Ow3YU1mogDDwlMxJoFUuXrxP65RnUEm4OZCkglXGO+3hTNaP2JnHv7Zx983cFECYB+uGfFmbFjWUKgjQEQb/hQLzOeDCXv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770660746; c=relaxed/simple;
	bh=Qecvf7ITjTB/ZhS4WGl7H1zqtg7BMlvbRHe5ucYtx8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SnSFzV65REoXfDSAt8KL0jeiQyxoWVRCalBimkSipZlgTa1GxehPT8jve/5mYPzNJAGISIp28lv96JXlrDzZsOmQKYIUQqz/X6OYnc6EJw8279j7amtN67R25zkq7vRFgezedqhc2X7knfj9Se0KdvMF1K0f9MdVbcm0fmVxsj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UsWQOt2M; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UsWQOt2M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=hlQ0h3ULSsInnjdI4mm7/TeODzVpOFV4IF90v6SvTyo=; t=1770660746; x=1771870346; 
	b=UsWQOt2M44daC7ij/hbqleXX214/GVz3XGCwtwXv6wr1VNDbSv6l8Emv1yCtELQQ3c6LksUZRcy
	8hRWKJ1niD6G5wXCjNNhQso/LyAo07auP3tz2ry/VEbLboAapN+w6qzqsj7kXTK6U+frbII1J8OBZ
	Te90E1HJ7wH26SYggo/b98thurTs7IjJZkXlGe9K/RmwidQoadb9WyLMY+87tZfaeUmdzjFf0rFRa
	z4ZWFpC6j1G3bBgbOwFP2S4/IKNK7loZu/WME2iz0ihgcTgh2ciBD4pd6wa1XC5Z1NI3ZasXKmeOl
	4m9n6feZLgiOGmICatA/7hslkDHDrL6dxTBw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vpVkE-000000038YJ-21PO;
	Mon, 09 Feb 2026 19:12:22 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Jouni Malinen <j@w1.fi>
Subject: [PATCH wireless v2] wifi: cfg80211: wext: fix IGTK key ID off-by-one
Date: Mon,  9 Feb 2026 19:12:20 +0100
Message-ID: <20260209181220.362205-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The IGTK key ID must be 4 or 5, but the code checks against
key ID + 1, so must check against 5/6 rather than 4/5. Fix
that.

Reported-by: Jouni Malinen <j@w1.fi>
Fixes: 08645126dd24 ("cfg80211: implement wext key handling")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 1241fda78a68..680500fa57cf 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -684,7 +684,7 @@ static int cfg80211_wext_siwencodeext(struct net_device *dev,
 
 	idx = erq->flags & IW_ENCODE_INDEX;
 	if (cipher == WLAN_CIPHER_SUITE_AES_CMAC) {
-		if (idx < 4 || idx > 5) {
+		if (idx < 5 || idx > 6) {
 			idx = wdev->wext.default_mgmt_key;
 			if (idx < 0)
 				return -EINVAL;
-- 
2.53.0

