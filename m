Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793627975;
	b=vh8VLnh29nsoI5+k/GtvsGKRNqyStCpd3vSKAikUnc0udRfttVMWpRbz8ZSVgiJgyBq1
	 ven04owO6HR2IawMg28ZtUTzRwPysSVGBFfIr99DWPBnKS+oTQVS9JxwKBL5jC6tUvTQr
	 dWdAm2/IuaRuYqLVd4t5ssDFsKgeVauypIwFL6325AiVjEkX05vCTlFe6RK+ZGexEr4Vr
	 F9oZLhGTgn99T5g/bqLK7mMgSj73y8TGRRPhIbZvW2ZhYzCTICh5Bzc8armzgo3mRXYP6
	 Mzjui2Jhaek7TkwNIRA4rE3BWJkGWcHBds8tJsIDH60DmXtc+OpyGu0Erd8P0HQqpmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793627975;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4wvmxRssayt2Gh/JlDXJzYBinssZXZB4IERgvDYW9IY=;
	b=PxX0PaBPwHb//Sn2xzY0p8dN9cAJtlPDJzqzCFXPeYwuJ/TcnalkgrkDMXoRk0H/AJ9W
	 OSCJiwjhjhUXST2MbOMwm6to2kXd7T+5E7+hAlBJPCR7FZP4Dn+X0zjSEgngv/wc7XfVg
	 pYJT3spJ8dzHTeJ2IqZtm5nA6+SjXnmkzihGAU0Iv+/yfujxYyMBHobO3cYzlw8stDwXg
	 rmbmcbbkSOM8Men6s8+i1jBVe647T3EbTbRZUl36WgSRhCEUFHpPn+LZnxXlpcMetdJac
	 KxgACaVCryAfodhFOLg04GuCh2HESVIhYV8T9U24fTUhQ+lsiiihI6XKzqUzL4WoP4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vyD8COu+;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FD6606A333
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 13:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4FD6606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vyD8COu+
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so34903915e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 05:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793627973; x=1794232773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4wvmxRssayt2Gh/JlDXJzYBinssZXZB4IERgvDYW9IY=;
        b=vyD8COu+frj4RNaBSRa57YJmHsoCzs2zU3MPsoqpSW7zJ58Oux6nDakb61yQZVMsvk
         XY4C8Xkohyp0A4mLJ9+HMH9zb1kokJF6nfADDFmzBLGZdcmJVfNq+wMxZcsQxOlFow+G
         ZIEQb+zOxL30lgzK3586obNv6TXVZlaqL4WU+wWHPLONDH/qcxVo8OHLfA46pL8SKo9A
         U+cIvzaEaX3/xImY1zmsVwiOz/ZfoX4h4/qmH6Q5v6u9Nx0xIJpgqmwWY7vw2JnyeG8K
         2EmRn91UL8NezbJ9Q6tYhu8e5M5JdvEd2P0bpWx6AH2kmYJCv3oROp8kGBIDrNlCscbO
         6gGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793627973; x=1794232773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4wvmxRssayt2Gh/JlDXJzYBinssZXZB4IERgvDYW9IY=;
        b=pMygmt84Bcps52rfTEQophvYiJBfv2rfZBuYdjTlobMmItc5o3zt3hRGMj3GT7qMCu
         SgslwyaERZZSaMcDtusxsDwNhlZGDCiFSKuRvVw5YXZcgmjBGvQIOOGkM8g9xUBtio1W
         SARzhtTCqrN6osS6oo+ZMbk0s0qKvLTAxxSvDccAYpf8dYhN93n1caRKKY0qKLDr4Xjy
         VePEpX12jAkKLpjywN3UGvo++zGkm+EwinitdVKj95MJZ7tlBxscvgQhCeGCnL32xb76
         JKxuJ4VZDvvF97A9mnvur5rvi/u1T6LDqG77SoFwDHb6bof8nOWpS8lB54xjHCLDZnmq
         KW2A==
X-Forwarded-Encrypted: i=1; AKwUvBxwgzj6BiQYcbjzB13CWi/z8Z+ZKpCimuUfInpEfbtReDYhdESmhTtBireR4S9Zg/4cc7ol+/+VtinozL8WDw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLRKP7SSF6tkZhpR1KbvHf1nXMGUHIxteqcysX8ighyLMW8Js5A
	I3QbQujVELqcdidruJ/kuKLt1hwYtGkKn4CT7L5z28TezWiOHDOsLKY=
X-Gm-Gg: AYBFou0RlzOp5n4qknRbGy4x/812NrRDko89EpPLtERFvKk1DUgM6Rj+xWnXFJdudbB
	ZUtdk6E+9OG8LJVXFJddj7/4PJUwldrv+uhsuMECJpc4YBIjTd/7TJgXpMG5xNxkO21xQCdkABo
	Ao+T1hk23y1Lsn1VDbP/VwwYkF4e2bybcF0zSlInfQ8p5avP2SnRGlaOmT7bt3BxfdHI6yEAcpa
	guXLdjDrwlmDLUtZGVNCeRQprWG+kU75f8UlFG7azlNH+qJ+7O0SA5IWQZ+tOO2et2vtHy6imyL
	h5/ML+hU68NnvtqlYjcnQLYgWkNK3fOWQM7mTFJhjr0gCZQqpO55ucs1vMQvKvzWr205JQlxOhp
	OVtKHvyaG4/X2fBkY377L8PH4m8AquUKUKfGsyBtRiF33i7yTdfdN+2OEj08JPsgTUcba7BEB6m
	MPQPgwtZeC2+zncrRmJeF8KSACYE7OumYJBzAmkuBDV4H+HKmRO9T2QygofNxkOX1+9NkL4YlGD
	QMEDAMUv4y2zJtJIcWviZtnD5rA2o5aciqXWhl2q1YBZIj1if79cLbV4VfwG9kiWX7uOwg2SIKX
	qJoXpM9LfEIB
X-Received: by 2002:a05:600c:8b66:b0:4a3:5a91:5f61 with SMTP id 5b1f17b1804b1-4ac1793f8ddmr242811975e9.14.1793627973338;
        Mon, 02 Nov 2026 05:59:33 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf6e63e0esm352680265e9.12.2026.11.02.05.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 05:59:32 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: briannorris@chromium.org,
	francesco@dolcini.it
Cc: bzhao@marvell.com,
	akarwar@marvell.com,
	linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 1/2] wifi: mwifiex: validate ext_scan buf_size against event buffer length
Date: Mon,  2 Nov 2026 13:59:29 +0000
Message-ID: <20261102135930.701845-2-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102135930.701845-1-tristan@talencesecurity.com>
References: <20261102135930.701845-1-tristan@talencesecurity.com>
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

mwifiex_handle_event_ext_scan_report() uses the firmware-provided
buf_size to determine how much scan response data to parse, but never
checks it against the actual event buffer length. A firmware response
with an inflated buf_size causes reads past the event buffer.

Add a check that the declared buf_size plus the event header does not
exceed the event skb length before parsing scan results.

Fixes: 21f58d200388 ("mwifiex: implement extended scan feature")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index bdd4b8465863b..77f55a3f9b450 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2631,6 +2631,15 @@ int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 	u8 *scan_resp = buf + sizeof(struct mwifiex_event_scan_result);
 	u16 scan_resp_size = le16_to_cpu(event_scan->buf_size);
 
+	if (sizeof(struct mwifiex_event_scan_result) + scan_resp_size >
+	    adapter->event_skb->len) {
+		mwifiex_dbg(adapter, ERROR,
+			    "EXT_SCAN: buf_size %u exceeds event length %u\n",
+			    scan_resp_size, adapter->event_skb->len);
+		ret = -1;
+		goto check_next_scan;
+	}
+
 	if (num_of_set > MWIFIEX_MAX_AP) {
 		mwifiex_dbg(adapter, ERROR,
 			    "EXT_SCAN: Invalid number of AP returned (%d)!!\n",
-- 
2.47.3

