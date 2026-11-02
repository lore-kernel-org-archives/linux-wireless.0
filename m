Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653408;
	b=E4jzU2/xNRw3/AUw4BE23gG+3lR55zp1UzGJ/7QB+QCn0Xzi1lnYgWqgz63FDX+TW/wZ
	 Sf2r5GZVfc38o1CtbZR9d8glFZ0IR3oLCIeJ8vz9bKH5+Yw+ktnSmTmWc/A5zurl2KPiF
	 C3XuTLA1usesB8iOWMZuHKHzCs+iOZ9XwGYuqOO8my3jlp4yii87LX4uEl33CwULFdejB
	 Pw9vpXtd9aEjW0t5yOgWDaNNfLwqcjXuN3sPg/wEpphkb5zPJc/qikw59zf25E6CTwTyk
	 XEygpMawemw2w88cph8vkRP/c5oytPNgn9i9LuJ0NfpGbd2mTFGpI6jQeMs8zSWzB4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653408;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TuJ2ldsJC8+jJL460Itk1jlnN1VC1ICHcq/6TmJ/uhQ=;
	b=JXcF/l6vui7blrHAXzM8O42SRYXIL+P8rWU5n4S6zcisxEHJW0LN1Zv9oe+75wn67F1g
	 ySh2zOB6b9VkEHlpR6lvYW93L+EzPE/iVAUiwrtxiAkng6DM3vLyU8mGkQQAmjGh8Uj+G
	 8Cgqto/CRn6/DsCmOgSlXCvgEodN6Yg90byfU7SON2Hp0TKo6ZMpAMvfEheRcz4pyqarg
	 tXN+WXjfEEp6AvOPi5V25EEh1X/m4m04Uhm614OYifiG9GGUq6fxP4S5lIwxdF8uuj/zx
	 sScKkQu1tedAgUbAWqUS2bx8NDKI4vGlyonJ2uH+das8yivs3pbiGcQYa027h6czJ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=gfWH1iIL;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9CA606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=gfWH1iIL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=TuJ2ldsJC8+jJL460Itk1jlnN1VC1ICHcq/6TmJ/uhQ=; t=1793653407; x=1794863007; 
	b=gfWH1iILFVEGcIhBVGCuqnOPUKDHiQpmDwOrQkVnJQRAmpiEwEtGyzgbcYf789jRg2PDf9k2iiC
	p8rFTWpCDYm8XAba2AQNC8nI39XicmtuEZXEIkDsebOpEbXv9vw3Y4kwHCkOuSYBxhRI6Zv4EjhqF
	8WpEdKFxechDbMPwqvX2ONiEdlpl/Nt+ZRO3oVP1xPCCAg7syDDPjw54euhGb6v8a/y4Rpcs8FRRr
	C0c5nEDvoXggmCe3UNxe1NNFOI4XVG3J8XqeMPjgY9oCazbt1dYJkpqu5zQ64cUNN6JzjHa1NBheP
	Gs0LAHbBRH+j46dFiIUNvDZxo/3WTykoi7jQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzBc-00000001xrT-24It;
	Mon, 02 Nov 2026 22:03:24 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless] wifi: nl80211: fix ERR_PTR use on wdev disappearance
Date: Mon,  2 Nov 2026 22:03:21 +0100
Message-ID: <20261102220322.39fb821963fa.I69d89618155b337779d44eed78c51e5068bad42f@changeid>
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

If the wdev disappears during an unlocked dump that
the driver returned -EAGAIN for (to get it locked),
the code will attempt to dereference the ERR_PTR()
on the way out. Since it's obviously not locked in
that case (it wasn't even found), return instead of
using the error label.

Fixes: 599b8a3c549b ("wifi: cfg80211: support unlocked station get/dump")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..a49224a5f83b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9046,10 +9046,8 @@ static int nl80211_dump_station(struct sk_buff *skb,
 				/* this fails if the wdev is being removed */
 				wdev = __nl80211_lock_held_wdev(rdev, netns,
 								wdev);
-				if (IS_ERR(wdev)) {
-					err = PTR_ERR(wdev);
-					goto out_err;
-				}
+				if (IS_ERR(wdev))
+					return PTR_ERR(wdev);
 
 				/* try again locked now */
 				locked = true;
-- 
2.56.0

