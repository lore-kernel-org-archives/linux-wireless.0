Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65557175A7F
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 08:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785919484; cv=pass; b=alUc2LgLlu/+cw9u/6KGEeIVIvOaAWqkQPI6V8jAIDhXYqMsHt3kQGygIag33a8lu61U0YkM1vSttALz6gO7btv83o7ctOs+Juv4DY50NiIV4sbyzrQ3Igg4bEgTxRrJpb4+b2SJDPpJTCq7pzxNLNrNRWhtU/puLz7xYNoA380=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785919484; c=relaxed/simple;
	bh=FnbA7S0cSZXFqeWKsgE7UzBvEHXkSW1qboecn7c9Eg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qwpGMqO+PZEXqgKaTnVwTIZ+mol5gEznN8OP8EvVUq5MMDJEZlfIRBeiDR8hURCVei21cFkKHIxTefvCjWXBiGpIfupGvp0pS/Xdnk+zfK9dIj4qDZFI3S6wCJDtnMHzAcj+qFWVP+eXAqrcvEH9PhIgzKhhQqnup2VowM6OgSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C92ZMnu4; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C92ZMnu4"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1671ec8692so110231866b.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 01:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785919482; cv=none;
        d=google.com; s=arc-20260327;
        b=fwDL1Df9KsQ4QPGYPw2sdWGw3efGievJeDxQnYXbhFDTaT63nU1hV3Qzk99l3KHb5F
         EXrxc2jai0evD84r7kLLgId80mNc73XtcWWgOCXBb4Uhm/wtjkEkPXlJnElsHqzQb953
         naXWnWtdMHt9GvfiYV8YZNrcRcYSUKGLnW5x8j7bApGvB7woa36s4jU9XPXaforTMCFE
         Rr8mN7svGeT3CdldR9O5MOpFltAsDDj8FUyxFxrdZqczbzj3LbYH0iOONpTKFszIBYik
         JxGTgSgo7iOmsqy5Fu3OUJzqQcdU4zY4YjajumUUr/H21LJ3JGttce4dkvW3fPqnMtRQ
         heXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nY5HP+b24Ht/fZnfSMRFxga4V+U+6O49PdW3sBxXF8A=;
        fh=IcLVWfcoahgv9Uad9xJPlujaYsPftqiBOe4T4a3v2g4=;
        b=AHCFxrURRqBr1qwojF5KplzYA2gEmYjOWiTZbXI4VY/0GuSSIKNW5YH+Xb/SfqRweM
         vwsBvPJHG0PdKieAh/aYif83hLxMF/V32w8mqZYyt/J2TmzOStmepawnlc6/RK2FzQtw
         bgbycfeVPsliLt7alS7GSbEqKR5pZyT55DVxKt/cS9+srwYU9kT69e56ToeJ6kCuzDd5
         eb7burQ+zA+y4MczfYGXRpda7QCV8E87bpgiwz1yed9jUunhKpxn29LJ/S5R6I+2t3qR
         M6y4obPr+LGmR8TC2MBCb2uP9asEgIAZCGHlemIKObwxXH5M5CmjwdKJvtR3Vw9UbBNO
         rM3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785919482; x=1786524282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nY5HP+b24Ht/fZnfSMRFxga4V+U+6O49PdW3sBxXF8A=;
        b=C92ZMnu4GLTcpX9MV58FPrpi1mfNiHciLCzixNbUmJjWmVxtL8SC5alDmpu8Cgha6K
         Mufhp0bv40RhlQj/iNF+ZHgnMZc9SAW0ANAxAZQV9fzi+YIo6Y8tmZAxXc0L28lcL5ze
         HUZJWXxjojcefpGT8RAA6XX0sBsQ3HGa29X5KJuEpI4cxoIs7d/dbMsiXfmldLLbq3T2
         AhASz7ssIf78egqygYhUsftsbZAKvfsC79txe1ZhJoW9i+ZJo6W296x2UV12SscaRCrb
         ZTYmLW7jihz1ipXbbySLsQpyZXvxc2eLpJG/hF7QRyCTPlAZw3/71xJmmO1VsunSquvm
         w5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785919482; x=1786524282;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nY5HP+b24Ht/fZnfSMRFxga4V+U+6O49PdW3sBxXF8A=;
        b=l5nXtZfCvOTsJd7Hvt7dvuFukrwspsarHwQat5JzR6FKH8j/Ah3FvF02xvNVxU1Gvz
         A+lHyNAYv55hipnZgPCtaBR603LGbukIKSEVo2YqZtCu3kgoI1VmrRt/LbdHQEH5EUhF
         FkHUwaQc6SYfEA/w6NOzpUJmBqS3TPubODfNzz8a4KLA/ytxp6BGPOCm0nO4XbFaklMU
         P34GdAqYAiCRjanxj1vm11Dz1AodKRULKSMGO8KsMU/Tx68tGUxTNAoeiKdBTtR0Lqtu
         Wx0V0JRFJI8n8UpnHYAMkmfadUGCtGbKhUCYfZ6BLOBelPYyG8v8d0lU+AV0iXt9Y92A
         R//A==
X-Forwarded-Encrypted: i=1; AHgh+RqdBgw0xvtr23LsAeT7XcSFBipFzRURq0UGP1C7xPT/04LCvqGYmFDYWtBlaMi5RCtOwHKXsR55+/Xp4JMAmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtQ161C/y2xigO7nd80rKT87wV7pydqvbQuKQi7ojFyXWpOGqo
	9beZ+k8hzV48GINt6OKncsBHWjGu0uk/KxIwbATyyyqDlu87K7RWYPXCKEF398Q906dq113PXOE
	CBeBG/EXuR36FsyS1uUDH1m8tpOofeY6ihO1M664=
X-Gm-Gg: AR+sD11d6VlKwngMtG1RukDUZzxc9ejwEhRouYUZcTQPVGxOAS6vV6oLSKxLSluRVz5
	rWc7BZz8DG25K3vm3b/Er5V1jdvUZA9C3GIigdNvGlMXXzclRdDvAkzEdNaIhYAvhcxqxQd8hwb
	rUl+QRxefhyndTmyVIDCyxE1NwyzxeklybYOLzT40QnmorpFmaM7fStCtGGHDmkv+QRyOsbQ+Os
	u97SPALsTU2/rqZCpPHADdtQgj8ZPfLh5s7CGl12CsLMOTYeRp46ytY8u7SUwKA4aOhDHz8k9+r
	c5C5WEElZNBbOUJGOJeajzjJXHRu3ALy51hpnM3P2ExV
X-Received: by 2002:a17:907:d20:b0:c1c:257e:4888 with SMTP id
 a640c23a62f3a-c2039cc4dc5mr243008466b.27.1785919481520; Wed, 05 Aug 2026
 01:44:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804095648.783881-1-colin.i.king@gmail.com>
In-Reply-To: <20260804095648.783881-1-colin.i.king@gmail.com>
From: chelsy ratnawat <chelsyratnawat2001@gmail.com>
Date: Wed, 5 Aug 2026 14:14:29 +0530
X-Gm-Features: AUfX_my8FnLz2qavlfVQxZGUIEY94pPYq-LfoiMpCy0Uf6vNS7_25jGLSjfwNUw
Message-ID: <CAOeBcHP0XGCt6bbBBhDeM8LbTOmf-7CzUXW07F5_J7OmPMjJxg@mail.gmail.com>
Subject: Re: [PATCH][next] wifi: mt76: Fix spelling mistake "dowload" -> "download"
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, linux-wireless@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, hlinux-mediatek@lists.infradead.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 3:29=E2=80=AFPM Colin Ian King <colin.i.king@gmail.c=
om> wrote:
>
> There is a spelling mistake in a dev_err message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---

LGTM
Reviewed-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

>  drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drive=
rs/net/wireless/mediatek/mt76/mt76_connac_mcu.c
> index 2f925d22b9aa..9552fadbc17b 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
> @@ -3130,7 +3130,7 @@ mt76_connac_mcu_send_phy_ram_firmware(struct mt76_d=
ev *dev,
>                 err =3D mt76_connac_mcu_init_download(dev, addr, len, mod=
e);
>                 if (err) {
>                         dev_err(dev->dev,
> -                               "The request to dowload PHY firmware fail=
ed.\n");
> +                               "The request to download PHY firmware fai=
led.\n");
>                         return err;
>                 }
>
> --
> 2.53.0
>
>
