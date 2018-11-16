Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE832C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 16:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A90520858
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 16:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnJMnEab"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A90520858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbeKQChH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 21:37:07 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34338 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbeKQChH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 21:37:07 -0500
Received: by mail-yw1-f67.google.com with SMTP id g75so5860814ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 08:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kpeE4oTAUctMa2536klbsKFBLoFQo2p5YKWtywzsAl8=;
        b=YnJMnEabNFxwTavpQetuNTkjb1c4FbXazMfnKDm4PFVbQLE0X0GPA/CpIy66dmYDOJ
         k+X5Lc3a2ksPS7aTnSFKaIgsFlBl+vHCqip6QsT72WB0vJ1wd53OIbI+OTehTlJuFS15
         o8IXuMb816QTRG6Uyou+NSxkP1kZovAt32LLUZqBdZ4DDykvpDu/af7hYJoEpjHNYNuj
         pwyiESrAzWphgADz3dKHltUjBwEsKJcyxexkLYAyUw/CdO2g62M/VRYCkDzBlMUV+dkv
         ffn68kLt32rWLqgsJE64a+uQkBVYiae29rLeUrEX4GWIen3r8PkTOVpbXqdM+BUMZBuf
         eEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kpeE4oTAUctMa2536klbsKFBLoFQo2p5YKWtywzsAl8=;
        b=fBLt+5pzyI7Qx0VBO9nWEJWYirPO+NuFisLfHYCf6AntZIo4IsEV6paMiTYUuo4wqR
         kUE82Rh2oeD40OLVD2/vPj9zKnMHRRmu0jlnjBQRVHk9C0igc/Kg+vZJo19fg6c4Cz1V
         VxpCgyzc7C+wP8RbvG2tAu8u9Rply/o9FMa3TCnrY/fl0gCgqrEDAS5vmcD9vS7m+klT
         l8Y2oQQE2A/Yfdwk3hLkrjkiQP53bDQ3ioowZwFg5vR/eHHSirfcyVLuWGsXhdCRSQV2
         Th6TV/wktH39XcTjbN4ILCoCL+LpZ/9UX7G88+TMoJF1bPwZpkLtgE1xxbS2e/eW6VaG
         DxaQ==
X-Gm-Message-State: AGRZ1gILCiaF/+BnQe7BkHoY+xYVQShf/soOae5lsN46azHndqehixLp
        Arj84NXuFdIPxQNrF7l/o2D5JsVmxjYGiLnkjsRJfQ==
X-Google-Smtp-Source: AJdET5cBHitVmpptQdwlU48scPcGFucxQy/OxL8zJOANNSPbkgMabZR6MZLOjasNdJ3AfNlwViSnGHYZuumTbOu8LfE=
X-Received: by 2002:a0d:e984:: with SMTP id s126-v6mr10687099ywe.47.1542385445031;
 Fri, 16 Nov 2018 08:24:05 -0800 (PST)
MIME-Version: 1.0
References: <20181116111235.86347-1-nbd@nbd.name> <20181116111235.86347-6-nbd@nbd.name>
In-Reply-To: <20181116111235.86347-6-nbd@nbd.name>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Fri, 16 Nov 2018 17:23:53 +0100
Message-ID: <CAA2SeNLOvRHq_wE+7iebAodU70Y54VHGn06NvJbVOwBiR_kA9A@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] mt76: mt76x02: remove mt76x02_txq_init
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Open-coding it simplifies the code
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 23 -------------------
>  .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 --
>  .../net/wireless/mediatek/mt76/mt76x02_util.c | 15 +++++++++---
>  3 files changed, 12 insertions(+), 28 deletions(-)
>

[...]

> @@ -191,8 +191,13 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>         msta->wcid.hw_key_idx = -1;
>         mt76x02_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
>         mt76x02_mac_wcid_set_drop(dev, idx, false);
> -       for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
> -               mt76x02_txq_init(dev, sta->txq[i]);
> +       for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
> +               struct mt76_txq *mtxq;
> +
> +               mtxq = (struct mt76_txq *) sta->txq[i]->drv_priv;

I think sta->txq[i] can be NULL here

> +               mtxq->wcid = &msta->wcid;
> +               mt76_txq_init(&dev->mt76, sta->txq[i]);
> +       }
>
>         if (vif->type == NL80211_IFTYPE_AP)
>                 set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
> @@ -230,11 +235,15 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
>                       unsigned int idx)
>  {
>         struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
> +       struct mt76_txq *mtxq;
>
>         mvif->idx = idx;
>         mvif->group_wcid.idx = MT_VIF_WCID(idx);
>         mvif->group_wcid.hw_key_idx = -1;
> -       mt76x02_txq_init(dev, vif->txq);
> +       mtxq = (struct mt76_txq *) vif->txq->drv_priv;
> +       mtxq->wcid = &mvif->group_wcid;
> +
> +       mt76_txq_init(&dev->mt76, vif->txq);
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_vif_init);
>
> --
> 2.17.0
>


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
