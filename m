Return-Path: <SRS0=h78J=OR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E802C04EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 09:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D4EE2082D
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 09:14:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D4EE2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbeLHJKp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Dec 2018 04:10:45 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:34141 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbeLHJKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Dec 2018 04:10:45 -0500
Received: by mail-io1-f68.google.com with SMTP id r9so5240612ioa.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2018 01:10:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MK+XvXeGhwnA23s1ycHow8Fbucye9XnG+c99XoU+kaw=;
        b=dFX61mS48eTmKoOslH15rGui7ZJFpUNlTx+6PqdSVjs34VPHNLVjQVZozjZQvT4FhA
         J580gE5X7YCwIrSfDlagzmIT0hiarToUKrmWg33E72wMwwsWnggl4vMonUi40tzc+OaX
         wl53AhbJeQVTixdy1JbFOmUIzeGr13bPvPM7dt1G+qHQsM2N0R5gYclLiGKSh3LMjdyv
         xFcMh4AFdo37CCTgR+UKTlk0zISPAVFiSyIxjSrUmArQ5kHu/KxdT9IUrQx61SHGZ5JG
         WVgv45Wr2tCBzQjShAhcVzKUVZ2g1frtpswoMh8AcWamuw6R+h546xyoumiFGoXvP6sV
         nmlw==
X-Gm-Message-State: AA+aEWYHS0C2T1lni/vb3vIaD33HNmeiVshM5ZQDfzTC0hOEQ7NWNnut
        qlIAqv4cfwjy3TymYNIUSVs8SZ5tDKdNf8NUWhxGozSUftg=
X-Google-Smtp-Source: AFSGD/Xkq7UyVaFf7q5tGWyqew9q6L6UIcdqCOIgt9CVIHJSQYVTVyFRRH5F1sx3/b8QRxHsxXQzjzzCzidmzQnFAo0=
X-Received: by 2002:a5d:9813:: with SMTP id a19mr3848360iol.181.1544260244688;
 Sat, 08 Dec 2018 01:10:44 -0800 (PST)
MIME-Version: 1.0
References: <1544189231-3676-1-git-send-email-sgruszka@redhat.com> <1544189231-3676-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544189231-3676-5-git-send-email-sgruszka@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 8 Dec 2018 10:10:33 +0100
Message-ID: <CAJ0CqmVF6ptpe9A95EXN7qVNQn32L1kzZ48mgV-oL3XQBs8m9g@mail.gmail.com>
Subject: Re: [PATCH 5/5] mt76x2: initialize fall-back rate registers
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Initialize MT_LG_FBK_CFG{0,1} and MT_VHT_HT_FBK_CFG{0,1} registers.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
> index a1657922758e..01e672bad2f1 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
> @@ -88,6 +88,10 @@
>         { MT_TX_PROT_CFG6,              0xe3f42004 },
>         { MT_TX_PROT_CFG7,              0xe3f42084 },
>         { MT_TX_PROT_CFG8,              0xe3f42104 },
> +       { MT_VHT_HT_FBK_CFG0,           0x65432100 },
> +       { MT_VHT_HT_FBK_CFG1,           0xedcba980 },
> +       { MT_LG_FBK_CFG0,               0xedcba988 },
> +       { MT_LG_FBK_CFG1,               0x00872100 },
>  };
>

as for mt76x2 patch (except  MT_VHT_HT_FBK_CFG1) MT_VHT_HT_FBK_CFG0,
MT_LG_FBK_CFG{0,1} are default values
(at least for mt7610e, I will double-check for mt7610u)

Regards,
Lorenzo

>  static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
> --
> 1.9.3
>
