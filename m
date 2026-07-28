Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F6D41BA98
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 09:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230562; cv=pass; b=BxKIUuciZF5TMhgKTXLLZhes5I7sDHCsuaYBNvhOgj9q2O6HB5baABBuSp3FHfj2Vg57aT+COBNgPZBEHm2ArR3eOv3m4dMxtBZrQg5y1r3HoeFhwk0IAgV62Hywa8Ysb8Tmn5ZQL5aAbSEoYLwsISRnulslJvan5V14ZWbd5Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230562; c=relaxed/simple;
	bh=eiahC4EwXO39hfBl12vbBh+1pVUCATYFHODBb9HHGVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=knhKS25rELzaaDOdmSzfl3GpmCMoK+zC2uEhky2Z3iDNI4D0eWi5AtKaAVcSBa4ii+/aSqrdKBsSRXVnilbNalWLCewAXmagVBxBTdL0KbEjdZ2r89tslkMj0qPcZGV8fEp51nNHe0oxXGPCumYdfez3q8AWDlTwqf3J9oc1T+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lEc6ZCfO; arc=pass smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lEc6ZCfO"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2caed617615so37395965ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 02:22:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785230560; cv=none;
        d=google.com; s=arc-20260327;
        b=Z2q9pFU+BVyEnqMOUfBnsHXilwmwFoQYJ+yjcUqnTp1SGG2JyABBt7/8srSWG+IETR
         +CdgwiPdC+RX6kwvPDv/QiuWRbLhx+uAH2cV+BXXWW7sdnzTe1HeiIu6nzt9a6d56dMN
         bnIJ5dM6LNOSnYulE1Wq47UC3D4pUEZq2Qo7IbJ9pJ1WC0pZy8x+bOWV4yFOVq4lMN+H
         5uEjTm0xLl+lpQ8S8Ewor/Gr0krxb1tZ4ZHX/3YreNn0/9lsIqUrlF88JBLsjqW/H8N/
         M9G38GOTbV3hK4Uf4wJaxZUvVJ/8QMdekur9Tzie7D5eoIjZt5+76w9RMuk7xP+XbH1w
         AYAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=d10schBzgEOF3C/t7XgGB3J+xn0+TODvHGCxcjgHzIc=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=Gta/7LNeCVJbXyBMFgeTwrd7qa5ol2HIpbm7KHuB/xqwA+9IY2aUDv/ZXuFk5qCFA4
         Z7PI6gfLUCfZvZ29VMPPcvt8eze1u08XO/5aDYzkKnP8uJYI0EVX+pQ449OWpq+jOwwZ
         NotoWBvZ7NedyO8tvWeJ4FlZuzJ7zZFQ8Wgr/DJ6RM62JAp+OnJzBKxTGpcRbSjuR3N6
         igLZ4AO9vjPgMxp4HfyQDV/fxWJklLw2Ju01NuD7aUKvk8zghziNnaqmVsc9cr+73LV/
         T6YNTW7Aq7NvKUgJHYgDFypbXVwLJVm5zhcwppX4jWiT/SSzHjTzdLVifADOpm8biEqI
         zUNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785230560; x=1785835360; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d10schBzgEOF3C/t7XgGB3J+xn0+TODvHGCxcjgHzIc=;
        b=lEc6ZCfODBS0e70wIg+erkVyKqDu8ClprbUuUKlubrFPIklOOLxuNLWeNY9lhn1R7+
         x4MXXAd4xY4XNrVJ2+KSNnkr0CXqxzS4x5bUW8E1xLCKazporJjUr/FHbi0HaQDZ5GKW
         TWs1sSJl8LB/DNmYqg/4CMfLZxEf1Dpyr8vgrOP5POGXP37uqG3O1rtA4JmwT0Qoz4MV
         blNQyu84ly3QJJLkV53Fg7oLERSir/QjlCL/LLQM1fyHnAnRT6cp+M1UxH+9V7SH2KZs
         s0u6V4maOY1VeGQQjOTuRhSwZ4JQy0GonNWGCob7d+TAUcWjr8lEzbrp2YkDdMoF/ULD
         6LAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785230560; x=1785835360;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=d10schBzgEOF3C/t7XgGB3J+xn0+TODvHGCxcjgHzIc=;
        b=N2fSmDLzsJhLdVWr9DRNZh7xx7KPo1pYrN3DGxWiPAcIKH36wtS0IWOZXcacwIZ2ej
         RpzdLXdUGwn6BL3+HWojEYzU2H19I/cAfW1pj/fVbV/eWVPS7tRtFVzVLdbWfCT2hKEB
         hyfeumd3XsPpDHwv8zTiUpVkkaO4nmMCewHgUu19DdlN4wxqaUQ5qfuvRxc7d1sHSBJw
         lFmB36ik5XNGgViiLig7eGT+mM8Y1HdofNK7Ergbl23tDk+a7FpkcMfBLcNOVCmvTExP
         z75TJeFKrn+4sOXVwpyrm6ZGpCYRlq0IadjAr54XpEMaNva/1TBFvoleVaNpwJbX81c8
         ktcQ==
X-Gm-Message-State: AOJu0YzyVPQIGtvTFmJXK2ImkhSKfPxWaKzZCNmqAkWuQkxZcLsmL2lr
	sv8zuvFspbKMEsSZhEXERsIRR5toiZ+1JxING8PC3ygpZCvHZ1+AW5SKeYS6yVBv0daWn7CUEE/
	YB838BKD9e1YcJxNs25ZhxNkRkey9TqJ6acQk
X-Gm-Gg: AR+sD11UPVWMRRRIt+foR31vGtxlbDANsBlPI3GHZZThdIalPO2rTIZulAtnKjCcYY5
	BjAJtn2sGVHKVl27qtQwHBCNaiApqqrq13ZrSJo67BgAhyWpHwNcNaAOw69198bLA8+p8JhKdoZ
	j+NTXwB4DZ+smD8onUWpPoEltlVgwxdf2G0qtpYyi1aR7M9Fre58SF22K+E4gg6J9pg2sPxEKb6
	bO6Or/k4oZp7TE6prVWdEXDuH9eetecJJHgFo3YHKAR0HSPB1VAvzwfWJQL1GdOk5fqzwqtPcfq
	TG32NVIXJb9MlpjA+N/1EnUNrq6x1PKUJskPMGTerhkoEFR8inmBYjlRk/I=
X-Received: by 2002:a17:903:2b0c:b0:2c0:a555:80d6 with SMTP id
 d9443c01a7336-2d015affc6dmr21677065ad.2.1785230560518; Tue, 28 Jul 2026
 02:22:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
In-Reply-To: <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Tue, 28 Jul 2026 11:22:28 +0200
X-Gm-Features: AUfX_myYF5m4MaWPMhULBm3WMkvOCAzcw0IZNGdmlYWK1mTszYhfif6ugumA2G8
Message-ID: <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

> Did you encounter this problem in older kernel version?
> If older kernel works well, could you share the version and help to
> bisect the cause?

Bisecting will be difficult for me, because in previous 7.1 kernel
versions my internet disconnects every 10 minutes due to
https://github.com/morrownr/rtw89/issues/109
The current issue is a lot more rare. For yesterday `journalctl | grep
"\[ERR\]"` shows me only 4 instances of this error. While the PC was
running for about 14 hours.
In other words I don't have a clean reproducer and have to run a
kernel for quite some time to see if the issue occurs.
This is not an issue if the kernel works, but I can't use my computer
with a disconnect every 10 minutes.

For today I booted into 6.18.38-2-cachyos-lts and will keep an eye on
journalctl to see if I encounter the same issue here too.
I could look into downgrading to the newest 7.0 kernel if that would
help, since rtw#109 only got introduced in 7.1.
I don't think 7.0 had the new issue, but I am not sure.
I should probably mention that I only started using linux desktop in
april this year, so I am pretty new to linux.
Would it help to know for sure if 7.0 has the issue even if I can't
bisect 7.1? If so I will look up how to downgrade the kernel in the
next days.

> Since the firmware version is hidden (The ipv4-redacted part is a number originally).
> Please check kernel log and share the version.
>
> [    8.282149] rtw89_8852ae 0000:05:00.0: Firmware version <ipv4-redacted> (52acc807), cmd version 0, type 1
> [    8.282153] rtw89_8852ae 0000:05:00.0: Firmware version <ipv4-redacted> (52acc807), cmd version 0, type 3

Here you go (output from my current boot into lts kernel):
[    8.749689] rtw89_8852ae 0000:05:00.0: loaded firmware rtw89/rtw8852a_fw.bin
[    8.749726] rtw89_8852ae 0000:05:00.0: enabling device (0000 -> 0003)
[    8.752352] rtw89_8852ae 0000:05:00.0: Firmware version 0.13.36.2
(52acc807), cmd version 0, type 1
[    8.752355] rtw89_8852ae 0000:05:00.0: Firmware version 0.13.36.2
(52acc807), cmd version 0, type 3
