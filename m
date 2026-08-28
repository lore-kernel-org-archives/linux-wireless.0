Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD63442FD1
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 11:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787917594; cv=pass; b=drEVaZ7+CHtTh1IaSmNg5s8I208kqccRmuaLy1AshGcHyXr+gsAJz3X3KWTHG6Vbr7ZGa+iRDsjO9E9EDNDYKtQU7jRncss45HCM69sgFBEdSk4XrtsmCbwGLmIH8z3OG60m2YCcatSrKkN7RuLek2uglXASglA7lOxxeJElXuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787917594; c=relaxed/simple;
	bh=czq0iY86tE9vmk1UpEtdE66iRV2mN8LTKlZ3L7FI82A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cPt67W2YW8gexqtpyCzCvZAbezxyr8UE+LoRYGqPdiLtyWWGpRfOfQ5aaedupKdKwoQ8zt68uNzGddVtH5m+1KesvB0H5Cw7pbSXgfBAMA+WRwAPjRZXEqoYQOBF4bhsg7JiOMd9B2ZM6xOxJsJ2cfnd6ZEGYOPVZ7vvSUnqaTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cUJ2nVeq; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cUJ2nVeq"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69c600f76ccso1194051a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 04:46:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787917578; cv=none;
        d=google.com; s=arc-20260327;
        b=ENaAqiJYnNAGC6+RcfD6MW3x61PepGH2YONIVCED0RVNt8s9IXEwHpeRCfxWWiKEAo
         Vxy3pxMDIP7phwGZFIBj8bQ2qudTEs+DymfzmxbKM1iaHkDBcz7qNg5FE6sii0WH6dXl
         8HGa04yOfHrFXcY1b4Lu9Lm/wIofegsNfmasQRPZWh21TuqA3umnj7Hj//hYYBdnGvQr
         72aFEez6pEHXwfgclnZNsBEIs17Xmut5HCHoV4zVbIDuq21QixK6w4zeA8dW6B+mjnp5
         ws/gRl3Ucy8wdpTBpRtW7ORABmt1AttqosZZdfmX3SDz+98MAdGJITAKWiLGqk/fnprI
         2U5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/J9olIsIhTk7fKZiLNVC6UMyj9uo0DyblzLYos7atQA=;
        fh=3cxnlwf33Fs/QMqI974j15Wk5rhoofLNUqgVWEiKnbg=;
        b=NUlw8YwEdfgvbye/D+RfMGlTdaNK4Pxa76D2qulayTbYIOhMLt7/hzFbIm8UFJ0nCw
         X2SU/VgDK+6z3SlvB6bFTw3rxghf+nt5CZIcCdqvy9jxofN0qsTy1anualREA7Ck76uf
         QbK1FEeJfmQOIB8lR45t1FYaC7EoH9Xuf/12k22jT1buoP9Rx1wx6Y4+KQJaBtEMeBii
         D6Ec+h6Y6vdhIHMig83j8XoF6XdMNV+mi0PnHF3ovGo3mg+69GrvbjYg1ChmFVmkKC2S
         MKTMfZVkzLEBEl9YWdt7nhuim5RVYRL4TmaGtPy8OfJ+zg775X3teBRKYDfJX5qd5E/i
         K0Jg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787917578; x=1788522378; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/J9olIsIhTk7fKZiLNVC6UMyj9uo0DyblzLYos7atQA=;
        b=cUJ2nVeqOcVpyJMcBKkrcCAu4kWacl5pXWrTo58eMVvXrcGGDDYIdvSHWRta51RLtM
         M6ktSWZjpRFDORxChRQqb+R3/20PlGhKfsacV4UoLfu61+j28g2tWUYEw+qeIxHOX1XZ
         ZD0r9E/0BZJPykXfnznoojyDJPyWId0PnMakDUf+kNUkXA64sFcfV+wgNs4Y7umFLJU2
         F7fnIdSpZ0tCKiWdsOLOmFaGRfrt/QECWGb74PTEMFCb/wDumE7gQvjupcX62Y5ZA8+E
         0xn6HgFoITRKr0P5Q8oC2hXbhi4FkEZPXvNkbzejxeFt8bufKi2gUKNY+PFs+puX6tWm
         npqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787917578; x=1788522378;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/J9olIsIhTk7fKZiLNVC6UMyj9uo0DyblzLYos7atQA=;
        b=cH/KHit0lRycMHwWnOZXL6YxOPadpBpppZqX1dY/oSY/tistoRzVRZTbJXepw7ZLvW
         +ZIU1uM177/7+LNUkwS0jdhr34oNsSBgqoZ818OpbRDYdD/L53gifJlS6yoTq22ceca0
         rW+xuIxR2b8R5nZQbg6u/tc8MM+Dq+UGBLGcS/kQzOlveDa6mx208wazvm4s4IH2ka+c
         i+vqagNAH1xEkx5IhyJf41eSr3jvkMJ6pWvrzs1mamrtelismkftaDuO2ME6ipbiQm8A
         pcbTYOO2PW4j8Gof1LH8YqUXiq0wxqFjPpZw2IMsSzYNAyVV0ZZho/NCOw9fwZ5/uACc
         2rUw==
X-Gm-Message-State: AFuF++lngWj9xUpX58nFXqaLltIP96bKnFvxuJOejGoY+HJHWc8anAAo
	Be88WSOISpeezs/qc5BlVF31FB6ebgn/FadcReuQJLP6Xs0WaCDAhzwHG5ydmK5GsNdDM634aV+
	/o4iJfDrZZ0IFI+6EqwFDu7ICH50YOPU=
X-Gm-Gg: AR+sD11jFOebMR1thvtXpRTZldY/KkrAFmQ8w96P78mmeeHQsWDvEwgeeY68nxt2DX/
	9Nb83wlbWliD5B9c8TmovsaBw4HIAhItw1oNXEZceBoH9RjKnWnvdJpaztQ0lW9CqzSUfBEQncn
	q317/vhdR9q7H3vbQ7TKK7N8ay0pqCcwesbJUkowfnKAYzhQKGR4jjqDgaRSTRS3VXVAVNUPS35
	EbtnkDOhlZFXiPDhg0AELITdIMrtqIr1MPS92668EN+m2zhUEEZrdECFgjB/NxwIYLNjtLnMlOv
	lyTRHn+fqbMG8iNFC08V4p3TTjsQLc5xDeUVCJyFF0Z1mYLubNgEePHYHwJvcSiQ6GIDQCuRqAh
	6H1l1nua/NXjpA/q+adSreRbWcQ8kpL2U9UZfl0iom9lepnJQRFtf2iCtvOsDMYRgD85pHA0=
X-Received: by 2002:a05:6402:43c6:b0:6a1:4458:7f2d with SMTP id
 4fb4d7f45d1cf-6a60d35f215mr4409501a12.5.1787917578299; Fri, 28 Aug 2026
 04:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMSTZOnSYZjqj4AyBpLg2hQfRs6JYZA5H26MwQ+G2WMGgNzBkg@mail.gmail.com>
 <025FFEEC-E57A-4C74-BF1E-D273253F4D9A@gmail.com> <CAMSTZO=2dm21hYcKKeDGCTb4KJ6R0ukDAFBQtsp4QVzPmCfcSg@mail.gmail.com>
 <1EF6CC70-90BC-4B9F-9F96-9DB1F3A69F1E@gmail.com> <CAMSTZOkWe9C2pGS75zX=_H4_Up6B6qSddkUPeaU8=br0geh-xA@mail.gmail.com>
 <AC809A9E-A3B7-4DB4-A267-7A183F60CA72@gmail.com>
In-Reply-To: <AC809A9E-A3B7-4DB4-A267-7A183F60CA72@gmail.com>
From: Mark <markmunene827@gmail.com>
Date: Fri, 28 Aug 2026 14:46:06 +0300
X-Gm-Features: AcwNN1UmI5M8lOLcrjuqT5vvcILd_sSk1zBQiCz1dA9ktvI7z9mOXknkvedT__0
Message-ID: <CAMSTZO==h8Z+mDqF=bQOBOq=icRh8O0okDS9T2x-ovPwt0g7fg@mail.gmail.com>
Subject: Re: [BUG] iwlwifi: Comet Lake PCH CNVi AX201 (8086:06f0) fails with
 error -110 on warm reboot
To: Bohdan <boulderobscura@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bohdan,

I tried the PCI remove/rescan suggestion you mentioned:

echo 1 > /sys/bus/pci/devices/0000:00:14.3/remove
echo 1 > /sys/bus/pci/rescan

The device does come back at `00:14.3`, but the driver fails the exact
same way =E2=80=94 same `-110`, never even gets to loading firmware, no
wireless interface shows up afterward.

Here's the relevant bit from dmesg right after the rescan:

[174005.380038] iwlwifi 0000:00:14.3: Host monitor block 0x0 vector 0x6
[174005.380057] iwlwifi 0000:00:14.3:     value [iter 0]: 0x00000003
...
[174005.380178] iwlwifi 0000:00:14.3: Host monitor block 0x22 vector 0x0
[174005.380198] iwlwifi 0000:00:14.3:     value [iter 0]: 0x00000003
[174005.397491] iwlwifi 0000:00:14.3: probe with driver iwlwifi failed
with error -110


A few other details in case they help:

- Intel AMT: disabled in BIOS
- POST fastboot set to Thorough
- linux-firmware version: 20240318.git3b128b60-0ubuntu2.27
- Also tried it with the upstream rev 77 ucode dropped into
/lib/firmware/intel/iwlwifi/, same result
- Device is the Intel Comet Lake PCH CNVi WiFi, `8086:06f0`, using the
iwlwifi module

What stands out to me is that even a full PCI remove/rescan doesn't
bring it back; only an actual cold power cycle does. So whatever bad
state the CNVi ends up in, it's not something the PCI bus reset is
touching at all. That's starting to point more toward the platform's
own power/reset handling rather than the driver itself, though I
honestly can't tell yet if that's ACPI, the EC, or something internal
to the CNVi's own power state.

Best,
Mark
