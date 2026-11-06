Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980019;
	b=kg2gG3+IvTEEdMGNWzh2nVaU4gOYIytH6eZu0rZUFGkuU/sz1yUsX16A548JZg2k1U21
	 GuaTOyuFQI5B8Ez1YoeSFFKMsDYBMlniV49MaqOYnJlwpD+QuxUMwnlgWmR5mLRuew5zm
	 mYLloZosQwwDF/cZI10enMS9lqKQBbI98SV5rYf6hAhubkvjFP35cQxGFPooUYTNP0ftA
	 L1ExbkfXYjZuY2+M7cgjmqksbIuPE3cQyZ3QXry4pC4/iCLkDDwN8dqEkrvtHcYvfpV9j
	 Z2BcbSDKcN3O5gNS9wkBgUvM7qPM7KXFMGQfri7yW/R5li7wX4wLn6THY9+h45M1szQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980019;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PJtPiFd6AQQuvOaoOKeBbrB3MceMNqMhbssmd9iEifA=;
	b=Qmw2YlJlZuU2cPqQ6abZynZtIQieJqG9Wx1MSlmW5HacCaj/ZJ8Eza3iTsVnNq/knF4m
	 BM97+59zrnfkRbF75enorYGukmhvxdzfmS3B9EChUWRqVYk+vwItcUwIjU1kHmBEJGI1c
	 RDMrQGZF1nG71cTYUwtA/r6OFbP1vE0EoY3FJp+O/LW5MA73CPHCjqI5/YCW99EK8lRwh
	 +mVB9VB94o84cwMe3BbGVo5hloOu4IaWLup+dtiLZAhKX3B0UfK4ACWuAdgMC9RscZw8X
	 RlAxuN3CG0nUiP8HMsAccUtFEl+nZdD/EGPGyE2LRWxB5qc5fW1+S8y6Xxq7ayqlMSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=sQq6Wr37;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C22606A329
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 15:46:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36C22606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=sQq6Wr37
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PJtPiFd6AQQuvOaoOKeBbrB3MceMNqMhbssmd9iEifA=; b=sQq6Wr37EvsSFkgeQTgEMKseDZ
	D1tItfHlv8wnp2UakDpMevTIX5GX9d1AqdX5u8+Ja6o0JWgXvOqMh+qo8cVO6rJbwo/RRS0lpNVkP
	UYfqCFGbR+XoK3c/VcLOe5eZ4jJcSaTkAyKqp9Y5nY2S9rFA8hzsKGU5ozRaiZAgb7eM=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xPM9T-00GvLl-1S;
	Fri, 06 Nov 2026 16:46:51 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless 4/4] wifi: mac80211: reject a monitor channel without a running interface
Date: Fri,  6 Nov 2026 16:46:48 +0100
Message-ID: <20261106154648.1228594-4-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106154648.1228594-1-nbd@nbd.name>
References: <20261106154648.1228594-1-nbd@nbd.name>
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

With NO_VIRTUAL_MONITOR, ieee80211_set_monitor_channel() applies the
channel to the interface of the request. While a monitor is running,
nl80211_set_wiphy() can send a request without an interface, and sdata
is then invalid. A request for another monitor that is down triggers
the warning in check_sdata_in_driver().

Reject both requests, since the channel can only be applied to a
running monitor.

Fixes: 9d40f7e32774 ("wifi: mac80211: add flag to opt out of virtual monitor support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/cfg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bb95173af405..9dc39adc2dbc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1155,6 +1155,10 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 		sdata = wiphy_dereference(wiphy, local->monitor_sdata);
 		if (!sdata)
 			goto done;
+	} else if (!dev) {
+		return -EOPNOTSUPP;
+	} else if (!ieee80211_sdata_running(sdata)) {
+		return -ENETDOWN;
 	}
 
 	if (rcu_access_pointer(sdata->deflink.conf->chanctx_conf) &&
-- 
2.47.3

