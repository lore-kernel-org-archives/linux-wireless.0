Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F9C4CF461;
	Mon, 19 Oct 2026 01:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373559; cv=none; b=hgGa2+VDcbN/D83If5r2uR0X4w9hLJyisCHzEmYzC3yDbhrnt5VrOR255YxoX0wgaHGXTmCQKkbyir4YMGbv5OlqOxdI+luJPLNomZrSxZsuN90MBjABD4PoaZSV0qJaSnfakJb6kgCzIteZLxaz9fs1MVyF21+aLWtiBOGjawI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373559; c=relaxed/simple;
	bh=NH96p92pKDtSl0oBNnwJUkq5TNAjqr8cqBjb7xKnP7k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EjsBu0JcM4Jz2bctBzDBnL2sGQZtfZfPC4H4Aa8tzRgSfz1oKLQCWzEPwajdQUFuzzPoSf0JJawRD1WKaGji7P88+JHy57mqWdZfKoT4IVbqkQFz/KfIBp81LRpOxYuQc/IuVm0hLARQaVER5Z5GpiXZdMP0mgPJK7KsDdG8eJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=GVU2wxJI; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="GVU2wxJI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=on
	LueFSTgMv7zyEEoRHRx+N4T3/KjiBeia9drbIDdhU=; b=GVU2wxJILpMTMa1F+h
	+pgxXKygNIVAwF/CKLzTpfGAEZ+IZhxywsxvRvbh/7QLHaMqOwyRTbXGfK48Zg3T
	so+47dDTvaTy9YDvkIk+Wnxnn7RoSjse+EmRHyw4ZtydZv7iaXJdfwPIDhS2uMD9
	89JLMhjRMzUWBqWg7qW/MnxY0=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAnfkEec9VqHwnJAg--.21892S2;
	Mon, 19 Oct 2026 09:32:15 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] wifi: zd1211rw: unwind failed interface additions
Date: Mon, 19 Oct 2026 09:32:11 +0800
Message-Id: <20261019013211.1489233-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAnfkEec9VqHwnJAg--.21892S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Wry7Aw47CrWrAFW7ArW7CFg_yoW8XrW3pF
	4UGrW7Kr1jyr4fG3y5GF18ZFyrGF4IkryfC3WfCas5AF4ktFySvF1UWa17AFnYyFW8CFWY
	vr4ktr15uanIkrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piF_M3UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzh-zLmrVcx+eVQAA3U

zd1211rw stores the vif and interface type before programming the MAC
and receive configuration. If that setup fails, mac80211 does not call
remove_interface and the stale type prevents another interface from
being added.

Clear the vif and type and restore the hardware MAC state before
returning the setup error.

Fixes: 459c51ad6e1f ("zd1211rw: port to mac80211")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
index 03948f0b4628..abbe25623b44 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
@@ -1102,6 +1102,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
+	int ret;
 
 	/* using NL80211_IFTYPE_UNSPECIFIED to indicate no mode selected */
 	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
@@ -1120,8 +1121,14 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 	}
 
 	mac->vif = vif;
+	ret = set_mac_and_bssid(mac);
+	if (ret) {
+		mac->type = NL80211_IFTYPE_UNSPECIFIED;
+		mac->vif = NULL;
+		zd_write_mac_addr(&mac->chip, NULL);
+	}
 
-	return set_mac_and_bssid(mac);
+	return ret;
 }
 
 static void zd_op_remove_interface(struct ieee80211_hw *hw,
-- 
2.34.1

