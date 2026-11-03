Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699652;
	b=SMmgJK7Dk47ZoRAMF0dG+RGHr05+1N5q0P/GGnTL5YHjna63a43VS6UwULE2cZoIpsH6
	 /6eXw3L7eIQwb61ro8PisaXqYJldA0DQ0VwGWBizP4v2TEL/4yJmovlfHB3bouzAck2eI
	 EtmvlO4KgRUqgnCI93P1pO4HyTVdTtN+1+V1P4B/8uQCbCmQKXwDOrgBbvhbna4jd9dTr
	 jqKO7ykEobYbTlAsXGoCTCkCMGylxD2ULHw0bSyHvDc9L8hhPkOd8zyMqRwylPR5XZxkc
	 ojC4/bTQztEkYK5JAUw5Z9a+ocib+nfFMLZJN+GD/y8MoAyTVi27fIYYyeI3KPkMHxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699652;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bEaC9cqGjO/waX3lszZK3l+LxB2AmWUBiYfX+wYhT3o=;
	b=CKrwKU8se5sJtMxg5+GyIUIPM9/agi3cb5M7ZuKlCRNCzfslwHvcoXoadZ0xdkg02vIH
	 3IwO7siXwZ1kXk92s5r40jxB9mmrgTAG2lnHNLKVwP9njWEJNlMPV0fN15PNv6cHl2kRO
	 6BuMIh+n7pK8e2EDlS4IEIgF1I4QgzeQgSykKaW1R8TdfqLuJ9IJBqlFP9AWY/OTJLHKk
	 ngmM9doq8Pj5JPjSzcSLSVeF4Kd7Q4LeEurpc8IFIy2+uvBDxfaLXNBPg1hXTZKdB6Gcv
	 FN0Dt5NV/ZCMk7LiKV4IMOO2R+Uyf/N1Mx0+G7IFPpYbiMCb3W9WAFwUrmyKz4zcDSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VWPV0q2F;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B78C6085083
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B78C6085083
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VWPV0q2F
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1a8cc11ac42so3834681c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793699651; x=1794304451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bEaC9cqGjO/waX3lszZK3l+LxB2AmWUBiYfX+wYhT3o=;
        b=VWPV0q2Fql7iwZXyb2WpBVW1604iWAwJ49R1dY/T1xlKmrcuPfXP1aPT8r15f06qki
         Mg0Cs6Qvxcl/eOhdk+fWXFTfOJn6OlcYKu06Rnk4hVzegy5W4M9nBqD3R+jg2HicPSHb
         VTrvhTDIEw41kwu+7w4vtKbrylmqg1v+H0wQmOb4/5Xk25+Kq2Mm7XXJt+3vo/h5Rd3D
         cSY0mwwHeEKWtBEF0beETgc+x8pl803f43Lb/E3Ft/Ny6Ia7tcsJduZh4R89PT0LRGLi
         nMnP7qTR5wQzsh0293uLJHNfLMiMP5jLNWSVt+9U1+oRzGnhaYqi992wVpehb65q2sNz
         hcbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699651; x=1794304451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bEaC9cqGjO/waX3lszZK3l+LxB2AmWUBiYfX+wYhT3o=;
        b=C785z1hj7Ffo3eQWp/7Asi0i5XeM4R2tj6Sy8q3SNEdPnqdSdSCK3ZxSF/Q+09+JLT
         2eCzl/YkNtBp5w9/qaTIxkUZi3/ZOFBUlihuzwCm/anSiZsHwYgZD0EqMydOsnyFBz2R
         uE9zLBswmY5ba+BH4Brx+PMKfhbonzgILW9Z896hdw+ngcifrAmTBxCG+t1g7fx+x8bb
         zGVvKo2yUMqyT8q2yXvpO0Ph4h3KRpaCWDywq6RJXanDYdqP/1u7VZfeHZlyAEtd9GSI
         /0pd07r8JkfkwMalPGxNhIdS/W4BY4UVBYGDHbBTJyRi33R1qfNZyZKWNQdF1gm6aKSx
         3eVg==
X-Forwarded-Encrypted: i=1; AKwUvBwXfee3642GK05dCw3mJvkY2dtahhdNyTCi/tEWfqs+ziSZGVP/NoSUK22KgaXbGHRGFaqzyqfWU5xISvo6bg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/XIcNTU2TQt0pZw1Q7jGjPrn+uUc701Wi7n6yEdHyeT4HHrSj0
	SLBoplXtb009IUDcSHWVZXk1AJKz8Xa2q24K/hLXWnBjiDzOeY8q0LjlIPelpw==
X-Gm-Gg: AYBFou3ZUgL8kELi/dedcH6z5k912AMuEAuXnTWggUnxrZFNs44/BRnDEXPKa9WRmDR
	E3C/HIjz6RBLVGLGCsUGnvH/S9UAip7xROhXX8YUTzgV4lcvMqZxXN8txJaZiK4cveLSEmf3/Tg
	jAMs0/7zsiZfTBwvhi3qTxmQIXmIdoc5zRyx3T8KPowjc1twWGupsJTOFzfm9L3m7s8GyOyeBzR
	r9OitGCu4FiaiQmH3OfeasKLudYbwBu59s6ZFZ5E9YcLQznY0RLRRerR74NaVNWFcHNUcS5MYUi
	jTrLlW7gZm2wRGgPSniR5SUa1jwPEdDNspeGx8VY2KvbN8cgXz3GIUvwIF6hL7+bY1G3K0vj5PB
	oVIzjS76uzK63U0/wjHCloWv3sPq5vItFlkvPZ3QnNTGNfUK8fQD7UScPDqsE4tAlN1GeZ4/fYb
	yNGSzYWay/RTcqhJGqXRukNDlGXoiE1uXCeMaBBpBuJMhxD0OeAwPOtnK4Yu6zfzPCZm7m4I5Q8
	TjXVnQ3kzK8FpZrKhPYBf8CmO4UhhYh/CUnu+ZBzxuFYMSNpSs/tUnLeMNFJ5jZVKf+9QgZzv9X
	gkj1nIGcz2LxmVVUV1Axg6lm6iMBi1CvC0CKwXMF6/eSKpeVfpFlifBeGXcFdl1QiM5EAfSQQkh
	C6p/HBvL7
X-Received: by 2002:a05:7023:90b:b0:14c:8461:b3ef with SMTP id a92af1059eb24-1ac5e6f5132mr24148676c88.24.1793699651034;
        Tue, 03 Nov 2026 01:54:11 -0800 (PST)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:9e8b:5db3:accd:585c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aed79b3dfcsm44178383c88.12.2026.11.03.01.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:54:10 -0800 (PST)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next 2/5] wifi: rtlwifi: rtl8192d: report no signal for frames without PHY status
Date: Tue,  3 Nov 2026 17:52:51 +0800
Message-ID: <20261103095256.949327-3-hjf3108@gmail.com>
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

Only the first frame of an A-MPDU comes with the PHY status.
This makes mac80211 report the correct value when queried from iw.

Test results (2.4 GHz):
   before after
TX 6.1    5.2
RX 29.1   27.1

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192d/trx_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/trx_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/trx_common.c
index 9f9a34492030c6..a8910cdbfa0979 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/trx_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/trx_common.c
@@ -425,6 +425,9 @@ bool rtl92d_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 						     stats->rx_bufshift);
 		_rtl92d_translate_rx_signal_stuff(hw, skb, stats, pdesc,
 						  p_drvinfo);
+	} else {
+		/* Only the first frame of an A-MPDU has the PHY status. */
+		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 	}
 	/*rx_status->qual = stats->signal; */
 	rx_status->signal = stats->recvsignalpower + 10;
-- 
2.53.0

