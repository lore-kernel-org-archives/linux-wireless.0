Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793666399;
	b=LN1P5e8DAqg7YWhvdtXQD7CwrazpYXrIC5mzRztgum36zLj6t5fhuB0XFCDHDraQo+wK
	 0i7/Vo2aZvoDIKk0DQTtfKK6x8ZE4R0PhUwamzSf8eymB8MzXDK3NyMvcH2qB71zcr4cr
	 +LXQCsRjvOC69NkIrFqa2COAsQXF9hZHW9lzy2C/gPfk3WMB/iNIg5G+ZhjJKeTlzmcEn
	 YXmS0tVUdSL8bp6Ds7MzRySJAhVp90LV6fO0SocXZhkBKMLYbk5rSJ2A4e1jwtxIo5JO+
	 lMCP25hQuaJ8y6EgcET4O178sWYpr6SgPGWMD5YGUkf2z2aa0bebLDinvZf137GDulg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793666399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=1OBly5kkIqHJs7IjxXNHGU8EGaenEAS+BQD4eQ1dDyA=;
	b=LFCFmBoX85TbU+m1vZpKqvOmvqfH8BqJ05NEHMJ2TiZ+wpCUub2yyWYxCegtn2IDVEyj
	 U93K5qWbsKzUGrNkj5uo70XrnBaHH+0kRurV6gyO5VPgSDVjqdY1ktlFgStGFo+otUgLD
	 8+arJS5/ZwYroJzrY73zi6Xrb0y1NujWhmeDRVNXEO9+CgjoFvZevCypXSRucwYnDfd2o
	 frqVlBIOqRPQnjWb881zLM3ZE6ofAKIVO0H2oR2UtmT5bGoFH8n5VxToiSEpuVUMSco0p
	 j1zcCfwCtX+/29+LZGpWFZhsvwWv5gOxiVkdJzwyWHOJtImUn4ZJMZc1Fp2Os+hPu4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YtZrvVey;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7154606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 00:39:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7154606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YtZrvVey
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c418e215671so473183066b.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 16:39:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793666397; cv=none;
        d=google.com; s=arc-20260327;
        b=FGmnY6C5dK6akRD5AFMVceck4Z9Vih7r5LHhAefS4YFvJmY/tuT4Qz0INdDa+wukik
         mmwbXFNnWkVwW0ZDXeW5OLjF+TY2toQL40POWN8vBJjd2Y3+fVAQ8IoHVB821yA6SmhF
         hmeTWgqgq2KsamnMOXmmPg7y1/THhhBwwO+QcYmqOolfHjNcX3/V+biVoHkq/ombVoWx
         4LrEIYRbNyh0OK7pbgEIDpL3mFOFLkNMWeH+2fPbRe5LfBEqXS4DMKvjmfYAuNt6XWNM
         OgnNiqWEluhea9so+V/BpthMZJ3pe13j0VmvXoTOtRIf8XgnPIWwLFp5b1p4Mj1++vx8
         Zwrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1OBly5kkIqHJs7IjxXNHGU8EGaenEAS+BQD4eQ1dDyA=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=Qo9xOjKoZ0lo1fYIsorQLI4YmWLiFLqeRuUpPq/WKwPjfMJ/bc9g8mBwW32O8j5zpc
         MQSEvdV5kmzz/83mT/i4CGKLIGrNoYH1rEXrYkyN2W1jC7X2gB91gvD5rA2dTj6/NRIf
         th4l8p6nXW/xcvDj6cK0cPjBgQMsaKN1dBk+rRIgJ1H3Cl2EcRlgdU9XONcvfuy4QaMI
         ItQ9MsOUI3T8GogrR10sFUUOiFQO2UJike/Mz58tki9jUypJd+zh+U1KEsei0HvftIuL
         4LcGPjUTUyQRb+jBBqasBOQXx5SONEJXhjtK+QHlWHn/pEBpuftA+hxgDBMFSv1RC46V
         I1Mw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793666397; x=1794271197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1OBly5kkIqHJs7IjxXNHGU8EGaenEAS+BQD4eQ1dDyA=;
        b=YtZrvVeylIdH8HuO9CIuVZZPaM8LV3+tGlq1SSMmFzeltnGGH+GbFHmHSpvGW1fg1b
         9Q2I15N1GpWPQiqUM+6dpJra14wyVbb9ucnoJnJhY0CSTA+h/UY6pnWN/YFQ2jDcq9AS
         PBR4/vSydv2IbMx0OCO2MvYkG/EKYjKjF/fYNfxa+Nd6s3/i7/JX+3090YcjI5wqFHNI
         R+xFvYHXjRn4ZoM9BvGfEBafiySOA8FErVcB42e4rOeXptbbv5SLVgCkTFzNUvj8v6/Z
         wZlq4avFVvG2jroxy4IDsDh7nU48MW8GlVq7Ng9CHa/zUlQhY4Mu9Z/KaP2tmkzFODw+
         m9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666397; x=1794271197;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1OBly5kkIqHJs7IjxXNHGU8EGaenEAS+BQD4eQ1dDyA=;
        b=0kOWrUelDb0vxyuj7OO41CsSB5Vse7RkSxd145+flw/iCXCBZQsI8rm0O5EgYORG7/
         +e3g8rYGVnhbc/aD3x2DZqXSG1OBzBexcMBNPPrbsMYFAwErfDMQzdUenlh47HsHW6QT
         mQGsjGiGH8K5jCgmdsHzzt1MVWFDE5EcCi7MVBheVH1D0juyUvmHtk6BAxlKmDJ1g+29
         25lyeSK4nB5go7pj/PR8U4PISdOmuzXur7IlOT6bh8Pu5H58J8PwhXek3aEIFki1lRuY
         THnwp4zXAr4sFSoLzdr9bc1lKWgfSHi3Jb96wQTT0WFnpt+4/wxYq6xm+imi5+JzaiLp
         9Unw==
X-Gm-Message-State: APuU4Z8PKv05Ktng4itPaCSkCQLXYKSWsK6db3UIpnYP7tVOMgL9ccEq
	CNCZaimkaWoNvQyXd4Q1KBeVXHd1RZ67u27GKISJgqPNp48zCeb+vgvQN78QKSuX6rJ4J/ANSSG
	QwueECRQ/qfxqimMHSXtcnyaDmslbtQpB9LX+
X-Gm-Gg: AYBFou1hsVbpsZKsmx+fLlIeWZuMzXSqalsSjDhWSiX+c6adBaO1ikxI7HSkmcqZ+tv
	RqDD+hFsrYXXjIC67d+NlMmKYnyw85CjO6BaexfY0Ic0dgIt3XS0VS9eRaiAGYop6p86xMMf8da
	VSfw54gS08dR8r3eNcwPT0HVOmL9CpTWnNIBlVt1nwI1fXEMO5VQeHhCNx8c2OOookO4QrRLpTC
	EMCTJIbQnndodzpEi4JPNAxf9F++d1qadBpxvadKwTHGHNuCiFbqKEOs+ui24OoGuXeBhpKLeM2
	rP7fiSy6Dny2bzQWMtP8zq5RUvbwfwpDA4nxIr8V97626JhBksx5K5riigGhNyrmyzVSjtwvpSZ
	5ZCxHGuNfNSLcqgRKZv12BMYOc1bcD+sFqTox5Q4WDUanS9SF4IT79dHJcPo7ONoX/Ww/uP7eS8
	vL8ompp6VAJdHDMpnlNx+b4LKAdX1SnLoJi6IJ1kpiIEKIhtqp
X-Received: by 2002:a17:906:558e:b0:c4c:b681:38b2 with SMTP id
 a640c23a62f3a-c4cb6813b3fmr471010066b.19.1793666396964; Mon, 02 Nov 2026
 16:39:56 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CADp4rm+GmTjCoFXvT8WpiLNohnREqfR9z78PfH1m2rxs00jMUQ@mail.gmail.com>
 <703ebc52e1d544e590874df041b4d979@realtek.com>
In-Reply-To: <703ebc52e1d544e590874df041b4d979@realtek.com>
From: Chris Vitalos <cvitalos@gmail.com>
Date: Mon, 2 Nov 2026 19:39:45 -0500
X-Gm-Features: AclHuK-szz3zhwEQa0X7JtKlrEiE5YRsQWBcvE5o6lPDE7gXO-gMv6oHSSfO22M
Message-ID: <CADp4rmKfnQCyu5RiEkjLWpb9w2bXKBbQdr+40bjVjsWmzyqCNg@mail.gmail.com>
Subject: Re: rtw89_8852bte (RTL8852BE-VT): recurring SER 0x1000/0x4000/0x1001/0x1002
 on fw 0.29.122.1/.2; question on rtw8852bt_fw-1.bin
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 1, 2026 at 8:50=E2=80=AFPM Ping-Ke Shih <pkshih@realtek.com> wr=
ote:
>
> Chris Vitalos <cvitalos@gmail.com> wrote:
> > Hello Ping-Ke, all,
> >
> > This is a follow-up to the July thread "[BUG] rtw89_8852bte: Recurring
> > firmware crashes (LBC watchdog / SER) on RTL8852BE-VT despite ASPM and
> > PS disabled". I see the same signature on a different laptop and
> > distro, and I have a question about the newer firmware format.
>
> I sent attached debug patch to the people who created the thread, but I h=
ave
> not received log.
>
> To collect more detail info, please apply attached patch and run test.
> When SER occurs, firmware will lock itself and driver dump a lot of
> info for debugging.
>
> Since we want to collect three logs at least, please reboot before collec=
ting
> 2nd and 3th logs.
>
> > Firmware tested
> > - 0.29.122.1 (2ac94d05), as shipped: SER burst at 2150 s uptime.
> > - 0.29.122.2 (42816c59), upstream linux-firmware, installed via
> > /lib/firmware/updates: two SER bursts on one boot, at 18:39:25 and
> > 19:44:31 local (boot was 17:39:31).
>
> It means no obvious difference from the two firmware, right?
>

The kernel logs look the same on both firmware versions: same SER
sequence and the same register values.  The difference I see is in
impact, and my sample is small.

On 0.29.122.1, when this happened, connectivity (DNS and ping) stayed
down until I restarted Wi-Fi from NetworkManager.

On 0.29.122.2, I have seen three bursts so far: one dropped my Firefox
browser VPN, one had no visible effect, and one happened
while I was not watching.  I have not needed to restart Wi-Fi after any
of them yet.  I will keep counting.

I will apply the debug patch and collect three logs with a reboot
between each, then test with power save off and with a different AP,
and report back.

I have been collecting post-burst connectivity snapshots (route,
neighbor state, ping, DNS)
and can provide them if you see value.

> >
> > Symptoms
> > Every burst has the same order: SER catches error 0x1000, "firmware
> > failed to ack for leaving ps mode", 0x4000, 0x1001, 0x1002, with many
> > "[ERR]fw PC =3D 0xb898..." and "0xb892..." lines in between. On the
> > 7.0.0-42 boot, disable_ps_mode is N and iw reports power save on
> > (defaults).
>
> Please turn off power save entirely by NetworkManager or iw command
>    iw wlan0 set power_save off
>
> > I have not yet tested the rtw89_pci
> > disable_clkreq/disable_aspm_l1/disable_aspm_l1ss options or
> > disable_ps_mode on this unit; I understand the July reporter saw
> > crashes with them set.
>
> It is worth to give it a try.
>
> >
> > Impact
> > - First event: connectivity (ping, DNS) failed until I restarted the
> > Wi-Fi interface.
> > - 18:39:25 event: Firefox browser VPN reported it could not reach its
> > servers; I did not need to restart Wi-Fi.
> > - wlo1 stayed associated: after the 17:56:52 resume association, the
> > kernel log shows no deauth/auth/assoc lines through either burst.
> > NetworkManager/wpa_supplicant logged only a DHCPv6 lease line at
> > 18:40:01 between 18:38 and 18:42.
> > - I do not have a measured outage duration.
>
> Can you try another AP to see if anything different?
>
> >
> > Question
> > Ubuntu's linux-firmware package ships both rtw8852bt_fw.bin and
> > rtw8852bt_fw-1.bin, but the 7.0 driver declares and loads only
> > rtw89/rtw8852bt_fw.bin (modinfo rtw89_8852bt shows a single firmware
> > entry). Which kernel adds support for the -1 format, and does that
> > firmware change the power-save-exit behavior behind SER 0x1000 with
> > "firmware failed to ack for leaving ps mode"? If it might help, I can
> > test a kernel that supports it.
>
> As I know, the main purpose of -1 format is the changes of BT-coexistence=
,
> so it might not help.
>
> Ping-Ke
>
>
