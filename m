Return-Path: <SRS0=h78J=OR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1CFC04EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 08:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 790AA2083D
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 08:58:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 790AA2083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbeLHI6J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Dec 2018 03:58:09 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:37458 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbeLHI6J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Dec 2018 03:58:09 -0500
Received: by mail-it1-f194.google.com with SMTP id b5so10769429iti.2
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2018 00:58:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uUo0lb5qcXgIp5gLB8+oPGxLA8rIBjvIaOCVCXNK+fc=;
        b=EFWSJX+zhqyYlTKsABNGvHjXLtweT7zi5NZGctKW/Rx9/c4lIRQGGb0dcLyD9QuFXG
         RaFs/vjXKhHEydpb9G8Sap47nT+Rq42RXqjPiMBWkTE2egwWDn5lOT8fCUr7A23fPhc6
         7KV0Xmt5gUyIJOxOgVaboTLmqzlcm3kTOT0oMt/3r7ofxf7yznuauDlAjkLarFp0WPpY
         63fXtJSWOyfe4TP9E9HTViG92gU9R7VaM9av84zy5g7NMUuEM8Ww3lFCQvG8ZWV29Fgg
         ixuhGTaHBpe7FRZmhEfBEGYZwDKbCrifDfqJtCkZitn316jjPKAEvUziK4PQSrNfeUCU
         /Y8g==
X-Gm-Message-State: AA+aEWYF77BVFGEq0HS/pAfIIcphw3aWbyFPrwvekzbJavADDQNQoepZ
        QCMCwKG330bsF47xR2NaXz5T0kXxzqg11zbRyJIWBQ==
X-Google-Smtp-Source: AFSGD/Ul9cl5kyrgNM3Tv6vzAJdnHAZ3yI6YrJH01ya8x90EDigRz76m6M7fwRFihzde5ia29Qb/u1UzFAkp9YWLU3w=
X-Received: by 2002:a24:c187:: with SMTP id e129mr5443016itg.68.1544259488580;
 Sat, 08 Dec 2018 00:58:08 -0800 (PST)
MIME-Version: 1.0
References: <1544189231-3676-1-git-send-email-sgruszka@redhat.com> <1544189231-3676-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544189231-3676-4-git-send-email-sgruszka@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 8 Dec 2018 09:57:57 +0100
Message-ID: <CAJ0CqmWSk8FwYpF3ZdnkNj0J4t1hxk-31fkYdXocfLfstdYtGw@mail.gmail.com>
Subject: Re: [PATCH 4/5] mt76x2: initialize fall-back rate registers
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Initialize MT_LG_FBK_CFG{0,1} and MT_VHT_HT_FBK_CFG0 registers.
> MT_VHT_HT_FBK_CFG1 was already configured.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x2/init.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
> index 54a9b5fac787..16fd514b5207 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
> @@ -140,7 +140,10 @@ void mt76_write_mac_initvals(struct mt76x02_dev *dev)
>                 { MT_WPDMA_DELAY_INT_CFG,       0x94ff0000 },
>                 { MT_TX_SW_CFG3,                0x00000004 },
>                 { MT_HT_FBK_TO_LEGACY,          0x00001818 },
> +               { MT_VHT_HT_FBK_CFG0,           0x65432100 },
>                 { MT_VHT_HT_FBK_CFG1,           0xedcba980 },
> +               { MT_LG_FBK_CFG0,               0xedcba988 },
> +               { MT_LG_FBK_CFG1,               0x87872100 },
>                 { MT_PROT_AUTO_TX_CFG,          0x00830083 },
>                 { MT_HT_CTRL_CFG,               0x000001ff },
>         };

I do not think this patch is necessary since these value are default ones:

root@lede:/sys/kernel/debug/ieee80211/phy0/mt76# echo 0x1354 > regidx
root@lede:/sys/kernel/debug/ieee80211/phy0/mt76# cat regval
0x65432100
root@lede:/sys/kernel/debug/ieee80211/phy0/mt76# echo 0x135c > regidx
root@lede:/sys/kernel/debug/ieee80211/phy0/mt76# cat regval
0xedcba988
root@lede:/sys/kernel/debug/ieee80211/phy0/mt76# echo 0x1360 > regidx
root@lede:/sys/kernel/debug/ieee80211/phy0/mt76# cat regval
0x87872100

Regards,
Lorenzo

> --
> 1.9.3
>
