Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1E7438023
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785524158; cv=pass; b=ZFFkoaS9yBaDtsg6tsdRBXMvKjPV+EefDE+Izq6+fPvtSRIstVoMKL0PZvw9ATUjMIU8HRCvl+xsJq9Ycj2o3IXiQA4bycj5SVbvtd2Bq+ugny5kgkFk2rgvIvq3wKg1WfmvvekZrlxwkDCkZ8wwztnOPKkYxfuM1dzpyVTJYDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785524158; c=relaxed/simple;
	bh=e7Xb6iyuKREBvhKuDndEnRmOXeFlw2JNtdV9987uNAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXeTQif/B6fTkG2iQ0ZuMSQ61Nzu9ad3LvGB7atzu3Yeibsp9ZN8kgTUAA4xIx1QX/JL0VxRi/zXwx6+lcJX339z30n3OU0TRu/WAmdI6fENHqPIfmPw8I4g0rYZdeU5xUXyoQ1YWUKE7nwKGv1DdXKhbjdoWzzWGcAxvygIK1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQ1iIw4z; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQ1iIw4z"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8efcef23d21so9178306d6.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 11:55:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785524156; cv=none;
        d=google.com; s=arc-20260327;
        b=m9wEZSu2nsaim6OLFoGlrkWTRYBzYTuFP9CK2YgPZd/CVeoZ5VkFZxnjj4BQDYXGFw
         2QCm1BkuIU51gu7tt/RjgaWGCjvBRn8UexxACi31MyPaFy/Ra8KeZCWETByAfwwARfx8
         mEb5tieLOMp4qoqnMaOgEGpT69pQBJMhoCUupLmsQhQnedGIn3W1gN0dSOlIyFM4qHhX
         5yFfR7mXwWbcBSSAZKRi7LwH5M6m52psiNgo+6E2Be31qkpzi6auw6o/j0fpjxYRBGnN
         0gAC5FhgKFNvpfKQVEejWAdht3wKiM5UD290MgkKY2vxamnnENhX3WcEGTUz//ZylZRM
         OjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8E4+shQav05WgyUY6G3Mum98V9wgbtXbHPtbTkAf4bQ=;
        fh=dX/Nco/B3U1XHrI35pOmGwJ5LyegLnleP1JtVBZLXFQ=;
        b=k/CgBbFZvEAzdUdMqncEr0RFcgTJ+P8j0RbmANJA9Yb7dC5j4znjybicspPyIWtTix
         BCsyRM3tF/TBcdoycd71dzArBavkb4hW6CznLepW7yS83oPC8tN67G2mlQQ+lMfJnlF8
         CmyqNZ/ZtxvRYVvSaN8QI2SMbbtMue1NTzhFNdHNAuE3qbWUhXKX+zF5fpg6XPmbW5h5
         Zo7gtnqDqNqmgCZF3UTQ5uLPzd0QHjDMbbb3eHhaXGTypYJgoMaZU7x1S3pKN0EsGlW7
         CcJg7A+4TM4qEy2LpG0T//Ku32fmp72aFyQ3nIZGsgmWTzinCryQ1t323PXWFn7P6J5e
         1XWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785524156; x=1786128956; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8E4+shQav05WgyUY6G3Mum98V9wgbtXbHPtbTkAf4bQ=;
        b=fQ1iIw4zBpEAG2qv3uhhVgA4F5aHd4LPH5nMZOvabLPgJBByL0Hv/Rxtzp0C9OWeSl
         sbFjmCK4OyGxBHpqL8Nyl//nN3iTZpR17OGo+UYegRJwss1ye50+mKk72rA2kdmR+KLz
         YZE/riLpKNfqc4s+H4PqFk6/BEVGXemBT4/xIwqSsFGuKZP+fJ58fl8GHOCT2sKcHdsQ
         YmVzK8meoBwx0Txpu8J3XS7ggeEFX+5HHQxxFfdwfAgH7O+bJAUyPp0P5cIge9v/EiZk
         OIkfiwnSqQUA5wv9O+73+Kb2Tb+G5gJuv59T7y0CVg68ErLvC1ohH9ABRYgj+heikxOz
         RydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785524156; x=1786128956;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8E4+shQav05WgyUY6G3Mum98V9wgbtXbHPtbTkAf4bQ=;
        b=GgkxxwZ1fZfTlSQNo6oQRqjdG7X299bBlLl5xwVkQX+Ji1ZcKhAl4A5lCLf7tUwQTM
         rqI1J1iGfjmNCl0ay1ZkrRpA1uGHW4RJu1OoAOkdTtfHV1cytOymzQjGC8Whiovj4AK2
         IFo4o9fV/eBzaudod7XNvwythTVq0LLhUgOmqmUT8qwWRhqItivygxTvDAlHUs7ymvyG
         N5oPO90tcPinHp8V4B/FfGFiLuTACFOYBDQabJ8chZoecK9JD6NwxZDWCQCq5gKqASdt
         vrgycApSStUc1ayTPScTy4AFnZDrK/7LATF5hWs8JPk9Tbhpd5SjLC9k7RIiMPIMoCLb
         y4Hw==
X-Gm-Message-State: AOJu0Yw2lXvvfD0GSzSk1fl8cUUgrNszRhLjV3qv9OnkvKm9Wy7JwRC1
	AXUjC1mzz7i0wt/tyrSG+ZBhMC+za24szqbhKpBsf9rfoH2ipdV/HCbUwd3o/EU5H//BStSgsyd
	k8FhPwqyIwcOFCAtOX4NWflxW/VrByug=
X-Gm-Gg: AR+sD11htAlhmMJDFJfJYaLKbc8tT6tWpc+81vyuWyGUipLmGhJIlLU/RhAc/5fAPgl
	Zwrleqz/haC84Kk7hEezUWQvVGQAYZRtgv6EDmVuwQZcyWT+h86LfebZIx0QVFKTpszsR06uN+L
	6GV3yCXjAxMRI93G0fQjs4/Mh4H4FDgGMxVkAB61fDPSkPHdyKEx10/7RJr3yDb+DsZkuzf7url
	ys8U76/dSoOz2EPbI4PuNt4/sz9gq2OMG2I45cviuMUYDeXqFfeOO2dhGEx+KsLUS4G0j/UJf/B
	4vnRspY/tmjsNp/reQpbxpkcGi3MXn2LzMf4sKDBGkeceVrAtA+9DPY=
X-Received: by 2002:a05:6214:509e:b0:8f2:d87e:29de with SMTP id
 6a1803df08f44-90849686d43mr18964906d6.27.1785524155376; Fri, 31 Jul 2026
 11:55:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731094141.2410630-1-perceivalpercy@gmail.com>
 <20260731175103.1745248-1-perceivalpercy@gmail.com> <8dcc424b-32b1-4152-b75b-10bdac0af9d8@oss.qualcomm.com>
In-Reply-To: <8dcc424b-32b1-4152-b75b-10bdac0af9d8@oss.qualcomm.com>
From: Kamil Bienkiewicz <perceivalpercy@gmail.com>
Date: Fri, 31 Jul 2026 20:55:42 +0200
X-Gm-Features: AUfX_myL8T9vAdW6QqQ1YACdqC_rsZuU2s0TooK_rdtdDDwd2VfH0OH--wwpTFU
Message-ID: <CAKXN0879kBtG=YbCUWRqg=RPcnkOdSiaWB5PREh9oqFVwV=vkQ@mail.gmail.com>
Subject: Re: [BUG] ath12k: NULL deref in ath12k_mac_op_hw_scan() when a scan
 is requested during firmware recovery (IPQ5332 + QCN9274)
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, 
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>, 
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 7/31/2026, Jeff Johnson wrote:
> I've cc'd the dev team to have a look at this issue.

Thank you, much appreciated.

For those just added, a short self-contained summary so you don't have to
read back through the thread.

Platform
  GL.iNet GL-BE9300: IPQ5332 (ath12k AHB, 2.4 GHz) + 2x QCN9274 (PCIe,
  5/6 GHz). OpenWrt "qualcommbe" target, kernel 6.18.39, backports 7.2-rc4.

Failure
  The firmware crashes before QMI is ready. ath12k_core_reset() then
  returns early because ATH12K_FLAG_QMI_FW_READY_COMPLETE is unset (core.c,
  "ignore reset dev flags"), so recovery is skipped by design and the devic=
e
  is left half-initialised. An nl80211 scan arriving in that window
  dereferences a pointer that is not valid yet, in
  ath12k_mac_op_hw_scan(). Faulting address is 0x1508 =E2=80=94 a small str=
ucture
  offset from NULL. The faulting task is hostapd.

Why it reproduces rather than being a one-in-a-thousand race
  hostapd runs the 20/40 MHz coexistence scan when bringing up a 40 MHz BSS
  on 2.4 GHz, and it retries that scan on -EBUSY. So for the entire duratio=
n
  of the un-recovered window the driver is asked to scan, over and over.
  Any firmware crash during early boot therefore lands on this reliably.

Provenance of the crashing code
  ath12k_mac_op_hw_scan() in the tree we build is byte-identical to
  drivers/net/wireless/ath/ath12k/mac.c in mainline master =E2=80=94 I diff=
ed the
  whole function. None of our out-of-tree ath12k patches touch the scan
  path, and the early-return in ath12k_core_reset() is upstream code as
  well. Our tree only adds a clearer warning and a coredump call there.

Suggested shape of a fix (not a patch, just the contract question)
  If ath12k may legitimately be scanned while a reset has been skipped,
  then ath12k_mac_op_hw_scan() returning -EBUSY or -ENETDOWN rather than
  dereferencing looks correct independent of platform. Both mac80211 and
  hostapd handle a refused scan cleanly =E2=80=94 hostapd already retries o=
n -EBUSY
  today.

Workaround we run meanwhile, in case it helps narrow it
  Forcing HT20/EHT20 on the 2.4 GHz radio avoids the coexistence scan
  entirely and the crash stops occurring. That is consistent with the scan
  being the trigger rather than a contributing coincidence.

I have the board on the bench, full pstore/ramoops dumps (complete kernel
log from boot through to the oops), and a reliable trigger. I am happy to
test any patch or debug diff on this hardware with a quick turnaround =E2=
=80=94
including the error-path work already in the pipeline, if it is expected to
cover this. If it does, I am glad to confirm that rather than have anyone
spend time on a fresh fix.

Thanks,
Kamil
