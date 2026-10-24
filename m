Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792874800;
	b=HuPyRK9jNUvsBoSLAiK164dIY0MGGsiEWni4PLe8YvY6RzZxyYJC82stMBQfhKtt8Dk/
	 YIhg7asTQkzpBKAPo6qLP5/47Hl1hqHuAUBrQt+B61z0C94bXtVqGxrkyI1n0NM5wquo4
	 iFQu+oPN7J+iAnognED1QhPQYWMhpB8xyPkviLe8QqJduPhclxm+Ng3t0v/l7RQrpUWeF
	 oS1w7mjsDJ7wIXE/VrKmJG0/tpas+q712otipQy1YfGGhWb9gwMFY4ppOQKsZRgTEkNPj
	 Z7qwKtipkFm6ZFncxmHda8+Xco2GfE3XZcDk1wbe2Nb/IkDhgEHhErwsH+TeLZeMx0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792874800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=UnXi3eekXKl70zsvSefuWRY6oQJRxJ2VpezoTiQGsog=;
	b=DXlqtPOcqTFG8rX5rbeMst0FbkzUL3LpRDscazs47wAAa7khcpb7Vn51qZWlwoamg88H
	 GN/KCED7t+YY7FyWtNDzt2D7S1LVQ8VzBN2VLoPFV9fE7EYplbtOii0zU8OJDUKLUmLAP
	 PoViBJQ+WiQXXTgqhsniVq+65HKos5J9LN+zh5zxXaYp9C6fEJ9gQBPnf2gFbDpq6F7jz
	 +j1CthM+ed54p83PanVAI6X6qib8ZZeHFqkrsXUly3akoOpLAOw6W2eOw2PoFNJiBZKS2
	 Ck/6tWxnB07aiOvByCj7w5HqpAQvJwrsNhKcZXCvS/C0wbMJsoJ/I9oojgNtEyz7Wgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mRvlV0yf;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F109606A31B
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 20:46:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F109606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mRvlV0yf
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so990808a91.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 13:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792874799; x=1793479599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UnXi3eekXKl70zsvSefuWRY6oQJRxJ2VpezoTiQGsog=;
        b=mRvlV0yfNwiBWAaIWq2wzbaMgYG3NSLiKYGgN0HRPopk0eToj4UIb/jwCUlVfh34pA
         L847ORl9vlv8Rw23L3FdZFlk5362vhDyMz2Dl2BGl7Drz8WIY9S8dP2+QEVHqmlSF2lN
         BlXI26pO8J+v3dxJOvls18hF3L/GdS7bcRlX/WtRGr+TOVd2Bkd5otl44/Qu0HIsT7qO
         UnmzmFBC6uNSeCgOcdoS9WsIZo3+WonpSpC5bQEUu0o0t00cnj7LJpp/G7r7LnCgAoPI
         rdyy+GN/6fWrLkDZs/VtXxIOOsGBvreW1bNFu4lOKvg7V5gHAtybk8jhE2zG/tIRPWLc
         nwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792874799; x=1793479599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UnXi3eekXKl70zsvSefuWRY6oQJRxJ2VpezoTiQGsog=;
        b=d+AFv/NBehLXgl/b8XBkQMg2wuPlvXp3YCMCM5WrBqZuDUuKIjHppaHrJePFGHfAg4
         GrLrYCp6VgTQic2KkaCwgO8GPPmBou6iVVLbX50dSrw1ZlqCZfKu9jUiQYMsUjCwf+XZ
         T0fSd4gqgNBm7iL+GhR33QoKZR2reu24ptmg4KCAKXy8utQDW/FEX9sO8eL4WyujOazG
         E6/jLVfUe5izNp2N76miVacwd9OETqNFJC2+euTh9+2hL5u3th3EZ9WZIVSHduBSQ955
         UWJ2VEBSf56O2p5I+xCwJEhh3i8DuSe3JQcDnLbU59I8b4E/YdbmgwlffVXNJp+kiXju
         mIEw==
X-Gm-Message-State: AFq9FYJ4iY9ZT2SA0Dp/hl1Pb3xUsHeqandxvZmzjxTaTzjS2fzUNanj
	8lnq8W5rSajYZSIE5214KjAXr32ibAHuIqm/50Krs29OgVLjFL5n6uKWlSSPMQ==
X-Gm-Gg: AYBFou15C5PNdeyV2nMb67DB+Lh8A9301BkUey7WOGf7BH1Spp7bYvtk3qMz9eVyesC
	4vZv7ysrWa8uQAtUe0h7wsHjJWVxmdio0b+1fBAnKtR6kiFx7aTviZPUbI/apqMRXQQvi/I2fW8
	pF/kZYxNo/3McyEXcrDib3TPhju7AuUwNPWUJxl8hnoczeJJ42lyl9KJNb1PLVriKdPqXxo53UC
	3LBDX/YyQfb9JZ+OZyK4fCX31dLCayC28F5jvySMcudYnlLBuI4T7wjIHv6ibdUDT5gipIbchXn
	0Jt/wgyVXPBfdTxZPLV6xOi/G22525xa3ZPm+D6RQ/kBzySLm0V0UXxje/I0ir8fErXu4H7lOQ8
	x57LKQOz2uRn+DgsIUAp13u6QSv70t7nF2JIQUnVWSuYrAgCSwvFh0nPew0ybWWLVdu3dSzgNae
	LZwCyXjeA8UpVO97SgHx3N6cIU8Zp2aWSDYY1ysIp7AzcdzHJ2wXRrnXTu2AOrWuwe8Oz7kvlyL
	TVeLfQDhSWg9pukewY8GnSB1CrdQhsKkpZPoUu99iA7GuPsHbi2LLanMwyZW/Dd+5BovsIW0q8B
	0ee2NXstG/8Y+bEwCfBbZr6b20YB2vQYIKFR4uDUIHFTYWsr1CSEU7hVplLkNslE0ASVO8n3ZTi
	3FLtFZhWXqQBXkel5xzzUg8PhEBnY
X-Received: by 2002:a17:90b:3143:b0:3ac:9e76:aa76 with SMTP id 98e67ed59e1d1-3adea9dca65mr2434190a91.13.1792874798834;
        Sat, 24 Oct 2026 13:46:38 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe8f0a7sm3793963a91.9.2026.10.24.13.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 13:46:38 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support),
	linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support)
Subject: [PATCH wireless] wifi: mt76: mt76x2u: limit TX A-MSDUs to 3 kB at SuperSpeed
Date: Sat, 24 Oct 2026 13:46:36 -0700
Message-ID: <20261024204636.23484-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At SuperSpeed the MT7612U stops accepting bulk OUT data after it was
sent a TX frame longer than 3072 bytes (TXWI and 802.11 frame, the
TXINFO length). The TX URBs never complete, MCU commands time out
("mt76x02u_mcu_wait_resp failed with -110") and only a power cycle
brings the device back; neither a USB reset nor a host reboot with the
port powered recovers it. Single frames never get that long, but
A-MSDUs of two full-size subframes are 3096 bytes.

Behind a USB 3 hub this happens within seconds of continuous traffic,
plugged in directly within minutes. Frames of up to 3072 bytes, at
MTU 1488, ran for minutes behind the hub, frames of 3080 bytes, at
MTU 1492, wedged the device. At high speed the same A-MSDUs work.

Cap the A-MSDU length for all TIDs when the device runs at SuperSpeed.
This keeps A-MSDUs of smaller frames.

Fixes: ee676cd5017c ("mt76: add driver code for MT76x2u based devices")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index ade15bddefc5..3e53b357858c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -29,6 +29,30 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 	{ },
 };
 
+/* At SuperSpeed the MT7612U wedges its bulk OUT path on TX frames longer
+ * than 3072 bytes (TXWI and 802.11 frame), which only A-MSDUs reach. mt76
+ * adds 22 bytes (TXWI, header padding) to the MPDU, and mac80211 counts
+ * each new subframe up to 11 bytes (LLC header, padding) short, plus the
+ * 14-byte subframe header it adds to the first subframe after the check.
+ */
+#define MT76X2U_SS_MAX_AMSDU_LEN	(3072 - 22 - 11 - 14)
+
+static int mt76x2u_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta)
+{
+	struct usb_device *udev = interface_to_usbdev(to_usb_interface(mdev->dev));
+	int i;
+
+	if (udev->speed >= USB_SPEED_SUPER) {
+		for (i = 0; i < ARRAY_SIZE(sta->deflink.agg.max_tid_amsdu_len); i++)
+			sta->deflink.agg.max_tid_amsdu_len[i] =
+				MT76X2U_SS_MAX_AMSDU_LEN;
+		ieee80211_sta_recalc_aggregates(sta);
+	}
+
+	return mt76x02_sta_add(mdev, vif, sta);
+}
+
 static int mt76x2u_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -43,7 +67,7 @@ static int mt76x2u_probe(struct usb_interface *intf,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x02_queue_rx_skb,
 		.sta_ps = mt76x02_sta_ps,
-		.sta_add = mt76x02_sta_add,
+		.sta_add = mt76x2u_sta_add,
 		.sta_remove = mt76x02_sta_remove,
 	};
 	struct usb_device *udev = interface_to_usbdev(intf);
-- 
2.56.0

