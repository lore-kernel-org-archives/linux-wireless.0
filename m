Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF68231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543051; cv=none; b=OSyQe0f2Yy1VH/7q5HU8Hiz7o2vBHW4lzywJZPRKynYIRvG1VP+dSKXTXxQfEReVe1LTVA6Omj/LrLY00EFZObJEgnf3hBvbADeD2u/50VE/+emxyIcR1pEubHHJswE9snNrVU0wrQRT4BCgmM3cXKpSuBIr4qqhQ8tFcf2Cat0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543051; c=relaxed/simple;
	bh=eKE0R8kxZi1JzceDIZQRCv7xn22mnQyHZsO0I0hv8dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBjGaYGU/SDMLJ5VjdaqO8NDk8J+ar4G3hG4swSwG+mY5YlMtwlUfTDUMatQp/yRzsdEtWGMjx4FLeYglVBgCMBx0a9Zfy9qmbWD0Rz91Q/l4jjWB/K5xXPcaGSLQ0lm06Fe6CQ+ioH6b12i+rG8Tlpiz2XzI7zRlTeOe98SnME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895353e9051so19520937b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543049; x=1791147849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HfnndOSayHQt29039Mri7RjxnsiGSv3tyGNDlDem8kw=;
        b=KbBer9oYw4YtldduMT+88QcUzWtRnJQSjuLYXz9ZpE21gxHbVWaBLtrWRWZ6X6SiJS
         ojBsSBn0Z8Sc3M7mORUss+sPknclfNJsCSKAekfCm9p/1OZGMRYC+yv2o02jYKEiKrss
         Kip1lAQ6xO5OyYs5e/qbz3F2DLtj/dqQ7s7PtUZY0XPjmQgaHN77RKvWa0fRoF49ftA9
         pgOz/pP+Gf4no8NQtkQH/XFozJJPb6m0xxx6E1oWbBtNp6KCGnOBfYaI0huAAzDsRAVw
         Ve8WMXf2ZEEwWffg+Q+BmjinFoHqIyFZc0j1KAlvAplq5fdy61Q11JwquLzbCt6E5Sng
         1knA==
X-Gm-Message-State: AFq9FYK6RK5Cwiz0FbsL81ocPslM5fP8j/tiBbFe7yoxtxb9Qf8i4HkH
	hg444tQsX7YU+bBM9VZnyCfH7Ck0lL58TSkQiQL5aOcbf9ABZp9PIFHS
X-Gm-Gg: AYBFou3UzaPFbaa/0hS4Ihpak+Fe8B7G6IseuWGdE9DBodoL8dVWEU2b0EewjymEihH
	uwBx3BCJrw7EcBp2tGayHbFTKNa2HwhlKlFx84Uv6ucOHag33J/n40gUn7nvfXt7FkbOcGX2Vav
	/8GplduI/U7d02gjFWEFlo7WMf3ntaEnHMB5uiRi7dCF9II5HsEcfEp5d8MFZ/RyMxEYTE/iHJO
	NgbXVw0frWPPZyOfLnNFnnAN/ruMUhWZXBL+s+gjsaxHeighOjwwblPqD2308iinFKjthurq4dF
	zdkyRRGiX9MN92MnJO2WlzX+rm2tHbtn7eTf80ELtSSz0dY4MmKf7F14NsJ97uQV5cJ9bA+x25z
	zWbzwy60809pF6iLkQ812xxc/ErX2ShRIzb48un9nNzCfKKYbG4ccSCwhagz6vdx+auKP9N0QMb
	HXCUSZCtYAlNxEN6P53EkgmOvrDDwyn4QjRikokDQA28awhKSm4tJC0hqJxQhqa8OoF6ULiDTT+
	9xjxq8tqAuhfTdVS1wAyDcqsOil8yoHKJoWGKszJkNdaD3XnvMu4Ls8IIYW1giMgtEtLQ==
X-Received: by 2002:a05:690c:6e81:b0:8a8:675b:2ba0 with SMTP id 00721157ae682-8a8675b2e7emr32483767b3.41.1790543048959;
        Sun, 27 Sep 2026 14:04:08 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:07 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 14/23] wifi: mt76: gate NAN unicast mgmt by peer availability via STA queues
Date: Sun, 27 Sep 2026 16:02:56 -0500
Message-ID: <20260927210306.737669-15-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jacobs Wu <jacobs.wu@mediatek.com>

Host-initiated NAN action frames (NDP Request/Response/Confirm) were
sent on MT_TXQ_PSD -> MT_LMAC_ALTX0 through the interface WTBL: a
force-TX path with no relation to the NAN timeline. With a partial
availability bitmap the peer is off-channel most of the time, so the
15-retry burst (~11-51ms) regularly misses the peer entirely and NDP
setup fails probabilistically (half ~2/3, quarter ~0), and per spec
unicast NAN mgmt must be transmitted within the peer availability
windows.

Route unicast NAN mgmt through the peer STA WTBL on its AC queue
instead: the FW pauses/resumes the peer WTBL AC queues according to
the peer schedule record (the committed-window intersection computed
by the supplicant), which is the same gating the NDP data path already
relies on. Multicast NAN mgmt (and unicast without a peer STA) keeps
using the interface WTBL, which has no pause driver.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 3707ee19e4ae..a3688b9fe635 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -681,6 +681,18 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		     head == &wcid->tx_offchannel))
 			qid = MT_TXQ_PSD;
 
+		/* NAN unicast mgmt (NAFs) must stay on its AC queue: the
+		 * PSD path maps to the ALTX (force-TX) hardware queue,
+		 * which escapes the per-peer STA_PAUSE availability gating
+		 * and transmits regardless of the peer's committed bitmap.
+		 */
+		if (qid == MT_TXQ_PSD && wcid->sta &&
+		    info->control.vif &&
+		    (info->control.vif->type == NL80211_IFTYPE_NAN ||
+		     info->control.vif->type == NL80211_IFTYPE_NAN_DATA) &&
+		    head != &wcid->tx_offchannel)
+			qid = skb_get_queue_mapping(skb);
+
 		q = phy->q_tx[qid];
 		if (mt76_txq_stopped(q) || test_bit(MT76_RESET, &phy->state)) {
 			ret = -1;
-- 
2.43.0

