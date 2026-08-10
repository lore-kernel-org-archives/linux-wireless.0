Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AF632B99F
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786377335; cv=none; b=d58uRLr8YgAnf+DR0lGhsNrX76TzM3ZlrIa64iSsYQ4bB8SumhuTSHNgkKy2JXmiaCGou5cmj40WZST7M7CkfHtIYLl+O+C8+aTpAQ8sK++rjZ0PeVWG7/SHJ+Oxk/MzXVO+jspnZ9MSSTqHtosvolU68FErfe0aZ7XLt00dZdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786377335; c=relaxed/simple;
	bh=AcffZDB0/rtkjU36puzUyA9XtqNmv41yfok2gLujHk4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oBVtp5NbbpjX+Oi3Tc89PJ/bHXr6u6oxC1Ows9KWvrUQ4M2QN/rE2ZMu89WYw+HgTi7UNTDJG4beMUDN6+uO0bG0VhkDuAzX/izlkg9PZ3RqQQd8zCgTllYm4Pd/zF20niLfGVm8G3LrDfk/Ojyvt7wBZiOMqy5VYsATXoCsk38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr; spf=pass smtp.mailfrom=green-communications.fr; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=green-communications.fr
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue011
 [213.165.67.103]) with ESMTPSA (Nemesis) id 1MKsSj-1waQNJ3sR3-00Kllz; Mon, 10
 Aug 2026 17:49:53 +0200
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ryan Leung <untilscour@protonmail.com>,
	Rosen Penev <rosenp@gmail.com>,
	Yiwei Chung <yiwei.chung@mediatek.com>,
	YF Luo <yf.luo@mediatek.com>,
	Chih-Min Chen <chih-min.chen@mediatek.com>
Subject: [PATCH] wifi: mt7915: disable rx napi when removing device
Date: Mon, 10 Aug 2026 17:45:10 +0200
Message-ID: <20260810154923.32546-1-nicolas.cavallari@green-communications.fr>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:GcYNz2bLwTytE0csR5Gx6OySAbh6GbRPTvzwS5RCEOYa9EGukQZ
 o0TyX6YzB3RrTLkvfwcwmvDpPWBOcYhDy2dxw/wGc00ysXOHZd0mwbaiFz4IpzT+oUdLDsx
 3YpEa5Dfo9YbN22fTrt/hZF3VxKGUZnPtNhrbXIFdydp4IXfPPERbcxUKUjdVrMOjRmcfwW
 WE1b+/5GXjFSB4rxe+Xkw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OED0LDIVG0A=;S1sHlulshkNAD4SVCLgOd7mX8iU
 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
 m41ylsCA==

Unloading the mt7915e module with a MT7916 triggers multiples WARN in
__netif_napi_del_locked() and in page_pool_disable_direct_recycling()
because the driver does not disable the napi before destroying it.

This is troublesome since on MT7916 it is required to unload the module
and reinsert it with a different enable_6ghz parameter to change the
frequency.  The system generally becomes unstable after reinserting the
module.

Fix it by disabling rx napi inside mt7915e itself, even through napi rx is
enabled in the mt76 generic code.  Disabling it in the mt76 generic code
was previously attempted and reverted because napi was disabled too
late and rx handlers could access freed structures.  Note that the tx
side is enabled and disabled by the mt76 generic code.

It is disabled in mt7915_stop_hardware() since, unlike
mt7915_unregister_device(), is it also called in the probe path if an
error happens after rx napi is enabled.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
---

Back from vacation.
This depends on https://lore.kernel.org/linux-wireless/20260804120004.523934-1-mikhail.v.gavrilov@gmail.com/T/ being applied.
Sorry for the trouble.
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ca46a203aa48..c8e389db63a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1238,6 +1238,12 @@ static void mt7915_unregister_ext_phy(struct mt7915_dev *dev)
 
 static void mt7915_stop_hardware(struct mt7915_dev *dev)
 {
+	int i;
+
+	mt76_for_each_q_rx(&dev->mt76, i) {
+		if (!mt76_queue_is_wed_rro(&dev->mt76.q_rx[i]))
+			napi_disable(&dev->mt76.napi[i]);
+	}
 	mt7915_mcu_exit(dev);
 	mt76_connac2_tx_token_put(&dev->mt76);
 	mt7915_dma_cleanup(dev);

base-commit: 4df22710a77d2365e56d720bc4106e54c1dfa2ff
prerequisite-patch-id: 7d4fbb111c901db1b996617c056803d005844046
-- 
2.55.0

