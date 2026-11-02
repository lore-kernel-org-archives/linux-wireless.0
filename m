Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622202;
	b=esq6yd6K2vTAHox/I0PJJJFSBcHZQ332iTX4WSbW09UazbHgtIv0mtJ0CL9rMl5fnvj0
	 JHqK0rG9wyGdxIwXL5rV8FB7y/6HuPNjYtKWEYIMywztdJPIdSghk1PMYIYByGo7dYyjn
	 5BMLZaTDufo2fV2MvSTJNcbaW6bTdQ6OR2wsimtn04ARV41C58oL+gMNAT2XE7JU8lPQL
	 JmnVU0DW2ht+jCcU6NE44zLzrgBz2ZTOOE+f7NiFOO4161CZyjQwSTwphn2+aq+vYa6F5
	 70oycFzDFTH5CMYW12wT2vUIMTHoUtvo+SRs5S7qJ165D07KILiRnaVvE+f0QwUNU0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622202;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GO0eQoXsdHBDsAY8r5qLcEfQWImjpXMenyB3OyA2xhU=;
	b=NDfPTw+UQFOe1scFJab59ZxIYEd2xWYU4QMEGOu964KQIKb6lG4nh9d6SlmhWdies1Ru
	 7rsWnbcFhm0a2QU4MHd2AvhhiQ1Nlr5oVvJ8ga2bwGms/0kU4dx3YJsDQf0J0FHaHAFkv
	 sPTfxgegJkcQswnNZ0O70jIHh0R+Fp8hXhNxoh+o/aeoQX3s01VSTNrcTQTMsNcCPC57K
	 zruKMLoVDYaqsh0/ziFlfdjN4vAszmOdIOumG/OdKQZNMw/hALlUaZlipPRANr8zuUcBQ
	 YaNaRwUQ+b3h34qVLQfV1Sc1rF9do7RjQTOXPcMDp1n7pKXeKv/I3k8QJU3iIQ1wzUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oeIIAX4p;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B1E60A6F4C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:23:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2B1E60A6F4C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oeIIAX4p
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so22368525e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793622200; x=1794227000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GO0eQoXsdHBDsAY8r5qLcEfQWImjpXMenyB3OyA2xhU=;
        b=oeIIAX4pm2Ytu8HtJCliysszXx2L+ft1QWG6iYQQAJNhrx9G4v6CElDYaCW92uxUgQ
         PbcDRqjrGRfgtFHy03UVVHpCY4ePzARb20txTsium7zzi9mAPT/4uPGtFJGEbr7q4TWs
         Nj52mspXoZ80PZVZyWvoqFbT6bPBBGoJgHHhI/HPY2mnO2Ueqyf9YqQMitNYWXaAso4y
         7X72JBKP2aqjgJ2foNDEdhTgFLRx6hUS1sOCDrzayACksxscB+qleHmjUkfkcY1YogoQ
         YbKLFJfnRcBnUa9f/oZjQNwWoIGtLKrna9SAz6t39+meWa/qfXAgOGPakFgSVqVw4ach
         h7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622200; x=1794227000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GO0eQoXsdHBDsAY8r5qLcEfQWImjpXMenyB3OyA2xhU=;
        b=WI8YVCLZGlpwIzTVwmywtXXbB7ho6H686j+aWJXdn6esVcWWqlHoqndmJGIUShFIDV
         lop1HRyz6d1nyR627k16wWzReIALgs0GQedyBNia6l/ID2RjElI8kc7Y8yQLMxu9efe2
         yr8hCgoLi2iW7T7uR37GXgjmw+WT8TPdhzi0VxNcSlOI4mrSwChUTf8S3kYTjxeMpzti
         viVD8ZIFbyPELlVvzC54jCYVLVPuTR4DsIcWLE4z9bWWcNfg9Qt9tv4V/D/mlO1AwJLN
         A+kIdZY4lGktVMZQM/39ONW9o7ZvwXQFIT+qle4rE0u8mMTuqCoQ/RJuhAgyrAV+TSoZ
         zapg==
X-Gm-Message-State: AFq9FYLoL92UpNJjuVXPJwaDy1YDxHBQcnvdeMfSl27GrmfQcueRMuPL
	86S4In5KaHvxCd0vXyi6JI5soHx+DmOhIzgez4N4qaZCnRTwDSCN2XCWBcKX
X-Gm-Gg: AYBFou0pcEk1Ph95ERwGDHdTz5eYO7JFzHilinKeW8eDOfZZ2rgnRXFsu2BXf8ZRLQd
	An+E7+xGGCvaqUIucGewJdibUbb9b1R/qnN4MV5XtW1M4QSZb6eBiBqlSzdmhiTEjEXdsdH5XDI
	ilvicnGd4OITDk4CMAHEqmkxrYbZoWGdqlAtjdH6QlACI2OV4pr3iAk1dI//Ca/e9ugmQX2ILWW
	Peb9qHBZ67AwRV4IV8Gi7RM/sEGJISwNw1+Z12ypn+gmHM7eIaWcKQ6RyfPCfP+9egN2x/U7iVB
	1FVnp8I9Kd11zFajrSk4jWqdgtDQw5CAw3/gx2ZfA1Pb7QNpC6Bzp85rdKMWJIyad3MBfG/ehl+
	HnwL2APVLeKRSl3f48aih+pJa6/3tuseczq0YH14W9e/UtufSqJ5nIuaxB2FT5oNn5bw5M4tC6J
	5r+Y4rvfSbdyEm80NmbMkJGDwFJbLUvRUvSIIuwz/PBX0iUpWlVBYtQHSEta+Jdi0cf+Q2jqrAS
	akjekEm0GWUbR6CWUrqmzgpjbWpeJCJuXpkycP5wzyinaelmpSa+4EX391EsNihqqnCifIJKw==
X-Received: by 2002:a05:600c:c48e:b0:4a1:f7f4:7cf1 with SMTP id 5b1f17b1804b1-4ac16bc47f8mr229484545e9.11.1793622199807;
        Mon, 02 Nov 2026 04:23:19 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf67aa704sm255490595e9.8.2026.11.02.04.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:23:18 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	fariyaf@gmail.com,
	linville@tuxdriver.com,
	kvalo@kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless 1/2] wifi: brcmfmac: zero-pad SDIO write to 4-byte boundary
Date: Mon,  2 Nov 2026 12:23:10 +0000
Message-ID: <20261102122311.181075-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102122311.181075-1-tristmd@gmail.com>
References: <20261102122311.181075-1-tristmd@gmail.com>
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

brcmf_sdiod_skbuff_write() rounds skb->len up to the next 4-byte
boundary and passes the larger size to sdio_memcpy_toio().  The 1-3
extra bytes come from heap memory past skb->data, leaking stale kernel
data to the wireless device.

Zero-fill the padding before the SDIO write.

Fixes: 8f13c87ccc49 ("brcmfmac: Split brcmf_sdiod_buffrw function up.")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 71c2f99cdb711..c6dd4148a44ce 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -323,6 +323,9 @@ static int brcmf_sdiod_skbuff_write(struct brcmf_sdio_dev *sdiodev,
 	req_sz = skb->len + 3;
 	req_sz &= (uint)~3;
 
+	if (req_sz > skb->len)
+		memset(skb->data + skb->len, 0, req_sz - skb->len);
+
 	err = sdio_memcpy_toio(func, addr, ((u8 *)(skb->data)), req_sz);
 
 	if (err == -ENOMEDIUM)
-- 
2.47.3

