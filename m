Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64736390CBA
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659971; cv=none; b=iySsJphRIJRc94SyfeRuhL9NMKPV9UWJjH9TX7TzcAnhGUiZdUeKo78pJjgaSOl7n4qr/HWww+ndM1HdompZU/wJFZHyRLzshVwva04Denv+Bn6Qsj6mimnWAaa8sVdG7+GvD8D9nPmzcbaUPfJAx7FgXiQxbaO5bjSlqKoN54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659971; c=relaxed/simple;
	bh=W3h7P7UQ6JCc4szLwupXzyRq863Ul8K0GSnjj2bwl+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffg964avzMntrDsu5e5RMmmMITkx0nKFhrHVDvHDHpg6/rXYzdIr46BDgTUsWSZn+fE6rSp3kD/kB1q0C/BwnXHdHM/xt/W40zu2E83DodBqiWi1SiBY6BzzKbnmzeONcklVQriSTm5trwHbYuakwH9Wrr+Vap1GOnHLy63/5UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Cf5ztD9b; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Cf5ztD9b"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso1550339a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659966; x=1786264766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PNoZ92uFtSux85DfpCBQ1jLiUM/x2tYkPs+r4OTGkvM=;
        b=Xej7xWbzUkhcaFTR9SYcZJ0FaUYTXbhS7y3kkmp8hRWyzxzrUyvxP661wbbWbAiBOv
         OQxdjO0U57J5ctSKG3J+YsEvnekNU9GP0QEaAzngOh18zKMJiQo5DHlaZ/LgCuQHBHsU
         O1UXbOv8Fhv/z7YfGn7HmJfzJsAhiZIbqv/HVKsalxHr3DRVdHgFRXEP7U1RnTw78zyP
         VGIoTY+ojJkOnrfhEMSD8GFLWU8/XRj6PxcIETz84GjnZHPQsBKHlB6a241nnQsEYU9P
         n/FTJL8/ajPNXXgLtiDtEPnu+Ng8T1+YLXnDP0BquF8ij23txmaQr65PE4K7lQ2AL+a8
         PhuA==
X-Gm-Message-State: AOJu0Yyi34hXElwLCV3LevdJJ/J5UVQnn1WJYt5zCz63mZm0Dyrk2pZY
	pgGOU0KVkzRDfGMZM/xkGH9C1wgwAUtvj4Hw5BNsN0PzGhZUXgu6WkgOxdaAEjj1fmx8aaaPLKz
	aE8KqMAKG07j5niJvSL0m9H9ENw0t5+Vr9AQ7KxoN9sRg71xN38RvSCp4qbfTDLsJrpdwRCEBue
	K/Wa9T1TnnUq1Bkd3ijz0KrfJeIZfBxNyF39E/1rtbPGOymfgdVCht+mU7dDKUjyR6S9pGlD94v
	3wABrtdKMhf4PaCeH/UODVfE6YC
X-Gm-Gg: AR+sD11vYMHt6WZ1i6906VMC0GaC/qR2kcX0Pni/EsjAQhg3yU1N9ptBXhOwF3Gtgll
	idxMu8qPAyiETpET9RZ7dx2XNnFeabEdPinMh6BWvGVTRs/wS1cTA7ZtNKWNtFmfyKgZApTyA8e
	ewKdGsHcnbrHIsoP9tX9qlnX0Lb5EJ37sufjl3Gqp8dTNfbrOVer7QqOOktKWybqywx305/3v2H
	/xx0TYPWwrXY8vNce5QWlKjOcRVFTNefoWf2u2w4ZAFDNswmEgKBZnxu1aqI5CeqrA/0XUXt1kx
	lMSvRvg2Q1t1biN1H9NCdR3ivRODvcIOjYBEjHzHagy4LUKKKjcWKhkAZeF61kM+kOffNz+ENl6
	RXi3cCx1U+Sviw/vE10xoafSp21JEWwGyKFGqel+ts+x74LyeAQe3CIZof9y2sl0x0h66pZ6pgI
	tDm/T61FD5xjGczq42yU7qmldy9tWkEzYioVG5wJI=
X-Received: by 2002:a05:6a21:1798:b0:3c3:6b6e:8ba0 with SMTP id adf61e73a8af0-3c92a5a153fmr6016549637.11.1785659965669;
        Sun, 02 Aug 2026 01:39:25 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-3153e2ad594sm468483eec.26.2026.08.02.01.39.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:25 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8efe7db1c42so26713576d6.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659964; x=1786264764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PNoZ92uFtSux85DfpCBQ1jLiUM/x2tYkPs+r4OTGkvM=;
        b=Cf5ztD9bkTUZuxLbKPc1hCX9Te8MUMfphQptUtE13ixQHkweW/Q/PQMhjfBRuXXbFT
         ja9eH7CRCjZc/OGRK26jnC5brhmhDDY0aRwp8/HkyD5jE+md3Z6UbItHB3WLaR1p1O+d
         1AsqAwmkkaPatdG5XOpM29ju1xmsRnDHETae0=
X-Received: by 2002:a05:6214:5015:b0:8e7:8d53:2417 with SMTP id 6a1803df08f44-908496389f6mr108159926d6.27.1785659964079;
        Sun, 02 Aug 2026 01:39:24 -0700 (PDT)
X-Received: by 2002:a05:6214:5015:b0:8e7:8d53:2417 with SMTP id 6a1803df08f44-908496389f6mr108159676d6.27.1785659963646;
        Sun, 02 Aug 2026 01:39:23 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:23 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE AP
Date: Sun,  2 Aug 2026 10:39:05 +0200
Message-ID: <20260802083905.3819981-8-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed, 29 Jul 2026 00:34:08 -0500, Bogdan Nicolae wrote:
> When bringing up a WPA3-SAE SoftAP with external (user space) SAE, the
> driver never told the firmware which SAE Password Element (PWE) method to
> accept. The firmware was observed to corrupt its heap over time due to
> this omission, leading to firmware trap (data abort in heap allocator).
>
> Parse the beacon IEs on start_ap() and set the extsae_pwe iovar
> accordingly: 2 when the RSNX IE advertises H2E, 1 when an H2E-only
> membership selector is present, 0 otherwise. This matches the behaviour
> of the upstream/vendor driver and only applies to SAE-capable APs when
> external SAE is supported.
>
> Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 75 +++++++++++++++++++
>  1 file changed, 75 insertions(+)

As discussed the extsae_pwe iovar is vendor specific so the fix needs to
be gated on the CYW vendor. The cleanest approach would be to add a fwvid
hook (following the pattern of set_sae_password in brcmfmac/cyw/) so
brcmf_parse_configure_sae_pwe() is only invoked for CYW chipsets.

[...]

> +#define BSS_MEMBERSHIP_SELECTOR_SAE_H2E_ONLY 123

This is already defined as BSS_MEMBERSHIP_SELECTOR_SAE_H2E in
<linux/ieee80211.h>. Please reuse the existing constant.

[...]

Regards,
Arend
