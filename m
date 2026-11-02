Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651919;
	b=ewfuq6qC3lZDoylwCmv2AU7dWWQ4JdF09kUHrLE8OGBoV1/3xnrL3rK+Na4I3uRROFUo
	 3lWjZB1QBjFNYYqoARCa1OKmiIHUi945nIOuuUrT11vVJaGbYyxUhWTyIv28TmetVMz+5
	 +1Nc36QXx1vzNlComYYzSwML0tZquXwtrLj/OPNOk1P0OmGN2RHgrLu3GixKmYbTUxTCk
	 7z2JMnYJ48bnOtRoSgKMI9TsuhSJp8WR/cLdSLgDATQF4Pu6xyhr8edvG6aZT/BlI8yPf
	 nPux+Q4gTTtU5AIBFQdLLCbvx2B8srgeTr/cdQi/0BKiykhISW9ssLBhg7ovX7BCg2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651919;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eBYgbtybZ6XBkGVdFqExcQwRwtbzahCZ7En/lsSyjXE=;
	b=23g2k6/oJZE9cyRkKok9gJbqxvVdtjFUuPMW8RVYycpUUYaja202i1IYC9o0xlGQfN/G
	 g5SCme4gpb6BPbOWhG2dtaR+SBeYkRhOzkPPpRLkQhuJBuie7U3+l+2I6NIfyBkZSjANU
	 IKWcEdCnkhW2hHOyHxG3CMnwTGSwp6M5v53bRGNNEcBjpu29V2GSTUmIgMaS00uyH3yJ/
	 3MsrnfJa+VIUY3TFFFh8zXIyiMEL+kxISTeqURekfPjGH1iG3HfX7FNRJJ1NULYXcG06t
	 f6wlxpmphWsJOKBXIDH19W+QkUaT5XQUGy0HZbZSVhrx1cvPvAJZ8qt7atifdTmJvWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=iOMvaFlW;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F975606A329
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=iOMvaFlW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eBYgbtybZ6XBkGVdFqExcQwRwtbzahCZ7En/lsSyjXE=;
	t=1793651918; x=1794861518; b=iOMvaFlWih2cyel5v2fWWSonDwL2X0lLjmPsCnRRRGtDDD9
	HnTa7zbE2C2CbMvqLdikNho4pmYwiLnvX0IJZO7aVaGfHYHB8rOsxjN9m/BLi0Fk+LTQ0sSgpntIo
	DNCO7TojD99wZDMsZHQaTbnKlwRtLz8JxuIUbftCinVjcYiQYaW0gPbdOLkU+vnYVpXJC396MzsDt
	5nDaBcPbGAA5JQe1Z9FBSA+EGgVQrJU3753rASXA7ThS/0u9ZkYD/yaNyep/QQippS0RyHsizj+Be
	auBQ7nD9LKSy1Cx9OeaBOuMoTJ242O6C0yd2EP7FLlfQV7QRH/7REMjJV3A08Tdw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNync-00000001vzr-0x3x;
	Mon, 02 Nov 2026 21:38:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/30] wifi: mac80211: mesh: clear PS_STA flag when peer wakes up
Date: Mon,  2 Nov 2026 21:22:51 +0100
Message-ID: <20261102203831.1058362-33-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
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

Since my old race fix, ieee80211_sta_ps_deliver_wakeup() doesn't
reset the WLAN_STA_PS_STA flag any more. Evidently, I forgot to
update the mesh code, so mesh peers that go to sleep are never
considered having woken up ever again.

Set WLAN_STA_PS_DELIVER and clear WLAN_STA_PS_STA before calling
ieee80211_sta_ps_deliver_wakeup().

This commit is ancient, so it's tempting to just remove the mesh
powersave implementation entirely, but this was easier.

Fixes: e3685e03b40f ("mac80211: fix station wakeup powersave race")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_ps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index ebab1f0a0138..0ec207ee845b 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -272,6 +272,8 @@ void ieee80211_mps_sta_status_update(struct sta_info *sta)
 		mps_dbg(sta->sdata, "start PS buffering frames towards %pM\n",
 			sta->sta.addr);
 	} else {
+		set_sta_flag(sta, WLAN_STA_PS_DELIVER);
+		clear_sta_flag(sta, WLAN_STA_PS_STA);
 		ieee80211_sta_ps_deliver_wakeup(sta);
 	}
 }
-- 
2.56.0

