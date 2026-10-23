Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792764610;
	b=h1lWZq5pkvqxiHWY+hLQSkB1ke7tb5VcNLIEj56604d22y8oRlajd12JOQ0mS9OAdaXd
	 ANZbKcdGuJFL9GBrvQozBggpkBZabY4fTHR9xKtSAEVGg8ZwTqr8F46K5dmWE2bQuYgSw
	 M+skGJVsiyxeU64ZGg7OEnaFgEZ9tu6369J/dWBfcLI0/Oeash74ui3FxHSS+3yOMbniy
	 5RrXlVLDbkbwFFvigvB+cXjGUDOgc8Xr33zf1AjHD8jM+iS5aYwdOjYezuijRUMCcCjAg
	 YNk9gt+aTHzKiL5bF8HZTdTOMxCrRe3F/VGEe59paJH/YDjCkTqxydf/alWOk2weJlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792764610;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=mQIMuGhmNTVLKWuN44aKl0Z9U6tRCw5m4IkDsvMuBMo=;
	b=yAhEdJmd8FaWoBi5gbAORWkW4ixo4lzoeOJvGemFgwNHqC34/d8rCFllzPoI6HUl/9RJ
	 fHtz9DPttAEu0W+JtMq6Gx1Xw/OAsbwSULPSP3TWZjFpAxdnzXu/lsFCa7HQCYJVmX92d
	 xSgfeO4NDzliHOmSW22or7XCTHVMmKEqnDGfs6Wlj9D/8aF23CLvgyl3FqX1hOLeVfbj5
	 2dOKoiLzOUNRsrlLRTScXFN0Th3yp0Ri8wppm9SAudVzrCo/BrbgKa3ZkKOi13cAhLt+e
	 QsKDXy2JIOW7PTgoHcVuBKTBOD2f2hL5b9ouP2ErgETQHNXKa8NExf4TMOLSG0CbJ5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TjHf5X04;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12C2606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D12C2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TjHf5X04
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3550c917fd3so1401913eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:10:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792764609; cv=none;
        d=google.com; s=arc-20260327;
        b=eT6OHthSxluICNy8L8YT9Lf+WiAmsvrYcZZ28RByluBXPp9RpO+axpBZ2rypZcYHGn
         q/yNlVNOcArAU8WBFYe2ULn/SnZqaMPZcyMjT5UocNhIvqaNU6au+3M2j/gBQH0g4X/g
         8VC2nRw/YU8KC67JGfDm79DGHjUlWFj2SQN2j/TdggbQ3TIjY0ZNikNojhmedE7ExvHo
         y0ztfL2esp+NjeR/bs6B+sPReyJB/5cTwvcYL1cWdvGNhNWYY0PeMom3Nwt0kxue7oa+
         5qoOWRYOXy5m/LnZ/SJ7TkjJzHLYJ4AagJTBQ2gDAc1XYyKbwoPsbK8l+/Mfjqc4ADCb
         IM9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mQIMuGhmNTVLKWuN44aKl0Z9U6tRCw5m4IkDsvMuBMo=;
        fh=eRDefTl1NMu9DwsARQCGxCbtoW7pnBRgtozJaak+MhE=;
        b=Gpu5CYWE97SLXlawWkWSdbP+cIZ+BOHmWAcnmm1AiU8cHkjb2jvNCHg+LPuX/G8che
         b/2adFGHQ3WhPmVRjTnRnUT9jD45+kduWXRvpsN9HpBKoI/HCFYBDGWDzOfloMBsjauM
         Kk2kUoMkdyI91Q8wSBMIdU+nZJkWsoLh/kuraDmTapaDMWfTGPu4lLvgV4x5D/fxI6r3
         UR/FRXAPJqUxlDF6uWWQ16OyhBZpWwAKHA1QpJeKAQex/DgSnRGo2ImvqUNOpxEiB3xD
         gOGHYCRumhlxVpdG8bnuksJeVp6xGq9fH5mVlY14+cQZ5bDhotbuQHBVbLVIgxWyf8wM
         UwiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792764609; x=1793369409; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mQIMuGhmNTVLKWuN44aKl0Z9U6tRCw5m4IkDsvMuBMo=;
        b=TjHf5X04L2XScE/02iID4Tw44gu1nLmMJJMUKD35SvFQH6J7UeqnYMZPDd0dLxs6a4
         jM/mQJ2TWzOxmVDDwvsgQ4STo1aoW+dB/3vMAI8IBaC/lulkbJq3Af+5DyYSfxsBmsL0
         egzS674wIncGJ0YKZ+krpSgqmS57e3qyMo110mDWCVfxoCoUvIA8GJ6DTrOcQ/FQthXx
         g8nHEhi6660KIwDIwbAh5YvUIYy1jIg9swAanOaix7a4wAjp5Kw3gcI2WU51id0p30DS
         SfW6NWC7FZCfixEyiF5mX3uk3RWoX8f2n1A/awf8WTXsObTMNi3ygCDGIrzGH6ioHwS6
         op8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792764609; x=1793369409;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mQIMuGhmNTVLKWuN44aKl0Z9U6tRCw5m4IkDsvMuBMo=;
        b=uncv0ximqe6lh1wyou3FCr6ExOTI84RoxMip6XPJv2jSLSacuVBVluPN9Is7YKrjYL
         67tyWiXjAGKhvGHoI8pFMg8POM3ZPngLeaRpnd3NgiI5+caRPfBWIm+C0QrzPrJ5qyxC
         Y8ArVH3XrogD+zrDwrPvwXqToH5Hdv+2a0nRrjjvHDD3HoA3BoPT9EGxUqwzSvwlBqe5
         oI/qCo3JBEN8ej9SXamwCmMMX0YkNN5Tc8waSqS7dw4IDMzJU2HCMJk1HX4J2W3WIEL7
         DZWxZJ6sKxrBCJLagFeOMSeTP9FqIQx7GTJPwMSwv5c/nt8Q6BSojmUJUlreTdRbpfU4
         GF1Q==
X-Gm-Message-State: AFq9FYITOrvKU7JvLmTPAk7d6BCRpgwwcqkHz99449SmPdDnQjl4g9cJ
	xlz6xRRkHKpGOrwhoRfCrwlBI7mss6vxXcoSL6a3Y9PtpNSvX0LER7QHbHbd8kA/Xq931GlLrxM
	Obu8DcI+BL5oPrGeCPqrN9bb5oNAoPUA=
X-Gm-Gg: AYBFou2O2vg59jcBUPhubQz9ZGLVxcsDRMXorPoMlqfY5oMRDxJXOAa8RD0TD371xB+
	xBG2z0dT/B7jZtajyiYwHISyowFbTcEa0fAJ1U47eJhrhP93SazkfTccEq2vakn8Ul48rX/JU4i
	+az/HL03FsfwlvdxH2otCuvq579nmpxcyttA3HTSjIbygB2Se2a7bR0NyfNK4VLuX4jxusOMwm2
	mHme5LNnbG1FC+LQyi+85Kv93L1xyGoHHLMiNf4HkA7CmwS+1EImkG11g61jVkqaedHWGLV0mCg
	chQMEDFoyXDr1YuvRRIuG6xa+J4RL6AS/5vZ2yNlVK9tExQz2pdBLmaDZnRkqobaB+iQ7sRnph5
	7TTC3EJdowNTL9Cmnh4DL5Cvn3EQeyi2eQMEIiLexxTaj4LvXi9hGSMMthLaAGntydBt7Iok=
X-Received: by 2002:a05:693c:2181:b0:353:7b46:4819 with SMTP id
 5a478bee46e88-369d97a9d9dmr3103935eec.8.1792764608764; Fri, 23 Oct 2026
 07:10:08 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023111730.481392-1-jtornosm@redhat.com>
In-Reply-To: <20261023111730.481392-1-jtornosm@redhat.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Fri, 23 Oct 2026 17:09:56 +0300
X-Gm-Features: AclHuK_XmTj2lE6CrOPoB66tC3YZhEmV1tTVAGJpc95D5nZpHETZ39vTNxwLqyM
Message-ID: <CANUX_P2oQDo6_A4w1e6a9_483aFy+iN07P=FyDJyeV6=xBUSYQ@mail.gmail.com>
Subject: Re: iwlwifi: AX210 firmware ADVANCED_SYSASSERT 0x2010120E on
 MAC_CONFIG_CMD with ty-a0-gf-a0-89
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: linux-wireless@vger.kernel.org, miri.korenblit@intel.com, 
	johannes@sipsolutions.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Fri, Oct 23, 2026 at 2:24=E2=80=AFPM Jose Ignacio Tornos Martinez
<jtornosm@redhat.com> wrote:
>
> Hi,
>

<snip>

>
> Last known working configuration:
> - Fedora 38, kernel 6.8.9-100.fc38.x86_64
> - Firmware: 86.fb5c9aeb.0 ty-a0-gf-a0-86.ucode
>

That's interesting.

> Problem description:
>
> The AX210 successfully loads firmware 89 and boots. Association with an
> AP completes normally. However, when NetworkManager assigns an IPv4
> address, the ieee80211_ifa_changed notifier triggers a MAC_CONFIG_CMD
> (action:2) update, and the firmware hits ADVANCED_SYSASSERT.
>
> The firmware crash also occurs during authentication in some connection
> attempts.
>
> AX211 with the same kernel and firmware API 89 works without any issues,
> which points to a bug specific to the ty-a0-gf-a0-89 firmware image.

ASSERT 120E points to some calibration issues. That can mean that the
antennas are not connected properly on anything of that nature.

>
> I have tried to set IWL_AX210_UCODE_API_MAX and IWL_AX210_UCODE_API_MIN t=
o
> 86 to test with the old firmware, but firmware 86 (used by Fedora 38) doe=
s
> not work with the new kernel (API incompatibility, expected), confirming
> the driver requires API 89 features.

Yes - we remove support for older firmware images to avoid code compexity.

<snip>

> [  229.212442] iwlwifi 0000:07:00.0: Microcode SW error detected. Restart=
ing 0x0.
> [  229.212507] iwlwifi 0000:07:00.0: Start IWL Error Log Dump:
> [  229.212508] iwlwifi 0000:07:00.0: Transport status: 0x0000004B, valid:=
 6
> [  229.212509] iwlwifi 0000:07:00.0: Loaded firmware version: 89.b20dcd1f=
.0 ty-a0-gf-a0-89.ucode
> [  229.212510] iwlwifi 0000:07:00.0: 0x00000071 | NMI_INTERRUPT_UMAC_FATA=
L
> [  229.212511] iwlwifi 0000:07:00.0: 0x004D0902 | interruptlink2
> [  229.212511] iwlwifi 0000:07:00.0: 0x0000C228 | data1
> [  229.212512] iwlwifi 0000:07:00.0: 0x00000010 | data2
> [  229.212513] iwlwifi 0000:07:00.0: 0x00000000 | data3
> [  229.212537] iwlwifi 0000:07:00.0: Start IWL Error Log Dump:
> [  229.212537] iwlwifi 0000:07:00.0: Transport status: 0x0000004B, valid:=
 7
> [  229.212538] iwlwifi 0000:07:00.0: 0x2010120E | ADVANCED_SYSASSERT
> [  229.212539] iwlwifi 0000:07:00.0: 0x00000000 | umac interruptlink2
> [  229.212539] iwlwifi 0000:07:00.0: 0x00000400 | umac data1
> [  229.212540] iwlwifi 0000:07:00.0: 0x00000004 | umac data2
> [  229.212541] iwlwifi 0000:07:00.0: 0x00000001 | umac data3
> [  229.212541] iwlwifi 0000:07:00.0: 0x00610517 | last host cmd

This is the interesting part.
Can you please file a ticket on bugzilla?
I'll ask you to provide a firmware dump and we'll try to see what we can do=
.
Checking the conenctors or any physical aspect of the device can be useful.

>
> After the first crash, the driver attempts HW restart. The restart
> itself also hits ADVANCED_SYSASSERT, leading to a reprobe.
>
> Please, is there any solution or could the ty-a0-gf-a0-89 firmware image
> be fixed?
>
> Thanks
>
> Best regards
> Jose Ignacio
>
>
