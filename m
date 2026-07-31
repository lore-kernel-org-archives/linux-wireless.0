Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2093D44E658
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785520286; cv=none; b=E3cg64fku5aUXZU+o2TUcPc4Z/pOCWOODN7gsgc/5rk2amPAbBoAF94+ZxzpFY5R7r4qqYTJ/JYEYUWkGnhTRzeA0vPu/old48fsOi1eQwdWCergqnTGyWpJDRBfnnX83oRopCuZIaqlE1qLAuEdCyqLeuDzWNOIIDLKUvP0t3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785520286; c=relaxed/simple;
	bh=zaqhEj9+v6MGiCnRsovbkSYQZhpmRKNnHeek3rHBD6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MH2SqPxwZYI9HBiaMYCS5+BCN/0ciB965LSHnCTMuVndf6ztNnvrgWyzE7KX9/x/CAcE6aNA39x/rsiqbnzBA3FO+xiMvcIc+/pMCT/7yW6Ct5pca18+mLpJqPq9OQCAwjJ7PJPiT1RXCIwQUONyNu0W2Skynmu4rTK+EU9BXyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UV6m6OuT; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UV6m6OuT"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39c8dbf4ef0so12013291fa.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 10:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785520280; x=1786125080; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ixOpGGSOB4JxiijiwyE8XeZhHl//VOjjOoGntCQrL2w=;
        b=UV6m6OuTdBSbsQh/XWth1fZ7wdluHoWcaY1lDGARV5kDay/LizHdmi5nKHSJpHSFRj
         06SGzqVdDzWhkB56QKR5VfGW1tFI2gY9kcJXEm8EmwQOpFkjfnATbzBXFEdhz+Nes4ua
         nBaP2IT7buV+q4JOrkRMgc+tnK0ZfkkUVsOLywVxYMqxw/UhwPN2dFkQKXFQVIouHTER
         yeJT1PjQwWCAWIIo9/htFDOEEeWw/bHLxjNa5/om5JpfGitgDnfMbmA2o5OCgeCILm4J
         2BaWSQlQTNHzH4ishw1ARV6nqwe8axb18hv7vnHnSwzRHkh2cCa4cfnV1P8lDBpngsUc
         +0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785520280; x=1786125080;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ixOpGGSOB4JxiijiwyE8XeZhHl//VOjjOoGntCQrL2w=;
        b=Pif+CRTB8MEaM0gSpfh9W0dEYq85ahY6N7Svsc6whJF/DBNeVhgVyTNu5z8kvoopap
         zl/RynwQmQ3jGsl8dRnHgap4cYTLpMqkggyc1maGq7v954I+fwWnOqSDZJNeOmipaWeo
         XzHmk5mLiWK/Aag3+chufSqjlMU5EE7XKE7w+ddA3tpP/rY9pwbqhlpuMuD+y9QEC32k
         UjEI7G81QyNdaiXhd5hDp/5Dxnca6J6HCeuLR3B4D1KVszjzX+UbCkQoeLCcEKwQ5Qqi
         OrXbkkxPvquwzk+chjQ+Qgt/tI3y0qVFPjOnoCeBm+8fDuL41nNUyJ6y2S1pa2/KRXis
         7Ssw==
X-Gm-Message-State: AOJu0Yz1A5Q2CuqO/YEk5oA+JgIO+mZJ5+PFOC2VOdisDSy24DV/piud
	q0zgtTtaqLcqeLI+DM7a+4lKEPI3Qcq7k1VyPwPESxvbXLGcs9XHmNugERjkcA==
X-Gm-Gg: AR+sD12mmXV42ydiHfIyZW2TqS/JQ1/P0jH5+9RLHbN0K6045mtcBGfgj9Ab/PDYnnG
	79Tuwq4n5ArwAM8R0Dls0in+CQO7qvrfNHZXsEoOgeMcUCy5HYixVCTTlAQ5nXTGEN1yyuhQO0k
	fFf8Xxew9DDWQGSWCHH2y1hl/K1jRfc6UO+jUEPvrNYm5uARcL8++k1wKH4m3VnhxSA5Ikpyy1s
	Pnm3+rbRF/J7dencgL9ELpzdMnA3bVtWoqI3YIcDoi5X91GndpfFr3Ix8dAtnaA22EJaP/D/nK2
	8D56dN26A1/E7sjBK/rVjKj1ZYbQAmJxX2TBfshn2CkXG5TdO6RmGGPlifr733G/lav8F6gtEQu
	bmQLybTZ+Z8QRXWIhyYYdEmHdhS0art8lV09UM28pRZVelVzajVf53PYV4K7+XtTAG49M4XsbM5
	SwguCh3LrflybxEcape8MvcPWiHWk4set1NGSRhUbJDUacRI6nPPuafrBAY5z4eQL0qTSKVLMkN
	TNlau5B+TBM2YoaqqN8z9XiWg==
X-Received: by 2002:a05:651c:a391:20b0:39e:a64f:d7a9 with SMTP id 38308e7fff4ca-39f861047a0mr832931fa.2.1785520279939;
        Fri, 31 Jul 2026 10:51:19 -0700 (PDT)
Received: from zbok.dom.lan (89-79-165-104.dynamic.play.pl. [89.79.165.104])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f812e1f70sm2673481fa.29.2026.07.31.10.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 10:51:18 -0700 (PDT)
From: Kamil Bienkiewicz <perceivalpercy@gmail.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org
Subject: Re: [BUG] ath12k: NULL deref in ath12k_mac_op_hw_scan() when a scan is requested during firmware recovery (IPQ5332 + QCN9274)
Date: Fri, 31 Jul 2026 19:51:03 +0200
Message-ID: <20260731175103.1745248-1-perceivalpercy@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731094141.2410630-1-perceivalpercy@gmail.com>
References: <20260731094141.2410630-1-perceivalpercy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/31/2026, Jeff Johnson wrote:
> Unless you reproduce this with the upstream kernel you should be reporting
> this to the OpenWrt team, not here.

Understood, and I realise the taint makes this hard to act on. Two things
that may change the calculus, and then I will happily take it elsewhere.

First, the reproduction you are asking for is not available to me: this
board is IPQ5332 with the wifi7 AHB path, and that platform has no mainline
support at all — there is no upstream kernel that boots it. So "reproduce on
upstream" is not a bar I can clear on this hardware, rather than one I have
not bothered with.

Second, and more usefully: the code that crashes carries no local changes.

  - ath12k_mac_op_hw_scan() in the backports tree we build is byte-identical
    to drivers/net/wireless/ath/ath12k/mac.c in mainline master. I diffed the
    whole function; there is no delta.
  - None of the out-of-tree ath12k patches in our build touch the scan path.
  - The condition that leaves the device un-recovered is also upstream code.
    ath12k_core_reset() returns early when ATH12K_FLAG_QMI_FW_READY_COMPLETE
    is unset (core.c, "ignore reset dev flags"), so a firmware crash during
    early boot skips recovery entirely. Our tree only adds a clearer warning
    and a coredump call at that point; the control flow is yours.

That is the whole failure: firmware dies before QMI ready, recovery is
skipped by design, the device stays half-initialised, and an nl80211 scan
arriving in that window dereferences a pointer that is not valid yet.
Faulting address 0x1508 is a small structure offset from NULL, and the
faulting task is hostapd — it is running the 20/40 MHz coexistence scan for
a 40 MHz BSS on 2.4 GHz, and hostapd retries that on -EBUSY, so the driver
gets asked repeatedly for the whole recovery window.

I am not asking you to take a fix on this evidence. But if the intended
contract is that ath12k may be scanned while a reset has been skipped, then
ath12k_mac_op_hw_scan() failing the scan (-EBUSY or -ENETDOWN) rather than
dereferencing looks like the correct behaviour regardless of platform, and
both mac80211 and hostapd handle a refused scan cleanly — hostapd already
retries on -EBUSY today.

If you would still prefer this against OpenWrt, say so and I will file it
there. I have full pstore dumps (dmesg-ramoops with the complete log from
boot to oops) and a deterministic trigger, and I am happy to test any patch
on this hardware.

Thanks,
Kamil
