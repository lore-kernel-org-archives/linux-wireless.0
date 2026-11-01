Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565538;
	b=I19sL8VYVz164DtFyny/C/VuMUqRvlu8T3W00hpStB387/5YUAdpBCrlLFNP9ZiiU+Qc
	 buVuuCRa6IV4gm8qDYSh5dGQ9iOtjhVnleIx5HHg/bF/kU/YF5zCb0jPHUx66Xn9iy31A
	 Sc8ZG7n/pGNoUdlqw/auUBKzsatApHJhRNvwVBoiDszqLjoA/ku9NSH4WghQM+k379t3e
	 3F2GZMTuXknsIUCSwxvsstakVBk8zqd29DB42Tc3/S8Uuieh1iRrX1EHB1mifN5VRMdc8
	 Cd9OsGMiXOsFWo2taAD0E232el/vmnjHz72jZWNNe+2mLZp2L+BtdcVSan3nfXdcYDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565538;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jyzRAE3eK4igcY55MYF2Ksg7aA4zKhF87ODiuJEPR/Q=;
	b=V2d92cIodRdpQgB87Vlk7nBs9gOghP/1gOB5/NNJY8h2tYooQDI5nyHfBQvFs8aGVVRF
	 Zg6kEsVl9e/RKdyy09cG6LIh+4uiMB1l247j1q7zaqJGHQNYevMC5WICLkerhBpIvEweI
	 H9zd9ko8+BMrbq6tJP8eFwCWE0jEG0W0RXQBw/J87M2Rx2G4XUNPxsPBnh7EiqLMqOpuu
	 bcdfPK2nU4qu1Qc4NZSUqXjPURJnasoFOs9VCbMGgNvCcgrb4uarpZMBwZDKuOyeFXYne
	 XQGYYUYNnHFDEKH0g13vGp3rpS73f1UItlMW10DEXhGbvJnOAHfoUVPm3b0xM053A/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PC03FEVC;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF11606A326
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:38:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AF11606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PC03FEVC
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso1596404f8f.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793565535; x=1794170335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jyzRAE3eK4igcY55MYF2Ksg7aA4zKhF87ODiuJEPR/Q=;
        b=PC03FEVCY9+mDRScSx3TojfR8X8GFQYMbCOOPfu/3nAGgTc+59IcJ30k2SaE23wfF/
         GR7NdmdauPwpAKdJMsfJ0A5hbhY4ugXncbfQLceVTHf7VTLMCI1OPreAj2YRtozObiGd
         1BT2xJ2XEWGsHe81vm7bgdi3QhwHOZMA83AJ9gALIscQq6DsBAcJNn3V2liBKdbON7jt
         xgXQFiYDEQFbIRWZKKzRTzhlwpeeQRiLn7S9zbniLPDDBPvXVNKErMPN+OtUBlA4TDmC
         yfVHxBVjy+jjz7nRNPZJkdld6L2DH/I5hZ/RWLmT+HhKLE1RGTqln7MTHKjl0iIbGwAk
         LHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793565535; x=1794170335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jyzRAE3eK4igcY55MYF2Ksg7aA4zKhF87ODiuJEPR/Q=;
        b=hZg+tBYpjyHJzS3RNnqcegEjT82lAz9j7r5N6uB7PG7TG2o5CREb/aHWTt5h8afoX3
         WP1y7epMf1yg60fphOp8L9MF2GbYYTJCB+lCr9qgQ+p2bnICuNQDYebKSNFyxmol2Z5S
         a9a+4rR1iwm5jlyaCdeydb+mZXASDHVORk3X2vpbGndJIo53FyD1awdxeZ7h1xjOnpt/
         ZvdaM9BTBBAJCZVAq+RnWd99TUbkyRqygk5C5fvsEn/L0PyjdQUf0fFUrAIaJbtCg81E
         WSbEmtp79DB2uNSi7x9j2G7IwENMvOMUg9C0UveS/SmGrZ6HccjV7j1AoBIWYVpF+yOX
         kIGQ==
X-Gm-Message-State: APuU4Z/82R4EPRRRim22TAVhMbyqgnwPRBsCAQ3yT7ESJ/vVhJ3pGuzF
	F32JSaGpYwPZPJWOhpFfDXK1YOk684cDur9MiZ9FsZbq7doYkIWCQgk=
X-Gm-Gg: AYBFou096rNSb3Kl8+GbWghGvKCPHgzv9pkWMOc9kMl/c3RbpEKG/3pNFBBpnn8HunB
	uGFUveFmoCAhi3gsoPGxTHEDrcayL86x4bmpDZnsNEtPOXEgr8aQdZqvMQPXMV+oIxHkO+W9fd0
	UyTIK4KO/WhXrB/MdQlR/TldTa4RzJk/PrJ9VprCOL9TxJwBNEBq9prWEJzJdaTJoX1pdp4biwU
	GCXHIEqyhVGLkQMz+OfOxIc68C57i0YKmHloCR34cuCJvnGq5Aqrr9G9GIwlyysjUYXbzS6dpTv
	CmT6K15naEvC5jcJgdcNfxgtaQNsxMJUsgqaVq0iL2XhqXxm4Bg9iaD1h1Ql/5kUY6ENISAlu0F
	bN5Q8uBYJdkSGFCy0ahiiBlvmbWCO4DOF9XaFwzXFeikQpFdawpvrrh0WUmARvtrLUli1bUZmuE
	as2tdPdf+D3MsIRicX7f/Gjf/7luCUbOEWSArXfHrWLDYsqWYZh7O5hjGyY82O33bYfiFw2FZ+h
	I9U0WrudBJAPQlQwgiE7Difbx6aJHUXIT1HIEbLPoyy8HQNq5sZeE+7vjh6/6Mr/EQUYWd73sC6
	HKsX15Yu02xZI86S8BGEPNs/Ls4JHcUd
X-Received: by 2002:a05:6000:26c8:b0:48d:f014:63ee with SMTP id ffacd0b85a97d-48e6e3040a3mr18060386f8f.20.1793565535266;
        Sun, 01 Nov 2026 12:38:55 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b72715sm15502295f8f.18.2026.11.01.12.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:38:53 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 1/2] wifi: wilc1000: validate frame length in wilc_network_info_received()
Date: Sun,  1 Nov 2026 20:38:48 +0000
Message-ID: <20261101203849.2807553-2-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101203849.2807553-1-tristan@talencesecurity.com>
References: <20261101203849.2807553-1-tristan@talencesecurity.com>
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

The frame_len field is read from a firmware-supplied buffer using
get_unaligned_le16() and then decremented by one. If the firmware
provides a zero value, the subtraction wraps a u16 to 65535, causing
kmemdup() to read up to 64 KB beyond the buffer.

Add validation to check that frame_len is non-zero and that the
buffer is large enough to hold the frame data before proceeding
with the allocation.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/microchip/wilc1000/hif.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index 60fe5f08964f39..46f71b6898998e 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -1579,6 +1579,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	struct host_if_drv *hif_drv;
 	struct host_if_msg *msg;
 	struct wilc_vif *vif;
+	u16 frame_len;
 	int srcu_idx;
 	int result;
 	int id;
@@ -1599,7 +1600,13 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	if (IS_ERR(msg))
 		goto out;
 
-	msg->body.net_info.frame_len = get_unaligned_le16(&buffer[6]) - 1;
+	frame_len = get_unaligned_le16(&buffer[6]);
+	if (!frame_len || length < frame_len + 8) {
+		kfree(msg);
+		goto out;
+	}
+
+	msg->body.net_info.frame_len = frame_len - 1;
 	msg->body.net_info.rssi = buffer[8];
 	msg->body.net_info.mgmt = kmemdup(&buffer[9],
 					  msg->body.net_info.frame_len,
-- 
2.47.3

