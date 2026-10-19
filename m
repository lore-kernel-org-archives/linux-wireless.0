Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7F33E40FC
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 11:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792409741; cv=pass; b=myJzWnbIftdGh7iHY3wXUZ2RgJ7SFHRHJLmy1Pdf6iG8tCBcPLfYlp2dIbZixY86hlEJpIu35QTw2tOgM6kdh3KKZLi+aUIA7KjJNzGUNCBPsyqcl7N77itB39DHOPsw02LQ8Ki2DRJWyUmUiIpKq569CsfrZcFHgYOr5W23Nt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792409741; c=relaxed/simple;
	bh=y392TKxI9NxK+HxZju6721gEDX3uifjte7V1FDxyHUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ObBygXtNK6x9RKoaohZxWjML6l8FHFjnjK260P2B93KXFmcEQeitG/VnrHHPdJ5+df4Eudk8b3dygFuTAPTHkQvnn7mbJezjAANK+rC2SnfF3oew2KyuPyZTcmu+Bxjz0auznalsKhPkngvM84QYs5HT6ZSTO5y5J1+YI1ch7qA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bjnXzv+T; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjnXzv+T"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5bcb0f245e0so1369257e87.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 04:35:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792409738; cv=none;
        d=google.com; s=arc-20260327;
        b=pB9FMJRdakKpcnqRrnFkGR8S1Hj4Nx7yjtByLuGCBOmMmQvdRAknpU0aJ0009e8y0J
         ZOD3SxgawnvMGEwYiOwfS/CLrNg42C1tfQYuPBiySVSSxTNHAnpo9x/VfPat8UnEFfvx
         4WsTo4DUTGMLDbZ+c8cwDEbSmMzZHMVFHseZ07IX8DAaAe47DNhaU8r01UdYRpWA5KvC
         k1k+YErDlNMO5GBRPskB/l4jwOrxzQaZTtztw+ZxHz9P77g8HIlHxF04MqA3T6uPHrVY
         vfkPa+xQttClVF4kUs3Kh/62VPHGIP6rQIYyAYgOpnbZr7mu2PXUjx9+zObemFV4FAwZ
         JCXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=koS0XoT+3CWL8eMG9x4Bhcq/7nCXU3LWxtlSg2MxqiU=;
        fh=pbu7AQxHm2QnNupOorCJMBYbmVWixapILVZhxz3Ttx4=;
        b=OgH19hOXeWTKbnCIoWq+d+4IQLWQXXemyB6XGOQF//jNbjdkVpa8h5JPsS/Ixto6aD
         jxkgFyIFnnP6cxE0k/jzyXkzVHUnllgxlAph40ZvhnSoyU2vY7blZpJQT9hrFipL+xE2
         TXAUlpkbJ/Y6+XvnfFZhtbyH+WVVML/HCrlJNM17Xkp/UEyJ6CxPinRjNbEgrtSz6Ace
         OudocAmsAvNR7wqETK7Zj7YCR8vsvZgYwF5BjrdHGfeGjSF2QNedFtFUzFW8wJ2apT/B
         8vatAlhSiLc5+Eza2Q0NXkn5eG+/TW6WlfyWW1j3wkKw9bj80HxIQLuvYOmoP7rha4/3
         wOEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792409738; x=1793014538; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=koS0XoT+3CWL8eMG9x4Bhcq/7nCXU3LWxtlSg2MxqiU=;
        b=bjnXzv+TBUQuypXXr0s8Nh4syaUK6AQxcOxTbgcpzk7eY4BtTmAcds4PU7QzhjgPqT
         Oq5R+pnwdzNJZVd7xKhnflqX0RQkJXppWnZtyvfxYY91IEz3iYhH9BM8/Dxn+RhKEJnT
         E1f4AO4RVLsdQJotpERt8Md6niem22wiuEtBwnmVmvRFMmkDtTzELzSjB4TjOJ4KMeB+
         88yViLIXuTh+6wvB+ba97qNcppNg8zaojFswZ2cXu+gSZdpXBDYe51JjzdzOrQgSfpkQ
         gTt6mrC23J5SYBP8QEol9BHPA6JBaQWK4fxODLsfR5b8r6omutWNtP6Vdq+tPLWCZ3RC
         7Hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792409738; x=1793014538;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=koS0XoT+3CWL8eMG9x4Bhcq/7nCXU3LWxtlSg2MxqiU=;
        b=akNAXHcxe3+75Yt76S+CTF+WTTev54yDfPjgdv9om8eXYFsYQv9LgAE3jdcaNAN3Zi
         aaC+Ng0Z1hGCHUeUfQqXWR/r9sJz9/NNIuT9UwZh5Y2LuIZ2CMU5RxsSkHTgnRq/x5kb
         nxxKadT7kacsCAj6w+LdComZsPJ/2hixjC84057sZj8F2KK90ymbouT56yyJ1/PGB8Q5
         wuN5r9q3xKt8/AHo51YeumOOLiEnUMT07QBKz/eNQZlE4cXZVCYg79qxEgFupb1CnmSe
         sr5G8OAANyLMGP/hglMflXMr6iDcubsN7hi1Y3rupmZCOQNqTsZcJB1SmPhlI6VfzZIk
         c4tA==
X-Forwarded-Encrypted: i=1; AKwUvBzJ04amlSbVxL1rmwa0tTNKbKLJKz3i/SlC8TziX1R3/4I9LhLthgP87PEVyZdpmAgaOwNqJCw+RB2mUy2yvQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLcJHsg461G5LFl+ZkbEWuIEIqwHd0eY9l94Qu1KHAaP+SW9k+n
	W82TrjKAaLjtAZxg138p+Q2toy+t5NwS5X9d1pS4Myk83sJH10xXu/fXjYnWGVXvp7LnXRymHHu
	wRlRqgc/H0Yvv/kieoB+sXAYlcY4POCA=
X-Gm-Gg: AYBFou2XhucfPrDNexaAi2j554GhdLVZ/HW4LTg8x+r6Xl2jhOMt1Q6roF8hAvuVOn0
	aNWTqptmQEDUPMUJBLvS8NHj22ftjChEUVcXr6bgsNAlYPbe3SkUhdJDhag/I+FGlrp29yLXPPd
	HdDGs+Sjt+NhbKn+ZKEQTCJBQiFgDtvGx0U6Yyo9A7aq1Ej1NYBQIaBzWESirvJaI/NtQFOSmQL
	8pY1lYYZVgvBde2RdYf5wKMWnAkrvp7IjOKlw6lyTEAM9RksU9xMFzMR4UHzHkuejqsA6NIt0hS
	yX5GAO93J+v+Gp6z7Z/QXZqquobP2oRzzvwWmrncs56QVZ2mhYAoSu6OTAthpbFvZf6OK2iiGYB
	CN3KgZsh+2h4=
X-Received: by 2002:a05:6512:10c9:b0:5b8:f3b2:429b with SMTP id
 2adb3069b0e04-5be50a96f8amr2627956e87.52.1792409738088; Mon, 19 Oct 2026
 04:35:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012011707.3378-4-sigefriedhyy@gmail.com> <179185709988.434549.15422498299449004512@kernel.org>
 <CA+7S2v+LHUWXQMD-cYPEzT5-f3Qhw_vz+LEssQH_A_oqDKtnnA@mail.gmail.com> <8dcd9564-e9a3-4b00-93b8-3cb023d68047@redhat.com>
In-Reply-To: <8dcd9564-e9a3-4b00-93b8-3cb023d68047@redhat.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Mon, 19 Oct 2026 20:35:27 +0900
X-Gm-Features: AclHuK9hdAIJx_qrpjOoKdOt12iq2yhV7pVdW2_mKKi8adHB_hqpyRSgWNesDcc
Message-ID: <CA+7S2v+rWYvz9xKPEeM6=3HPz3o7TbX2uRfRKk95f9Y60HnEiA@mail.gmail.com>
Subject: Re: [PATCH net-next v11 3/6] net: add a generation counter for
 dev->mc changes
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev-bot+sashiko@kernel.org, ajay.kathat@microchip.com, 
	aleksandr.loktionov@intel.com, andrew+netdev@lunn.ch, 
	claudiu.beznea@tuxon.dev, davem@davemloft.net, dsahern@kernel.org, 
	donald.hunter@gmail.com, edumazet@google.com, idosch@nvidia.com, 
	jacob.e.keller@intel.com, kuba@kernel.org, johannes@sipsolutions.net, 
	kees@kernel.org, kory.maincent@bootlin.com, kuniyu@google.com, 
	nicolas.dichtel@6wind.com, nickgarlis@gmail.com, sd@queasysnail.net, 
	shuah@kernel.org, horms@kernel.org, sdf.kernel@gmail.com, 
	vadim.fedorenko@linux.dev, willemb@google.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 8:19=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> I agree this is not a blocker, but I think it would be nice if you could
> follow-up on this one.
>
> The solution proposed by the LLM LGTM.
>
> Same here.
>
> Also, still speaking of possible follow-up,  I think it would be nice if
> you could change the addr list lifecycle to RCU (no idea of how much
> complex would be that).
>

Thanks for the review. Since we're already at v12 I'd rather not respin
just for these, but I agree both are worth fixing, so I'll handle them as
follow ups.

The first one is a simple fix, so if v13 ends up being needed
for other reasons I'll fold it in there, otherwise I'll send it as a
separate patch.

The RCU conversion needs more thought and will probably
cause quite a bit of churn, so I'll try it if there's a v13, and if it
gets too messy. I'll post it separately later.

Thanks,
Yuyang
