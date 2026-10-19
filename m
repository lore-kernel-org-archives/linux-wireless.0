Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72F3343D85;
	Mon, 19 Oct 2026 01:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373544; cv=none; b=hfs7+taRGTRlpYtiM4jm5R2Xn+7PVNUHVt7ZAZayER2Nx3hdYpvwHArpBarlkd+aP4Xis1vNgUw07BDGcLt739skitD4023OnBB2NX7GN+zkhJfdgONJK64QvCYWy9jV9cegijrf1OtdKC7VqHQ4NfUsaqg4x8ortwmi03BYUxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373544; c=relaxed/simple;
	bh=busPEMuaioz+nTRoij+Gs6oW6KafeqEn7gD90vy21pk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lCowqhviB52HskmnucEncawSIGfmnVI1UJTtNlNwxO5MLlJaK1l2bAkFjJNjxWQz2AIWr0ENvOatW5es9UxIPH9zMw4wvUjFVn0H/QNsBxJFyKHKoMe2eAdnO6RHc+VHgnyjPkVgVc6ItdOi+iXritGcNvShNiaAYU8TfkvkT/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XeVqd7Pv; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XeVqd7Pv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ra
	XwGJrDy6pGPg58/To3J8V4Bg65cogK7CHPkkeMMvM=; b=XeVqd7PvnDdkCztFlc
	8g/2r1caBX1KCqiwZHdzxVXfRv0WoSsYYj/fzFr5IWpl/x0nafZz/uhOvNO2O/Rp
	jTerqgP5IKOEejESD6Irqp8gbcfZIbbSzbpT5XUL9GWD3koLUgDPUPWGfnS8JbdU
	K78qCge4kjAa7eInZop00WvgE=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD337MRc9Vqd00yAw--.38211S2;
	Mon, 19 Oct 2026 09:32:01 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Solomon Peachy <pizza@shaftnet.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] wifi: cw1200: unwind failed interface additions
Date: Mon, 19 Oct 2026 09:31:58 +0800
Message-Id: <20261019013158.1488968-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD337MRc9Vqd00yAw--.38211S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrKFyUKFyrAryDJF48XryUAwb_yoW8Jr4Dpr
	WDCrWxKr4kJF45Za1xGayrAFyrWa9rWr9IkFZ7Aw4S93Z2kry5X34vvFy3ZFy5AF4kGayf
	Jr1vkFn7WFZYv37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pirHU3UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRHwK2rVcxH97AAA3L

cw1200 publishes the vif and changes its mode before cw1200_setup_mac(),
but leaves that state in place if setup fails. mac80211 will not call
remove_interface for the failed addition, so subsequent interface
requests are rejected as busy.

Restore the empty monitor state when MAC setup fails.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/st/cw1200/sta.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 5d8eaa700779..92a729f1e9ef 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -235,6 +235,11 @@ int cw1200_add_interface(struct ieee80211_hw *dev,
 	priv->vif = vif;
 	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
 	ret = cw1200_setup_mac(priv);
+	if (ret) {
+		priv->vif = NULL;
+		priv->mode = NL80211_IFTYPE_MONITOR;
+		eth_zero_addr(priv->mac_addr);
+	}
 	/* Enable auto-calibration */
 	/* Exception in subsequent channel switch; disabled.
 	 *  wsm_write_mib(priv, WSM_MIB_ID_SET_AUTO_CALIBRATION_MODE,
-- 
2.34.1

