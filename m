Received: from mail-ej2-f11.google.com (mail-ej2-f11.google.com [74.125.228.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903AE44C51F
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787241702; cv=none; b=sKatUTV9G7V6euZCUSPxF9Lqd4UslHGSdq7R+WlGpZVzTLydZa+btUcmIFeVMNF/lOp/LjWsWeQlMfKfbFmKMCjfglrlC0ysIY28pEuMpypDIgn/r2KlB3P3e4Y/VfqSgi2wOfH4lbAY//5mYUefga7Lo84cqbVvzGYqAEkdCZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787241702; c=relaxed/simple;
	bh=d5yqy9ZRiSn59NjKvR598Vjs1Fpyr8k+j8cRU4zI3mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUChrWBO/dLBWZUlYtCXNMSivuK2zx2yJ7ppQowG/JEQRm2ZQv6SBisi1W1BnlC2WM2ALEmmpoKuACZPZlApgmpoLU49KYPuPJJIu3prOGopp69uEhQGI6f23UIyyqEraaIL05NnV6AfKma1/VEO6O0IW2nObRAoQTrxp1Qsj8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QZo+BP+q; arc=none smtp.client-ip=74.125.228.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZo+BP+q"
Received: by mail-ej2-f11.google.com with SMTP id a640c23a62f3a-c243d41dc07so38366b.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787241699; x=1787846499; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wzv3uP0w/VGEKyAdxgzQ+j7UoRyZuBIJ3kqw0ykhhiw=;
        b=QZo+BP+qgkFxcBDqlDyiuhvLWsXJGTWPjYiME62vwYSv9lV4oT5hIpoP+5iBA/QHR7
         nZh9lvHUSEOmL1f1xQvxugbKH+kEfojC6y2yis4WKAaFmeYEzaSsyU373mYbmUjIc3cR
         q+4LPGzBwSLlPnNsMM+Vz//c+mlODT3n7BQhfbKIZ9swL9QoE8N1I5xaCMhB4dDAxWql
         9SqEptNNquMoCOJCd/NHUbpCj1sFs8+vh4YPyhOX6WEK2l2D+VjPho0fLSb9mZGPhrpL
         ZOQt4wUToX1ZgzryZRCzLJZa6LeNkeFb5gwT2U30eV0Ixp34F3fNmYy089HaA6EJv9ZZ
         JPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787241699; x=1787846499;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wzv3uP0w/VGEKyAdxgzQ+j7UoRyZuBIJ3kqw0ykhhiw=;
        b=jnieb10LLplGc4f3c9EgSTeCYkregBTzW5CWeeuZfEdwDSjGEdI3Gz0zlfnf0URLiU
         8XnPZsyRvOLHdUlhWoL8aoJaYCYAQ7vFHGfRrGFJMFPGlrwtwuzhhVpsf7RMJrR3H/vo
         rYsyOheyd5fRuph0tqyJSKCttykMJnrHXJBSSKPURKcQh8rGdMxIU60mNA/y0xHuJ7gU
         hPxcxzqRIwo0xQYZzEf+LW6u8MRhkj8wmdQexSS/X/+ejZfWIeNleEGtqH7GRLnIicBh
         mRcI/IQE79X777TdQb6BDqqZ7mnJwfcq2DIawI2fIFic4EL1lBrGKdCFS+9Tx+I+IR65
         Vldg==
X-Forwarded-Encrypted: i=1; AHgh+RrHmHqLpoePTz/1rtwzSkOWDyn+BuMcwfWfM/ipvHLjbY9Z6zWUXOJumx2pChKHZpYsF9ekT1/v1CpikSTE9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRcOuomGuMN5gD9DxLT6Czp4MFABksPPjWAfAKuCIhZd2Lu8h2
	TUBM0uP2IUGVprLd4cuY35D7vwDX7YSOSV6hJJnb3qkxA7IayC/ASQsM
X-Gm-Gg: AR+sD11Zjlqv0p5qGJrEIAGPyikhnM2VSGm2bhqwONXAIz54cWUbYTgLVPyE3SZsnpA
	IMc9JNACQErKjfs7ISsCP7Fguk8bdqLcITcyy6G0lUz/gCk6VXW3vE5gh85mAm/iZrwl3TW/nFC
	oaTg2m/AlcsABfq3aPZ3GyJ2i2uQavHvjbYJ662PFeiFxBhcoiKWObMYG7u9b3WDfR06bIwIQWy
	p4TF664anBbxhqFR7kXclhfsOqZA8NjdKrPi3+B6qSKpTQijQB1ubfrdgBq7V27YN209h1LHLT2
	w7o4FJzZdMOcg+jIiw+ifBU9xOzCx2rSFXyNqBqkEFrOw2w6HbILlERowQEw6L6VuhCDzgt08Wx
	Ha/96h7e8jbYupivbTO/yg8CDFzP2ytMnp6OYd5KC1mr31TD+V0laVNo41uQI4uCmJUI/ky5S0m
	SKjD2QqR+IGFse21FmFdGgEbuJBpkGtnugP0EHBwi451Wh0p+RE1x8UolGJX/JOiH5XaxdtpDNm
	/oR4ioxibXoNAC38YJ5nmafdPlaEifL/3YuV7Hacn1vXX4=
X-Received: by 2002:a17:907:c03:b0:c19:fb6e:5fec with SMTP id a640c23a62f3a-c242e25525dmr1171279666b.18.1787241698523;
        Thu, 20 Aug 2026 09:01:38 -0700 (PDT)
Received: from fedora.fritz.box (dynamic-adsl-84-220-246-20.clienti.tiscali.it. [84.220.246.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1441c78sm13634405f8f.2.2026.08.20.09.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 09:01:37 -0700 (PDT)
Date: Thu, 20 Aug 2026 18:01:26 +0200
From: moosager <moosager90@gmail.com>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Deren Wu <deren.wu@mediatek.com>
Subject: Re: [PATCH wireless] wifi: mt76: mt7921: check drv_pmctrl return in
 the PCIe reset path
Message-ID: <aocbq-_gRsXgFV94@fedora.fritz.box>
References: <20260809012309.43657-1-lucid_duck@justthetip.ca>
 <an23_8DALILoGLP6@fedora.fritz.box>
 <20260819171454.21329-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819171454.21329-1-lucid_duck@justthetip.ca>

Hello,

I've tested your commands with a vanilla kernel (no patches applied): the 
results differ based on whether the bug is triggered by my orignal script to 
reproduce the issue, or the issue happens naturally.

For reference, this is what i mean by "my original script":
#!/bin/sh
echo 0x7c060010 > /sys/kernel/debug/ieee80211/phy0/mt76/regidx
while true; do echo 0xffffffff > /sys/kernel/debug/ieee80211/phy0/mt76/regval ; done
(to be inturrupted with Ctrl-C after 2-3 seconds)

So, when the issue happens on its own, your script (accessing register 
0x54000120) outputs 0xffffffff, and even me attempting to write 0xa5a5a5a5 in a 
loop won't change anything.

Instead, when the issue is triggered by my original script, your script outputs 
0xffff0002; again, I cannot manage to manually write a different value to the 
register. In addition, with my original script I sometimes get messages in 
dmesg saying:
> mt7921e: MCU is not ready for firmware download

So it would seem that my script does not reproduce the issue identically: 
however, whether the trigger is artificial or not, the issue pops back up 
naturally on subsequent reboots almost immediately.

> Yours reads 0xffffffff where mine reads 0x4

0x4 is the correct value for it to read, and it should correspond to 
PCIE_LPCR_HOST_OWN_SYNC. When I was testing the bug with some dev_info(), 0x4 
was the value read all the time up until the issue happened and it started 
reading 0xffffffff.

> Comes back 0xa5a5a5a5 and it's alive and latched like mine. Comes back
> 0xffffffff and it's off the bus, which is a different bug.

We may be looking at two different issues after all, both mitigated by an error 
check that was missing anyway. I'm still inclined to say that it is not a 
hardware issue, since nothing similar happens on Windows.

> If you're up for it, reply with this line and it'll get picked up:

Tested-by: moosager <moosager90@gmail.com>
