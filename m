Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699654;
	b=f8vtSM4E+u0eR/Kx4tr7/sy2kMTrFRyv30yIIWPAMtVjCupI/8Bc8AKF2yitc8tM05nn
	 K5zwLfwyDRVWL6vdQqEqMHExbIXhI8vzpTH9XaRXjz6DC0TGxcUT8+b5kyaNMqCBBC+kb
	 PtmJttC4QE06Zaop7lQmnx5Qc/a6pen9xCv+QIXb1KbiqOcHOLzbMpIrIhppKfqS3Q8H+
	 xvx+QhysNIJjd2d4MuoPLzc17gKJ2ZVbRdMOg+qNbvjmQ2FzA5YSbpvNMeWXq7/0/u+vT
	 dQ7heLekltNvyNE7J3i7CCgRv2/QFeMjf1/H8WW3+rin5EUds50KtVUlYE2dOrFmnZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699654;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VH9rnPZxjjFJRh7v5jB1tJ74r1hNDJAcatTrJyGbn28=;
	b=vuepvWBg6u3TeeiQ/26mCE71h3+C6CUnWze4+llXZHb8T7KRk9kHIMU+zhT05pYCeY3B
	 SlZnIeP+d818+EXmvgA4U+awsIpQjBWEn85+Bkh4cfDD3SWEog2lD4pCxc7z2NWqBVmP6
	 qKlOmKk4v6XFtlPI4j7beO3taMPZhBnzwEIo2E+PDz9xBfgGDV71z7MSTpv1IdpA3HxjL
	 KdJMY8SqE3MMko1sw3vZSJKS+5nJwkiEcc19chFyd1oWPbRSyNw/khEuHR7ZvAj0KEAw7
	 GPSdwIUBz2EmN4xlSB4mLsB9RHmIdK5q31C0UC/SPB3klLUnRnvis39kKNl53t7vJKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=znowCaag;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522AC60850A0
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:54:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 522AC60850A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=znowCaag
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3514b90bb89so8202077eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793699653; x=1794304453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VH9rnPZxjjFJRh7v5jB1tJ74r1hNDJAcatTrJyGbn28=;
        b=znowCaag/T/6wn73dbKGw8K3eAxraIpXmNquQaSzH20Kkg5njNJ+r/aEETTgLvYSUY
         zDCo5mPpeG/xFfp8vBdrq81Vz6kQwB2LyI3HI+LZ9rRQK3VWp1yEXEhha0fOfP/IT+Y1
         I9Ui59lEkDHfrwnG9FmRQIfM5fB/cGps+YrTVI/NRyL1n1ZVsB6n08A5M45SfjAkPgpm
         HdAqupqSO0zJa/zNHn1nQzWo8zcniFa8llMV1sD7EcOHagooZ+r/Zsbb7PfBFXMo0JWB
         aAV2CsvZiEUkonyLusGmKAxcvFUSJzINNcA8KqlSSTGXYyo1yRQMvrourGSqJOYIDp4+
         clJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699653; x=1794304453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VH9rnPZxjjFJRh7v5jB1tJ74r1hNDJAcatTrJyGbn28=;
        b=xS3GyMo628w5bT9oJLE8sxlRDqH/W8Zn+YeggVlMkECx+67Ia46SEMILSf6hSXtpRh
         FSZM6Mfgu7n74t1b9E4uP56f94rJeht6MtH9P/uSxQ1XcyIJAwgwg4A1SX5n0mFSkuav
         xWMoeOPAhId8fBJL/vd6L0Yu+iw7uYy5LOmCZ4ehQdeAeAObNJKnldeEUO4NM5SvdgNk
         3dgtxSiWUDcivYd9ftzlzqwamXE/UDZ4bDbOME9Ct3Y7yfSTSD9dwjaQiMIfIjtdRExk
         oxkze+f6y+l6whUJLrAaSJUdNoSnpI6ClExBcM0W/URMP61Wow6LsgSjWyxfv5Zw77ob
         IN4Q==
X-Forwarded-Encrypted: i=1; AKwUvBzS17/ZZbliUTf1lvutG97TqYjR55fK85mawa+IHX0V+qty85gCLCypR7plv8u3iVXs7DuJXlZ5pBVfenDKhg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9cJFLtJoSD/ZgdyhnjCzuTYM77nUW2UZy+MfQhlX0aE73uVFAZ
	h2PnYxuL/G6KjC1XlF4Ie85BCNvMIbeHdceg5vL8vORUQyxo8yX+p0H9
X-Gm-Gg: AYBFou1YWKZFVQYKizjLvkutOZfKqe1mmMDXHcDdqRVvFQIW4+8IzOufhthXWkOzW0L
	CrX7PdsXaZCcIYXoumAv8YTiGWId0yjV1pcSMGdTnkapUB2uATZNesK1RWQ4b3BwL1zQxa3273k
	DyKTw2lhdWC2w0kKgBX4hj5qkBJhl/ivU5b0AdRIP2kYGxp0upyC4GskzVXxEt3rRerlZkmwU9y
	2S1RLLDXmX2WaQdMjLXZQA8JCKcg92vVjNnPaRfelVD8i9X91mytVcOkIY1AE04c/DXduzGPTFu
	bmAjQQJ4hCLi6VHl5bHzzFlyUZTC+UcCBu6vrob5zHk95l1MdkC26wUmMuQRFy36IzXLDtOTRK1
	yEf3SMB2OBHUh3UmXjN/P/J+2iKAUGOCS9Uex4/kI6IufmS4C++CtPg/J4qryNUk5DFr4weXjGX
	oxxktyG+23sCjkv3oPWdPU/sqg9BuNKaK6X8lNwMD1CAI9prI5rmHr6TGhYDClrfF54qwRVUQ9j
	vn7aSbjRRQQPqvfd9F6y+zctk0P4FFApeiHJ2G+OfryfejtWzUpXSQmgP7lW7eoHWmTtVK1Iw0L
	rWrt2yEPLCHhXtEH8WjzGdPhZ+sV9SjERGSWrccZQprBR2pvzpRBPlyA5aueNqhNjVm59zWRa97
	+TUsjfQ6O
X-Received: by 2002:a05:7022:4392:b0:1a4:c892:b14f with SMTP id a92af1059eb24-1ac5de53bc8mr31064985c88.29.1793699653343;
        Tue, 03 Nov 2026 01:54:13 -0800 (PST)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:9e8b:5db3:accd:585c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aed79b3dfcsm44178383c88.12.2026.11.03.01.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:54:13 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next 3/5] wifi: rtlwifi: usb: unify the RX code path
Date: Tue,  3 Nov 2026 17:52:52 +0800
Message-ID: <20261103095256.949327-4-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103095256.949327-1-hjf3108@gmail.com>
References: <20261103095256.949327-1-hjf3108@gmail.com>
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

_rtl_usb_rx_process_agg is a copy of _rtl_usb_rx_process_noagg
except without the tail end. The noagg function can be used for
aggregated frames, so drop it and rename _rtl_usb_rx_process_noagg
to _rtl_usb_rx_process to unify the code path.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 52 ++--------------------
 1 file changed, 3 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index d013e5986948b5..d7b3192262c001 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -366,50 +366,7 @@ static int _rtl_prep_rx_urb(struct ieee80211_hw *hw, struct rtl_usb *rtlusb,
 	return 0;
 }
 
-static void _rtl_usb_rx_process_agg(struct ieee80211_hw *hw,
-				    struct sk_buff *skb)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 *rxdesc = skb->data;
-	struct ieee80211_hdr *hdr;
-	bool unicast = false;
-	__le16 fc;
-	struct ieee80211_rx_status rx_status = {0};
-	struct rtl_stats stats = {
-		.signal = 0,
-		.rate = 0,
-	};
-
-	skb_pull(skb, RTL_RX_DESC_SIZE);
-	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
-	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
-	hdr = rtl_get_hdr(skb);
-	fc = hdr->frame_control;
-	if (!stats.crc) {
-		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
-
-		if (is_broadcast_ether_addr(hdr->addr1)) {
-			/*TODO*/;
-		} else if (is_multicast_ether_addr(hdr->addr1)) {
-			/*TODO*/
-		} else {
-			unicast = true;
-			rtlpriv->stats.rxbytesunicast +=  skb->len;
-		}
-
-		if (ieee80211_is_data(fc)) {
-			rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
-
-			if (unicast)
-				rtlpriv->link_info.num_rx_inperiod++;
-		}
-		/* static bcn for roaming */
-		rtl_beacon_statistic(hw, skb);
-	}
-}
-
-static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
-				      struct sk_buff *skb)
+static void _rtl_usb_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 *rxdesc = skb->data;
@@ -470,8 +427,7 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	WARN_ON(skb_queue_empty(&rx_queue));
 	while (!skb_queue_empty(&rx_queue)) {
 		_skb = skb_dequeue(&rx_queue);
-		_rtl_usb_rx_process_agg(hw, _skb);
-		ieee80211_rx(hw, _skb);
+		_rtl_usb_rx_process(hw, _skb);
 	}
 }
 
@@ -490,11 +446,9 @@ static void _rtl_rx_work(struct tasklet_struct *t)
 		}
 
 		if (likely(!rtlusb->usb_rx_segregate_hdl)) {
-			_rtl_usb_rx_process_noagg(hw, skb);
+			_rtl_usb_rx_process(hw, skb);
 		} else {
-			/* TO DO */
 			_rtl_rx_pre_process(hw, skb);
-			pr_err("rx agg not supported\n");
 		}
 	}
 }
-- 
2.53.0

