Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699650;
	b=J8/EufQXUQQesBCq+nL9zLJTjAJHPUVjj7Rb6iLiHHIRXXj9fsGfWTQRWX1o2O7Ujj2B
	 ma3ypr8DCx5YwwJD8EFJk0eATijJC5Tkrf8t/ABOhQEyx9l9RzfbBxIpZS66pqOWm7cOP
	 U7QlL7JPkzRQfhDUIDvyUzeMYn9rH0um0wGAKYR9JmlQfT2NIkg0mDfuLq7WnoBYGn4ZB
	 N8PdIeXnPBZQftSYdC9uj4p5AYmoRXp+0NU3QF/Q5f6KgrUrBsdJ0SYeq1iOmKOj7M4zL
	 sURV7Yd6eearCG+OgR1mfRlvNWY2r6IqCb3n5A+G+xPB72gYnV0sobfxCQAcAtNn6lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699650;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iH+5bLQSIskdkGMDhaMY+sY910o9sCp30GjpM4gNOE4=;
	b=hkH511u+Wz4pK4d20sKfBrEW8AkRyxR7m5dSX3beEDJWlZVHmHoKogrPGrNJ9VtwayMh
	 DeSyPMaCyKRQYcJKud171JQSX23IwpoAO4QAy2dvXczcw641d/aVPIRlyIOrMI5Y6p8dC
	 L9I9o/+0zcqsjQKGrKp5X5Le8qHktljXGohWogx1JCBw6Cwwpz/c5JhRZO4UiH3gis1Oe
	 1Euxe66OMIe2Ed1zjlSbN2yam8i8Wm0wWxr2DYPSdXDUwr1IUCmvjzHbQ6eL1r02iHeyX
	 /xtqH10OZGv7ZnAfiBs+4sN1pq71l573EaqNv+j8VEfVwmBRCpJefXe4Zw8TROLu+4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FhKm7Mlz;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E296083617
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:54:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5E296083617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FhKm7Mlz
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1a2761c69fbso6673123c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793699649; x=1794304449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iH+5bLQSIskdkGMDhaMY+sY910o9sCp30GjpM4gNOE4=;
        b=FhKm7Mlz7AFZvIyJnHmfrY4U0zO9EzSqdoKR5tSwgyt5HEQ25DFyOkHBBGTL1vDNn/
         mYMv6tZSM6s65ROAP3XNPnTz/d8mEDlFxrZ8jLyfRg4mt8Eh1IH7TCOxC7yCryCBnccG
         rfOyTpPMkftACnZnC6YS4HKQoRQ4p3LNZqCIV7xSXmjyUZCj6enzUV/YSfZHCU8bV8ha
         i9V/lzc8ARwmaOE9tqAoK+8TD31tfdQJuyN4JntA+5ga3oPFS/l529gcrlWwG9D69/mm
         aNIUdSmH/OzExouUGINcJn7bXFWWLnINjQQbdTwvEaQ57X1DQv7teaBer8ilmTwQ1iE6
         LfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699649; x=1794304449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iH+5bLQSIskdkGMDhaMY+sY910o9sCp30GjpM4gNOE4=;
        b=pjsmBZBiWlgYiQcJyp2JW6Zt2A8O6ab30wLPJDbhUzhPdrzQtIQZPq4fUocH+B+El/
         5lxpqMWaAhvRFXf2DY3owKYw/58HSSudFZ+L2VNUsKg70n2RP35aQ1cXkCFSsdc1hlcw
         7vQ4MTyLipcRomrWgKQn+W69DIK6Zv2Sogb4G0I9HqBFVhmu887MbTmSajNa73dIG+qs
         N4O/GaKv2i7pXla8fmTDvffgVr+ZnOFC1K6ADKfuqilUut7F+FZQ2AgseXSl+wFS2ntm
         rIaqm1tTBkScrsyGzB7qObGoTJ9JLpebibc3X4LmqJGaXBaIb6fNw7Z10yirGkFzR7H3
         qwqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwaH+FPaWUFfSu8DwhLI71V9za/WKs2f4DEEmdFmCz6rHLMf36UQw9yH8zvxsQs72k7fVImC/naCjHMVyKZ5g==@vger.kernel.org
X-Gm-Message-State: APuU4Z+bMUZSru/VaSlY+IaKpnIWjtRbvuOLs1J0UfZ+G3DlbpEdccAA
	OyfDUGZLdN/d0MtJhIQX9AuA67v0aakv/xaVcJd7635hYErxM0FeElpW
X-Gm-Gg: AYBFou3gu9ULUfpwHlBwQgq+6eoVE/P10nVCGaD430JmczLPA0BSrJB6xXsy689Ops2
	5nVwZKdRlcqDrLfrkPGSRvYp29BUpW8N/eQa8TLtNn/SHJkD4P1Dls0O9NhWRrzBqa+fr5KeVob
	4hvtJaT9/cqpoLw1kTWgwuvMQNfhyg5Q8sT4PEUXHmAOSeqrx4B8QQwlaF4kN9kpIOfr61BCL/+
	ocFH1p8WDdcevCOyjmorlwqUXh6n6KxvkRmSIEYTcZDR9OpEP34QQzKN9FLniImQLZlvV1DmiCE
	jLHSS+/SbWkwz4ROKDmFkiurpHKFU6JYx3zG3fl+X7qbREI9zp6cPn0MqYDJ+fRJiK9NkgclH0r
	70vfTm8cz97MfSBkWDm8mwUzsMvAhyKRF9fdENNCEw8InRnARuirc5+iyl6C1bSdmrLv1vc5YG2
	WoAeSev6o9fZjJOI9qYdxAEB8kcQPTYhymsU19enlNVBTdp8JUaT+1F7zr/eBriGIPiuUI35CJ6
	gYY97N3NgEKfLfFrGWlTTCEy5u2G9HpH690L/fi8A55ZZ2hAxkr2cB2vRLOm4J/I8IumVnmvQZa
	q2kgmHqZshcaxQDmP4OOcn/T0rDdQnfIMT9hJ3wTMdK2yg+iwv533tOa+JIgciFzsb5m5b2lB/7
	XuL9YdOpn
X-Received: by 2002:a05:7022:ec85:b0:15a:2b63:a0cb with SMTP id a92af1059eb24-1ac59dd081cmr25711377c88.13.1793699648752;
        Tue, 03 Nov 2026 01:54:08 -0800 (PST)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:9e8b:5db3:accd:585c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aed79b3dfcsm44178383c88.12.2026.11.03.01.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:54:08 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next 1/5] wifi: rtlwifi: rc: start no BA session for QoS null frames
Date: Tue,  3 Nov 2026 17:52:50 +0800
Message-ID: <20261103095256.949327-2-hjf3108@gmail.com>
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

Only start BA sessions for frames that carry data.

Test results (2.4 GHz):
   before after
TX 7.0    6.1
RX 28.3   29.1

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
index dcfaa98198b612..f475f1b8a98272 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -216,7 +216,7 @@ static void rtl_tx_status(void *ppriv,
 	__le16 fc = rtl_get_fc(skb);
 	struct rtl_sta_info *sta_entry;
 
-	if (!priv_sta || !ieee80211_is_data(fc))
+	if (!priv_sta || !ieee80211_is_data_present(fc))
 		return;
 
 	if (rtl_is_special_data(mac->hw, skb, true, true))
-- 
2.53.0

