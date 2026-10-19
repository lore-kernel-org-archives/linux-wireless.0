Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B811A682B;
	Mon, 19 Oct 2026 01:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373487; cv=none; b=SJlE9h1dzgGiFio+ipiY5xqVyu/anKYn6atSgNfLRbn9sP+ehDhji0W/2qXGg2jdsvvslTCmDepRCAqu2Ny6kT9q3VONBxKahx4wwETFQVdj3In5BLZL8kVDzYfT1HJVP93wDNvBMv3i72UpLRFt3U7PfiNYCIjANccF0vkqS0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373487; c=relaxed/simple;
	bh=sCdyTZ67jTOIiaXat5qXaNr9R9GLdZiPNc2+Bj384bs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=koyt3KEWc0VuGqeBUKcI56GXv0VFmy3apMIHBm8AXBJD90jvMEBnzcAqHMJVaHUGDaNTCY/4PBCUO55PNL8M4S2d9HM6kFPJy3agbsnSytHWMMS39PSH73AUZr2GgUZNBAacVc4DsWNdXfTVfgyGHJKc/UCzWEoXOEXDpRbeUEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=PKkYdPlN; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="PKkYdPlN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=S6
	MuLUT3S/7cmqKaPzxm3WCl7cdI7ecv9ygcgEc7WpU=; b=PKkYdPlN2hz4oXOyZC
	YfNzjO/lFvv1S6vArtEVjHMxdlff3RXCV5aFVurbmbqyJtVxEfGpahwUTAd0R6cH
	2HysAF4dmcj3MTCC6bqDH+OCcdkfXFAcG7q2lCAzfsCo62wsdH9x4WI83wFnkJ0x
	B1aV9fJOxGTtLAgTQalv2yZp8=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3H8HcctVq9ZioBA--.28112S2;
	Mon, 19 Oct 2026 09:31:08 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] wifi: p54: unwind failed interface additions
Date: Mon, 19 Oct 2026 09:31:05 +0800
Message-Id: <20261019013105.1487978-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H8HcctVq9ZioBA--.28112S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr4rCFy5WFW5Ww4xGF4rKrg_yoW8Xr1Dpr
	4jk3y7Kr1Uta15XayUGF45ZFyfCa1UCryxCF9rCanYkF1vyFyfZw1FgFy7Z3sakrWrJa15
	Z3W0qF15Wa9I93DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piYhF7UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhzjHmrVctyXDwAA3m

p54 stores the vif and changes its operating mode before validating the
interface type and before p54_setup_mac() can fail. Since mac80211 does
not call remove_interface after a failed add, either path can leave the
driver believing that an interface remains active.

Publish the vif only after type validation and restore the monitor state
when MAC setup fails.

Fixes: 1ed32e4fc8cf ("mac80211: remove struct ieee80211_if_init_conf")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/intersil/p54/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index 57a62108cbc3..69d85efb9260 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -236,8 +236,6 @@ static int p54_add_interface(struct ieee80211_hw *dev,
 		return -EOPNOTSUPP;
 	}
 
-	priv->vif = vif;
-
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
@@ -250,8 +248,14 @@ static int p54_add_interface(struct ieee80211_hw *dev,
 		return -EOPNOTSUPP;
 	}
 
+	priv->vif = vif;
 	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
 	err = p54_setup_mac(priv);
+	if (err) {
+		priv->vif = NULL;
+		priv->mode = NL80211_IFTYPE_MONITOR;
+		eth_zero_addr(priv->mac_addr);
+	}
 	mutex_unlock(&priv->conf_mutex);
 	return err;
 }
-- 
2.34.1

