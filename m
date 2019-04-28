Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60767C43219
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 20:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D2DF20679
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 20:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfD1U5x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Apr 2019 16:57:53 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:37095 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfD1U5x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Apr 2019 16:57:53 -0400
Received: by mail-it1-f193.google.com with SMTP id r85so4713021itc.2
        for <linux-wireless@vger.kernel.org>; Sun, 28 Apr 2019 13:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IakkYFcub8dYxluDy2qa2Pn3/9zOQ89eVmk8iBVEbtI=;
        b=U404tDjPZvRL7rHB1mNi0moupxoZhaITYWdjiqc4xID2sAekDWhhhNAUXICCwXlkp1
         9Z/LKYEjOb2yr1dxGb/gPyFHyYRt5zL/0uArfHtT47KXoP+QSQtTCz2BudO/1hple6Gi
         OZq8UCWC/2xnTCuDq9jek4ckaLv+GVTsm0v2gQBPLv9oJgpK8/nVli5S/64T9l/Q1JIV
         7/GIUZoeqt7PJ6XPRMX1TcksU8DL9ucm+jMheSFtyzEk2n4VNO1aDNB5RpLs4y4hO0Ii
         +450RzS0E1SwzRJym4jgDKcEYDrxQqC6eBV1FbuGjN28zCYvt1M872bxEHWrd9Vwxwh9
         wjHg==
X-Gm-Message-State: APjAAAUN95T6eo5l3oit0B1+Vyb8poWgTYidLGZj2uU6Ur7SJcgKp9J0
        RiIqH0EFZWkHH116TzBUYE25OfHk3KMrGdeEb/YwYg==
X-Google-Smtp-Source: APXvYqzdRsgsID38nXpyQ2hJn7UdbHV/aOTBZyw4y2Q4kldAUB4Ue7hBmy+Zvp6SEoJcR7a/TELbD5CSLerejxs6IIg=
X-Received: by 2002:a05:660c:209:: with SMTP id y9mr17238079itj.31.1556485072190;
 Sun, 28 Apr 2019 13:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1556280002.git.lorenzo@kernel.org> <e7bc3645ce73a15ef9fa16a40f2bdb8577494769.1556280002.git.lorenzo@kernel.org>
In-Reply-To: <e7bc3645ce73a15ef9fa16a40f2bdb8577494769.1556280002.git.lorenzo@kernel.org>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 28 Apr 2019 22:57:41 +0200
Message-ID: <CAJ0CqmXXSy2p7jEPE-4AaUAVwpG6awyXRPnghk5NAVqB4HxnSQ@mail.gmail.com>
Subject: Re: [PATCH] mt7603: wait for pre_tbtt_tasklet before scanning
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Disable pre_tbtt_tasklet tasklet before performing frequency scanning
>

Hi Felix,

please drop this patch and 'mt76: move common beacon code in mt76
module' series, I will send a v2 rebasing on a new patch

Regards,
Lorenzo

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7603/main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
> index 18a33d921601..184ed4cead0a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
> @@ -535,6 +535,7 @@ mt7603_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>         struct mt7603_dev *dev = hw->priv;
>
>         set_bit(MT76_SCANNING, &dev->mt76.state);
> +       tasklet_disable(&dev->pre_tbtt_tasklet);
>         mt7603_beacon_set_timer(dev, -1, 0);
>  }
>
> @@ -545,6 +546,7 @@ mt7603_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
>
>         clear_bit(MT76_SCANNING, &dev->mt76.state);
>         mt7603_beacon_set_timer(dev, -1, dev->beacon_int);
> +       tasklet_enable(&dev->pre_tbtt_tasklet);
>  }
>
>  static void
> --
> 2.20.1
>
