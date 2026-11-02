Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622205;
	b=VHg7JLufJUo9v2OaINRseeG0OMfJbTiFpwf3JfjJUvYMPWL2jPBtiGiqupgMcqDctSxJ
	 1J6x2bGagCNvYORfs2Sfelll5qART+WEO8eKp/aF2mdcPvdZZmU/P7TbVINsDRHqZzf5r
	 FdCWKl5gehAP1638K/GSfFrnNsf1zJaZvI/YBlmnQayhHivgkVRzvPTX13nHYeR07/M53
	 8EYK2tXHOpAZEzEWX4EJV/4ZqIFUUPtMdg22x4LfVUZP9LZ73+RMtRNmuRIr+++35YOZr
	 JXgDBc75a584bWLb/q4TtRjTrNFxBlGbSG0nvKVzbikdGeWcyY0+zZwp63c+0brvjAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622205;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gKgdPxUwvGsj1jITDycK6PgHkA/hoEEzGZT6KHBzS7I=;
	b=CWSJySu0iPwNJUJhAa465ZQdkWos49ShuJ5gwfuZJJ9kZdCqmzWMKmxl3AG7nD7KlfUa
	 JaDF9AWH+AEhf0SIWWZub0T00jBVBXA8pLVBzcvp/8u2IyG9j5pSmKwNWpJALBghybR65
	 VsBNfa2551e6UI2ty3GkNco9Ljlyfxmb+RxpYQTYsHVEaJPJBrXscCHmXdjSk9OBxJb+V
	 D6EtEcQXmK65s+EtfP6bx2F9d+VPv3+N6+XKDGbwVarBdKy7fn8uLIS6CBkkswD3Jgd2g
	 pUFTB7/NWZP79TjCdn9WjyPN+CwqGtO22gOlKyvrnFyTrQFLRaVfoiHrmehddLb4U3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="eqUQ/aSU";
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E76A60A6F75
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E76A60A6F75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eqUQ/aSU
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so24342285e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793622203; x=1794227003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gKgdPxUwvGsj1jITDycK6PgHkA/hoEEzGZT6KHBzS7I=;
        b=eqUQ/aSUpzOH/ouqbWd6Z6zeNty80SmGLbcaZU3kusNRz+1m/u/i/RSkegJ8/Sou7S
         gZQYnwajklbBSa5Lw5km2FvzhIy++XDjVGW1inLAj+Nc4fh/ih+rswNlYuFPTFU3AZkf
         5yTKbS8qNdo/L6V7n0sIDUYtB+voTA0rt2wx401gMbzpVeP5c4yTJOYAuI52p53ixdj4
         aMbs8tJHwDQvrU67SgmeZI1vrqQ1P5gvnqcP9u5zLRmx42PR8uYlRzFmzDMCRytDvLO3
         NlcGOgBRsBtn8DoRK5r4hs3t4L/hqIWa3zbfZyIKjIWXXLges79hhlvd05RZHkq8lREU
         Ei5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622203; x=1794227003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gKgdPxUwvGsj1jITDycK6PgHkA/hoEEzGZT6KHBzS7I=;
        b=xZinWbFQ0IGX5Nkz33adbSYhCcFwVY5M8urRuQFiREqpbcmgTzk/m2gyk+uW+JP/2c
         VftxwcpqgiMDnK/zfGypLT17t+TP9JDrBnlaxdg2fiicfrL9ceoQsAZWjX1UDe6Xlbfw
         y3YlwwFlIuBgQn+EhvoqGJzCSwpRVd1lpJeyw6WAVorxMIKMV0QCtngWBUOQlwv+KsN3
         bh1zshhS/xBQezHOPocxZj7iqQuXJ31oOJJI6CJ4UUUAAlqV+hLLYjB2xvHphS4pbHvv
         ht8ZojdosCLQeQsIdPNKJtJnYygZPKRzKI9FKT1ITOUcv+8zds3wyKxqpJFKzooMxaGp
         7TwQ==
X-Gm-Message-State: AFq9FYLAHXMC8OygYFo8SjptGXa+O7YHQYsINWNcgRMch/yksLQfJpV3
	xKA1B+U6Mqj1v9KbPikX+SPQazlsbwENoQlIgac3eBJXXjsiM0jHJxabNVol
X-Gm-Gg: AYBFou0KRI2xCmW/zDjn9RO0Ah5Jwz42p7Q1teg23ZrIkekzbwdj2epG+gHGvrKX/fi
	DZTLrAa3TRPwB19lHJHL5l28UuP/dZKN9Daqm3sG1Mk8dukmxCLCLL1JpWGdIgyaNdt9z7mhRHt
	YV3qVZMpEefMsL9QQIlUx2kzyb8EyB6JuK9Cagq5UF4AHtQsR9SD4Iiqdp//II5v50MuhK0hxKt
	Ncd95ZkIO2XVPCY58pJp0sAHDnoQn6p6+mGzeE753OdXD3VkVHRmrCOqcbJpc1fnnX7ismQWNQU
	MeioKb/SxmEseXVVboORgNZMJv2dZYL9m5yU16bIxTAt5CC6hAWBXs96zG7ufKhhvVG5kMnRxEi
	YCFKd3jrMr95MzLW5GV5mWiG5TFcuX8Zg/DbAr1WB3M86nUYp9A9boAfL36CoiYDNdydC/wig/J
	p15E3AjfYvktvtkYC6efFDWhqYTq4YvEYTIMN0H2fVpwhYNxwUMv9BnXwq6ZtuZMfJVNW0Q3L1X
	zhagy1wuRIykTocwEpY530c0KoVSh/3xTAsCwV/Lupmlah7U3ZyKqS/Cb1s3nnIPBH7gu8GoJ3u
	dP+igOrlNPBGb+SkRxM=
X-Received: by 2002:a05:600c:4e90:b0:4a4:f48e:78fa with SMTP id 5b1f17b1804b1-4ac175669e4mr221304045e9.12.1793622202606;
        Mon, 02 Nov 2026 04:23:22 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf67aa704sm255490595e9.8.2026.11.02.04.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:23:20 -0800 (PST)
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
Subject: [PATCH wireless 2/2] wifi: rsi: zero-pad SDIO TX to block boundary
Date: Mon,  2 Nov 2026 12:23:11 +0000
Message-ID: <20261102122311.181075-3-tristmd@gmail.com>
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

rsi_sdio_host_intf_write_pkt() rounds the packet length up to the SDIO
block size and passes the larger length to
rsi_sdio_write_register_multiple().  When the packet is not
block-aligned, the SDIO controller reads past the original data into
adjacent heap memory, leaking stale kernel data to the wireless device.

Zero-fill the padding before the SDIO write.

Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index bfa386b820d89..8bfb08306d03c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -772,6 +772,9 @@ static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
 	address = (num_blocks * block_size | (queueno << 12));
 	length  = num_blocks * block_size;
 
+	if (length > len)
+		memset((u8 *)pkt + len, 0, length - len);
+
 	status = rsi_sdio_write_register_multiple(adapter,
 						  address,
 						  (u8 *)pkt,
-- 
2.47.3

