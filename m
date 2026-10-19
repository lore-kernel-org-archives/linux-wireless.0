Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5693451B3;
	Mon, 19 Oct 2026 01:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373570; cv=none; b=Yo8EQyiUCvGsJUmdAkENm/aDXUu0hP4d/+gEkag4hPpzDHJjS+OKgdWifmlbehnyd352Vg8CHpmSkcBA97Tv5jDaGTAZ/C83XNlej+5LkMh3N0sAMHOPtLaP0Xkm9TVoPT8/FO0je0c9K5Tv0k7TGa7oKGF2ZqoAaIPA5tTHLt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373570; c=relaxed/simple;
	bh=EihWXuU2SzMe49bGnLeChZxXjMHPYrb8vW8mwFZIEBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rkXGb3Q8wDyctBqOLORaxon7K6FL9pcSsYLbm/rI8t1Mpbs2+n4MhKyv+Ot/DAyErAkfo7p37v4RHyIBvVCNqASFWr2qn9Yme9lQgdKnF9+CHw0hvpKPdNAh16/9P896pKs2n91zvGUcL/CHaMMYHTp1zdsi6oQ3RQ5V9YD3pwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IxfTPeLk; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="IxfTPeLk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=b1
	99l97DoTZZKVGtixU6kfuqebMbYMgI0bsqB1/8bH4=; b=IxfTPeLktkmuc4NZjA
	19TElVLQp7lR39OCcQzlYMnki+dZ6KTVcHMArg5QI1DwhnsMz0kWaCgOMBTC2ipF
	90oi65Cp+4wa7KK4m4KIZfMgaan5lZGEo6MW861IwS8IoOLhbjWmnNNVBVqoNG23
	twiyxfc0cs3/e43+nmQ5qk38U=
Received: from pc.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgB3sQgpc9VqLZuVAg--.15458S3;
	Mon, 19 Oct 2026 09:32:29 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 1/2] wifi: wl1251: unwind failed interface additions
Date: Mon, 19 Oct 2026 09:32:23 +0800
Message-Id: <20261019013224.1489500-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019013224.1489500-1-yaojiale02@163.com>
References: <20261019013224.1489500-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgB3sQgpc9VqLZuVAg--.15458S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1ruw1rCFy5AFy7uF1fCrg_yoW8ZF1fpF
	4DtFWDKw1Dtr18Xr43Jr4YqF95ua1xGryxCF4xAa9Y9F1vqFyfZw1xuFy3AFy0kFWxAw4x
	ZF9Y9w1UXa1jkFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pN0P-fUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7w33MmrVcy00jwAA39

wl1251 stores the vif and updates interface state before validating the
type and programming a changed station address. Failures leave the vif
installed even though mac80211 will not invoke remove_interface.

Publish the vif only after all fallible setup succeeds and restore the
previous BSS and address state on failure.

Fixes: 2f01a1f58889 ("wl12xx: add driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ti/wl1251/main.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 0f3f22e729ce..306dd6379931 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -481,6 +481,8 @@ static int wl1251_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
 	struct wl1251 *wl = hw->priv;
+	u8 old_mac_addr[ETH_ALEN];
+	u8 old_bss_type;
 	int ret = 0;
 
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
@@ -496,7 +498,8 @@ static int wl1251_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	wl->vif = vif;
+	memcpy(old_mac_addr, wl->mac_addr, ETH_ALEN);
+	old_bss_type = wl->bss_type;
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -507,7 +510,7 @@ static int wl1251_op_add_interface(struct ieee80211_hw *hw,
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-		goto out;
+		goto restore;
 	}
 
 	if (!ether_addr_equal_unaligned(wl->mac_addr, vif->addr)) {
@@ -515,9 +518,17 @@ static int wl1251_op_add_interface(struct ieee80211_hw *hw,
 		SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
 		ret = wl1251_acx_station_id(wl);
 		if (ret < 0)
-			goto out;
+			goto restore;
 	}
 
+	wl->vif = vif;
+	goto out;
+
+restore:
+	wl->bss_type = old_bss_type;
+	memcpy(wl->mac_addr, old_mac_addr, ETH_ALEN);
+	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
+
 out:
 	mutex_unlock(&wl->mutex);
 	return ret;
-- 
2.34.1

