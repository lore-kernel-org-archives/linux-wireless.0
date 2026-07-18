Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC3C2FD7B1
	for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784396345; cv=pass; b=P9yZauQBtNS3Cld2Ca5pgiMz1RNeVgo32rvIVW2B/zL9PNwqagwg97e37mk5aoATiILaIVcNcE1/WBgjiw23+CL0+WTSyQrP2PEknT5o9kxT2r9zSO9HsnToyfVgbmrCaIZ7JPU0+acnldrZjoi/HMCyCCJf8yffQa/e224jcnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784396345; c=relaxed/simple;
	bh=5WC35L7Iv1EnkbiZDr7ZHCQ3R0J2NLJkqYIJ2Ez6/Bo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YlCa7tPZst854zjYiBvCKGVb0J51buIBAgnswPGbiHituA3DsME+GbFBjkVgHKxQxJXkRbezy+qvc3gSx/fMATYI8UwJsB9LfM76+Mik6R5/s2i5dsN3hy2kvxBt+Fm2wYuid/STDctP+Jxd6AJqZL+iYFtMNxtC2ig9556UvcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UlQmaisR; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlQmaisR"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e6391b114so452855385a.3
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 10:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784396342; cv=none;
        d=google.com; s=arc-20260327;
        b=q+6bL314UtQbbjzXUSM9FCJ2lsxNWt+LqVl/m12zlB4IQZLDPs518xdTXLpERj+kNt
         uiwb5dW/uT55m9FD8zWyYyE2jsDLoZa26uXLdWokDVsu7BkL+isCSVOfjyuQ+Onfhy0F
         64bcoiBRkt5mc14PPpTQu5y+tPMJUF7M7evdydP/C6lUm5BxYebYhRGYqoJ2AfO8sctq
         yGBIwDvvs1l9HQK26rmfnUEdansOJviYafnndC213sxtQUMCdnfGlJ7HX1wCdWiP4Dd2
         rslzBpZ5lXo5ktL839IDjMZ+ZVzzXpNfZSxQzkOtpE9kBXDkzn+tF6m5GkYJk2I86QJZ
         7jNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=mdH+D//T2JL/1hYWCoVD9zXsafdlcW0Rf+V0DeWKlfw=;
        fh=HwEDsXFY9GqDxlPZMG/IFpR2ehYXnMh/V0QsVOtQwEI=;
        b=GdevD5cGlxOOfPKO6/5gsMQ21uwu70Y610muVzQ1VRHHbFt7xHKJZVcJbGyFpVKaId
         zTzsqG+fiHW4tpVKa5FgYimsalwbiffXXhK5bXiRvEG/aKCoNkehqLIztadNLyZeHryx
         kytDfBYt7gOOaZ1n5fTcyPTW+qaHcOQbwzpkOWN38lqR2pq1sV38Kz6Yc917fuBeCmuP
         vvacwam7oU9yL+AXvpUZpn0ONZ7dRpvRdlskJxSSJiBOD4uVEYkOU5WXHTnXnltxbx4X
         1wZuDuvhm3+VWJsVpT50IFXWtnehY63l3UsEobmNY62QmpnlJtNJ2EiGOE+FJdjAYt1s
         yPew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784396342; x=1785001142; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mdH+D//T2JL/1hYWCoVD9zXsafdlcW0Rf+V0DeWKlfw=;
        b=UlQmaisR2MyJQ3BSgmXpMUf3q9/F32hAIpM7R+TVV8GrE4BVq8QwEeazWjpzRaYIyp
         RyQ28rxvnAkU35O2fy/WurJMfG2mpuAE2qqyRNDMuNfoucqZ+XnFA1TsjE5GrcCefg7c
         jxbi7epGdMsr0QkERXXSn53j7zBgPmfGAFPVK85o0UT04FALrLP/TfHrTbCrLRdgyfE7
         k/B1cJJ+mIBwDy3GmTv3UB3lE4nw4rtAOcfIEHn/53CAvXfKmNYgMncDk4jEAEdsU8Ey
         q4t/MtnatwAJEId9DqKrLG+NhgeIrIkFx49J1tBhZuBLw1Di3yoQecwCcWcQxXeh5q1m
         J0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784396342; x=1785001142;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mdH+D//T2JL/1hYWCoVD9zXsafdlcW0Rf+V0DeWKlfw=;
        b=B7LvWHmg4WwWPN0TDomftox9bmwHXg3ZuqkHY4crJQZwp9p5TO0ExBYPAeQ1aeiFdp
         OQj0vx9YQMk/9Oi8/yziAR0u0lEPCekZReJsBzF2UcvKQABK8vZUJcI0xgPscC+LJ3nv
         bwpsDSH4w0UzWyDqAhRMY+PPR4kTbXT1X7zoz9MuQ+CYzItx32w9SV83FSQ/4jAwnDzj
         CcQhKj8FnKUrxexYM5u52UdS5SKyW/yTj/bodhRn+gREQiHJ46jXrQyWIY/vn1jszYZ0
         /1kpyE0p/ZGXfU3wPeKR8y8qpGNwgq79/V81EDynBrbkvEW8NqM5BfwQfP+3p+vtt/Io
         Pu9w==
X-Forwarded-Encrypted: i=1; AHgh+RrGgGkcrEleGijvI8nZGYqPtptg8oVDPfGmnyQXsZo6gNNqubp+25h1GbxHBXK6PcT53j7/T/VH+RT8R1sHIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSFnbjCD7FPRVeJQKnxqvNWnf0huO/Y0+fZl1MZTOK8WtucYEV
	f8juVABda9oppb+0TVJtNIt9A1GIB3V3b2bEJcxTjYx2AQYWZOHVxXjU+ap7H+jQxbsKxyFqDaW
	VFhU8jBBst2bPjXwAtjqzYxCHS1Wv5t0=
X-Gm-Gg: AfdE7ckveneFE0xejKjIXyxByvL4qFWpb92FgU+zOaIJXAigIo+VmyJeyq3W0Jzv5AQ
	/FhimN00a2G8fzERbuHnTLE0eT9WWiSbCX4LqISWMMljMq19V89H2Ucr31LqEeVmpHVRn/BPjoe
	XeDn7JWbAsRReH/UnqDY+R+t4NRzCicMRvNnfS7bkO/tgITMEYuADgCxscWhDBJeEhw/U6nfIPP
	lYZCs7GuuH1QyPUdMwbCX9QRqP5rxN//2XykN7XcdsASQV+Xmoo6vqChTfm78L3FQb58W3fDkzy
	6IZhYn899SHwel0Z+WVYhqOCzt+02qsNAf/ocl/cyeXLrwUs0z/JWqFEcKPDhBIsR+znWOdT7Ed
	Ly2+V2jK7PCpRrulxMRuM4tlsHKFSuTh6sBB10ESFT2SKP2f0rGKPC/GR
X-Received: by 2002:a05:620a:371d:b0:92e:70e9:687d with SMTP id
 af79cd13be357-930b419edcemr853747485a.57.1784396342408; Sat, 18 Jul 2026
 10:39:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Peter Robinson <pbrobinson@gmail.com>
Date: Sat, 18 Jul 2026 18:38:50 +0100
X-Gm-Features: AUfX_mzerzJFMzBZusY7ri-XiZxklgZflQ3_wY33chXzrGlcMPOXboioOsT19_A
Message-ID: <CALeDE9PgQmpMfDt1DgfLD4tBFGH0MZ7GncV6RUEOHhHbKF+TdQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
To: luka.gejak@linux.dev, linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, straube.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Luka,

> RTL8723BS predates rtw88 and uses the available Realtek vendor firmware
> (version 41), whose H2C/C2H and association behavior differs from the
> firmware used by the existing rtw88 8723-family devices. Supporting it
> therefore needs both the common RTL8723B chip implementation and an
> 8723BS-specific SDIO path for firmware commands, coexistence, power,
> association, and TX/RX handling.

Over all the driver works quite well on the Pine64+ and Pine64-LTS
against a 7.1.3 kernel that I tested it on. I get the following errors
in dmesg, they don't appear to be detrimental to the operation with
some basic testing:

rtw88_8723bs mmc0:0001:1: Firmware version 41.0.0, H2C version 0
rtw88_8723bs mmc0:0001:1: firmware failed to leave lps state
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
rtw88_8723bs mmc0:0001:1: firmware failed to leave lps state
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
rtw88_8723bs mmc0:0001:1: firmware failed to leave lps state
rtw88_8723bs mmc0:0001:1: firmware failed to leave lps state
rtw88_8723bs mmc0:0001:1: firmware failed to leave lps state
rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware

Overall for the series you can add:
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Pine64+ / Pine64-LTS on Fedora 44 with a 7.1.x kernel

> The driver requests this firmware file:
>
>  rtw88/rtw8723b_fw.bin
>
> It is not included in this kernel series. I would appreciate guidance
> from Realtek and the linux-firmware maintainers on whether the existing
> LICENCE.rtlwifi_firmware.txt redistribution terms cover this version 41
> blob, or whether Realtek should submit the firmware directly.

There's precedent for including the realtek firmware in linux-firmware
like this, you should include in the notes where you got the firmware
from and how it was extracted so it's verifiable, as well as cc:ing
Ping-Ke Shih who will then ACK/review it. That's been done for a
number of the realtek firmware that were extracted from official
realtek windows drivers.

I am happy to see this, I had started to play around with a similar
patchset but still had a way to go and little time to move it on.

Cheers,
Peter
