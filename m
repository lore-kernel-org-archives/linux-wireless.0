Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8A0390615
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785660029; cv=none; b=let7r78OzFbTn39V9zY1TlQxmBPLQnTgkYJr6neHicJXPn4Ihy24SKFmXRYflwK1BR1qQTHLsxx1/AfjAwWJVgnrU3EhuLfepsPwxw/Ec5naRg5Obk+GYm10/kRmpOZY0/2fYIk/TZG9Djd3Sj1dbilRekiTm+sWxm63P8KKxu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785660029; c=relaxed/simple;
	bh=PT7hVwn7HvN7POJp1fsvDwrLtADAemWAXcCYDwHIhSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQp/+QW/pPWmd2Ze9FQair5b5NGfqdc5ZHpXh5ZdZ3LidPHHUw7DaE1gJcGQGehuTinXdXWxISvwPgVfdbfV5hTu1DGM1fy9NeyTsH14GYYO39hinnZDA/3ctDQHAoKIl33ymgI6/iTpfD6tNAjQy0752WUZnBIZcJyQHIMewyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=V/OT8rlj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="V/OT8rlj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=m2FR2fJmssPrZfBlJQRvrpxbJS+nH6wSt1MwJqT1tQc=;
	t=1785660027; x=1786869627; b=V/OT8rljvf9Gz0B88dQsTx0A2JWw2mQtZlYR8CNF6pTV1XQ
	7yt5cSwIIjxPcNGF+wM8tRpiO/GR8PlIez8WQ+FAoOJm6ffp1ww6GmHBj14FngIWszTfeohzTijGt
	aSPtG6ruBKtzsC6x6W5+BfCsuUlftJ6UvHdIPAI8JSEDqfHD9z72EIYlnHFJQsllZxVMs/5iQyBNT
	qiD/CQRF0RzyymP8VkGmxrzVjhacPbzvVw1qmTd9fx+6CBLKQSgtYRQKU9Tu4mUsGkDXc0tiIvoVg
	C6TT+v2Z4yj47TKMdjIE9t2alKZIh5qyY2/4nwZskFLPhttCsbnZnQZ1qZhsZS0w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqRk1-00000003w08-0iLA;
	Sun, 02 Aug 2026 10:40:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: fix RCU usage in peer probing
Date: Sun,  2 Aug 2026 10:40:10 +0200
Message-ID: <20260802104010.6c09477032c4.If024b480b96bf9fe7baa821ed48b80be322d1e44@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802104010.94bf0862c329.I0a05bf8ab999cb737c487d79082425257e10132a@changeid>
References: <20260802104010.94bf0862c329.I0a05bf8ab999cb737c487d79082425257e10132a@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Converting the station and chanctx lookups to wiphy_dereference()
was correct for the function itself but removed the rcu_read_lock()
for the later transmit, which requires it, as well. Fix that.

Found with the ap_open_poll_sta hwsim test, which reports

  net/mac80211/tx.c:608 suspicious rcu_dereference_check() usage!

(and four more like it).

Fixes: 1c3f880ed00e ("wifi: mac80211: implement STA-mode peer probing")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d42f8df9badc..23ae81b88669 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5035,7 +5035,9 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	local_bh_disable();
+	rcu_read_lock();
 	ieee80211_xmit(sdata, sta, skb);
+	rcu_read_unlock();
 	local_bh_enable();
 
 	return 0;
-- 
2.55.0

