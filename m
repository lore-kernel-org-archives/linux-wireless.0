Received: from mail-yx2-f3.google.com (mail-yx2-f3.google.com [74.125.224.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267063DB622
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 09:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539566; cv=pass; b=ioIA559wW2w6LT60gbHoHWesHABbXbNlTAXh/JUCxJNBStuNSBjTTVvZcyQvmTLqRBvCqZzmXwn/WruxgXol8O0rT91hKKrTGxstdq8+iUQWhFrbBOxQvaj44LO6t0eHB8/oqRYyjvy4SYp+l10gYgYw9kyQlL+8BIp6S0seVfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539566; c=relaxed/simple;
	bh=T7SpG46De35LmcpDGTp1cn9NtPrirF+SxoA6obO7GKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D70ReB06yQowoBhZTma74iCZO7K/OugxBtNXNLo38APmDjstj/T/nRsFhiFJXDE9Vy0MB/o1eMCG8S20JuasmwIw8I+zjcTxvSk1EQ8yBdwhPXZcvCsYR3Rv2MOzy7qo15ondidtAFrnCjTPrNb57+Pbs1C0zvvVyiBNI6BkZIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ki5DtPJu; arc=pass smtp.client-ip=74.125.224.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ki5DtPJu"
Received: by mail-yx2-f3.google.com with SMTP id 956f58d0204a3-6664ce5db57so2080273d50.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 02:26:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784539559; cv=none;
        d=google.com; s=arc-20260327;
        b=rGhZSabafbZalx9si5JGAp8I7nwb/mzTKMoZ5TO+VTFDBYSO/gZsOc9rnOoVhwIahO
         wERa/0LDXpIUk9kalvDU/wASYbRVmNatqxp9aaxkYO086T9q8d59faMEN/o+NN0QRGiR
         zHFlnzHLhJD9yaokU7fAio0LnNm7Lvi1fkwkjFmYwzE4LvA+EX/r2mQBQ9m4Jyjkyk7t
         1tDWA+CCAFH48TNFj3GbKbC1euFcKREIKgotgon3mIMADhhQaDYO+neZcuA21pqQWRqj
         XwVLStU9WNZrjvo9RbFZJ0uYFKuPNSsDm9NjCxL/I+UwKHqxANTn3EV4rwmh/7FlNHFF
         2RfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lb3rvNERG6Trh6qQOAy5/wRaGSHQwfEXmqSq+iCr7LI=;
        fh=sFJBlFmUGDCKacwC5WBMmeWTX+GEX38fm396yGIPiBM=;
        b=cnNgEjaF5XinRZEsFi8qzOv2uM/b+MuGBGJkFKqFdtu6y7Qzj28SNL8VRrxObc5d4H
         5ooEbvrlxZsm6rP7+rfSv/WTMVsicyPg6DZ/hrmx6HhLU3TkhzJJj2tsZmu8f1u06YB5
         cuT7u4nB/8HoMhB9mZVWUmW0eIWhVs7cMBj+7rmSpIQ2ecTQPfQk8YoE1kQG/owFZAn+
         XMfAwYpmchWck0nHZ2Zi78VyPh73XcCO1IZxQ3PQqyae7Vw93P9TMraZsVKmNxcfz53n
         yQ5Kik8CbEn9WrUjVpMDVFQUGGLuOQ/9z88Qn52SLTwDAts036MO1JMt7+u12MSDGUMe
         j8cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784539559; x=1785144359; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lb3rvNERG6Trh6qQOAy5/wRaGSHQwfEXmqSq+iCr7LI=;
        b=Ki5DtPJud6hwi1kt2koUT900KQEMSHVb7yQ6SZBTNiN3rX8SddgHjqkjB419hYoiKE
         oJ18wVgE2gqpEPGM2agCkVS7vnEn8MF9Xuuzug8oqFQczxyb+CYyzgZkHKD4WdxJS3/r
         /YVNPMbC325h9ckhGqV75qkwt8AwxDaiKRex5F5dAdunUQ7cFV38SOBHwLrpRk0DJFBt
         vvX98AM9KsI1Wyx15dbE+VUlk1gLzb+muhcDgHr+AFVWTm/AtvaUm5bpliy8ANkee3ha
         bLMCpif1kGEEgV+/bcGP6FyEiBUTkJLambhk29m8CeF1soiBAwsc08ghPw1621NyvQxM
         Q0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539559; x=1785144359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lb3rvNERG6Trh6qQOAy5/wRaGSHQwfEXmqSq+iCr7LI=;
        b=V1XsOihrAs9P5ETdwVyrAHOTFmdfHUJBfkjMafgPpr7ZaGoYzCwuA1y3UmeiC8b1F9
         CkT/9GLddLAAmB9PXDPbAPRvw/LTO6/VxZmICEF2UG63ru2OvvpS1LJ0bjw6ZSES+jkd
         kBszGib1vf1MG6Fv3KsxNyvKNnConf79pTmcbd9JxsMum7memylxf9y1VltAq9X+UJrP
         Fs1LHp+es9qoF/4MtdBXe1eZS3c/qYAvCXDaJnsRqKW5H/T/Zh7eOmvW41R3UoF5Fzbp
         t7etla/JJsYfV5SBr4N3pZHhFu6eJK7gc9aFDXfDmOamvrZNlfcT3l1gdi4MB4PPF0hf
         S1uQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr6V+3GQWiBwQsxT71KNizyxrNVRjrd0lOms8Qwku01hlWJ1G4vSqy0rQ6wEcuAN24YdbN0aqVYVHlZKte5kw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh3Isw91AcdNemOPpttnRg+GZldryhevJYTMsqbXc71WJ9sedt
	hfLf0QzobXoOyZ6MZwfa79nKVe6aDe5GntGeRoq5FLvowfPfg4EOaKnQbBI0xo1iLBFLLb2htlR
	7LuoqTsBTRIBExcDXv1BRmdN+j58a/CgAEeLaTVY=
X-Gm-Gg: AR+sD11jCvIp8bXbkPwUVnYxpmlZ/7RRWPsHwYVxh4he7Qu2DHwDrPloJj1fuZl3Htu
	o1pO6OLZF1zs8D9IHa2SHT4O/w8ce11yJEg4peMtDl+c59noxrk4+v/FvtVsurRNY+7INyYE7Bf
	lUc5EToTbuLj8n89KCiu3glz16VkM9EYf/zHUDZT+ChMeDFsP7roGZcXlsPcXvb95Fi1QYIOgd/
	RiC1/G7uC1pIuAcYaHvGkUZIv9XZcmXwmf2VQqXQ0yhRa36YWI6zXo/6s4=
X-Received: by 2002:a05:690e:43cf:b0:667:8db3:f121 with SMTP id
 956f58d0204a3-6683ac68ccemr2490841d50.54.1784539558649; Mon, 20 Jul 2026
 02:25:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715065218.41232-1-gsh20040816@gmail.com> <5ca16013-e8a0-4403-a2b3-b3b43ea2bb2d@oss.qualcomm.com>
In-Reply-To: <5ca16013-e8a0-4403-a2b3-b3b43ea2bb2d@oss.qualcomm.com>
From: Shenghan Gao <gsh20040816@gmail.com>
Date: Mon, 20 Jul 2026 17:25:47 +0800
X-Gm-Features: AUfX_mz1h558I-KD1cpQBjn39rZY5EPNkCbsv8QW-re0Y30za8AwBWztM33ZCjM
Message-ID: <CAMVcGaDKC626A6=VC+10vtw3KVNm2NM_yPXTbgnA9Efd5eyL7A@mail.gmail.com>
Subject: Re: [PATCH ath-current] wifi: ath12k: fix frequency range for
 single-pdev devices
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, 
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The update sequence is as follows.

ath12k_regd_update() first resets ar->freq_range to zero. On the
tested WCN7850 under the CN regulatory domain, the 2 GHz branch
calculates a valid range, so the first call to
ath12k_mac_update_freq_range() sets ar->freq_range to 2402-2482 MHz.

The existing 5 GHz branch is skipped because ar->supports_6ghz is true.

When the new regulatory domain is built, reg_freq_6ghz.end_freq is
reset to zero. Since the CN regulatory event contains no 6 GHz rules,
it remains zero. The 6 GHz branch therefore calculates freq_high as
zero, and ath12k_mac_update_freq_range() returns without extending the
existing range.

Consequently, ar->freq_range remains 2402-2482 MHz, and the subsequent
channel-list update filters out all 5 GHz channels.

With this patch, the 5 GHz branch also runs for single-pdev devices and
merges the valid 5 GHz range, extending ar->freq_range to
2402-5835 MHz.

Baochen Qiang <baochen.qiang@oss.qualcomm.com> =E4=BA=8E2026=E5=B9=B47=E6=
=9C=8820=E6=97=A5=E5=91=A8=E4=B8=80 16:34=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 7/15/2026 2:52 PM, Shenghan Gao wrote:
> > Commit 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update=
")
> > made ath12k_regd_update() handle each supported band independently.
> > However, it uses WMI band capability values as indices into
> > pdev->cap.band[]. Those values are bit flags, while cap.band[] is index=
ed
> > by enum nl80211_band. As a result, the 2.4 GHz lookup reads the
> > 5 GHz entry, while the 5 GHz lookup reads the 60 GHz entry.
> >
> > Also, the 5 GHz range is skipped whenever the radio supports 6 GHz. Thi=
s
> > is valid when 5 and 6 GHz belong to separate pdevs, but not for single-=
pdev
> > devices such as WCN7850, where the same pdev covers both bands. After a
> > regulatory update, 5 GHz is therefore omitted from ar->freq_range and l=
ater
> > filtered out of the channel list sent to firmware.
> >
> > On the tested WCN7850, the 11d regulatory update left the frequency ran=
ge
> > at 2402-2482 MHz and sent 13 channels to firmware. A subsequent 5 GHz s=
can
>
> can you share more details on how the frequency range is updated to cover=
 only 2 GHz band ?
>
> > failed with WMI_SCAN_REASON_INTERNAL_FAILURE. With both ranges combined=
,
> > the range is 2402-5835 MHz and 26 channels are sent to firmware.
> >
> > Index cap.band[] with NL80211_BAND_* and update 5 GHz for single-pdev
> > devices even when 6 GHz is supported.
> >
> > Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0=
_SILICONZ_UPSTREAM-3
> >
> > Fixes: 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update=
")
> > Cc: stable@vger.kernel.org
> > Assisted-by: Codex:GPT-5.6 Sol
> > Signed-off-by: Shenghan Gao <gsh20040816@gmail.com>
> > ---
> > Testing notes:
> >
> > - Runtime testing was performed on WCN7850 under the CN regulatory doma=
in.
> > - 2.4 and 5 GHz scanning and 5 GHz association were verified.
> > - 6 GHz operation was not tested because it is unavailable under the CN
> >   regulatory domain.
> > - QCC2072 was not tested because the hardware was not available.
> >
> >  drivers/net/wireless/ath/ath12k/reg.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wirele=
ss/ath/ath12k/reg.c
> > index 89abf2e87ad1..c3bb1df2b1e2 100644
> > --- a/drivers/net/wireless/ath/ath12k/reg.c
> > +++ b/drivers/net/wireless/ath/ath12k/reg.c
> > @@ -300,7 +300,7 @@ int ath12k_regd_update(struct ath12k *ar, bool init=
)
> >
> >       if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
> >               if (ab->hw_params->single_pdev_only) {
> > -                     phy_id =3D ar->pdev->cap.band[WMI_HOST_WLAN_2GHZ_=
CAP].phy_id;
> > +                     phy_id =3D ar->pdev->cap.band[NL80211_BAND_2GHZ].=
phy_id;
> >                       reg_cap =3D &ab->hal_reg_cap[phy_id];
> >               }
> >
> > @@ -310,9 +310,10 @@ int ath12k_regd_update(struct ath12k *ar, bool ini=
t)
> >               ath12k_mac_update_freq_range(ar, freq_low, freq_high);
> >       }
> >
> > -     if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP && !ar->supports_6gh=
z) {
> > +     if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP &&
> > +         (!ar->supports_6ghz || ab->hw_params->single_pdev_only)) {
> >               if (ab->hw_params->single_pdev_only) {
> > -                     phy_id =3D ar->pdev->cap.band[WMI_HOST_WLAN_5GHZ_=
CAP].phy_id;
> > +                     phy_id =3D ar->pdev->cap.band[NL80211_BAND_5GHZ].=
phy_id;
> >                       reg_cap =3D &ab->hal_reg_cap[phy_id];
> >               }
> >
> >
> > base-commit: a1a21995c2e1cc2ca6b2226cfe4f5f018370182a
>
