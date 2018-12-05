Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1060C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 09:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BE82084C
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 09:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L+kEuI0x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95BE82084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbeLEJEe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:04:34 -0500
Received: from mail-yw1-f48.google.com ([209.85.161.48]:44414 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbeLEJEe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 04:04:34 -0500
Received: by mail-yw1-f48.google.com with SMTP id i22so7897501ywa.11
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2018 01:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6fHRLhb06z8zDmAEhigg1CP3Q7Ty+jxmQnoFaOHAnkA=;
        b=L+kEuI0xVpmwkKT48FTT4AyTlQ5Zb0gailV93dfLopizcaJDlC1ML/0dPbpXaSSXRG
         wLybirrzsJQ6mtJP+4Ye4jaRgWnBCmNQGhowvJCLCQTRvgrxVgk4stOhAFCYIh6yYirH
         rFIMo0wnBpy6EmShYujzZ/K1URSFq1FGEZ8uNsOVEiLFwObsiH/1MkfYMWCHM7nsOy/V
         g8CSL498DbWs43SfHFOLz3TW+iUcqe+eZfTPBA+47y/qKzYDXF5H+ZZVb/Q7s6cF8/bx
         227Wu4UMWMhAoZiti0rdgnfSrQ+wPJcRVF4aeszvnn5bPWL+8tM563bgjTcbYuwrq4UV
         eOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6fHRLhb06z8zDmAEhigg1CP3Q7Ty+jxmQnoFaOHAnkA=;
        b=Kjlrh4orLD4CW3irtX6QlCcv9P2WV0FsYZu6orI3Xvd7hN22oebrfBRl6bFeFB7fJr
         ZRoog1ra9/Ai1FSFNSQtKrLRvUxY08rrihBgwiYLKEYvMkSihtuzAW0PPkgYKsCNj2E9
         +TOFFPQp4TNgdVuxns1uPIgtjsjrPkC9XeE0DP6ClldgLY8VwMOYpPQA4Ek5qj3SXe4V
         7QO5c4Xz363mF5yVG8T3Ctu5fSOcPhrht24+EBH6lZLOUQT0djZA/CmcRM5NqNCDkJb9
         +8YELv9W16a6Li045YI9JnaHuc2X2z2P8qfjbhnxcMuM5p+EsCUjayHvJciT86jpo4o8
         IwBA==
X-Gm-Message-State: AA+aEWZFpTcvqUqrOm9BOlDcwfNlrwyJ82uTOwNcUxL+EzLL7TftH4T3
        e8j9qvSdpKdNkQIO7Nfs0WDHQaGzaKjFSj8dFjc=
X-Google-Smtp-Source: AFSGD/XlLd/s4aMi2r3yZrR1/gL0HawagkrEKE7pxG1XSb4CRF4b+jmQBXS6NayGyU0sOC0aqkCc35gEk6Sd8jFq3b4=
X-Received: by 2002:a81:98e:: with SMTP id 136mr23048396ywj.47.1544000673037;
 Wed, 05 Dec 2018 01:04:33 -0800 (PST)
MIME-Version: 1.0
References: <b65d2a36-4cf4-1536-fd0f-f3bcbaf000fc@nbd.name> <87sgzc4ecv.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87sgzc4ecv.fsf@kamboji.qca.qualcomm.com>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Wed, 5 Dec 2018 10:04:21 +0100
Message-ID: <CAA2SeN+1-4tfKX=uW8u5RbOc4UrtdPx3yG4suMM+0koEKGuWPw@mail.gmail.com>
Subject: Re: pull request: mt76 2018-11-30
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Felix Fietkau <nbd@nbd.name> writes:
>
> > here's my first pull request for 4.21
> >
> > - Felix
> >
> > The following changes since commit b72c51a58e6d63ef673ac96b8ab5bc98799c5f7b:
> >
> >   brcmfmac: Fix out of bounds memory access during fw load (2018-11-29 17:33:10 +0200)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-11-30
> >
> > for you to fetch changes up to e28487ea84a9c081c6d8d7da319427f7fcc32ff5:
> >
> >   mt76: replace sta_add/remove ops with common sta_state function (2018-11-30 12:30:37 +0100)
> >
> > ----------------------------------------------------------------
> > first batch of mt76 patches for 4.21
> >
> > * use the same firmware for mt76x2e and mt76x2u
> > * mt76x2 fixes
> > * mt76x0 fixes
> > * mt76x0e survey support
> > * more unification between mt76x2 and mt76x0
> > * mt76x0e AP mode support
> > * mt76x0e DFS support
> > * rework and fix tx status handling for mt76x0 and mt76x2
> >
> > ----------------------------------------------------------------
>
> I fast forwarded w-d-next to net-next and now there's a conflict. I did
> a test merge in the pending branch, please double check:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?h=pending&id=e69caab09bf98d0d8b559d06887364cc0090097c
>

ack

> This was the conflict:
>
> diff --cc drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> index 3f001bd6806c,b54a32397486..000000000000
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> @@@ -264,21 -173,6 +173,24 @@@ static int mt76x2_get_antenna(struct ie
>         return 0;
>   }
>
> ++<<<<<<< HEAD
>  +static int
>  +mt76x2_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
>  +{
>  +      struct mt76x02_dev *dev = hw->priv;
>  +
>  +      if (val != ~0 && val > 0xffff)
>  +              return -EINVAL;
>  +
>  +      mutex_lock(&dev->mt76.mutex);
>  +      mt76x2_mac_set_tx_protection(dev, val);
>  +      mutex_unlock(&dev->mt76.mutex);
>  +
>  +      return 0;
>  +}
>  +
> ++=======
> ++>>>>>>> 1b0adb0ab8649a1ed44f9840724878cffaaa6896
>   const struct ieee80211_ops mt76x2_ops = {
>         .tx = mt76x02_tx,
>         .start = mt76x2_start,
>
> I solved it by removing mt76x2_set_rts_threshold(). After there was also
> a compilation error which I fixed like this:

correct, mt76x2_set_rts_threshold has been moved to mt76x02_util.c

>
> diff --cc drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> index 3f001bd6806c,b54a32397486..000000000000
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 3a70e5bf7d42..38bd466cff16 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -462,9 +462,9 @@ int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
>         if (val != ~0 && val > 0xffff)
>                 return -EINVAL;
>
> -       mutex_lock(&dev->mutex);
> +       mutex_lock(&dev->mt76.mutex);
>         mt76x02_mac_set_tx_protection(dev, val);
> -       mutex_unlock(&dev->mutex);
> +       mutex_unlock(&dev->mt76.mutex);
>
>         return 0;
>  }

correct

Regards,
Lorenzo

>
> --
> Kalle Valo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
