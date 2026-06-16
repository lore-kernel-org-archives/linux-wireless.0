Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C9E451052
	for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2026 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626241; cv=none; b=Bsw7wlORHNCjct3FhrxoTrClDz/m8WxSCAroYWWMLSVSCXIvr/UNhHbqJ0di7JYdBMlMc4Ew42C8FwEHmsxZH7SGekBT505wQzZCjYGCKxou714nJoC8koDEIczHW0Qm4vaXSbMEBoRy2YuBcB4bN+1GQIbCSftBUrnS2kA3mJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626241; c=relaxed/simple;
	bh=jEoGq3WpGTVIVPUqmh4lvksI6/c6ObtEqpx20Y1pUpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TZnQDQql2jDQM63pOMGtKCenoRZ7wO0hYtQyRWNiiCKUghos7+RvqIicuq4EPirRHhPm0H/IZTuGXP7mXTgmXaZAuRaVu4f4N3uJskS442mwT918dNIUJnyQ+uxHh5nvC2r/iEplQuki9Ty9SBTBGZqEUA63O8PrCjflZ7OxjCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c0c3546924so30870085ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2026 09:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781626240; x=1782231040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfKOVyRBVUkjlDsBRH3w7gLrWCYdWHEdVo3BiIjzYz4=;
        b=Z2TEPae8aFHcZHTREjStq+sQvXFQTj7lTeDqYWSBQ6ss1IH+My6ASb9I7NJvU/zcj3
         qvWM/wr5bFtebA81EfcZzrMJVuo+8/EU4//1KYC2k5i0KqnXofYraQONzoX+x3gFXx6T
         /Jbd9pC7+fPiCLJgS8pjCNjLF4yyhxB4p2X08pYjDxCtQvVO54jLSceuV+Mo7OcAS9ZK
         MlABE391n3h9G3VhqBw6F1Ma9Kjoerw8FncyTeAE18F8tcGaqq01f5UUcmqhGsGFCYr2
         jvifTHpZbiVtSRE8FNKQ96/jkLq/EaX4oL41HYjbX2QcxNNehr4w4PwP6NM3GK/I4Goj
         W78g==
X-Gm-Message-State: AOJu0YzFCsnCoZXsAGs5a7ORt52Wo1kX+XR+EzhrFgkOnAlOGN6vVz/t
	+63AxDmwLNkOehuU4Hpx0ZUd+YzdlLq8NPyTdBz3TXKXVpZLy7hdknhuh2wW7Lrc
X-Gm-Gg: Acq92OFq6d83SqgaGZbfmD3re/ZRO7p+NTbRIxSWm2V76ljZFN8yO1WwGRNr/8NJeS3
	wnTEsLirYki1uWDVuZhwXdvIHCDgfs6C8rQi8W6nMNlTlXxczt83LV5P4STiEkPhwqMhci6PVBG
	ol9a3FlqXNZ4TRo8T3Vu538Jnq6NeX6tjoTEjZpnx7WdC0orKx4AKzMSuxKiHeKl4JQNOCDNAgo
	n90EdoPlvseFssv0annsUrfDC7VufxYWjnOHMhsbjWo5oUoz3CJnnx/RcJYwNZdunuVspzy6SAj
	3lVnepgBhncGNEyAXgATMYgYHoQ/61s5NxPQbkk5nMTuS+J+onf2BGXKgDCzsTFNN5b+9ceQ6sF
	l+EJmxzWuFlZBya4Wqn4JwBGES1dXCAvX6lj1KE9ANn3yr7SYPyYgWVZ2RYifKr2j9d8CFSy4Bz
	ToWZWh23dBFrPuK7VP5//uZfZCO7NVbp7OqRHAln9WJwktpK2NYElK5ajPJrkzzzbZ8XXOizCDo
	yV6rFkbUpGOTXGqMnnaNVs7gO9ZdGVd1ez/n6Zz06XaW8X2LwE=
X-Received: by 2002:a17:902:ea06:b0:2c0:e5ee:f56c with SMTP id d9443c01a7336-2c664271b0amr171763185ad.20.1781626239769;
        Tue, 16 Jun 2026 09:10:39 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.. (114-34-228-194.hinet-ip.hinet.net. [114.34.228.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c432f77479sm139360655ad.63.2026.06.16.09.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 09:10:39 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: fix crash in reset link replay
Date: Tue, 16 Jun 2026 11:10:16 -0500
Message-ID: <20260616161016.19346-1-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

During reset recovery, mt7925_vif_connect_iter() replays firmware state
for links tracked in mvif->valid_links. After MLO link changes or MCU
timeout recovery, the driver bitmap can temporarily contain a link whose
mac80211 bss_conf has already gone away.

This can pass a NULL bss_conf to mt76_connac_mcu_uni_add_dev(), matching
the crash where x1, the second argument, is NULL:

pc : mt76_connac_mcu_uni_add_dev+0x8c/0x1f8 [mt76_connac_lib]
lr : mt7925_vif_connect_iter+0x9c/0x168 [mt7925_common]
x2 : ffffff80a77f6018 x1 : 0000000000000000 x0 : ffffff8099402080
Call trace:
mt76_connac_mcu_uni_add_dev+0x8c/0x1f8 [mt76_connac_lib]
mt7925_vif_connect_iter+0x9c/0x168 [mt7925_common]
mt7925_mac_reset_work+0x264/0x2f8 [mt7925_common]

Skip missing bss_conf entries before replaying the link. Non-MLO AP/STA
reset replay is unchanged because the helper still returns &vif->bss_conf
for the legacy link.

Fixes: 14061994184d ("wifi: mt76: mt7925: add link handling in mt7925_vif_connect_iter")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index d7e4ebe92342..cee4e4b8ff41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1284,6 +1284,9 @@ mt7925_vif_connect_iter(void *priv, u8 *mac,
 
 	for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
 		bss_conf = mt792x_vif_to_bss_conf(vif, i);
+		if (!bss_conf)
+			continue;
+
 		mconf = mt792x_vif_to_link(mvif, i);
 
 		mt76_connac_mcu_uni_add_dev(&dev->mphy, bss_conf, &mconf->mt76,
-- 
2.43.0

