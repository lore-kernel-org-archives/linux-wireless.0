Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532A73AAF50
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 17:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791394886; cv=pass; b=E5HrYOOdenHVEiLe4rBdBqtGGTbL5h0e0FMmvhUIjo9OzqOA64TNcUzUh0EwI9T7tBAk6znuRQLqku2lfZ6nqnYR0feIEGkrfKxA/CzVGEk0959aI4rDClTHFZF4MwDD0DbxOje/QJpbMGA0lTGTO+prtx4Tq2wlrIeJvVpLu2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791394886; c=relaxed/simple;
	bh=4Jej35f24dmqTIY8xLAbY/Kdm8Ex5aNAucOZfyaQ4MU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=HcwvL5naRbSsAYPGE8MenYQzJKRClMfRpc44Rd45EdGVH0CsMvLcbE28HbsauX2JwT1KwimWzuk8grAPGzVV6JJx/I4FZkQ96t/pOFE2hEH5/BQT/1XBX/+5biGQzRJkts0kJA9Jio47Fc6psogxjW3hYMMr5fCeW1dre4qY6s8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTXjnbgL; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTXjnbgL"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6aa850436d3so5819609a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 10:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791394883; cv=none;
        d=google.com; s=arc-20260327;
        b=WeIKDL01bz8fwvgvt6ESmdpVpOODg44mEdazeW6pXsJ3hVHjoClzNQJsKDFoxqJuRh
         I/12BKMNrAynC3H1Kj1K4ZzL1SANrY7LHOb8o2j5oSw3zX+s3UKJy0SHpTfzv1xQo933
         XhGC5Qf2XsqpYCZTewPvjvOgwOZnPWEiSNn+5/uNxlYsfGc2nYjBU+NDoXdldDxD5x4L
         jRFPrGR/GC+5lWRYZOyZ/APCUVXc6u+tiqchuP7NttLw5bYEy0SI/mlOxxazxR3SprNm
         97J3e/yemnUkgQmVPxwGB2pRYlkgHmB+wpEZh1wikKfixUR2uj7PPPec8o1jsvfeW8I3
         WBbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=XylpUE0I2nGeBgwFtrUE5wzNHACJyMShQ047aik0R0Y=;
        fh=P8JnnWkwNLrKSKxnDbU+mi+UbCTIFHcZgGeDERvZPL8=;
        b=DHI66BAKEzzzhGcIdPfxkkdox4LH2685pJOlogdTEM91yn4PUGiiWmei6K3vb4qjp8
         Sh2DMYZBtP7BEhZhhSXAf9l1lTIYRshA6TA2IJPw1BCbb7z2UL+QwUz9GwNzDB+MPs3a
         c8Sy9GUWbkvByU1GQvrD+bYNQN3+rkuM0y8M2WRztFSlBUtfzr0MDDFM4NOXvND3mDjY
         BbBnAx6ULzlRW1QS0DkFco2mURTOYuhc2ziwwIDKo3EPpvrhsk9suyA3iZkS+N3LOv5f
         6VR3SsIeC4ynK1htoQTgf68Rskj7iZr8hUM2p0wbEjJ06XlgdGZkOYDtmmfC9dLA/qXh
         suYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791394883; x=1791999683; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XylpUE0I2nGeBgwFtrUE5wzNHACJyMShQ047aik0R0Y=;
        b=OTXjnbgL8J0p8Rx7nCOqFzhvk15aLRDCwXbyjNhwkKAqfG1HwJO5jpVwYAWvjAY4vx
         ud+kGKRJvUCSP4d5SJlzBo5vqzEnKZr1RAzB4aFDSb0oRW7LRE2f05Q5lABEZbBCtYwS
         R7oHqBOlsDpl8OzUJhHyKIb5lzeIEDgO8CVf28ZCAneDSkKhlJGefwfq2RDPzVEsaUN5
         R7w9uv45a2C843SisZ/w4tQrq10PlN8it4Sp/+W0jjfeaEhsuHRFnrWmNx7KOsImzXuy
         Dtf3R6ucifhn5mKGtS2W+PAe8rcJcWQFhN3m0da1cwyEneHWtBFUwJMG24GIEG9L+fw/
         MP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791394883; x=1791999683;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XylpUE0I2nGeBgwFtrUE5wzNHACJyMShQ047aik0R0Y=;
        b=bjrmxgbmBM6Dx/y/7qMUo0/oKI1BPuoMN85mA9dJ2k3gK2mw3BtoF27J2b4l6mxpPK
         LEtw6YvTCIzmC5VYPeVW61Mg1T1o/+hh4frV1/3HO5cdU+qX+AQ/Wh2i+/IL1S7Qnmxj
         F6N3QRoBYAyPkfDh+a6xzO6GU1plf0OfoDTZdm8lZZKrjM2ib1CK0JvirXpckxvKWOcT
         OjImhHeNsUppOaG9PZE36iw0TGGqtaOpeYnQTAMV/CiQWw7MKmO2IxcL03RbqScgth19
         zGFLUj6hs1UEOUjSPGKWvxmVaJLTth9xgghsuE6bNqDX+fzSlzcNZi8DX5cpGmuCKT9B
         Nckw==
X-Gm-Message-State: AFq9FYL6QGeL7xPeou559hPEctfKidbUmfCK0q+wvZGhGHUr8sZZZ50Q
	dcLcqLfliLupSHkPyeSNkK/dnpPELjGnhRP+CtdZxJBcrN+2BHxrRqLks/uVFtWlMxn9fVWKG8a
	nDWVfU6rWOlJPR5vzPhHz6YAZmEQTlD8pNQ==
X-Gm-Gg: AYBFou2Eg+Ooe9VkD99l8PT0qD6ssRkoM4isO5yN+MaXzOc4raj/xLU3WVvMs8aE9cY
	ri26pOAlHjHj+m250s54/FsYSbX+QmiVHjTdJ3s95sbJppBhgQXdugECKQv8LAGvvTgqDUQmY9T
	7tQNcb+ReGzTxxp/3pGnuiR/vuMmfHM/nHGzWpovNeA0NqoNVOxsCzGnBF3XuebYPnc8XYgHRCg
	/5J/B75KiB78MqEAvHN36D52zTvNnX2I81jHZTx49FjRv9eLrFkPHTUfUeBsAh4p3rgv7pO+IF7
	R72Eg+dxUw0mG0T76KJrrhZzxCxJhykn7q9H1lTWlmfdqdKFIMBRJQ==
X-Received: by 2002:a05:6402:218e:20b0:6ab:81e:e827 with SMTP id
 4fb4d7f45d1cf-6aff441894bmr2332913a12.43.1791394883309; Wed, 07 Oct 2026
 10:41:23 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 7 Oct 2026 10:41:22 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 7 Oct 2026 10:41:22 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zephyr Madera <dencity7@gmail.com>
Date: Wed, 7 Oct 2026 10:41:22 -0700
X-Gm-Features: AclHuK8Pxavj5AL4tzu3fUd_5x4Qx9JoVZa7mcyYokAr-1cN1zJq2Bx2A_FU96I
Message-ID: <CA+KzPsr0G_1tpEDyi2Dk_1ZF_JVeGJL5Y6_A0aCe=dY+5ufq+A@mail.gmail.com>
Subject: [RFC] IPQ8074 v1 / Netgear RAX120 v1: interest in support and review prerequisites
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Robert Marko <robimarko@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hello ath11k maintainers,

Robert Marko suggested asking here whether there is interest in supporting
IPQ8074 v1 before preparing a formal support series. I own a Netgear
RAX120 v1 and have an experimental OpenWrt port developed with AI
assistance. I would like to make the useful source work available for
review, without presenting it as upstream-ready.

Linux socinfo on the unit reports:

    machine:  IPQ8074
    revision: 1.2
    soc_id:   323

In the OpenWrt discussion, Robert explained that this early silicon was
intentionally left unsupported, differs in peripherals and clocks, does
not comply with the final 802.11ax standard, and lacks publicly available
ath11k firmware. I understand that successful local bring-up does not
resolve those concerns.

The bring-up was rebased to OpenWrt main at:
    edc6b8f160c798cd211893bc5df25aec7cfca838

The tested base uses Linux 6.18.55 and mac80211 backports 7.2. On this one
unit, recorded checks include Q6 startup, both internal PHYs, LAN1
management, and four client cases: 2.4 GHz and 5 GHz with WPA2-PSK and
WPA3-SAE. Those cases covered association, LAN-side DHCP/DNS, ping and a
checksum-verified local HTTPS transfer. These are limited bring-up
results, not standards-conformance, sustained-load or cross-device
qualification.

The source work has been separated for discussion into:
- Two candidate generic ath11k parser corrections: host-sized MAC/PHY
  record allocation and bounds on READY MAC-address array reads.
- Secure WCSS separate-M3 loading and its binding, retaining PAS6.
- IPQ8074 v1 register/descriptor/ring handling and legacy firmware
  startup/event compatibility.
- Separate RAX120v1 board, image and upgrade integration.

The generic corrections have been checked against the pinned OpenWrt
wireless stack, but have not yet been rebased and validated against the
current upstream wireless tree. The v1 development sequence also needs
review and reduction.

The working setup depends on owner-retained HK1.2 firmware and this
unit's calibration. A public, repeatable firmware acquisition path and
redistribution terms are unresolved. Source provenance, attribution and
DCO certification also need completion before formal submission. No
firmware blobs, calibration data, private settings or flashable images
are attached.

Could you advise on three points?

1. Is there any interest in reviewing IPQ8074 v1 support, or do the
   hardware and firmware constraints make this unsuitable for upstream?
2. If there is interest, what minimum firmware availability and hardware
   evidence would you need, and which tree should the initial source
   series target?
3. Independently of v1 support, would it be useful to submit the generic
   parser corrections separately if they still apply to current upstream?

I can follow up with focused source-only patches and sanitized test
evidence. Local button and diagnostic customizations are separate from
this proposed hardware work. I have the router available for coordinated
testing, but cannot claim testing on other IPQ8074 revisions.

Thank you for helping establish whether there is a useful upstream path.

Regards,
John
