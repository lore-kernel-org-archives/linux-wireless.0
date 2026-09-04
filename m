Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE794E80A9
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534081; cv=none; b=OLwThKF035mA+BVpJ6PHOcCtETPqXD08JKoFdrA66ZdopX/CkEgPixaXyE7FQDjtl2F45ga/J4dZmjWPMzk/M5f5XDnjMRg6mzVvpdleRFn0HGtXo0PbbVIbNsws+1+sJasvMye8wJpLmufKlG7WrgWN856y/OHSEDo52gPGn/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534081; c=relaxed/simple;
	bh=XeNmHRlBxm5r8WZbLXiZP1IggqExH6gE7QHr+I8rtkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHse/dPOovFLGhAiQdhMDGU9Vl72zKXMwLsCgGXCvCcxGqM93krDxHFrfwZs3rITmgMojjQblD+A7SUhM3UfEHTn+1qmVTcFulMwsrf9tfc1ojgkOsBvn7DxZdu7RMV93HY8KQnIjd5U/CMCicwIGCC7MI9VRvCOzrlnL9sZ8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=m0BARFQO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="m0BARFQO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NgNyW7TLF9JyAAFaU/9Wx0ubArwetd440zQFqFgloC0=;
	t=1788534078; x=1789743678; b=m0BARFQO6LteJL6mo0EWCDBp4RQqJ2rg+UXWs0uxfT96fH6
	H3pbAhCf0QRjPAApixY7bUPQDJ+xPgJMjKTEqgB92tdNLLfpkPaOyq89ufCgHETZ/bgpoKDFwRra+
	Jhxr4oj0Xa2QXlTaV2HxZo8z/5JgVSRoS+VE5twYDG8mB31SD2jrvV61V00Eeg18j0Esz55aRNXSB
	97umMa76F7kCOXOQgO0jG5wOrbUWn+xYkZwzyv4kwZCzI0xrOJwgTaUXxSou7qxI1YqifAMDIva7x
	3qKo1K3mCSgnod7H+VqHXGXD1z8qAzI0HLDViHk1DODdZSJgmvdQpXBOK+sXJ+6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPm-00000001SeL-4AoL;
	Fri, 04 Sep 2026 17:01:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com
Subject: [PATCH wireless 05/10] wifi: mac80211: don't RCU-dereference the mesh CSA settings we just set
Date: Fri,  4 Sep 2026 16:58:04 +0200
Message-ID: <20260904170057.30c3a1780224.Ia633160bc01e1ad1b30a9f44446728a747f2b16a@changeid>
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

In the error path of ieee80211_mesh_csa_beacon() the settings that were
just assigned are read back with rcu_dereference(), which lockdep then
complains about.

There's no need to read the pointer at all, tmp_csa_settings still is
the right value anyway.

Assisted-by: LLM
Fixes: b8456a14e9d2 ("{nl,cfg,mac}80211: implement mesh channel switch userspace API")
Reported-by: syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b59873f5699e941717ca
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index bed7ac838250..a35e2d5870b6 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1559,7 +1559,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.55.0

