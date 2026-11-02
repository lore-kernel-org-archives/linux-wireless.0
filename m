Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793627974;
	b=cDJmfj52G17iZuqRNAN8sVOOkXpHjMV9CA5rCM4prCp9GNPT62YwmFRxB4qcJ2Ld+reI
	 zrZg0Qdzz11LI6rmTykwk3NdnVgctABbZIU3Qy8mm/R4cM4Hg873mnnI0AaVD17n9UMFh
	 qQu6nw7J6ZKzn6XePSppZwyLixUh171BJoFAfKQrSiy76UunmX4B9FGfu45ZRSL6LDL5L
	 MSBGEMDXFui9rKjnJo1MKHk4QUOYWONSGXvSI0c0gibEzR1asIJmWytRS2IhimsfM5h96
	 KInfE4OQnnH7NfdfaUKbPwlkS/BLzvt6L6fQIIDu6dp4/jbwSp+2Pr97+WOej+J4UBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793627974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S2d7OdEO5Uy3arxUL89OA5ZZcKM4fqZIMbcJ+h02Lps=;
	b=anB03oTrzyOYlQNKu1rXN7P3Y1lwT3HWFqOZQziEaKl1XfsuQXJMSXmUYWwPkgYzTPTe
	 bEqipdaaYPy6CxOY6kXlG5TTSdpDl1M7/D5gMqK34yLPEorLCLBg61a64mJq0vBhTyeJ1
	 UJp4YT51CmmHMY/CDHKZ+zMAK/+Bh/twWvWh9Ld/tTAoP9ZxJKtXLQ5N3ijhDtd55stMh
	 TmcDK4pDVJr04lgdmntZT9we6+D0xmKsrVceF+wNmJVjjmGJZP8zH77D3YvS4Y2xemtoB
	 tLzAKc5t7Ojkzai8pdR+HS7dj2PEkceIyWM1fGftOon6/6rQHzrTIc5dswzxDR/3UfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oBUnxIfJ;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AA3606A32F
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 13:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28AA3606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oBUnxIfJ
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso30834985e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 05:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793627972; x=1794232772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S2d7OdEO5Uy3arxUL89OA5ZZcKM4fqZIMbcJ+h02Lps=;
        b=oBUnxIfJDoTZEByopHtEIdJUz07MmRKUaOQlkZrSFrJ6mML3CxCbB18dGoaYnGq9Vs
         pTOhEao7IAJrPqBvsd8MQDNNWlYs/e5e6z71xIxUoB1IGN3Y5JdagVUXIPbx24AGPbFv
         YFJbTrgXPE5Ed3Se2V7RQfOWd5ZOxah21CKOVc+IBQrcAJVVD5xA0q3n18X9wP0n6nEb
         cZ/9SgaF99UQAK7Lb1rUDImy7wEdptuQWjdGz4718wSaLxnpX0zJTaZFVWf9zz+qkKwh
         EI12EzgwYLDcf10HIn78HuD+UKeOJh86v+6tcH2yfyo9UvEhbHBNRxVNLTaW6/mvlaJL
         QivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793627972; x=1794232772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S2d7OdEO5Uy3arxUL89OA5ZZcKM4fqZIMbcJ+h02Lps=;
        b=uvFIusY1orYmHUhSfjpOnElvl+H8gJsdEJDxkvHRiMYSgM16RA7DZcotD/f87xBxKy
         m67LIv3Vs1QBhUJg9RbIuj5ouKpbje8Otvl62KoxE4+C2BrWQRcRuuN9A8YOEHaLqO4E
         q+cKIZqyfDgsaL8IbQCpIqviFq//vtiO9zmgQjqFekJycvtLXnqCaXr5AeZlJe8T3uUr
         oI+pKaNurQfy6qF4LA+3Gd2CW9FDGmLkwwqANyVXqqfWN1WivyEKdH4frkkAVbqaTgDu
         ER7U1x0OG0wKPzkqFCQfcqEdjAQ2MISpS0TSkRD0prEPbn5CAe/qfKyIqNR+tGJh9fWc
         coQw==
X-Forwarded-Encrypted: i=1; AKwUvByKIpoql90h34OT9viDnZZIuLr7Bvu4V8kUOj1d/6R/8yGnWkuOoQgVmJkoIH0qNhRGz1vlDpBrKx9cr90zsQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYII3YV2PzuNfPWeS/wkcj96jKICo8RGTHYfaqFOdhMkzYPm+NkD
	k/scvvjtiRnCUeqbmVWM7ZxvDuvp1QZ2NEjCAR5vwsmZ6eHdR+969mo=
X-Gm-Gg: AYBFou1U//uM0Rdj5VhZevR0G40LzHzNtUW1PFi3EVoGoIURRrRTgRCRpbw1gPf5MXJ
	PBGxLA/O/RJ3zA9ZGc1H9/EAfwhwQPpvBE6JN4rw9Kyo2b1d2eg+aGBLTsgpKz3GUMmLE58nSM0
	WUsn+FcynE+22IUZ4VF33BuJOoFfDG+GIgUTk0FxBEDD0r16YuclVjsqhoP8To1q/JbI4CZBtFg
	VoIjAv4YIJGnWJT7wGoO2va59VPNGKw8A8fOZFwXyQOYCJwXWvU0SmBxq/NDksdWfDwVS/1quH3
	zTnGTVONHdogiRPbMBwbLr6tQwpNXYGa0I2W7Kd0mLt1xcrGqNhUjQvJha2IqolpIeip9SjZf35
	UZekFmASF60nzh+Mt5RV/Ug1bKszmE8sq7Ec3xIjSt+XhryHkjakgWpV8oabdAZnsiHd975+g9K
	EMgRTJptfoAXzUGdMzY1e4J5+STPa50fcPayII7KDz3OnhwP2+WT6+qk+5uqatJkcAB3oXkzzmR
	vCEy9R9BDT+MccicQFhmri185JrXpDz085XIexAp+u1pUeR78vf0226MwE9eYCY9qT7yHGiRCyZ
	32C9muRsouU=
X-Received: by 2002:a05:600c:848c:b0:4a1:f99e:f22d with SMTP id 5b1f17b1804b1-4ac17471091mr246374955e9.6.1793627972424;
        Mon, 02 Nov 2026 05:59:32 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf6e63e0esm352680265e9.12.2026.11.02.05.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 05:59:31 -0800 (PST)
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
Subject: [PATCH wireless 0/2] wifi: mwifiex: validate firmware response sizes
Date: Mon,  2 Nov 2026 13:59:28 +0000
Message-ID: <20261102135930.701845-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

Two missing bounds checks on firmware-provided size fields in mwifiex:

  1. ext_scan event: buf_size is used to determine scan response
     parsing length but never checked against the event buffer.

  2. command response: resp->size is passed to individual handlers
     but never validated against the response skb length.

Both patches add early validation that the declared size fits within
the actual buffer before proceeding with parsing.

Tristan Madani (2):
  wifi: mwifiex: validate ext_scan buf_size against event buffer length
  wifi: mwifiex: validate command response size against buffer length

 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 14 ++++++++++++++
 drivers/net/wireless/marvell/mwifiex/scan.c   |  9 +++++++++
 2 files changed, 23 insertions(+)

-- 
2.47.3
