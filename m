Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886D54E8DED
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534079; cv=none; b=aF/VWzn61Q6yYO3aK0UPimTxU/dwQpg8cN3+e53fq+prgb+0aMWDoVqQIE5TpL2A+bqAWq3WwWYc0OXv5CFNrkPbU0cYtNksshIdSzJyFOPDSPN99Yt3pQXbz+sJHQ8OUgujS8jKxm5DRgOBjTfTd2zJLlf5XdAzbnjvDsoL9ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534079; c=relaxed/simple;
	bh=4evQ6mgYVVil0DkpyJ/B3pcNoU4tDbiFrOWVFydUFGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCSgVYCakm1+m8SXohma8GqSz6sSBYGf1h8c/025HPSqLlVXTWRwTOeGObuN7uYCikBEAv9uiiD+YDOG6J6Njqkqr3XnK32YtC57fGlmtVG/9uWxN3V9jpiao41OJyC9tTKMh3OqNOT5QZzH1qfZvXwBMVhpcJYUS0+TnJW7VlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PVIJa/rf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PVIJa/rf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GApykz5RrSng+Bd/BW5TcQmMODeuNzscx3bbYHkVgwM=;
	t=1788534076; x=1789743676; b=PVIJa/rfHi/D8e5R9cU73KklAOljYVG1If2KKXbzXF/ZeDH
	cZLH82PkgpdYYKbBAvxzGBpjWSi2sdV2Tux8XpVFH7zbWaL+4RzPuokQOehpuX6g7bXwI0hNZcIzM
	c+AV2EhrSoeYhjjSv1fAmqIRqxTUzsUIwmM7jxfLojG+L8nkIjOLkFmJZ3piOoxQ49lE/ar4yf0wk
	fn/mPwe0RlJSuMxfNmfNvl7tTbgB97wfaHJtfXMl0Rk36uxZeq8P5ps1ODFir1yXFbB/OsgxeXI09
	SQifugilaJS4FV8ijrNZ9lT6Hh2cZZSOCPNgbUqQahA3JnGLrcehjl0DC/0WoK/g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPk-00000001SeL-2Pm4;
	Fri, 04 Sep 2026 17:01:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com
Subject: [PATCH wireless 02/10] wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
Date: Fri,  4 Sep 2026 16:58:01 +0200
Message-ID: <20260904170057.1f4fc05e5663.Ic863c2fea0352a9282006378bc9c9dedbe27c037@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150057.424369-12-johannes@sipsolutions.net>
References: <20260904150057.424369-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

On ifup, AP_VLAN interfaces get crypto_tx_tailroom_needed_cnt from
the AP interface, but it's never decremented again unless the AP is
also brought down. Thus, bringing the same AP_VLAN up again will
increment the counter again and eventually hit the sanity check:

  WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt !=
               master->crypto_tx_tailroom_needed_cnt);

Reset it on ifdown to avoid that.

Assisted-by: LLM
Fixes: f9dca80b98ca ("mac80211: fix AP_VLAN crypto tailroom calculation")
Reported-by: syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3ee5362db09487ea37
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9c10d2f0b8b4..ebe3b068c7ea 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -616,6 +616,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		RCU_INIT_POINTER(sdata->vif.bss_conf.chanctx_conf, NULL);
 		/* see comment in the default case below */
 		ieee80211_free_keys(sdata, true);
+		/* increased by AP value on ifup, so reset on ifdown */
+		sdata->crypto_tx_tailroom_needed_cnt = 0;
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
-- 
2.55.0

