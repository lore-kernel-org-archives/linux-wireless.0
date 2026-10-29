Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281715;
	b=BKirOgcNw+1HTG6SVqOk3HMXBBFD/gS20FR35UXg6hHTHRnEeSH9JkYGLf9o3LZStX0j
	 r09/TFY0YKXFjSlgJK3dbwiJwMzYL7i1yXEukbjPK7ngZ/hvBzyuUHVH/A6C+HBjgiDfG
	 sn5+bR8fzp19hPriJR91NaQPcfWEsfnSzEIiqkvzvX10Yo3tbf7HlNkzO/GpqtMyzFzu0
	 769wRvpXgiPF4g7sCTUGy3lx90Eonc8kn8y7z+ATwWVNdwYQ3DsT9FCthmF04S0TNKp0E
	 Pk1Z0kI0GsTW8a13YInFjDY6t8MH3A+21cAjJn3fiEibad4ZQ5fiLMMQpvn9xyEonOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281715;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6FAsT6Nlkq5SUXzwLZ4CbonJEIj4q+1xkqhKuzZAeQY=;
	b=NatDTGL/D2r5BXPUFIMVTgkGrZsd14SnhwLEeFK2ydMpDR61U3yZwVK7RJm8zGVd6QSY
	 Y+VcEylq7Dvq+Q5oH2StbGWupDJqRP65hwd89cV3RJO66d06AzyKeHVmCxazdJsyr20pQ
	 K/dUxr97TgZ+pNxFnut7yhBeK4XwhB3QDNStWWPPKHeLhoNUWByswqT+AgSfa4z7Djq22
	 GPmd4BaimJlbqR5eXam5IgEEzoTUG3Z6eHkYIGWh5d04JnJf2lX5wPRhWNQjqmo/HAUko
	 Xhl84yZ8/4Rha3xvwMqLxXbS8aAhm5AIO3XZ6zRM99HZ4njQo+kyyvCy9XoySHbl4rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vNlZcfKi;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E7660A2621
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7E7660A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vNlZcfKi
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so474245b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281714; x=1793886514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6FAsT6Nlkq5SUXzwLZ4CbonJEIj4q+1xkqhKuzZAeQY=;
        b=vNlZcfKiFrbQWMDu8AtkAr0fe8dfBLX67ScNnCxoD7c5ltOQQh5auiFl+Xw3ioGBdD
         KPNqTVbjBhuUF6bOY0v5XquFBKifXPBzinDIdyhXLWxKyZzJ+dJ7goCKn3jVmN9c3xCN
         +g1doY10A3A6JuL/5FPEW4Joqok0zTfa4T750ZJWbAuXRZBZ1QJJMEU6SDrTfUb2nod2
         NShddLvb/Gi8qIYVctWei4cAxh3xW+WwpRFVBgx6wgp3f8SsB6d0JaM+3z5WLTtvUYvp
         s1PnH10J6HLpl23vzemaRprMHNV5XYal6uZ0lRXY0O2dfXnebVaY/+kOPMsy2Ww7UBZN
         W9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281714; x=1793886514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6FAsT6Nlkq5SUXzwLZ4CbonJEIj4q+1xkqhKuzZAeQY=;
        b=OgxEtaok5yS+nhZdYBwTrWx8BjfQ4/gTGC7FdDrst//WgVpfPJjwG0wu8sm7oEwvDD
         GtMSdAo3Lq4v/LyDukOVyVSi/tKfUDqneI5NuRkAS+ypLg3mRbrFRerZQl8jI1917aoz
         vdW8T5y/GaWyvuicXDgIlPLR0GF83mlJUNjZH27y4V/shnLbl2gfmopHOymnMk5lLm6j
         Or2sFqLppaqYKZAaFKD1hqrg0YT+lqG0sLZI1wZCl+bbKMSv4RJ0ETf0uTcHwzlkdIuZ
         3nBJLU/EpcC9yK6bSzAfBHpsMX8RdeS0oIJ1kFOA86nceFlC/xV2JBqTirgBP2ss9odx
         gL/g==
X-Gm-Message-State: AFq9FYJOvtg7AsGVb4+ni2rUTitdxFiXv70mznIuSDof4qhOvZTY2o9j
	qQAABW+iduxKX5RnXZYTGYmADV1XE6ufeqfkF/tu2x/bk33oC6kqwrdd
X-Gm-Gg: AYBFou1BP3KKHWs6Ne3DgELdcAjpu/gPcBeYaH/JgfG5P8pcCYm5vZN8S2O/OmGz/3/
	S6piy3NzyjiWHZXG2j8a2mS4W4qQLmNDbZ/HTqIHINeFnt3cD9Hvd9+PAAyIwzteke4vIG+FYR7
	OOussVyTujVDO3V/NVzXyHN0sh5VJXOGTyXPzQeBTSr3NMHmFfIpLwJ8GlZSLV6oOAHXsrmYkfq
	qcX5XX3O7hZBnuSCTeOJ4H2nqPaQlxY0U1dS/WHulaw0PaceVErdxzwHT6lDcQYLkX0n04gK3xd
	hEqlD+6+o9wznQN/A15ChR95M1ZKy+S9NqIaKkoq2F0bzuauJXpYsTNgSxkuwwy7BMowJ5S//57
	CcsU4IVJWztNgtpQYhZew2rPNKuIR6laoF1eN0oKfupApMeVEYvKtZqpYUhIEa5cYSBVKAkjBMJ
	swqw4VdPjwLQiGLn1Eh0XiP3d7ESv1fpf/SXO2mHpV5VrENOffD9Tyhy5j9GOHrh91z1+cuIjQx
	oCZSwhk7CAiUJXgL/ssBzbeQb47hwhNDaw1txaAjVFDucdn71Rnx64mHhHnqTNotM8yDT5aIocR
	2imwbvuzIbotKTtogTOD3s1tAIECq66EPpkD4rBvRPH+cZ3SwWke8gdT2K/phmKzasPoWmZkgtX
	G8HOkDWbx
X-Received: by 2002:aa7:8613:0:b0:89e:37b1:b820 with SMTP id d2e1a72fcca58-8a82e90b2a2mr1414879b3a.2.1793281714328;
        Thu, 29 Oct 2026 06:48:34 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:34 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 5/8] wifi: rt2800: don't report an A-MPDU length to minstrel_ht
Date: Thu, 29 Oct 2026 21:47:46 +0800
Message-ID: <20261029134752.1299130-6-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
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

Set IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN, which was added for drivers
that can't report the proper AMPDU length and record this workaround
below the TODO comment.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index de234bcc7a065..032cd6ac345f0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -11860,6 +11860,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
 	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
+	ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 823785088a308..66094da07325f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -373,6 +373,8 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 	 * by the hw we could provide the real ampdu_len to mac80211
 	 * which would allow the rc algorithm to better decide on
 	 * which rates are suitable.
+	 *
+	 * Currently, we work around this by setting TX_STATUS_NO_AMPDU_LEN.
 	 */
 	if (test_bit(TXDONE_AMPDU, &txdesc->flags) ||
 	    tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-- 
2.53.0

