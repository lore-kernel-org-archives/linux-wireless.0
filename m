Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776AB4F4743
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895823; cv=pass; b=joLBpLb9GEAqedCoggwngJR0X7X1VvSTTk2RQUTgCUi6poYPXFzUZMjHg66jvpQcHQyORshnoimTGriK/7zGr+XBLsq25M9ClKJOh9RUMfWhzjvy0lCY4VCZghX6uP76gZy1xaHvRX/UaUwCaGwMqIEcDDr2gM7XoyBKje3NlVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895823; c=relaxed/simple;
	bh=y10B+5McX5GFmcHXrzd/IPUq3EhrQHTcQsvRx7nvMcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FSreBrKKuHUpqCj8uKpD/mhmCVbIyGR7uE1DTrjEX04fqMsWnCrLF5aZRmod1jPVoCyEm8AQdKHS/Eht7B6Y3vjjfh3VhyOpx0J/mL2rW1UoKaE7x+6c498zgt4X85H0spjmHCUwytWbWkl1ZUdoIa4fTT6II+QxP4sQ/zK8Q5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=COPa1bxV; arc=pass smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COPa1bxV"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-81b54d0cb17so2266512a34.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 05:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791895821; cv=none;
        d=google.com; s=arc-20260327;
        b=hHOpBNVfcZbl1AdTiDQ4cJ/vSDy8RfoIhREKah6w1G2XJbhfFLFeHgYkjA1+Lr2vQz
         GNjyBXg3V2xm+Qmcqxj+DDIZLcyw+5XdC5BFF9G++mhyKHzRFoHZEHuxxsnK2HDKruER
         d3P69ehBkzvz8EYC44gkKPYtxVjQnYutvKQsFFquTjs0CxngnC+Mq5K1ewVM48CEDFTn
         x3/FJxwb+PM4ZwqJRkk1oZrKo3yy3FSAClsAdLjBtbhYF5/xiuOrLRReKe3aqw5k6H4l
         xSuUkzWjHCSjCh5tEaJEfOqYgEgwCLgYZ4qGegzycPBhtRT5S/6poFKf46VzjwvWjJgP
         FvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qPCIf3nqJm+mvruponLSllUxXEgyCZu14V4IgZlQmf4=;
        fh=f9hFQUVjbQq8USMzmbA7B+6DLDxgXYGTKGlXxISsNwQ=;
        b=MM/u6pGmnQY5HIChvOPv981CLeaW1SUKoxyZn9toc17uPnRUf6Wm7V+Z2viMI0s1yl
         AYNmi6OHG3sl38DBwwG2AQHMWTyLaWKtUD4bDfb2OAnFkZlvAhfYLQoiXZzvKwrUMyum
         23ZcVITxPk/+cDh1MArDcanY8jfrvve5EI9mJBpGuPBJ7ECxoF4kbe1J3nOzghc+/LU/
         RcOayB1gGCcqE2JfcYODAMC25gjAQ1fth9OiVDTevxdF9Rm2DPVdVqGKK0RTZaF+sD1g
         OIr6isyk8uN8+SlyzljpzllZB/VRb5cX6Znvx6f9IUP0Ikv47BC4/jexTD0ATGKg2jmm
         k2zQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791895821; x=1792500621; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPCIf3nqJm+mvruponLSllUxXEgyCZu14V4IgZlQmf4=;
        b=COPa1bxVDjjxD5Cx3VNptw3iCvHFxY7xkWm6HOUxvMvxKoKKD8TvWqmRIU6W6tR91W
         IrdcjnyNYXtsoQjX4nqoCQKbQ4YKGH9j5iNzIRtwIf39codNnPxBfEowkyWz6PfGSzrX
         NWitb5EcEA6Qza62vJR+7M5aWXUjYrOFHP9kEV4R0fYZTnCeBdW9+ATi81ANA2Ujf0kL
         tGr8KC+5+tQfSl2myNYVlKj6+MmGiHmfg1e7n8XHXVHtKHHOfvbQbKMx7k4SrnOCol0/
         fMwk9UJmCwjbGmrT7fx7k3cAcnGxDy3oOZuSOJb3d5DHR0+3hfZQ2xHw2M/ynY9gtHip
         Qsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791895821; x=1792500621;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qPCIf3nqJm+mvruponLSllUxXEgyCZu14V4IgZlQmf4=;
        b=BkdRkNWhs6hTU/Kanz9oI+shRFWmZt/OB6FThyOdS9YEhm+BtUUTE2CR4JyggV5HJD
         cWZ3hClAyZUrC4jR1ZPw6OE/SgpdGEdiX+WZEtCcvyDlVlPJsLUtWAl6wDZXQSqmYAN/
         7y37KbLagNwXoQ9WB5L1eFZiWyPam1HJisQiDQCkvJsM+a7dFAXUWoJfsTAzLl/VVe+Y
         qmbARi1HAHro63h9yoA+xOyDS9x9iq/v4xEmHpoNC3gpqoI6rsLZFkPv5YQmdOawiavS
         Wzj5noNVudF6Tf2pVnkE7YASHazvUFEarE5Xcw0wBB+WcNeXQuyVzuNcWPN1OL9gOwEd
         CHSQ==
X-Gm-Message-State: AFq9FYJp5Szzv32JfASfNioyI/uY2NNo+sINXhFDJzL7D6MF47gabFsr
	YhfC1/wMfMlUoVRY5OO+EYnCC1S350zHUGtFx++CbU3/v31251rV7wyoZXT7BdaQmaXOlLxo1qX
	ECYaobv3+bRvpYTubY1Ezlp1jKcHFVTvWo66+TXR+dA==
X-Gm-Gg: AYBFou1LTSOuCw5eIV2tEHXBQqd9RMeToUH6ihyzo4domyZT+xbrzBy6o1458yVO5jZ
	6Si1J8t9/lVDadaAtM694kA2O9AyDwmo/CTSXyu7+KfMWOaMfBNQezFI+VlUj2BSbCsT45r4DoL
	cYX4TPCdKRjiDT7CbYCdnsdPs+hj9WVGYd/RkcyMuUueD1oOZT4aESTBrSKUzJDtZT7k0KSkQRf
	VDNgP6vdw6hlnVG/9doisStOsZwx0WJ32ckQ66NrjVXekUlOpZDsh5gt3XILwl/uA/Z3EIPwu+S
	/VXya7+Tj8Y6ImcuUfFeXRYEAGUzOzZRmjXDJWs8sEfGqhkYmoML/AIUoRt5m2V9OPCnDF2jajA
	7yJFBcXgQq+L/7g==
X-Received: by 2002:a05:6808:1b97:b0:4f3:e98f:fa0b with SMTP id
 5614622812f47-50c556bc9d7mr12282169b6e.5.1791895821283; Tue, 13 Oct 2026
 05:50:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012133728.77780-1-hjf3108@gmail.com> <20261013102305.GA58849@wp.pl>
In-Reply-To: <20261013102305.GA58849@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Tue, 13 Oct 2026 20:49:44 +0800
X-Gm-Features: AclHuK8P-GSOHZTU-eaZSfu6_V1anWwiWDqTC8h6Cz6QgDTAn6y4yoPgEyKi0Nk
Message-ID: <CABOQOSU8KHVUrSc+qkCrpGK9zDBc3dNRqaRWKQ7ka=S6uLLbQA@mail.gmail.com>
Subject: Re: [RFC PATCH] wifi: rt2x00: use VCO_IC 0x2 for RF3053 on 2.4 GHz
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Oct 2026 at 18:23, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> Hi
>
> On Mon, Oct 12, 2026 at 09:37:27PM +0800, Ho Jie Feng wrote:
> > Using the 0x1, the VCO calibration result is 0x7f on channels 6
> > and below. Using 0x2 fixes it.
> >
> > Hardware: Netgear WNDA4100 (USB 0846:9013, RT3593 rev 0402, RF3053)
> >
> > Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> > ---
> > RFC for this since I am not sure if it is a generic fix, since the
> > vendor driver also doesn't use VCO_IC=0x2.
> > Is this also a known issue?
>
> Could you elaborate what is the issue and what you mean by
> "VCO calibration result is 0x7f" ?'
I had accidentally left the description out, sorry about that.

The adapter doesn't work on the lower channels in 2.4GHz,
channels 8 and below. This looked like an issue with
the PLL or something after debugging.

By tuning to channels 1-12 and using the debugfs to dump the
RFCSR registers, RFCSR4 is always 0x7f on the failing channels
consistently. Since there is code to switch RFCSR6 based on
channel, I tried the same as the 5GHz code to switch RFCSR6=0x2
for lower channels and it worked on all the channels surprisingly.

Due to the behaviour of RFCSR4, I think it is a VCO calibration
result since it seems to change after enabling the calibration.

I could not find any mention of this issue elsewhere, and suspect
either this hardware has very few Linux users or my hardware
is special in some way, so I can't guarantee that setting
it to 0x2 will work with another device even if it is the
same WNDA4100 model and chipset, so some testing would
be appreciated.

> Regards
> Stanislaw
>
> > Testing on different hardware would be appreciated.
> >
> >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > index 2e2e382b62475..4a44a0222210d 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -2979,7 +2979,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
> >
> >       rfcsr = rt2800_rfcsr_read(rt2x00dev, 6);
> >       if (rf->channel >= 1 && rf->channel <= 14)
> > -             rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
> > +             rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
> >       else if (rf->channel >= 36 && rf->channel <= 64)
> >               rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
> >       else if (rf->channel >= 100 && rf->channel <= 128)
> >
> > base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
> > --
> > 2.55.0
> >
