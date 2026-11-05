Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793916053;
	b=rgCswse6TWjgID0zPY6dMeJ181ouomKurWts78L0MfLZqApv4UlWhDLTRPVirUEuDgoV
	 sNDLfr6Q3vuT+AveCGk/AUAqT1bJ6xH+qEdG5oE9n08R/YzZOYPWeauwZli2VogSBI6iV
	 iWaAyX++4i9Vf0hzFTkDBGaMMHnEFKBTj/RlsO1Wt0dWMzrezVKjRO4htZqUwof0VBzBS
	 RUUMVwmexvXKD+ylqARIW+CVVmNcYL0XZnBIQnYS35RDbKsm47vnDoOzP012G5zJTd2hw
	 NgLkVAEiyYB/5R0QPuPQh6p4dUHIdMyWLELM6nqGMSXu2chqB1CJNaz3+jP37Qqto5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793916053;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EfUxS4j8KiqdcDZ0OsuVJwqrTRdeU5cL78NKs2afAZ0=;
	b=CFiNjzMIvp7qFcsqtrxO/IERX12uWUFajSNPtO+4tbE2SN3NHbrUZsjGW9skXdqBJ3AC
	 hHB40OSXwQkl/8r7hbQ6ms6oMsg2E0EYrArJkgIQPN6uQ3nu2agWEb/OT41bEHz7AKp33
	 yDtrGMSg80P4aYJdOzzwAqdvhpo79YQ54ykGrwJCxJp+Wx0gY78CL6X3uonhnoBB28rOC
	 6mb6WW5IFb0/QF1ZtmZyzEan/heAtbaksC1UlbPSjmtpRm5Kg6++dYMuEanfj+oaGffzS
	 al1fu8E8A73PiprTHotF6u14tITaWomIks4ThZASwgCYWfuCAzZlhn9QXbiS8WxTIcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ci0DxVVh;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3600606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 22:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3600606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ci0DxVVh
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4910b863b84so835667f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 14:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793916051; x=1794520851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EfUxS4j8KiqdcDZ0OsuVJwqrTRdeU5cL78NKs2afAZ0=;
        b=Ci0DxVVhIjk0x1XyRoJcwvBseRlqz1xvafs6sCvRiPLpQARiLsJFPHkI3EDBdodKz/
         DjzQLHV3CN8suhVV9m4KRHqcS01fppqIql32A6Ng5k1c4EsNLHTycykHsDkN86gIJ75J
         nE2QDGuYYoEqVepJ90qiemWmoJw4vYrhNC4pAyVnm6n6c55G9398ilZKFWO0bvT1PMCk
         MC3y1gqkGALUrvae3c71/KJ/x5Ra7XozlWhh9h+jvSjfYaqYnZ+gdW4LDmBwOOmce883
         GLqRaOTpN1tYjDpIodENv/evo22s30xxwQSJYNXJN9zRMTXVZKr0xYOGz2Wa3DD/qA3n
         2YyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793916051; x=1794520851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EfUxS4j8KiqdcDZ0OsuVJwqrTRdeU5cL78NKs2afAZ0=;
        b=RYzaIBiRxwVsfoTbV+ZQEevj5xDQ1PWJfQMVjVnrtYAOvdwL9P33ydEzyNbP9lHO/9
         HS9I91WgQzSppmjiyWnaBdZ0Vlh2wrqBoZxpj/CuIxTbRrWjL9dgsdlc0jNLzTzndqo2
         i+hkJOKwzjmk0HziWdXwfLsd8z5q1HDr5X6IhvnEO1n2BiYTcO0bC9Lm8JXxzP/dQpt9
         bmTMNbVA4+iW4B0RsSBodw5Gej4vMBkOjvDGH6YhVOsZ16MKs0ZO9ww5Ip64s+fZRSHv
         1ET0l7Eb98v+lBIG/4hI3+VU7qcPFIbEydOtCIRaa3OG2GErHAPVqjZTkDfPloit16k4
         mJmw==
X-Gm-Message-State: APuU4Z/g9C8ghqgHRW2tp0WBzyTa2o/SdAbLdZZ7OF40a36ZzzJftpww
	Mka7266YXOJslGcQWg7l0IKwtH4cusZJQ1Thw1510/sYD5yedZOLa6yShJs4/fDh1Ks=
X-Gm-Gg: AYBFou0KGytto9rB5GVp0WuToh5GS+iRk8ajzEr4PgvWu1fFE+aECR1OsV7qGxcEgaV
	cArZLEI16BADM923078yZzAAJTvj3NUpnCQJR5Zt8yFvt6ErT1wQ/baoR9Nrz5dZeae8Ssc/+ZL
	anHfvddbmMb35t1kqGYPU0AwAf4YMioxSbU2O5FDHFz1fckTgKLz58pY+61I4EbA96Q3XLzJOZ/
	m1izaIC0vfvLpAWFAaA86wAQm8vutlr9dI3yA7wynbR8Rm5QRJE4UyP2qa4lBZGGsxl512GHgm4
	45S7ClSgn1XOPwuSfSV36F5I/7RPbWP+qn3y5z0d6KgP2a6GWPrDfh44CFzvEEt/VYt//8bSIwb
	DP5nWEaALJQzE0lzYNX0+uf3ZlyEUtDkrZ4F7BlW5AxgKyNaPd2dennw9KRvGlPhyUImsjvLoBj
	HHZwhKpV3+M4FzTfxSe/uGfVu4svdUOkEhKkjSCi79bJBJ82zlc8ytBs4Wmelessg5U+m0yGHP3
	7P+iZCVhSx8MBv+v8Ea+/s77gYZGyBW6jj/wUEUitG5ja/S8akCeAaL/9GdyssB2t1qzXBcAQIY
	gvtPZ9saL0ZHh39jccoCPefXlprCJ4f8yq/A2TG0p/IPb8mfKtKtkXB17sn69Ta9y9BMgtR4ehu
	8LhbV6qbV
X-Received: by 2002:a05:6000:40de:b0:491:1468:a504 with SMTP id ffacd0b85a97d-4927997a35emr1710921f8f.21.1793916051004;
        Thu, 05 Nov 2026 14:00:51 -0800 (PST)
Received: from soeren-MS-7A32.tail37253f.ts.net ([2001:a61:13ae:e301:329c:23ff:fea4:379])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda203b6sm11922212f8f.48.2026.11.05.14.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:00:50 -0800 (PST)
From: Soeren Coremans <sorencoremans@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	Soeren Coremans <sorencoremans@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless-next 1/3] wifi: brcmfmac: pcie: stop console read on invalid write index
Date: Thu,  5 Nov 2026 22:59:52 +0100
Message-ID: <20261105215954.184290-2-sorencoremans@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105215954.184290-1-sorencoremans@gmail.com>
References: <20261105215954.184290-1-sorencoremans@gmail.com>
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

When the device drops off the bus, MMIO reads return all ones. The
console write index then never matches read_idx, which wraps at
bufsize, so brcmf_pcie_bus_console_read() loops forever and floods the
kernel log with 0xff characters at several thousand lines per second.

Seen on a BCM4366 after a firmware trap followed by a fatal PCIe error
(FCP): the reset path and the failed dongle setup both entered the loop
and never reached device_release_driver().

Return early when the write index lies outside the console buffer.

Found and written with the help of an AI coding assistant (Claude Opus
5.5); the cover letter describes how.

Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
Cc: stable@vger.kernel.org
Signed-off-by: Soeren Coremans <sorencoremans@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index eca5f5f63bce..02c58de67b82 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -992,6 +992,14 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo,
 		return;
 	addr = console->base_addr + BRCMF_CONSOLE_WRITEIDX_OFFSET;
 	newidx = brcmf_pcie_read_tcm32(devinfo, addr);
+	/* A dead device reads back as all ones, an index read_idx never
+	 * reaches; without this check the loop below never terminates.
+	 */
+	if (newidx >= console->bufsize) {
+		brcmf_dbg(PCIE, "invalid console write index %u (bufsize %u)\n",
+			  newidx, console->bufsize);
+		return;
+	}
 	while (newidx != console->read_idx) {
 		addr = console->buf_addr + console->read_idx;
 		ch = brcmf_pcie_read_tcm8(devinfo, addr);
-- 
2.53.0

