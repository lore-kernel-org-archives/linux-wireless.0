Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BF5382385
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 16:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476720; cv=pass; b=u4uHwrZphNu+5TpFjpShxO9+OlfCoDgL6qEau1zbBJ2a5Db9RPaAp5EAYWvdgjz0si2RuDtlLU38c8gSdSn+H3VBSqSZOYlp0/Hzyn5z0UAk7wnd9zMSp76kx6c8GXSCTx3va5QhbWZzYwREdt7wkmDdfJH3Utd96U8MBD+q7zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476720; c=relaxed/simple;
	bh=Py4a1BgSZRLssebWp1apnpYrvJt2ny1B6Tr7oqaHD/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XcNZ7DW7Xx/Js5KibKNjLJ/Y4bxaYRG4dwXTQwA0jp/pkyxWgQxGcHaHW7lvL1WCzqKekiqzu2pLVE4tOTJlVN/CDiUlrGVeAIOgfWDVczLUshDs8+VQ8VgrLqRml4YIMSE6qehVfhcy0hp+hM8k3pACuclj0KCh9E+9JZJRuoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HG83a/rA; arc=pass smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HG83a/rA"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-885cd98d226so478144b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 09:25:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791476719; cv=none;
        d=google.com; s=arc-20260327;
        b=oJ95DPqeFgirE1gBHJenARE0GJfL2ElLHKRg25tSPYCHHuXGtWPso3jvtcdvdp+hSi
         cl/J5ioE3Gcj10qw/PMfv0IXEF8AwLngMJaywz7vO3byPW/8A4kNYP95kG71Nbt6YObd
         xkvkhcX6syjzeGEuC77ly9Jk0NsdOX7ecWKMHFXkJP0oQ0Hf1SxE40g9DMQK74o6fgr4
         wafRrjqjpE92IPNvWk/Bq8pim8cEcKOHSQCuEgS/CYJlYt/F2K5F40FsG65PJWIylJwT
         9lM2c25/bF+kAziXbqOLh6dp5dZkJD6kqaIpW6162gI6WH9BmUeWYZuNe2m0Xh8ARiu4
         sy7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v3009lg5pcm5M+YbIWWDWH7usfrEFEQwTVOIUvlwAMU=;
        fh=qXrb97swvtxVVcD5kmLQSiSfbLAoEacAJp/ZvkPZvco=;
        b=of5PYNxerh0wxb/bZjQNsEYR1sFENw1XaP6Yj+2wg7ehP5G8EZW5hkBi49ewq9BsRD
         aOyVN+ZdTGJeMORzrdRS5uaYa4RUaulkOVJRwBWQ1Tn64sfxGlXvsbIadeY4m+EzI+Ap
         I/i15jEJbk802pf3psAZ2dydlfOnq9xu5W1h27N0pZJOPXQ9V+/5XibmwzEIv1Ka2eUc
         59sya4U1L+SaoXeFiWLdWAq5xlPb24Ms5kdIV0lltYLgXUgEwOuUQ0+CfloJ2GZd7zXF
         Iu6lRBfVCk3P7XajhveAHkeemgnAicHeufxzFwb8Itz4f0IZ45jwWSXTgDjLDJhv/3as
         j7Pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791476719; x=1792081519; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v3009lg5pcm5M+YbIWWDWH7usfrEFEQwTVOIUvlwAMU=;
        b=HG83a/rAzud6+78GDlEx278aKtJY57cbq8Uw6/5V4Ic1Y7pfygADYa6YJ1iPe32t5n
         YmJ7Ou4sDaQYyGfc634KMloiw7RDMSS30OQBQcS3PNiHDsuCTfLEhLJTWinnECXOwupR
         JcRx9et5iBr8GxOMmacus3Xkm8A7tC7eciHTtB5OszNsoiMnYTsJxAN5H25jzZ/SZOPf
         ycTm18+EAi9XSfjba5AgQ/wGZy8HnPbsyee3GY0CZS6K9tvJf2bydM779NBvHbw8bZs6
         8/ET/0q9GSR8Uqvrxpbdd+MXMZUPgt4okoTzGTAWJMp65IIUe3LIQQ5s5IgMNUrqy5Zv
         JnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791476719; x=1792081519;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v3009lg5pcm5M+YbIWWDWH7usfrEFEQwTVOIUvlwAMU=;
        b=NaX3Ek1MD6eyrM/fC60RGhYKX/hCAAhg6ISSBJ+FAbs1EycYxhh6dU6m5HW9fvY0wK
         KOGvyYKWSqAHLY6g95fwUvkKQ71GH6B3c6AjeCoBJh3tjCz6J4v862SvXfb2rOV2a9zr
         kaIkoF6E11e6n2bzQK6KpLtB7Hi1rEAJ7+epIDbPBYb94eYWqRis1hpF+j+eKqBozkW0
         7j67hDFlFBFH5sL5gAOfozvXA0jkEBAbYZXOqKVRO4imCy/gIpoRZr6J8jDG9VSR6uLK
         ZsoJDznjaWjJ5k+qlEhJ+s2TDVv+fCybEms4E5s9IaiRZVl9S0Tng4RQi2sL4VMwzkjA
         XDZA==
X-Gm-Message-State: AFuF++niVeU6A0MCUl6JRS96ne8iqdc8Us+1q6nHZoYlswCrK9ZsUtxp
	0uYKK6q/HUX3oBXD3JvAbaR/m9PevLyVfPOLUGlKkwQ7D+y2uQP84inwZdV2FIuOy71bBSQUusa
	h355ZoRT284mpGwbVGY+aTe3GKyNrmBE=
X-Gm-Gg: AYBFou0/Bp+hNrYFGjek4cEx0L2y5/CJG3VGdMrdjiv2PogRXlIOXWYMoHufh3rSvO5
	aVdkY8yd+tUtkCsNYCpinqUMCorfu3tTklq29g+/ECLyheym7z5/DbDZQ/pZxSAHJh3VPIM59Z3
	hy4uHQNqTvty+2geQi9q50dUyVfquBH0nAWfjvztoTk5XZwgTEHgdNJTufphuTdyoaOKuglATcG
	o1cVJ+vhl9j3s/fKweae9EK3SvE6Bp7sjQip6ni9oLE6JornMfj34++WcX9g79MBt9Ulii5/uON
	Utm1ztHUR3efXR2bNA4DjZFHup4AvFPvLKEWG8L+VCduaGGo95Rp2I2e
X-Received: by 2002:a05:6a00:170d:b0:878:3705:5723 with SMTP id
 d2e1a72fcca58-8930d7eb730mr2071924b3a.47.1791476714157; Thu, 08 Oct 2026
 09:25:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com>
 <CAHaeJsQ3FxvU1dQTSP751-Jq8JVv-tS8oRhNhuVy5-U4kPXwrA@mail.gmail.com>
 <CAHaeJsSM2kg6undbwaMUwcBbrA500CxMShU=VHv7w1B+YefHiA@mail.gmail.com> <20261008053636.81286-1-lucid_duck@justthetip.ca>
In-Reply-To: <20261008053636.81286-1-lucid_duck@justthetip.ca>
From: Chris <hoopyfrood42@gmail.com>
Date: Thu, 8 Oct 2026 12:25:00 -0400
X-Gm-Features: AclHuK921LrYizTaBBX3SgjlGhlS_3wHXqo7g9rY3iG00HYarZhs2dfHNXOLRL4
Message-ID: <CAHaeJsQTymsh1kv6Xv79im7ak+nqyMChoA40kRUhSy=O7i06Mg@mail.gmail.com>
Subject: Re: [BUG] wifi: mt76: mt7925u: survey busy time is 0xADBEEF per
 update, booked to a stale channel (monitor mode)
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 1:36=E2=80=AFAM Devin Wittmayer <lucid_duck@justthet=
ip.ca> wrote:
>
> > You clearly know this driver well, so I wanted to ask whether you
> > would be willing to look at it:
>
> Thanks for running v2. I took the busy half to an A9000 here.
>
> The firmware answers the MIB query at every offset from 0 to 255. Tx
> airtime is offset 28. Offset 29, which mt7996 reads for rx airtime,
> moves with receive traffic but at a small fraction of five others that
> agree with each other.
>
>                  uplink      downlink
>     offs 28   +16082143      +3708623
>     offs 29       +8749        +81107
>     offs 17    +2925971     +12992696
>     offs 20    +2852775     +12903656
>     offs 90    +2931365     +13006210
>     offs 92    +2751610     +12969276
>     offs 95    +2863941     +12908314
>
>     20 s at 836 Mbit/s up, then 20 s at 581 Mbit/s down
>
> Deren, Sean, Ryder, Shayne, if you have a moment, could you please say
> which of these carries receive airtime on mt7925? And if an MCU command
> enables the IPI histogram, I'd appreciate a pointer. Nothing in the 256
> offsets has that shape, and Chris's write to those registers wedged his
> chip.
>
> The same MIB registers work on an mt7921, so any fix has to be
> conditional on the chip.
>
> Devin


On Wed, Oct 8, 2026 at 1:36 AM Devin Wittmayer wrote:
> The same MIB registers work on an mt7921, so any fix has to be
> conditional on the chip.

Thanks for taking this to your A9000.

One data point on how I use the counter, in case it matters for the
fix: my A9000 runs in monitor mode with no association, hopping 98
channels across 2.4, 5 and 6 GHz with a 500 ms dwell, and polls the
survey every few seconds for each channel's active and busy time. So
what I need is busy time on whichever channel the radio is parked
on, with no traffic of its own.

When there's a patch, I'm happy to test it that way here (Ubuntu's
7.0.0-34 kernel with your v2 survey fix applied) and report, per
channel, whether busy stays within active time and follows the load.
On 2.4 and 5 GHz I can also compare it against a Wi-Spy DBx2
spectrum analyzer as an independent reference.

Chris
