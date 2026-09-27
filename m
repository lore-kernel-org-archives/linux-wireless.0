Received: from mail-yx2-f39.google.com (mail-yx2-f39.google.com [74.125.224.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB7E231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543048; cv=none; b=BmJuvw0NpWsMeS38cooDBz3qOl0ECh+MbPDZ9pcdoyktkcxxmH+4Hh6yGcIPl7B7fbKQB2dY9nxCVL1sbjKDSDULlzr6iB5CHBLxRElbfoJEgqk/w/rq1hS38udeqQ/32/o5/D1P/2jeUN4at4GoruY85V9idZBMj1sgLUPjejE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543048; c=relaxed/simple;
	bh=kO37BeX95ibuRjqkmEFDK27m/CxmHWjaG32e1p9eXvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKcr5A0tQwP2C/unxjM5ojMINDJFd0kASx0et/qJPbDBhPu8fLC6OFUtWe081Bin0hDxCOD1JP3Y/aJfYt6725Wqx/HFy8Wf0cNSC4m4vX+v8aoXEiM+zGyR6hHQSy3AUNwpPraHcqXtjcRQ+4zIPYdAIkUntmX5tjEtkiYZq68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f39.google.com with SMTP id 00721157ae682-8a9d7f097c2so3408357b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543046; x=1791147846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Z0I4HTCyvJd+H+GNxUVvWWAhv5GfqRxaa8myeYI1+g=;
        b=u9hIeHbL/UDPs13Apn+G+wmmcraaeMan+OnwjA6IX3hkb90rZo1QtecJRupA/9P0kz
         XkPTVhbJnQrAIrN9cn0V+xIZ/kiSLByxO1DYG9HTwdj5FxNF8lgDKLE+PDBYaOPFz5dv
         VvTANBSgIs8gG8zL/TiMjn9Eg68AJtNjHrUHopCgW+gTNiZC05YG/vUa9u5FrbHkueth
         4Q1HGldEr3VKuGHHlKSGBj85SPYiW4p8kip5/pQxoLDa7ejyzKird4J+Ix2uzt58AVX9
         hOTTi4Co7BVfu9RH4mm3RQf2grgyYzKjbXW/Zz78dfODasvK/ZSGeqcb6t9HV33VZLCo
         Yhjg==
X-Gm-Message-State: AFq9FYJ6zL91AXwZtB+wexBxG5Fly0v28KGTqsrFllyjGLEloZSqqG9t
	cLKZ20dpnwV4z1d0KMnhcGEVhlvXiUPNvfa+R/Xw23SzFyvrL4vjbLX7
X-Gm-Gg: AYBFou2pvNaHonCGpwITUmwfvHEf+ywu3deGtliNzJSdtTPx7cR73KELETU1urVM7tC
	w2DYnG5p5J1KONzIxQCaJUq2LF/8KMbp9Mb949cJzl6LBA29QXWnM3s7jBij9jojm7v5x3haQBo
	DvjZv9mIaYUN2VzkBfF9L3jdIPqi/1hvyMb2d4vmGdW3WKkIIq4fgGrWPAWfkMua+ay3ipLf6zo
	ZZKCCfEu+nxa4TtJGLPVxqFx6EWJS5WMr8w2pJHaCpH2qBzh/oX4tVjHoATnr0Pxnp/oxvx+BvD
	G+Y0aSVDkECKedV1Okg26pvtqriojrW7s7zyAzES/5fRCrjqIQnZuFcURU7K9T0r8UvMpL+7XsQ
	Nmbl80DNzWAUWDyVVyhaviQjg2tdXKwAZFaTAs5DGMel2k+EbEpedMje/d6q4ykbFsau1OEWUbT
	y/rKb/a0ebIMoG0K2i7o7PRzUBS+cItDtm6kJkZUXzPB1cNi1ErCFTfHCHJcv6HhPuDtZT4/3y6
	YvO7wWdiDGwqzhk8dF/ZddlC7de/SJGURaZNxUWOkUrrkeB6SBo+rgmDmqULj19qLZObw==
X-Received: by 2002:a05:690c:c425:b0:8a8:928c:b9a6 with SMTP id 00721157ae682-8a8928cc891mr17437187b3.34.1790543046172;
        Sun, 27 Sep 2026 14:04:06 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:04 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 13/23] wifi: mt76: mt7925: do not deactivate shared NAN BSS on peer STA removal
Date: Sun, 27 Sep 2026 16:02:55 -0500
Message-ID: <20260927210306.737669-14-sean.wang@kernel.org>
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

mt7925_mac_sta_remove_links() sent BSS_INFO(active=0) for every vif type
except AP when a peer STA was removed. NAN (nan0) and NAN_DATA (ndi0)
BSSes host multiple peer STAs like an AP does: removing the NMI peer on
NDP teardown deactivated the shared NAN sync BSS in FW, after which FW
dropped every host-initiated NAN mgmt frame (TXM: An MMPDU for an
inactive BSS_INFO) until the next NAN_START. With partial availability
bitmaps this made every NDP re-establishment after a teardown fail
(unicast NAF TXCNT 15/15 no-ack); full bitmaps masked the bug. It also
tears down the shared data BSS while other NDPs on the same NDI live.

Exclude NAN and NAN_DATA vifs like AP.

Verified on 187/235: teardown no longer emits the BSS disable cmd, the
FW drop flood is gone, and half-bitmap re-establishment after
nan_ndp_terminate succeeds repeatedly (was 100% fail).

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 64853fc7f60e..08a5bdcf1094 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1489,7 +1489,16 @@ mt7925_mac_sta_remove_links(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 		struct mt792x_bss_conf *mconf;
 		struct mt792x_link_sta *mlink;
 
-		if (vif->type == NL80211_IFTYPE_AP)
+		/* AP, NAN, and NAN_DATA BSSes host multiple peer STAs; removing
+		 * one peer must not deactivate the shared BSS. For NAN, doing
+		 * so would kill the sync BSS and the firmware would drop all
+		 * subsequent host-originated NAN management frames. For
+		 * NAN_DATA, it would tear down all other NDPs sharing the same
+		 * NDI.
+		 */
+		if (vif->type == NL80211_IFTYPE_AP ||
+		    vif->type == NL80211_IFTYPE_NAN ||
+		    vif->type == NL80211_IFTYPE_NAN_DATA)
 			break;
 
 		if (vif->type == NL80211_IFTYPE_STATION && sta->tdls)
-- 
2.43.0

