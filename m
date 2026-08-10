Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32A386C2A
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786337649; cv=none; b=tK1sVCt8M8kXsCI7P6gpkNxdUZwufvXBqKsl/6i+Ved2f+nzAyFfH2ds0MPycgHynwaFyi58d6PDGhtzLq0AfgDRAsl/ex2bSxpBSviGgzQ8WC9nnLU0djR97y30EOFGMIa9Un67d0j2t5UxfH+eMGTylvd7HTmeCSrcv628vPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786337649; c=relaxed/simple;
	bh=LO7PjTiOBv5reVhI9OJ04+r6QOBjVbOHLZGCPkWU4IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUZC5xMYBExFDKH8UxvHqTQ+9WoL7jKj7+FUlFix504epHBwdWaN0Gj0tqV3qw3MJ3KNUfc0yzRFbSead8KWzXN4AZKmmWWYMWzAOQfhOs5VwT6EgDnMZ1kOWng4j/mZKxmoz1ZHexG1t3MCTsew6FNfTWPuBW4LwjXzQ+q3I0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=Fj8CkSJc; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="Fj8CkSJc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1786337642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wwr5kmWf5hpa0pEkxAw4sYvKXnvwgXIL/4/Lx7PCg6s=;
	b=Fj8CkSJc/vKPgVC95rOhBx9fgZm28mEge18/Jb7H0EjKCV3xdJnI7xOv8LbmJTm45ffPJL
	NuLAtu3CucZrBLuXUx9wECa49oiH9rPRU6My26Xa56MWShcI3NqC23MzMIINB7luJhMbVx
	ZR9fkbke0NLNl4gZ7u3Q5er6BenCIW1Vqna7O/H/EsPlDHWdVZr/NKar3d3UcFEx0Juw6P
	XFKR3xUgA8Kkq6OSYcz3co7n4pLCL+48n/RjCUt4G/Nxw1C4g5vjeURt7MweSK9+yVo0sV
	xz2GTv1Re67deBPHUB1NJqSJDvCya1fCnaqcF0G7JG+qyu+Izq8/iSN/2EAxEQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH wireless 2/2] wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_mtx
Date: Sun,  9 Aug 2026 21:53:38 -0700
Message-ID: <20260810045338.118923-3-lucid_duck@justthetip.ca>
In-Reply-To: <20260810045338.118923-1-lucid_duck@justthetip.ca>
References: <20260810045338.118923-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mt7925_config() has the same inversion as mt7921_config(): it holds
dev->mutex across ieee80211_iterate_active_interfaces(), which takes
local->iflist_mtx, while mac80211 calls drv_unassign_vif_chanctx() with
iflist_mtx already held.

.config is only reached through drv_config(), which asserts the wiphy
mutex, so use ieee80211_iterate_active_interfaces_mtx() here too.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 2b6cc8e253c0..b42564283a01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -816,9 +816,9 @@ static int mt7925_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		ieee80211_iterate_active_interfaces(hw,
-						    IEEE80211_IFACE_ITER_RESUME_ALL,
-						    mt7925_sniffer_interface_iter, dev);
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7925_sniffer_interface_iter, dev);
 	}
 
 out:
-- 
2.55.0

