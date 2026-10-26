Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793013717;
	b=O+tsMDeKBSSDlTWtnhgmObgT0c8KeBV7+MnPkS4gMXUXTFexhxerp1qoK9YpeEqxP8pp
	 H/PjHj1HmXB/DyvAItGkEOkuvEb6uci9l2ENs8SKvzjkG5bYD4xsHtH00Ecu5aCxrxUPv
	 cd60Dj/kLDywvyiON7QL6YxRAsJS1kmnY0IZ/jQYc4EbvsNZ+chJnsyOb8INIv+pTtEKQ
	 egW/SXAJfv5y7XcFbusKQPkhMQ/+x7c48V7RtwNN9UeMDleDplEkG1Bdx/PkBHPVWcMDn
	 qrp9KGCj/UJ4bQqbY7iLMCJhP0oiHNzpSXgpSGrm67IXJ1VMm9xR2olfTHrGH7RvS3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793013717;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xZ3hvppsJXNIOs0Q7rs6a6KCMDKrK3IMk+V7dGRWIBo=;
	b=WOUYCe4PJZxvedlgxquzwHh1NrCyPvVzhiYnlqE5qMS9Sp0oNPr8sxHCrXGnWDGeLObP
	 Qr4btVRs3Yv8SUz46XIc1MPCGofnWWIBhvZMC6toRR4YGXS3YBLRnjLfCqz+IJs2FYNIH
	 z44jYL51qGyeGrVCEzXTnYol+xMwo8kMVF85kvoKjFu0INgyt52y3dh25q41hVdbgJWDB
	 SDSjom8kmx3s2FitllG+Y/IGDQu2i8d/wH7NNSAmqNM8qoZf0DZValar4rnu7xrH+86r/
	 abAVxTItcoIO/UHLFqIvjd7L8W3na8zK3QM6Kpb3TcvD9BN5/UkVFjNTOGllpewvhKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fZe1YKnc;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C693606A33D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C693606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fZe1YKnc
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48df4f540ebso1386318f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 04:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013716; x=1793618516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xZ3hvppsJXNIOs0Q7rs6a6KCMDKrK3IMk+V7dGRWIBo=;
        b=fZe1YKncduevfg7NRuTy7rSWE+XGiGSVEcRN2B0KUQRf3H0Ky8Xsymf98qiiGW47nA
         T01E+nvTV9OYNFD4pi7cViYa3rciBKhLiwCobizFfV70x5vKYQVU0b2IJDfB+8gbkhZt
         LK12IZWnOk4dH+90/2AW8JyEfrBgo7wAUyIQjghgHNv+/R8f7lY9eIic9epayqPX1kzI
         EDVVMXykiPZqoEqa7ISHSItDHmts9xImVsFym5q8aKW5bwuqb9+1kdj5s7x6P9zlSBva
         xpQNxS+f3VHPjDsgdg6eHhVR1DLCga0yWK6NlLuerecx+b233tOOC4FsbFKFfBOhjWbT
         fBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013716; x=1793618516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xZ3hvppsJXNIOs0Q7rs6a6KCMDKrK3IMk+V7dGRWIBo=;
        b=E5ntzfd+GOEPRfHEVNAQNUlxcLWZxnwRmT96PnBNKNVwtLt3R9fxpt23bgPiXfLvdY
         Tn2NcJMpRaDeUd3GuFmE1K5dPQC2GjLtDMecvl907RFn5NYtDM3LHfvj0As94VVqqXv6
         V7gOVAhtwTew1/yQVinG6XYo5NoA6qGkJ23Nsi+PcMJVGj384npn4PnO92CqGEdxrfXy
         iS2CEzW0Lfj8ufjYP4FDn93U4960q6UNy61/cacdfG+9FwNdlbhtqqCzHmIDzi+CKc/n
         3KmDPFpaplxZeiQ8aZ9XUizrlZGyqTM/4fzioNKaHbqdddhNk5CsImfRBiQnQcp9XaiQ
         fDNg==
X-Forwarded-Encrypted: i=1; AKwUvBzdcLHuyT5t/8frkfVCD8bwgZTJzH15n/zQrzyXmqBeYdJoEsBmZ33sZQCjcn/kGvti/aA5Zs+Hzjok7Lb0hQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJcjRpL991KWAuoAtPw5Y8zxowxJyjvTGFouEKDL0OBEAwGkEqy
	g2f4+5MALpskW7dwcaB8IIrRK/cTStEsOyOwMp9geXnTDcmvvxtFOh4=
X-Gm-Gg: AYBFou0aQ2DRNqoWqOGNrnv5h+CQuBITJNbBcVn5DKTfCqda6yBiF0vA1kI3JNwP0IU
	ggbHddAdcHNx3E+LhiUvs/krWSbFNvnyVnY9zF36IAf8oWIGEXFydkMx4I/Xq2KHHa0aZyj2k7p
	AqZSKveNsWSdFyXl7srEEUlciOts4mRYP9fkYpPWlqmmbEE1t1C5zd3Q+SUVaPScG0ekISU53vb
	fW5kenVfIfdewZH6SsV13EmxQVDpCu9jLs48AA3fqD9hNwWVO5mD1+zCAIEms2p5Nsmox8UFfuC
	xlHzGeJAw0tSyRinRs38Osi8KG1KJWKhycIZyPSgtO7WcBvngIsByR7KBV2ps1bnNliFA2Wf+hj
	UWq6KIa0DiyVNfkGCA2dQCQaQIFyQ15nRxpFGMNooGfd/iBpIvhKNs+3l3JFrrbb6snpASOKM6E
	k+7WgOXz8fk8WQ5OCMdAXqgNbQcEwb/QP538MGiAlo8tBYrGXW7ORGK2SZLbXhrOiaHee4q65Q/
	UkgMFnPYQfRIZEahEjkTZVKkS03lzmSXzUi1wpD0gH+6Q==
X-Received: by 2002:a05:6000:160d:b0:48e:35d4:55b5 with SMTP id ffacd0b85a97d-48e545bcbe7mr305812f8f.52.1793013715854;
        Mon, 26 Oct 2026 04:21:55 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdfd8dsm15048703f8f.56.2026.10.26.04.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:21:55 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 3/3] wifi: p54: fix IE parsing loop bounds check
Date: Mon, 26 Oct 2026 11:21:51 +0000
Message-ID: <20261026112151.2515228-3-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026112151.2515228-1-tristmd@gmail.com>
References: <20261026112151.2515228-1-tristmd@gmail.com>
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

From: Tristan Madani <tristan@talencesecurity.com>

p54_find_ie() iterates over information elements using a loop condition
of while (pos < end). When only one byte remains (pos == end - 1),
the loop body accesses pos[1] which reads one byte beyond the validated
buffer boundary. The read happens in the bounds check expression
pos + 2 + pos[1] > end before the result of that check can prevent
the access.

Fix by tightening the loop condition to while (pos + 2 <= end),
which ensures that at least the IE id (pos[0]) and length (pos[1])
bytes are within bounds before any access.

Fixes: 0ac0d6cedf611 ("p54: Move mac80211 glue code")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/intersil/p54/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index 57a62108cbc35..16614f65dfa5f 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -81,7 +81,7 @@ u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = skb->data + skb->len;
-	while (pos < end) {
+	while (pos + 2 <= end) {
 		if (pos + 2 + pos[1] > end)
 			return NULL;
 
-- 
2.47.3

