Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050B390212
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 09:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789290519; cv=none; b=eh0b3i9ov6cTtT0kjYJSWkN0feByzud2DIuZ1FU8tb6UetewmaXZNKkphPmW1QFZVEQUbsjzEp0UFDvyuoqJrbyCcYjHAjs5Y0eCRhUB+ldDFA0uol1Pm1w0JC7wYQmLQ+27Y4JpdIFfejaJvc8g3AE2LfY/bJb1wUqPUAKGm5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789290519; c=relaxed/simple;
	bh=TDvcrBX58plavsGuirvSl5Kas6jxwauWWLGcv5Y+8k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHqBh7yM190hg5KG0uc2+DPGLutlYj97eM++iOlkcrGi5Q+m5bRARMlLP1fVQvIxvZedkjMnOZSbomAS9MCMHN++MTXW+arqqClAEbbXCKhBY0L1HrV0ZICoEo1CXG+tQl2T+oScPZraNwrIcUDFcHNJlVwaNCMovAIeKA0ujwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RjCCBV7P; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjCCBV7P"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4843e397f74so1348149f8f.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 02:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789290516; x=1789895316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4caHLEBEOxtFSlC57AtIBBtI8i1ci+K6n0fqXOkiksY=;
        b=RjCCBV7P4yVjo4sTj3v6vBgCGLGw4j8+ZuduFfqR8C/HMplExnNzYKr9uLwJojZZTk
         eIkF7N3jIOwUob4hNmOk587sC21EPZ7R6Pxf0ZWsO9DAT1JdOEtxu2fpiSDhKK7u0Y39
         IAqI8kycxzPAqm7x6Bz5zLEwlLX8IB7TufRHhUWX/N4Qb3KbdGSpTuidJyuVhrIWBQP3
         ULNr5pZCqoMkiW1y03fWFa4LZvn9JlFoTxz0V1itqfOMBOSa+dtyLsH65Cld/Xt7J4Ba
         EB6FYlzTirZRof9YRYjaHfnZMEKqZmQJDYxjHr12vJDPT5y0xIPs9T6sjIvK/nKKeWsy
         z4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789290516; x=1789895316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4caHLEBEOxtFSlC57AtIBBtI8i1ci+K6n0fqXOkiksY=;
        b=PM2rC4jsmojukiTc4PxfooA7Dk6K/VY2I3w8pQi1BkZ6ffm91Fmbk/8eSRwLsMFh7B
         U1eBA7UvPo6OAs77WB6YVDIPpB1ZG2uc/PgA1oLgMIOfWOwNlLKohsaBNcbKUp5OxOMx
         7eX4TSmWO6LbWepxWEBmB4HKPvdPGJ6Bw1ccfLSVXLjU/SGVDrBWdY7GzuBELHEFCJpI
         QdJwoseFQIOwlUZLEEY2xW+lkwGjZ0Rax00QxHcwnAdI/Nc/ugTNMx3iEQh7xf7fmW0y
         t6uMePR0BIQz11qFLggRRo1b5g2bFoO0uCY8RCjE9S/kuCAmWXD9tzYm9kt2zIIfLeQN
         8bhQ==
X-Forwarded-Encrypted: i=1; AKwUvBwdzmLd8L4gzLm1ghKrEjB0zD8Cl+o47tFkbcjip/rvXgg+baOoH9u1eksVoqHY3G72M1wjHR7+sFvk5JjiMQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nPkZRh4rzsA8GLOTp9OZIEBQBGf0stEqYzY2rcBgjUwlGENbRT
	tcWuXBC0STRHiq12JjWLIa8NO7cYrB/udd7tXJt1YfGPWnGgze8heEKM
X-Gm-Gg: AYBFou13xRuKvI5d2Vsdyk/Uj2UCIE2YuUsbApvlfRJG54kL20jvU3piLD58e8ZSHo/
	gYP9uI09Jd43sl+LH1JHxP8oxF5ZANJU9eGyE7n1R8SVsQsGGEh0jkVFfEBUNwYr38lHgKGrDdG
	D/hu2lgARP8h35//DF73zwtazNTWbIe+Tc3idq+yUFEsc3cDqZiNVTt7jw2zU6anLzJKMLbt4/y
	HM2L0oOa0w0/4NT9w4Up52fgJHMqalRF3PxWUNZ9FLXE41bua/hKO2hBqoelWzq2hNxGo6t9goJ
	Dt7bxttLy6dneSBAlKjmt21+wBxTxGkTPwIFC+DXj440inAjeLj8yE6Uoqb3okbMpFsABW1/Hyx
	QPNoBddyl7+KJydNPx8DJMW7ev5iNIE3TSzxwDZ8I1Ucz9eUxxMINj+Q+ykzSYfkhsGPRZ1lxQf
	fZb/br5FNnxwMAhdPAbvM4C5G2OzxcO7JsNjud/2WBJucbhjkphJJJK2bi6iJkxQ==
X-Received: by 2002:a05:6000:18ab:b0:486:f1b2:cf44 with SMTP id ffacd0b85a97d-486fc955e0cmr1787905f8f.3.1789290515586;
        Sun, 13 Sep 2026 02:08:35 -0700 (PDT)
Received: from cachyos ([2a02:8070:6286:900::a57c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb350686sm19704385f8f.27.2026.09.13.02.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 02:08:35 -0700 (PDT)
From: Cristian Fleischer <cristian.fleischer@gmail.com>
To: Junjie Cao <junjie.cao@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Huy Nguyen Dinh Quang <huynguyendinhquang@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit
Date: Sun, 13 Sep 2026 11:06:27 +0200
Message-ID: <20260913090744.316095-1-cristian.fleischer@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <acb947435fc78d5c06039c7bd5609c735468b0ee.1789002236.git.junjie.cao@intel.com>
References: <acb947435fc78d5c06039c7bd5609c735468b0ee.1789002236.git.junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 10 Sep 2026 09:23:00 +0800, Junjie Cao wrote:
> Some ASUS firmware includes 0xff values in MTGS power slots.

Same failure on an ASUS Vivobook S 16 M5606WA (MT7922, mt7921e, BIOS
M5606WA.316), kernel 7.2.4 with this patch applied on top.

The DSDT carries MTCL version 2, MTDS with two identical tables
(1A 19 17 11 15 10 12 12 12 12 10) and MTGS version 4 with pwr 0xff in
every slot (offset 0x00 in entry 1, 0xff in entries 2-6). Region ETSI.

Before, txpower_sku showed tmac 3 for every OFDM/HT/VHT/HE rate on every
channel; the AP never answered auth frames from a few rooms away and TX
sat at 6 Mbit/s with ~3 retries per frame once associated.

After:
  5 GHz ch 36/80 MHz: tmac 29, TX/RX 866 Mbit/s VHT-MCS 9, 7 retries in
  776 frames, association succeeds from the spot that used to fail.
  2.4 GHz ch 11:      tmac 30, TX 117 / RX 104 Mbit/s.

Tested-by: Cristian Fleischer <cristian.fleischer@gmail.com>
