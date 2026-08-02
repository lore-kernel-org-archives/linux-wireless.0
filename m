Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CFB2AE76
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 21:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785704888; cv=none; b=YnsxemQI0GGzqBQzQiKfO9FXhL/zYBFLvQHLOSLnuDrOAbvse6MSP1D7Ow4kOjJ4aM/iC5BvXFNat+1ggL8G9ErGr3qNMqgDug3i1tN1U4c9TSyy/W4UrIY4GqM6odXdwxG3V9JeUNEGkESUW+vRqxvTh68hoOxUceQPGEnelrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785704888; c=relaxed/simple;
	bh=ZnGA7yShDJ516cawRRH6e/oM85Yox/RUkybSkMD1+tE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kbm2Ny3Vy/TwU42awZpZab6H/iX4MC6ZQsI54wTUmvVtUgrTpz0TgDm9uugIqIRpzwBQBlIC0+sD01RAhzs+42jShBB6rfWkQn1WOlmZou708mTVyVdG0ugKUI3kYbhfB/C2xyf48+f44k8kMTrPgxv9lo9i0Lud1KaR5Zg9Dhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=I5W+P5os; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="I5W+P5os"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=iYSjjoQ6Sd+tzanGITzXGGjfFXivGOmCrEP1ftxwvyk=; t=1785704886; x=1786914486; 
	b=I5W+P5osC7Y2KrH43rDVhvbWVe2k2RPbaT9yE6WB3ovA+VkcQuu70Br/pP0STVIxGd1AG4bKrhG
	0TyId/6fDJhTFFfew2+rG84C7w3n9cpAlyVVxop0nQyj9FGVkcykgr9B2EMdnz4dhQklIEuRw8tVu
	Xf+Rzg+8X8pzx4RST9j5AccFwicyW1l1vjs8qkvkTrU2YTmPu5y0GL6cbPAkkr0iZYOFwaR1iSwf7
	hsLQqlW1BJ0ht+DroMuLcEjFyktz9lNsDZazGMx7IvAF6i8CvyStHEkalAUSgeczjsKuL0x0DtI9r
	KZTexrPjK1QwEdGr9R99zAWPbhpr8vQUDT9Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqdPf-0000000E1Hi-0fcF;
	Sun, 02 Aug 2026 23:08:03 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: nl80211: don't export nl80211_mlo_reconf_add_done()
Date: Sun,  2 Aug 2026 23:08:01 +0200
Message-ID: <20260802210800.1733352-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This function is only used and only usable by cfg80211
itself, so don't export it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08670..8f022bb1413c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21523,7 +21523,6 @@ void nl80211_mlo_reconf_add_done(struct net_device *dev,
 
 	nl80211_send_mlme_event(rdev, dev, &event, GFP_KERNEL);
 }
-EXPORT_SYMBOL(nl80211_mlo_reconf_add_done);
 
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
-- 
2.55.0

