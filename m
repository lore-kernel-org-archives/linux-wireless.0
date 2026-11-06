Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980019;
	b=KOSm2kJuhwX10FT+weZjiDRWAu0NFjiWH1slBqHVfizy7gJw8I03dLSglThZVmKMkaHH
	 vuE2ow7eh3A9v74xPOnJrp1rkU7hvx61iHZ/XJoo3d5U5mgmM8FVWiSJ0KDygMoW6bsFv
	 oHPPwOgQlMoNwpXTe5a4fPU8YgoXCim4JC+awWB3hVdazOcjzuJkj/43ijERl+9Ciz8fE
	 lhlOPeM6EYUSLOgeduA1AEzIbm07k/JteK+oGUxe5F8Xgf3xK9eBv1oJexFnhYhl9+3+b
	 HtV0clT0x6GWun/7GDsjeFoUKekckN0h9DLFSuwIWk6b/uHSraVTiyCyu48CJq+KrCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980019;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=D1QBFRzPXFFgy/L7JYOXmPlOw49NVVBCezg5DcfdvnM=;
	b=jxfg/aV2Bv39xmuuEVGPZpU3szNWWWd5vNY/OkrH6yJQjCqUFZhMOXs+ZBTmugERjJdw
	 ADMGR/pesTcQwfBAlzLtgqekzgF2WkqYWixwaB68DzQuThtbTcsK8Gy/OG47Wl/gY6wzK
	 lDi9rHx4/0H2AHJf8a5CpxYu/iVJwOZmusBEsCAmp4stw7Uniz+UMDtGhPIYnr8XyGtj/
	 L/FDIpnkBkICz+56qS+9TbEmhh8Mo8Z9pb6wIU3IimKDeFw54M2uYhX+zns68FUJqUmvV
	 MEJ+hc57hkYRCF3TtCje7X2QCGlXsRfsJFEHsgzP/ejSaKm4vtL0JtYxgbk1lxVAerA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=LVMfNvyW;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD451606A32E
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 15:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD451606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=LVMfNvyW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=D1QBFRzPXFFgy/L7JYOXmPlOw49NVVBCezg5DcfdvnM=; b=LVMfNvyWuPYxyWY6esPoauamw4
	2Nf3TjI2R3OtUH2nF81Rn9US7dlioJKPK/E+Mjp+j6HJYhZIpqz8vqrp/8rfTPwuWaipnchERLE8o
	HD8xwtrHWxmp9xVACKlM4I3t91nNGg6cbp7Gp25D5Jw7bDWevJoSfRnhKgfuFrv4V+i0=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xPM9S-00GvLl-2m;
	Fri, 06 Nov 2026 16:46:50 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless 1/4] wifi: mac80211: keep the monitor chanreq empty without a channel
Date: Fri,  6 Nov 2026 16:46:45 +0100
Message-ID: <20261106154648.1228594-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
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

ieee80211_do_stop() releases the channel of a monitor, but leaves its
chanreq filled. When the monitor comes back up it has no channel, yet
the RX path still filters on the old chanreq and drops all frames
received on other frequencies.

Only keep the chanreq filled while a channel is set on the monitor.

Fixes: f92e0cf19ae0 ("wifi: mac80211: filter on monitor interfaces based on configured channel")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/cfg.c   | 6 +++++-
 net/mac80211/iface.c | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9608c07bcea7..bb95173af405 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1165,8 +1165,12 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 	ieee80211_link_release_channel(&sdata->deflink);
 	ret = ieee80211_link_use_channel(&sdata->deflink, &chanreq,
 					 IEEE80211_CHANCTX_SHARED);
-	if (ret)
+	if (ret) {
+		if (ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR))
+			memset(&sdata->vif.bss_conf.chanreq, 0,
+			       sizeof(sdata->vif.bss_conf.chanreq));
 		return ret;
+	}
 done:
 	local->monitor_chanreq = chanreq;
 	return 0;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d0b0a503b229..de9250bf38b0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -758,6 +758,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 			break;
 
 		ieee80211_link_release_channel(&sdata->deflink);
+		memset(&sdata->vif.bss_conf.chanreq, 0,
+		       sizeof(sdata->vif.bss_conf.chanreq));
 		fallthrough;
 	default:
 		if (!going_down)
-- 
2.47.3

