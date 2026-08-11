Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D2F385D64
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 07:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786434494; cv=pass; b=ejhTacv/qPAxXG7k6lhccMZhlb+Ohyt/Qx0If7gUZhDsae+prVfeMQ4IWWai2FiXyzYcGX/vAKkGpoQQtveP+VpPARaVyEL8F2SdKjmEmLj/4u/rofis+1mZ5LM0aDWRLYeJLWXaH0N/hBn9M9joF9bWnKqnHPivFJz9kKF1VZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786434494; c=relaxed/simple;
	bh=nMYEZy3hrjcGjchEAiVUV/3h3Gqr5gMSmjKYU9dlr/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rvXmY6z9A/Ux1QsWr2hO4OVbXnRQGhEih0jCojfuIj3eKp4HD9GUNST/zKHg9GMs07ddcr2DqCL0rLMSAEo9UTCwZDwW4+cvHRGFQjO6ILmgoLDUtQSn0QQjO0npjXPWfH10hM8lgauw4SkqMsis7jxvTgwSlmo2rbGsjAs0ZzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PWMW/LwH; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWMW/LwH"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2055573c8cso363862566b.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 00:48:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786434489; cv=none;
        d=google.com; s=arc-20260327;
        b=X1YxMK04PJcXy1CbIkPnwwOcAY4cXjwBQErEaqlHzrYiZyCL1IRCH3bRBV6zlEoTaV
         dDctgqy5o38gL7ROmwUARuaJcrD+JoCU5HvURY8k1wVMkRWepw4/pOl6ge4lF5T0AgbF
         lsg1qIyuHAsfcPq1GdD6/hJMUkwwCVRKQ0jTSkP6U4klYVN74HFHi5NowE0j2Fw6tPUB
         cypeI1xxyM0OFHvlH7/7tZYUqn34WAiE+RO7UZSKfi1HZPYacbZ6vCiHunZfRDoVg06o
         rkZL6PsiwZBzRehSu/cfmDVnwIQ066R5c3UtIYvwaTwRR1R/FBYvmazec5/6G0zqnvs0
         pYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=l16wahn0ql7OYFYjaBl0IVwR9JL5C379TOChm/i1hGQ=;
        fh=pjvBU1CZyw2RF1BBrVSylvh5tnZYppQGrNmYPR0V94g=;
        b=S5byPhcT6eA+rH+J0h8nJQtGWxSPUTWKPxQ1oFslReR9HdufGqFGqbYZQJOuph/1uX
         ogFYXOubmhqK48Ny71LDSM6OQEzVXSqjN3xJW1MEkHQcGHihrtcnNCWirqZq0CW4JYL3
         R15k8/qZruggxDNayS0VXEFpKnTrrxgyWXo1me0gwv8CF/iDEixdjpo55U6nyWaShgsJ
         QhPQbXjwN35WyDSF5KKy5+Gk0n/4KCVQ6CAW9me371DP3MCPr0hsXrR3VP01fGGANGkV
         saBhgwTGc3+zyAIIxbayvVIIlb6qLWylVk2bpaxCyhOFJX2PAO4dVAtEAuqNHvuftX82
         bwvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786434489; x=1787039289; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l16wahn0ql7OYFYjaBl0IVwR9JL5C379TOChm/i1hGQ=;
        b=PWMW/LwHpGkiph14GJnXLXi/LLWU//FhOOGhulkUKD140XUXp2cYg/EvBgzJDlWRzv
         AWR6UDyoQtMO5NtnvMEqv+f4o7EoWF7oNwD7LYR0PhjRkcK6djlat9L8in5FdvEJfyYl
         BRUM+06hCnDrc5nZZjPsRHEsfZvYxizhe5aLpjB1Yo4xTJKS8tWOel0qaMoVaG0BHBYu
         BstCUzUdnfdGVdcTWhEn7OCC9HS7WSJrJxTzlXVagbuT8G7QwYtyCuh0pmmQoWrqUUSo
         lNzaeBtZb4k3wMnAsMkXBIoTKx0isx7W/rok1tNWAFp7gJO2nQ7FrkVzekXW+G3rJhyH
         WqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786434489; x=1787039289;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=l16wahn0ql7OYFYjaBl0IVwR9JL5C379TOChm/i1hGQ=;
        b=J5LDFxfvPngBHSH1ozYRDFfRr1cB/WtLeLfROb2zh2S4LjRlsToFX3eYQ2BTK/CWaB
         J6yP0eNUOahgSaz2xhmPFUoUHGBUHW3vDu0j+74M0d/dfBZVrSbURRVCdavlpq0L2BX9
         mHGs01lqtyF51aC1mtswRc9FesxwWmIH1LyKnFxw5cirmba2d0TqrXldDIy+vi46UNBQ
         jjhEAnPqoTZn/Q7ocfbJqWyE02EwyQIpwrIyWv1gHA5FhrRjsMTF6oKBSB7sqb026EcA
         5SRu8GZoPV2Qkb3PoH7f4b42quuZexNE9SsurvI03onWKPc0d6l+FjO7YW/tN1dsK83n
         HLgQ==
X-Gm-Message-State: AOJu0YyRmkggSXbKeX1U3wx1y2+Rw7L7ZKUtGVHuU+9Bz8hINNbYljKI
	Hhv4qIfDb1UiS0gLGFd7gvR2u8tStwIubk6U669j0PqT2dXW+u1aBQYYE/wN1PD2eMkjxlSLt86
	G+eNhPkdP2Lg5e9EFYC5c+ZLzX9m9tak=
X-Gm-Gg: AR+sD13PHWESrra8tQtZ/EmvwRnq45SarCGG2EmqzYZJOZFDA0pGpcNpR+O4BZQu4dq
	1zNqwHSzStWI6XZtC0XOzs/WX5KcAJCu/ElmUC8hFM/BqmxMY1IiSRw5D9Mxv1MXkHWycgKsSc+
	hySjWk04gtkz6LPbCFeXhI5eUL4NRCQMe1N6q8RBIKSEav3k5EWOuqGF6ZqFijwFgh5kXG/kyZ+
	fypFIdtT6UOHM5ydNRx+eRoekPqG2581LAX56wfsezRoDQacqM1TAsOZs1Y9ZHJYMG2mkQ6MWXl
	Z6cNRYtiIlCQ9CuqFaTcXGFFbr1u83Z56/9I7BcWkLmh5uTXTwllYeQtkYkcoVyFD6W6JLkxZ4R
	GpPFzAPG+Dj4k5R3cnm+0PiTkW9SIQk4=
X-Received: by 2002:a17:906:f59b:b0:c1f:29ce:76a1 with SMTP id
 a640c23a62f3a-c20e621dcadmr65053866b.19.1786434488506; Tue, 11 Aug 2026
 00:48:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAecyrWNVtgywvchgHe1XLoGKcubEm_pgSQiv+i=6F4zdQhStQ@mail.gmail.com>
 <CANUX_P3v7Ecf_C=OUiLk-UZZFevLVTe_1uByEN4C6hLzox3Gaw@mail.gmail.com> <CAAecyrVhOjhETw5w6fTmnzOdTBJrJ9Qe1SDNTUv7B_59T-M6Jw@mail.gmail.com>
In-Reply-To: <CAAecyrVhOjhETw5w6fTmnzOdTBJrJ9Qe1SDNTUv7B_59T-M6Jw@mail.gmail.com>
From: Michael Blake <mgblake7@gmail.com>
Date: Tue, 11 Aug 2026 09:47:56 +0200
X-Gm-Features: AUfX_myDe3afFHRdXnBPPBYVst-1mt4HpFk3B60TQebfqKI4cdpcLiqMM_Gfjto
Message-ID: <CAAecyrUOc+PGFaL7uPMk-xkXstQh284Z2YUGoMmo+=HEWmya2Q@mail.gmail.com>
Subject: Re: iwlwifi: HE not negotiated on Wi-Fi 7 BE201 (iwlmld, kernel 7.0.9)
To: egrumbach@gmail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Emmanuel,

Just a mail to say thank you sir, closing the loop on this one, with good news.

After upgrading to kernel 7.1.7-arch1-1 and linux-firmware 20260622
(the card now loads firmware 102.07fca168.0 bz-b0-fm-c0-c102.ucode,
up from 101.6e695a70.0 c101 in the original report), the problem no
longer reproduces here:

- Zero cTDP_CONFIG_CMD firmware crashes across the last 10 boots
(2026-07-26 through 2026-08-11). It previously fired on roughly
40% of boots.
- HE now engages on every association. The current link runs
HE-MCS 11 HE-NSS 2 (tx 1200 Mbps) on an 80 MHz 5 GHz channel.
- Band 4 (6 GHz) is exposed in `iw phy phy0 info` in the ZA
regdomain on every boot, which also resolves the 6 GHz issue I
reported separately at
https://www.google.com/url?q=https://lore.kernel.org/linux-wireless/CAAecyrURg5npc%2BcoGw7nG58EMUoM2wu1rao0EGL3cV8CqcVA-g@mail.gmail.com/&source=gmail&ust=1786520475419000&sa=E

This matches the correlation from my previous mail: with the boot
crash gone, both downstream symptoms (no HE, no 6 GHz) went with it.
One root cause after all.

Since I no longer get crash boots, I can't capture the trace-cmd
data or file a meaningful bugzilla ticket. If it ever recurs I'll
capture the trace and file it as discussed. As far as I'm concerned
both of my reports are resolved on 7.1.7 + firmware c102.

Thank you again for all your help! Much appreciated.

Kernel: 7.1.7-arch1-1
Firmware: 102.07fca168.0 bz-b0-fm-c0-c102.ucode op_mode iwlmld
linux-firmware: 20260622-1

--
Michael Blake
mgblake7@gmail.com


On Sun, 24 May 2026 at 08:50, Michael Blake <mgblake7@gmail.com> wrote:
>
> Hi Emmanuel,
>
> Thanks for the quick response.
>
> Before answering, one new observation that may unify the two issues
> you split into separate bugs: I have data across several boots
> suggesting the cTDP_CONFIG_CMD firmware crash, HE non-engagement, and
> the 6 GHz band invisibility (which I separately reported at
> https://lore.kernel.org/linux-wireless/CAAecyrURg5npc+coGw7nG58EMUoM2wu1rao0EGL3cV8CqcVA-g@mail.gmail.com/)
> all appear to be the same single problem.
>
> Across the last 5 boots on this BE201:
>
>   Boot       | cTDP crash | HE on assoc | 6 GHz Band exposed
>   -----------+------------+-------------+-------------------
>   today A    | no         | yes         | yes
>   today B    | no         | yes         | yes
>   yesterday  | no         | (untested)  | (untested)
>   yesterday  | YES        | no (VHT/HT) | no (only Band 2)
>   yesterday  | YES        | no (HT)     | no
>
> When the firmware boots clean (~60% of boots), HE engages on
> association and Band 4 (6 GHz) appears in `iw phy phy0 info`. When
> the cTDP crash fires (~40% of boots) the driver recovers enough to
> associate but HE is never negotiated and 6 GHz channels are not
> exposed to userspace.
>
> So there is most likely one root cause -- the post-crash recovery
> state -- not three independent bugs. Let me know whether you'd still
> prefer separate bugzilla entries (firmware crash and HE non-assoc) or
> a single one that frames them together. Happy to file either way.
>
> > Can you attach the full message?
> > Or even better, open a bug on bugzilla.kernel.org.
> > Pick the drivers network wireless intel as the componen.
>
> Full dmesg from boot 2026-05-23 16:21 (a crash boot) is attached as
> `firmware-crash-dmesg-2026-05-23-boot-3.log` (212 lines). I will also
> file this on bugzilla.kernel.org under
> drivers / network-wireless / intel and link the bug here once it's
> filed.
>
> > > Is HE expected to engage on BE201 with the current iwlmld driver?
> > > Happy to capture more detailed logs (mac80211 trace, iwlwifi debug
> > > masks, association IE dumps) or test patches if useful.
> >
> > That would be another bug.
> > You can run
> > trace-cmd record -T -e iwlwifi -e iwlwifi_dbg -e mac80211 -e cfg80211
> > and provide the trace.dat file it'll create.
>
> Will do. trace-cmd isn't installed yet on this machine -- I'll
> install it and capture trace.dat the next time the firmware crashes
> (can't easily reproduce HE non-engagement on a clean boot since HE
> engages by default there). Given the ~40% crash rate, a few reboots
> after install should produce a captured trace.
>
> Kernel/firmware unchanged from the original report:
>   Kernel:          7.0.9-arch1-1
>   Firmware:        101.6e695a70.0 bz-b0-fm-c0-c101.ucode op_mode iwlmld
>   linux-firmware:  20260410
>
> Thanks,
> --
> Michael Blake
> mgblake7@gmail.com
