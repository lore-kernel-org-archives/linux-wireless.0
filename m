Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="p3HSOpTU"
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06850173F
	for <linux-wireless@vger.kernel.org>; Fri,  8 Dec 2023 07:32:53 -0800 (PST)
Received: from mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net [IPv6:2a02:6b8:c08:d315:0:640:bb64:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTP id 16E8F608F1;
	Fri,  8 Dec 2023 18:32:50 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id nWgXPLCcs4Y0-J9Gpg8T3;
	Fri, 08 Dec 2023 18:32:49 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1702049569; bh=LT7fRfs8KC9k+kjaUKEuNtxWzom/y9E6tDR7zotRLtA=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=p3HSOpTUdiiujr1/6ojxEYgHwAXsFbSLZ+7UTr7jcsFcfbOlHruL3PE/gsy8Nxq43
	 T+dCkGf9KRfthwzWJi4wtHQBbOpAnyFO6acdJNPkJ51RkVjQccVrI1mTV1bZeyfnS2
	 nD2ExQcxTW+Yo8K5uS8+b48flJXPNqk0mpkypemQ=
Authentication-Results: mail-nwsmtp-smtp-production-main-31.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] wifi: mac80211: drop spurious WARN_ON() in ieee80211_ibss_csa_beacon()
Date: Fri,  8 Dec 2023 18:31:25 +0300
Message-ID: <20231208153130.107409-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The WARN_ON() in subject was actually seen only once, with 5.10.200
under syzkaller. It looks like a weird artifact of (ab?)using the
syzkaller itself [1], and hopefully may be safely removed.

[1] https://lore.kernel.org/linux-wireless/1bd8f266-dee0-4d4e-9b50-e22546b55763@yandex.ru/T/#u

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 net/mac80211/ibss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8b1e02f2f9ae..8f2b445a5ec3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -485,7 +485,7 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 				ifibss->ssid_len, IEEE80211_BSS_TYPE_IBSS,
 				IEEE80211_PRIVACY(ifibss->privacy));
 
-	if (WARN_ON(!cbss))
+	if (unlikely(!cbss))
 		return -EINVAL;
 
 	rcu_read_lock();
-- 
2.43.0

