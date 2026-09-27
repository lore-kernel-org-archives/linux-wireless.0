Received: from mail-yx2-f40.google.com (mail-yx2-f40.google.com [74.125.224.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A96231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543037; cv=none; b=cHrA/llUoldvA/ePxcRqacdfyYGjZvGlddVL9rWLZ11PzNJtS/KTDikoir3pM5yqXXt86KDMs7uqm7jTLxdwiCYaHqGxBRHj5iMNbZ4O3vGqwcudfvmT/kqaSJVCq11YHXSx5gpi1KroLi2c0XV0SavJ5OVL9Dmp02NfdfI0jEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543037; c=relaxed/simple;
	bh=w4L7GGPIQoshak4HbTecdDMcIcy1RX5G2Mihgl8atJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqz4+/5V9lHjhRQOQPuI/26maOgUEgtio2lHB072j/vmnTyXwdrKJRXe4/BfcpqdJZ0g+82WAXilc1gtYtOmVFu/3tItEGBwmd+MWl3S3mn1f+hFSqDO9LilZThjiki4FMuv8IjrwPMLts5nSNZ2qhLuuz+uNi+r2vuQpYz8Nd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f40.google.com with SMTP id 00721157ae682-8a886c555eeso17705747b3.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543035; x=1791147835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=skVQMSALO8vNJg9eTzKOXnpwu/ZZsTQZ4qhOnqD3fsY=;
        b=LjYYXuPlbVovHxwbnj9mv+dE1gQer8CN7b4TPTZINn6iPPjk35ynjOjFTAT4mcb1Jj
         xDnBd1P6+ApAP+2pspgnCMpelDC8bOhusV66mqZ6+rSMFID92aiz+TnprXfgNtJ16CVV
         Xue/J1aZAM4MIoBG7RCYusv6TPOPsfR/l99rmu9GZbpFbk0Pq/WH4lBzb1lCshyGbSuO
         /i6lYFy2dXonk/ecsxDuxe/0mC8BtHf2xxd0WV1PJ8t2pJsrRdx5u6vyAWhBVGV1Vkb3
         qL81T70zLOEKaiPGwfA9RoGYzdvO23mFweeutRyeNa630AhnU1yUt+if3Qs8KoM8feqj
         2Tew==
X-Gm-Message-State: AFq9FYIGP7xCzHguVATKCR4DJMJk65aWTFbxFJhVdObCYqpWJHcgaY9w
	YqA3O57Qz6UPiTb6I3vnmtvHE4kXQXKUrhuIQFTfP//GUXKPMJAI0vPifoXPrFE6
X-Gm-Gg: AYBFou237iIrSc1dDAWE33EGUqU8Arj3crQ+lEQWFNr473m98f4s87A+Jtlq0WRJoXD
	o+n/KfOWx94MnY/IDkyW/GlCPxtEB0xqBtZ/VSNYAz/wCAvScHCbutHXFq9Uz4SITmyqDvkmTTs
	RW9mH7IZh5eno8BXXibc1nY1hU/EewmI9Kc/N8gkG4OgIWt2PBc5w1vvHMdD4yR/1Fo3ydmM0Jx
	Dvfe6SF8FI2hkWMqlN3Mn9Rv4cijePNbkHcKY4QeW/VWpGkNnARJ+5UkyW6KrL5QE8AktgKloBZ
	xbMifieeI7xopx/gLTKbzJx+E7NHjXl7S9drvT04uoRJn/+4XY1undFjh0Kk+28rA8sEiTgYr3k
	488DO+SFn/TsIS+2ZZ8qQ2Kc2pU9lA1RYsMlcPIdQckpanp0xnWa6gnUMWnwwXTIco6HQjpqL3q
	7OWhuDgZnhsaRahPlg6bz7zymtRRf8L9OMZe/bxrkFGwr8pFe7xtuKAiSrO4r3ZsC8eKuDkuoLg
	0AiF0a9uixkxzReovJ3o6CdhC91RpKAUhE1vvYQ8l3mzEhiGzsqn5dQ/6zR/awRYF5EUw==
X-Received: by 2002:a05:690c:a607:b0:81e:abe2:9a3b with SMTP id 00721157ae682-8a86ca4e2a3mr15878547b3.10.1790543035150;
        Sun, 27 Sep 2026 14:03:55 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:53 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 10/23] wifi: mt76: mt7925: install NAN BIP keys standalone in sta_key_tlv
Date: Sun, 27 Sep 2026 16:02:52 -0500
Message-ID: <20260927210306.737669-11-sean.wang@kernel.org>
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

From: Chengwei Yu <chengwei.yu@mediatek.com>

mt7925_mcu_sta_key_tlv() packs a BIP_CMAC_128 key together with the CCMP
key that sta_key_conf cached from an earlier key installation on the same
link: cipher_id BIP_CMAC_128, key_len 32, the CCMP key in the first 16
bytes and the CMAC key in the second 16, indexed by the CCMP key's id.
That matches STA/AP mode, where the IGTK always follows the GTK on the
same WTBL.

A NAN interface has no such pairing. No CCMP key is ever installed on a
NAN or NAN_DATA interface WTBL, so sta_key_conf is still zeroed when a NAN
TX IGTK/BIGTK arrives: the command would carry 16 bytes of zeros as the
first half of the key material and key_id 0 instead of the real 4-7 key
index.

Restrict the combined-key path to non-NAN interfaces so that a NAN BIP key
takes the generic path instead and is installed standalone, with its own
keyidx and its own 16-byte key material.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 76dcbbffabfc..d494753cdf04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1378,7 +1378,15 @@ mt7925_mcu_sta_key_tlv(struct mt76_wcid *wcid,
 		if (cipher == CONNAC3_CIPHER_NONE)
 			return -EOPNOTSUPP;
 
-		if (cipher == CONNAC3_CIPHER_BIP_CMAC_128) {
+		/* STA/AP mode installs the IGTK together with the CCMP GTK that
+		 * sta_key_conf cached earlier on the same link.  NAN has no such
+		 * pairing: no CCMP key is ever installed on a NAN interface WTBL,
+		 * so sta_key_conf would contribute a zero key and a stale key_id.
+		 * Install the NAN BIP key standalone via the generic path instead.
+		 */
+		if (cipher == CONNAC3_CIPHER_BIP_CMAC_128 &&
+		    vif->type != NL80211_IFTYPE_NAN &&
+		    vif->type != NL80211_IFTYPE_NAN_DATA) {
 			sec->cipher_id = CONNAC3_CIPHER_BIP_CMAC_128;
 			sec->key_id = sta_key_conf->keyidx;
 			sec->key_len = 32;
-- 
2.43.0

