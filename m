Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675706;
	b=xz98P1grzd6De/QYUEsDPwRllfIeyFK2YUrWo4bb4yS/RH+KV1F0SPIBOPRSX7WHAcHs
	 pA4oz17hp3q8t5yW7xef8wJnGPstsA2XThkXuMJSK1OzztW+jGtxq3Ure9SIoYj8NcCHe
	 Cato9WmcwOr9P8tBKwBelpZddFf0noiEV1MqfiKIHb91Q2vTwY7d72XC65BfAX/vrJyM0
	 rYiV6QYm1w9YKA+ehDqKmoWXlTpkr15F3xIArBzVF9E6tr2zjZUVdKZ9q+EcYkQdQBPgp
	 09erernVp84+XJJKs/Ak0AcCG3KPwxNpmDsAGfT4TUkZqCWJoQ/ib3+rrc+c317F0Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675706;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=SKXI0sWSYT7UPLN0EauTsGPP60jK0MdnGiP43AY+iUg=;
	b=YWOYG5BbxaBeGgCQfxSx9aJ75HxwO9kos8YeI9fvZNq+i74Bju8kg+Tt0/MeBNJhxvH8
	 xyLt7QKrDVBB496YuX69aqX69bKCNwfWiMRNMEoitEj2OhKSteWVlS7/vyeU2CdxNaT9F
	 Hxdy7XV23vcneHVRrOtCBG1w5q6N/B7JPqbtSpH8MmjYbewv+QWluOJQ2mDB5HbsiUtwA
	 HACCgxS9BndRl9GHmkWOCR3dvcfFUCasI6TOqMNBcW34Wyv5zUxxpQNFa0POzzmTGwNqc
	 EFFSTaD0rf1QNYqeZ/l8UFrRZ0JXse0ULvBc3op1GqHfnCmMi0oWC0JfKOK1V79N1eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoqvERnD;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946A4606A330
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 03:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 946A4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MoqvERnD
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3550c917fd3so5106313eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 19:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793675705; x=1794280505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SKXI0sWSYT7UPLN0EauTsGPP60jK0MdnGiP43AY+iUg=;
        b=MoqvERnDjdRBmannAIgk2l9HInTM0FPNujozqtsQ4dstlvoAFjQCJzok0+sNhI+JUy
         XwXs8xnYC8+49sZyeTLv1HUUjSm8jD7LnYq/rnJ5lbrQA99QNKrSXllru+eSfnEcJK/4
         nOGhHej978lwod5zvZesxKvfjV2IXK0iEyLtmJia8zPimZBV8qO2B8UuBQPLqnaN6k5M
         l9cHUO5V47QvH6a8PgJIjg+G6hwFnhABVSPdsP4MCdkeFOzmqCLmIiCaMDd/nCDpxNNj
         ptZVaJgQpDV4pWWOg3xwN8BJLBwD2oqyDo4OKR7d5aI6x/2YOgqbNX5NPA1o9xxw+Egl
         Gmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793675705; x=1794280505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SKXI0sWSYT7UPLN0EauTsGPP60jK0MdnGiP43AY+iUg=;
        b=kTiTAajni1hlqck6tBGQSG2XiGwSq/hXQaml604F+DyKEh0jpsq48gQ4OOeZ7ycEBL
         nTsvC1bPoPmGkbJ9987EZuFn/87QrZ4UurBiN2DTX+6ntjP0XwnCpUK7ANnx6hzt8ELO
         jIpkadG0UvB+XNeJcLgn26YGmc0cJwAE29yET+K5P2JnSzRf0pbESiVqQ1omYbZDptpy
         mdNTj0IPh0caB5JuwsRjJ2/DgDkwVPgk7LtaAg4GzqUUY5wAGD5PrF+XYhrK1RdfMggu
         kVBwt3h0ddZDJ68s2Z75sC4R7cm5RgN7N9n+icjnCEKCHH/8YOBaR1GYhmfgW5Al+7xo
         dFnw==
X-Gm-Message-State: APuU4Z9ZJINJtszEh9kiF0l4ZZX5R1ZF0jzYqTHg5VuFG/qTlOw8o3Bm
	yjs7w8u9pLg3UZ6Sng0VVN4zzGmF57nbnYFl7NXFAeRE+NZBxmWP1yMq
X-Gm-Gg: AYBFou1MQHUwsa059uSfY++dbHwY5eRgt0YDCmT1xPOINrgbzb4c+KijPA1bMTxmuTY
	IVUOfw1ySc7sVgkUThsJK7tq7gC5ZP1RTsDXcDJWCfaIFL7uEjvaX80B18cboRzCizjgZaau7rd
	RkEmRTOylVZu5tph78JADY0rhWdY0ZEcO2jlqeDxi/UXHMNPJsXB4UYvSWdt4cMqqs7uKVrjvQj
	VXl78IpkZUgyz53p6nA3YRIn+/jnv/3z4l545thL5dDD/zogE+3yfakhpYFo3PAYK7mq/NWykNp
	gt5zFA0QPH1VFzjeObVllFuSk3vIuIxVxJQRTXR2GFuf5bCpmIpOt6xYQTVmvw+s6eUKRQe8awn
	TMq0ym1oaJemxYGgZGWbCRcK2xm3qyvsa5DoL8lsebFyHNvwFsL7vIG1dBbn0OnfPOGVDCbR0GL
	GUvEeiwGY8p3rwMIqwsTnqNdYqCb7MLhFvuayDPUXmJlDwhtl1ic/rnYOVSTTzi12HQiyeLIwn7
	5s+AjwyJt2EfeEWDZDxxw8pDKk4jVG1+zW1S/rFgBB1TQkH7ojc/SZ4PRaX7FljsU4FxPeXlPB9
	RQjwMAUPcg+CUGdr4ZPYsdbS8v1ExwD7D728xQ==
X-Received: by 2002:a05:693c:601c:b0:36a:270:ce76 with SMTP id 5a478bee46e88-36a424de9abmr19193358eec.33.1793675704513;
        Mon, 02 Nov 2026 19:15:04 -0800 (PST)
Received: from xploitoverload ([2406:b400:f11:1bac:4040:640b:8a1:8629])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428c17bdsm41090051eec.6.2026.11.02.19.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 19:15:03 -0800 (PST)
From: Kalpesh Solanki <skalpesh942@gmail.com>
To: pkshih@realtek.com,
	kvalo@kernel.org
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kalpesh Solanki <skalpesh942@gmail.com>
Subject: [PATCH v2 1/2] wifi: rtw88: pci: Add DMI quirk for HP Laptop 15s-fr5xxx
Date: Tue,  3 Nov 2026 08:44:33 +0530
Message-ID: <20261103031434.14449-1-skalpesh942@gmail.com>
X-Mailer: git-send-email 2.53.0
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

On the HP Laptop 15s-fr5xxx with RTL8822CE, PCIe ASPM L1/L1.2 and deep LPS
cause the card's firmware to fail to resume from low-power states,
resulting in repeated 'firmware failed to leave lps state' and
'failed to send h2c command' errors and stalled network traffic.

Add a DMI quirk entry for 'HP Laptop 15s-fr5xxx' to disable PCIe ASPM
and deep LPS, ensuring reliable Wi-Fi operation.

Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
v2:
 - Rebase onto rtw-next.
 - Pick up Acked-by from Ping-Ke Shih.

 drivers/net/wireless/realtek/rtw88/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 66d2e5f5144..c87de645083 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1779,6 +1779,16 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
 		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
 					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
 	},
+	{
+		.callback = rtw_pci_disable_caps,
+		.ident = "HP Laptop 15s-fr5xxx",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15s-fr5xxx"),
+		},
+		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
+					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
+	},
 	{
 		.callback = rtw_pci_disable_caps,
 		.ident = "ASUS TUF Gaming A15 FA506II",
-- 
2.53.0

