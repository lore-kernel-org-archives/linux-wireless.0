Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C03A346FBC
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 10:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792233502; cv=pass; b=GDmDzT6uc9qdXVfluzglQZdWROIrBwchmiQMMgGy80STRmAAkNUZmlAfede9N3N31JYzcb6WJwfJKBCrddw2Tr9b4aF6Baz3q+BOzBoNAesDYD4IgayzVV1qXFlDTbOssaYG9tNGAewX4he7Q5fwUMK3ECK2tsNNknOFf4BkNU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792233502; c=relaxed/simple;
	bh=rUjDD6U/Vk2sVzndgzGKR20/1geXd0fQlZah3gocmXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMvaUqvqmE/yFJZRTCEDfSvnDT2nr0AQ8AGRos+W8SCjgoVasLo9TbhPBfZDbo+Wjc1gXnwe2PjbzgNdX1SdBDW7WadTDH5tixr77AJJc3WE4ErQ1/zjTI6dLyR1QexU0YHE08M27FsoL5iBXtss6Y2pxL5+/NFzFLxEXc05iJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=j5FIfqGu; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="j5FIfqGu"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6711f05fb14so558935d50.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 03:38:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792233498; cv=none;
        d=google.com; s=arc-20260327;
        b=f/1/pHqjvbEiaQgWb90uJYhjl+AmZcbNvsmsiAOCiT6KurugBGxu6mZJujo8CzziFv
         LhuBExUJiFBd02QuRbInXS4wKOcyftab8/apMAVUoIZ61qLD/JrmGCK99p9q8CVuvtf2
         j3vkh0fF4BBrra+EMCpU2QDNFP/RMzW1gGew7l955/AqDPWbmai6fGrL3JRYVhjQueGr
         QqIejdpVH4Q7Xt+TKempECR7XB2gjx9xaOixiWuWE1uLux5O3VDALnFtJYYwWV47+UlG
         YKS41YRAJEMNMUh68sbgver7b00/GI9mp7CHSsRUAxFCt4rWoW7I7+rKUVL2wLSllMmo
         ev4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=F5snhMS2ueW2Cl14d0N6Rs5a/KC8OfBoDlKdn0Y41pQ=;
        fh=JQUcbOIocNpOSJdYrtmOhrQz9dXHoGLpc3FxPsv84uo=;
        b=cWiDWrPYWhxSlth8Asil1Pfj036qa3qzdhEbmrvK8pnrmp9yZ5Pd+2cV4VpCvO9NxO
         3yM0Im/6CZ5lTBBDzW6rtTG6awrjZevEZpaVHn5xIftwqu5Fm2TdBcs8OWHTzKUCHQ62
         TSzBqqz+pHt5PFH3cX8gz/6jEMi8YV9HaKmuFgmooCaVQvvMp2RYllqPiT/UiIDVJk1v
         DM9+L4AY90pifxr8WQy2t5DotAQXOef8oQEkASLxqo0z5Q/ub8aNeCfO9NJyqeYiLJUK
         lp2H8tZTND/uxoITvvzT8c0p4x0QUebdDViuA5v/jbkyIjVeRHfHr3qnaBC+MTI43FdO
         1slg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792233498; x=1792838298; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F5snhMS2ueW2Cl14d0N6Rs5a/KC8OfBoDlKdn0Y41pQ=;
        b=j5FIfqGux3fWPogqh9AjX7mbsEajb8T3Hc9zBPl1s2yym7aHtAUq1iQb9AHiWggeCU
         F2QNt/qbXONFaIC+kFNWeGATOeYftLvZJn4VKyIKS1B9pKMnnFU3roPVajtluDBLSeKf
         /purfHugOIFBmK+Ii2pHRfCTZJNpKg60OB+QGnRv4PyuK7573FBLEEhPHmDdQYV277FV
         VrQE0xbsvgJkdGCBvl4NWNO5J/GeCzuZkfFqU55QiQQEFhrVtd1r/TJTCOsKBmO0E7y4
         62axBcQWHkTljhPY7MptIXDcEOEttFCRUbKBt2fU/rqtFfyR5kTSc1zaRLdPjG5ksN9x
         yhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792233498; x=1792838298;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=F5snhMS2ueW2Cl14d0N6Rs5a/KC8OfBoDlKdn0Y41pQ=;
        b=AS3BdzdxrpNyEULesXkKvqkJoVjiCiEypLkVr+9nHjzgtVv1DDoAYC0Yvr5VdDov50
         mDtGcUl3JdUvClielm2X+Fcezvb3Qo+AjwDr7+YNIPSfPYPqdLmXV6546g45qSLG9osr
         fq30BaXZBHpvMEY7r5VRFmmQLnRyJDJnFGZ5mAJi2YF7ZlHxXnptFWJje/ZAaMTh43KA
         v4RvoRPqj8+TRXCXRPwBul2v+0dlctXrbVqUVi2rYZAPe4SaVGrIcr9Ongkox9SyMjuO
         if3QdGQEtmethyikYRSSQx/wvfcHRmZ58M72/94kx3oBiDiNTxV7msXictCnvrWAWPIt
         hcZw==
X-Gm-Message-State: AFq9FYKyK35eMgYQcZZH6FU4wYp8jmfnOGNOexHhMTHwEUlqNGNW5c5u
	kZ28FAGNlZeKH1Qf6+N8/ubcLED2WewpblhkvxgHKE4HKaOQO9Z8/+te+5/YflUmIetOE8/Ea+3
	MEJ+P2vliv440jZ154jjQBd7puTwOUHz9Q9wntbtA
X-Gm-Gg: AYBFou3h+y27QXXTWlNZfMfm+h8uQcPoE6i002w3HdZuIqaOsxoB5u2URE9oCpQVgxw
	sy9sioHcNEz+tii4CuLsZL+axB1tsFV8nnX7jLYtp2hvEBLwgzX87NV1ldQgCJY8Wy+4Uft25x9
	tabOBuoQpIJ95hVt1igztxedHAn4J0c/AJt+IG4kXtf0xQ6wK63HM5a3RlL5wKV4ZhxcTcLBFrG
	0XpiYbrBV5X11oh+YQxbCb2ySpzFtRgpTTWsGXj8jhcpV2NzJMuG3BhHOrMSyOIpO+vp0DXHN7Y
	n9f0ju9bpnK0F/Bm8JlPs0Z6teBLHc+t3hzydxvZlk+NFBvMZaZPYkiSHxbARjJzTYWP2oJosRq
	+EYjL21zPAKEGmRM+jBoTW2WCkRvUJhs8X21zHjcV9AhLuTaRy6GLhd6XXuue3mudBDkeXCti/Y
	1leWL84O7A8FXXxDwgtaXSAFbdyYmTn8iMe+DiHiM3GjU+9qH5QOw88onhnZ3VFU7k9pyB60XDG
	FPQta9zwSFdC2mGsD4PO/qLHKdu+rUNttv+gnOscnKtMazJxSIg+D/Q6H85vfMli/5c+H1xWyiH
	JTvdqgLvd1WgcQ==
X-Received: by 2002:a53:b547:0:b0:679:aa23:4150 with SMTP id
 956f58d0204a3-679ca906735mr433421d50.107.1792233498275; Sat, 17 Oct 2026
 03:38:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910071838.1983652-1-julius@bairaktaris.de> <CAC1t37+f7+CJ+kBSe25g31fMWE65hme1m1gvB7ZZ_Ydvmce4vQ@mail.gmail.com>
In-Reply-To: <CAC1t37+f7+CJ+kBSe25g31fMWE65hme1m1gvB7ZZ_Ydvmce4vQ@mail.gmail.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sat, 17 Oct 2026 10:37:42 +0000
X-Gm-Features: AclHuK9YPhV95_cGbl4XOUUVArJb9QpR6dXPUyjfRBwMk0R7v_0JU9GGfaOaYu8
Message-ID: <CAC1t37KfVf18kbwDqHkVgSFMfAykqbh8th33362Sw07vTt9sMg@mail.gmail.com>
Subject: Re: [PATCH] wifi: ath11k: request firmware-2.bin directly
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Jeff,

gentle ping on this one. Would you also like the same change for
ath12k? I can send it as a separate patch.

Thanks,
Julius


Am Do., 10. Sept. 2026 um 07:25 Uhr schrieb Julius Bairaktaris
<julius@bairaktaris.de>:
>
> Hi,
>
> This doesn't change functionality, but log lines like
>
>     Could not find firmware /lib/firmware/ath11k/IPQ8074/hw2.0/firmware-2.bin
>
> confuse the average user.
>
> linux-firmware does not ship firmware-2.bin for IPQ5424. I don't have the
> hardware, so the fix would be unverified there. Would you like the same
> change for ath12k?
>
> Julius
>
> Am Do., 10. Sept. 2026 um 07:18 Uhr schrieb Julius Bairaktaris
> <julius@bairaktaris.de>:
> >
> > ath11k treats firmware-2.bin as optional and falls back to API 1 when
> > the file is not present. Request it with request_firmware_direct(),
> > which does not fall back to the userspace firmware helper.
> >
> > Closes: https://github.com/openwrt/openwrt/issues/24743
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> > ---
> >  drivers/net/wireless/ath/ath11k/fw.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath11k/fw.c b/drivers/net/wireless/ath/ath11k/fw.c
> > index ef1b4c81843a..88ec2ffd9f00 100644
> > --- a/drivers/net/wireless/ath/ath11k/fw.c
> > +++ b/drivers/net/wireless/ath/ath11k/fw.c
> > @@ -16,10 +16,12 @@ static int ath11k_fw_request_firmware_api_n(struct ath11k_base *ab,
> >         struct ath11k_fw_ie *hdr;
> >         const u8 *data;
> >         __le32 *timestamp;
> > +       char path[100];
> >
> > -       ab->fw.fw = ath11k_core_firmware_request(ab, name);
> > -       if (IS_ERR(ab->fw.fw)) {
> > -               ret = PTR_ERR(ab->fw.fw);
> > +       ath11k_core_create_firmware_path(ab, name, path, sizeof(path));
> > +
> > +       ret = request_firmware_direct(&ab->fw.fw, path, ab->dev);
> > +       if (ret) {
> >                 ath11k_dbg(ab, ATH11K_DBG_BOOT, "failed to load %s: %d\n", name, ret);
> >                 ab->fw.fw = NULL;
> >                 return ret;
> > --
> > 2.53.0
> >
