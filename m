Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550133F8251
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787854001; cv=pass; b=JiaVHaoTQeD5RAKYtsbPkNuSLe12SIIDWli2ePnOwZ5R3cDjAX+rrA4bPZRQYyiZczUlR6TVNaMzuFqRtkLJpRixho/OCBQeHQIDjqiEdEqUnpo30J5jfmO5ZxPQoG8ISo7syZYCMptdFMRPxtwbc/bHdQiG/2r5Sq77Om9EcuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787854001; c=relaxed/simple;
	bh=LpHBYoHMdiPAajZy9sdCErHDZwuWgnrQOGAixrVAF4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pjc8j1N5mIPni43CpdsqdJFPF2otWjBq+7jMX408YL4e49+e0wrPK/QC16KNXoVx6vzvyUl6YN1BVqFJAtb0TsVLOECMEgD1N32efKhhy2BdWa2u32eWDYvnUZLTHn9N/BujhUCAYzy8oaFckCVzK+gj0ZmK1nQ805+YdVWqh9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLDVAU0V; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLDVAU0V"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so7781a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 11:06:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787853998; cv=none;
        d=google.com; s=arc-20260327;
        b=U/Z5KjydylU6fIQkiSlaK5NwV+sqnqP1GqECVkPmJzNGWUHvuGD0drOogln9PxIfF8
         JbJjpbEkbSjnqEVhqWs5hdOrOaO+pqaczapcuRB8DN3yHV2ITc5Fmil+CFf9WpiRDBRw
         ZOxmhTngJRN/je+VWCpiAd9yCNopS++37isj2I1PkOWzW4Aunxd0vJhu4WlrNi6n1s0L
         ue7rs8IR2iyCO+2lQ2TOfeW8eic4he9fDZRV031cF82C6UgPJymXtsqCBvcFJ5hCsGrH
         c7bT3nlrYWRbChGlmxhS6lOLeeOENdbOW4svOkTF4Vi7neB2X56Wv8FNEXJS+9wpS3qM
         wh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BaRKrIMZE6CzZHQFer6xDBywTcO73BRi8oQHQ8vhuLg=;
        fh=3cxnlwf33Fs/QMqI974j15Wk5rhoofLNUqgVWEiKnbg=;
        b=fTbgUxSgmEUcUg1m16SyjJJ+kN6FZpqT6sCRGssKZwwkdxaVHc0Jh7HO2qzKDvbVAM
         akmLVfgBs1K6v8RzYDriNLsA+9MmYn9i/wdZin9cnAMK5QN0LOsu7P1LwFoO20vE5Zfm
         qlEDJv5ydLeRoDOkAsqQ1bStOMvjDZTOvtc7Y3lXGBPiK6UQuyrgo5bPhAbgtKTenAYe
         M+fBhVcbKrl9ykit8aW3tWyRoX8OM67VJhaBjSg9p1weRf8Trv9he+hODDMsn35Q0ooF
         A8CrrvPcfiDXt/X5ackjvuE5qY6erULXnsNpHfY+Cri+IfyC7o1e0eCl1a+ipAM16A4/
         01jg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787853998; x=1788458798; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BaRKrIMZE6CzZHQFer6xDBywTcO73BRi8oQHQ8vhuLg=;
        b=FLDVAU0VKK4IrNhJa0iPCfdvmBhzRg9Noe1g5/K6dWDsmHblILi0+43TdVYSgVFoCD
         fdX2pInkAQV2rvtpiTGDMCl97OqX/NwMv+JmVj14BzktNYv5tqGVdDP8yJmL1aeVs5Ny
         OFXxHbfVWDIOcwT0RKah7OouVUVpVCKapl3b7ng1P0I0ZtsjKrsJih+TeRbqC3amYaFn
         kpoI2SQsZnsU5HK7TeEK20Hr2tkrcGJkkvRCMVXdq9M6LatTi2jDQ1cqTKfpQgvhnrX4
         a7Bz30ACJrSQFVuc9wfJIIEOErTfdeE+usZb385B7uaG3kXc1hJpaNJbqVlRui2+AKPY
         826g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787853998; x=1788458798;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BaRKrIMZE6CzZHQFer6xDBywTcO73BRi8oQHQ8vhuLg=;
        b=q49c0F8Jt3I+bdovgq+YWi4mqcgW9ga11Ham4sX5Rtp3Pr3vHZensMeSGR0zbeTvhu
         FvUGOHLRkjUHzAk1m/t2iCe3fbYc8BXTEa5GqsyH+FWDKku8hip6wSnMkP4zLc3FOnX9
         rJJ5hgMZjKFqaLwwS2cxLQCB7oZ6uMA0/otE9Mx9GE9xZVQ22hltQqPvfXdD9NGXYErd
         2FNfYx8gVQoda/eW8tLWGvrME0XatIlSIlY7NmhV5lL4CUjja2PY+PspwAQfCNirZzFz
         F+qXZF09vwg3STVyvfv7uSAE7ptb/ljjFNBzm9fDOSGmcbpalBWPsQavMZLZ0BpFknV8
         e01w==
X-Gm-Message-State: AFuF++l+Lg3Hgx+6RZ/TlrOSQ8Fop5FU4SkILw6KKT9GRlJoHHJlnXx9
	hFMXc0/FKrJGTpUbvKpAZ6e36LkSotNquPmKubEnl19IeRfgFPSe1kIwrTXIyaQqGMDBFPOhNgd
	AF/y3rVwRc8dGXCnPr27JIuBqNOUaREE=
X-Gm-Gg: AR+sD11pUqwdm4IIqq3I9ebSlqARKvbfB9OEqqcwvpFP2QP2dU//20Ojnsp4B6Mk9Gm
	LYm6wi/Cmaq14nVqW6Pr/4CTWPvbhQPvWrqfte1jNdVKc4FbKptqaPikqG97gRymJkgOzwobRl5
	TGBSLqyN31F6HTVGiNOKKXqz7J0lG2hWLMnpp9hYeCW5qSs5kSzml1nW0p3g24+U1N9E645Xl0R
	3spaNRmctLI4JbqT0oh1hnw5k7aDFiA6Blk8MAUI78b42H/5Iiy2IJ3SSguryI/e+tuZ1bwt6Ft
	Q5yVyKxAaWytZS30fVsk7mOQzMTFgmERE0DIKc4PujIvWs9r2KU3L+imV7dOdCjpW74qrsPBb9c
	nJ9EaHOQCmN5zLZoiV5kqG78EfPn9N4rOkasSGUCjjBW8rTJCcIyPC6OPAHZv
X-Received: by 2002:a05:6402:218a:b0:6a1:f95b:8cef with SMTP id
 4fb4d7f45d1cf-6a60d307486mr226383a12.4.1787853998162; Thu, 27 Aug 2026
 11:06:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMSTZOnSYZjqj4AyBpLg2hQfRs6JYZA5H26MwQ+G2WMGgNzBkg@mail.gmail.com>
 <025FFEEC-E57A-4C74-BF1E-D273253F4D9A@gmail.com> <CAMSTZO=2dm21hYcKKeDGCTb4KJ6R0ukDAFBQtsp4QVzPmCfcSg@mail.gmail.com>
 <1EF6CC70-90BC-4B9F-9F96-9DB1F3A69F1E@gmail.com>
In-Reply-To: <1EF6CC70-90BC-4B9F-9F96-9DB1F3A69F1E@gmail.com>
From: Mark <markmunene827@gmail.com>
Date: Thu, 27 Aug 2026 21:06:26 +0300
X-Gm-Features: AcwNN1WCDMEpxuTdD1sfPSRVH8kzJ5Pl7DkCB7LcSGYEaQVAh2cdk_LQ0bAeKYI
Message-ID: <CAMSTZOkWe9C2pGS75zX=_H4_Up6B6qSddkUPeaU8=br0geh-xA@mail.gmail.com>
Subject: Re: [BUG] iwlwifi: Comet Lake PCH CNVi AX201 (8086:06f0) fails with
 error -110 on warm reboot
To: Bohdan <boulderobscura@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bohdan,

I ran the test in a clean live environment running a modern upstream
kernel (pure open-source drivers, no NVIDIA or out-of-tree DKMS
modules).

The behavior reproduces identically on the clean live session:
1. Cold boot: AX201 initializes and detects networks.
2. Module reload (modprobe -r iwlwifi && modprobe iwlwifi): The driver
fails during the bus reset sequence and drops the device.

Kernel log from the clean live session:
[   72.114520] iwlwifi 0000:00:14.3: Host monitor block 0x0 vector 0x6
[   72.114522] iwlwifi 0000:00:14.3:      value [iter 0]: 0x00000003
...
[   72.114548] iwlwifi 0000:00:14.3: Host monitor block 0x22 vector 0x0
[   72.114566] iwlwifi 0000:00:14.3:      value [iter 0]: 0x00000003
[   72.119890] iwlwifi 0000:00:14.3: probe with driver iwlwifi failed
with error -110

This confirms the issue occurs directly in the upstream driver's
CSR_RESET and Host Monitor polling loop during PCIe/CNVi
re-initialization on this Comet Lake PCH platform (8086:06f0,
subsystem 8086:0074), independent of proprietary display drivers or
local distribution configurations.

Please let me know if any specific kernel debug flags or register
tracepoints would help you isolate the bus timing issue.

Best,
Mark


On Thu, 27 Aug 2026 at 20:47, Bohdan <boulderobscura@gmail.com> wrote:
>
> > Hi Bohdan and Boulder,
>
> Both are me, for some reason Thunderbird on Android decided to use "Bould=
er" which is Google account name. Hope this won't happen this time. Please =
bear with me while I debug identity settings.
>
> >I tried testing the mainline 7.1 build directly, but on this Precision 7=
550
> >the generic mainline image hits an early boot panic. It looks to be rela=
ted
> >to the out-of-tree proprietary GPU module and its initramfs hooks, so I
> >wasn't able to get a clean 7.1 boot on this installation.
>
> We still can debug this, but you'll have to blacklist the drivers that ma=
ke your system not boot (and lose the graphical interface in the meantime, =
or rely purely on integrated graphics during debugging if they are present)=
 and try iwlwifi through the command line. In the worst-case scenario, you =
will need a USB with Linux distro ISO on it, and a guide on how to use chro=
ot. Keep track of the changes you will have done, that way it will be easie=
r to restore the system.
>
> If you use NetworkManager for wireless (you likely do, most Linux distros=
 do), you can use nmtui to connect to Wi-Fi from there, which may be useful=
 for further testing.
>
> Hope it's not NVIDIA (it will surely be NVIDIA),
> Bohdan
