Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978FC426D37
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 21:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792101056; cv=pass; b=Zs10DeubCrpjZ/xPpjt4f8SHujZ9w+bsaFJa7UETMzV4+KqQE80hQ39PgAjV5fikfDp01k55Iqu04fSnNczfLJPhx/7HpTxA1xwm2+108eMBUsIgzOvV2XJvR/NMCQdAbjohis7TePR0j6pISE2xzgQq7bIJh6mGgHXqjLWD5iA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792101056; c=relaxed/simple;
	bh=LHqqK0s3MhegjL5dQ8ANXh55c6tzTb9R7AdWVmwpF9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lbSYDNp6/Oez/H32pD1GLAqFzXm49eawWEbw9iAeSt+v+ztA9f4w6yiDksUws4gresZJnHk7DvCwwoHTg1Cip3bfABYJcvbnm3+xaR9pt/o2JghQTh+fjAVbpiO5BGX9ZsZdfISLLt6PmyTjb27AlIJ2ZIFuH7zgAVX5eAai8Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QKhr8o7f; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKhr8o7f"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so7760371a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:50:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792101052; cv=none;
        d=google.com; s=arc-20260327;
        b=FjqtLoj9Y2GexH+gPUrm+3AmrKhWADuz+5A1neNJthBRTv+/hQgwbFwaGq6KeBn+6B
         XuiaeQJjC6mHajZgCdz1qbaPc/lY3pms5ma5Fz2dFSoXwArJiuD5T+ikOFbDSSbmMELU
         /iTS+lPfBmidaVJBvuMepn+Fh04jY5o7IK9bV8WMMJWCBmqh15ym3COD9OgvdSfoHaDc
         nLXpcRu9Jw0a2fkww6IcKtaev5/BmGroRA0sustXQHwPOSqQ+MvrxK51w6ww2ywJm2xi
         sRMPOkRuKM2oARg/EsuEWNw24Q0Hj0jDfDx1U/ozKtCS/8qmTEUEfnOAgNxJ4DwQMiGb
         tFwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z3l/JvkYfEQXOwbbGLlrfyh3SUMFiLYxwMbPJvYgs3E=;
        fh=kqlrRCXC94DXYouSVwwXsPgi5Hm584w0aixToaZZe88=;
        b=d+9oUKrQDsyrovj+1qQf7bcus15iVJFMKt/Gs4MV1M70CJ3Ciwbp4tsPQgjM/vlky/
         KwxRzVYS3EgI77KJU88nT1ET/joSXx9LDg5bfS98LOH0CjdC2QpIb+AbVLaofhg2ev3G
         clfcCAhA5lLW+50YiAy32HGkWVs/Yj1HwJKcNi/UokcOs+3JTr+2pHkMrORcVD/j+RGC
         68rNmohYqMFpVn2B6letlH+uU5O27c6fWm0LxqF6S9q0AgLyizuNeuhRwzC4z5iTKYMm
         +KEQ4WPPmRCYV0h6vWeHtVItaWytybsb41gbak25p1S+j78hIUMApAQ32OzGzCjkBzu+
         KEzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792101052; x=1792705852; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z3l/JvkYfEQXOwbbGLlrfyh3SUMFiLYxwMbPJvYgs3E=;
        b=QKhr8o7fQo6wYd5ci1beGIXQNsk8sdnVf6Vqv6wG5BmhXhKixt2nZGjC0H5tZ5Wi75
         IIz3mlAWF50foHK0lzwdsI0qkNVwm+v9Qqz0ajEelZSxEXhA5Hxgx48jbWGkmmai7/tU
         zlJ7pw2BRXNdhCz20FNc9NYRYql5jwqfbGCOamdGbH1mVYOD61LTPUgvv1y5xPYh0M7Z
         xmspDm3PdcN7FWr+ucN8A8/9KJ3chiBtySVC5fILgdncTflOOLiRg4wZCL99bz0qT+0b
         WJHPNPrBBnWSHIoOIp76qBDE3CaCPLTNdReUJAqJYvcmkxPI0g23lOqf8opYKZdLtY5u
         lTBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792101052; x=1792705852;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z3l/JvkYfEQXOwbbGLlrfyh3SUMFiLYxwMbPJvYgs3E=;
        b=EEjj5ugUP+AEVgCwSf19x1EdXI/2xktF+FO2+3cBU7vH7wd64+kAfbimfXa/S4r51o
         Qbb9pKdWgUEhbPdslZoYX/HyhyX4MUitXw/X2JSJkteoeGV3iwvyaDghT9RSfXPyHpQM
         NRjrFfwZGtkd/xwUaz0Jg79fBVW6V/TmPb70B22BHHm3/Le0dhfbTff0UKWzTo92BuXF
         6kWEdDw7mxyVWkpN749pn7emdMKkYrszvYw02rdkhlTdtdvxSnA0GEFpwScDwpiNcrl3
         3logR9vqZwGjGwsc5BRtqDeJjqXm+/TknPGF65KJnLw897D0PJwZcMHhk1rcqYV7ZOLk
         0gkQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5SDL/xt3ZkKu7stBeGmMBNC1agAHOdjuslVEWZx8Lc2KKogZbavtuPp/5eMb4oUA6H8NRxTWY4Ql/GXyDeg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLMkkotrRhs59s/JYNX2QvQLGRX/TG2p9AeWC6Oz1Y+fbuQq65C
	NGQniWs17GzcC8W+4XgzWcnpTY4RPNHqwxNHcKz/DB31LFGjtwwi7ZBNlKBATfcFtHT4Wcobx88
	c9D7j0KvGdSkV1nbeTreYELGRhnj6PKI=
X-Gm-Gg: AYBFou3bS2vrvLNDnXkkmVdV2RsA5hlgSX4QHezbuCfj2MzBOY1xpyXZJa+vaB/0A2u
	3JfAhjMJ6e3eI9u0McbknMsJSE3Vf4vej3WFhPgGVWD6noPk0mhlV1hdccKQY5N1msq91H+wfMS
	VdMUSOBNvLIUgWet4ch6m4ydhdP79zVF6oZA5vRKNJMtkjg++cUYKtHTZYnz5UTxBCPiJiymeZS
	k3y6IfxANFUYcbSgNTkTi4FDjFblPSIH1v44pXnquNpAbEhupSLMT9wuyWVnF7sEFzytpc37J4o
	LGx6QQ9OSRET9CK3kSJkW9Y0rxSgszcGGOf+F6vh78l/KQlDJbb8Exm3cSeTCdbVGVWAvh4ruPt
	7qYq9MWQw24WO8XzvDLDJBBYQoIQamCMv2W/WEA9cafnCU8IKmQcSqyKOYbL2JdhDw7E27dJitP
	jZx7N6fCZOQdhHEw8QcYtWKrTb+IlsTsNjRf44owep0J3z8MN060Z4vE/W6xLhNw03lMkq3iQMs
	v0C
X-Received: by 2002:a05:6402:46c4:b0:6b1:b16d:acaf with SMTP id
 4fb4d7f45d1cf-6b1b16dae69mr11532575a12.42.1792101051502; Thu, 15 Oct 2026
 14:50:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261015175928.3558057-1-rosenp@gmail.com> <20261015221110.000078b3@mythread.it>
In-Reply-To: <20261015221110.000078b3@mythread.it>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 15 Oct 2026 14:50:40 -0700
X-Gm-Features: AclHuK8liOXgbxfojrksuCyNWz7nnSVwi1wLqz12WnOn5wyiTfwv03gx2MILWks
Message-ID: <CAKxU2N_J0Rkj1k+EutCRZGui0YKMAxeq5KhOH94e8_x0apY1Ng@mail.gmail.com>
Subject: Re: [PATCH wireless] wifi: b43: back off the N-PHY TX power per rate
To: Alessio Ferri <alessio.ferri@mythread.it>
Cc: linux-kernel@vger.kernel.org, 
	"open list:B43 WIRELESS DRIVER" <linux-wireless@vger.kernel.org>, 
	"John W. Linville" <linville@tuxdriver.com>, 
	"open list:B43 WIRELESS DRIVER" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 1:11=E2=80=AFPM Alessio Ferri <alessio.ferri@mythre=
ad.it> wrote:
>
> Il giorno Thu, 15 Oct 2026 10:59:28 -0700
> Rosen Penev <rosenp@gmail.com> ha scritto:
>
> > On N-PHY rev 3+ the hardware TX power control aims at the highest
> > per-rate target, and an adjusted power table backs each rate group off
> > from it. b43 fills that table from nphy->tx_power_offset[], but never
> > sets the offsets, so they stay zero and every rate is sent at the
> > power allowed for CCK.
> >
> > The SPROM power offsets exist to avoid this: on boards with external
> > PAs, OFDM and MCS rates have to be sent a few dB lower than CCK to
> > keep the PA linear. Sent at full power, 16-QAM and 64-QAM frames are
> > too distorted to decode. On an ASUS RT-N16 (BCM4718, N-PHY rev 5,
> > radio 2056, ofdm2gpo 0x66666666) the router could only send at 6-18
> > Mbit/s and MCS 0-2, even at -50 dBm, and 24 Mbit/s and up or MCS 3 and
> > up delivered nothing.
> >
> > Set the offsets from the per-rate targets b43 already computes from
> > the SPROM, as brcmsmac does, before the table is built.
> >
> > With this, the RT-N16 sends at 54 Mbit/s, and at MCS 7 with HT
> > enabled, and TCP from the router to a client goes from 9 to 17-18
> > Mbit/s.
> >
> > Fixes: 8615eb2870f1 ("b43: N-PHY: support setting custom TX power")
> > Assisted-by: LLM
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  drivers/net/wireless/broadcom/b43/phy_n.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c
> > b/drivers/net/wireless/broadcom/b43/phy_n.c index
> > 22359bd9db47..c9b2b7496983 100644 ---
> > a/drivers/net/wireless/broadcom/b43/phy_n.c +++
> > b/drivers/net/wireless/broadcom/b43/phy_n.c @@ -5834,6 +5834,7 @@
> > static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct
> > b43_wldev *dev, struct ieee80211_channel *channel =3D
> > dev->wl->hw->conf.chandef.chan; struct b43_ppr *ppr =3D
> > &nphy->tx_pwr_max_ppr; u8 max; /* qdBm */
> > +     int i;
> >
> >       if (nphy->tx_pwr_last_recalc_freq =3D=3D channel->center_freq &&
> >           nphy->tx_pwr_last_recalc_limit =3D=3D phy->desired_txpower)
> > @@ -5868,6 +5869,16 @@ static enum b43_txpwr_result
> > b43_nphy_op_recalc_txpower(struct b43_wldev *dev, /* Make sure we
> > didn't go too low */ b43_ppr_apply_min(dev, ppr, INT_TO_Q52(8));
> >
> > +     /*
> > +      * The hardware power control aims at the highest per-rate
> > target.
> > +      * The adjusted power table backs other rates off from it,
> > so that
> > +      * e.g. 64-QAM isn't sent at the power allowed for CCK.
> > +      */
> > +     max =3D b43_ppr_get_max(dev, ppr);
> > +     memset(nphy->tx_power_offset, 0,
> > sizeof(nphy->tx_power_offset));
> > +     for (i =3D 0; i < B43_PPR_RATES_NUM; i++)
> > +             nphy->tx_power_offset[i] =3D max - ppr->__all_rates[i];
> > +
> >       /* Apply */
> >       b43_mac_suspend(dev);
> >       b43_nphy_tx_power_ctl_setup(dev);
>
> I'm not the maintainer, and i also have the same exact patch in my repo
> https://github.com/aleferri/b43-6362-wip/tree/main/patches/mainline, so
> i'm all for it, but isn't the ppr currently populated with 2Ghz sprom
> params for all bands?
This patch comes from work on an RT-N16, which is 2ghz only, hence why
5ghz is not touched. I submitted this since there's a Fixes: tag
that's appropriate here. The actual fixes I'll submit in the next
merge window. It's quite late in the cycle.

There's no maintainer here. It's an orphaned driver. I wanted to focus
on brcmsmac but that driver is really slow.
>
> Alessio
