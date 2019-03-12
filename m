Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07745C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9992177E
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iibUy15w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfCLM5g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 08:57:36 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41105 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfCLM5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 08:57:36 -0400
Received: by mail-oi1-f196.google.com with SMTP id e7so1942711oia.8;
        Tue, 12 Mar 2019 05:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QdpB0yqk9irxbeRBNZ4oj46IQGC+jIFBfKXVTxsbwZs=;
        b=iibUy15wPV+3VYPJ1GYn2m5L5geb49SI/nEAh75OE8t4vdM2dQR+74rzR4BSg+tXOZ
         Y98XIOc3va4Iaw9CKPpe3ODJ22foeHnm4MN0T1LkGDL6ViBGdmVgnUb/UMQBY7b5cevI
         ZKZfhw2I4NmHvdDCsnWjqaxp0Kv0ycOu4W+aDp+qWzJUfU8tstsETXGOJc13eCCLn+Bv
         IzPzBqQu3E99wwnb8dNzOYi8RzBKCkyp5ajleu/pVhFGBPC0rfTtlVfJwLhG2StY1CFk
         4eocIWe0jRiwYPFZCBBGM8I1U7GBxS9JGEd+Ey90fb0sj876vbfGStp0As1AY+xeUmcC
         +79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdpB0yqk9irxbeRBNZ4oj46IQGC+jIFBfKXVTxsbwZs=;
        b=giFaxsugJbxfRuk9Ep2JlQpkITrdRLdY3aXykwKvEhR8nlPzgk8Wx9tS+pbgW4EHXN
         Op6Izd2U+nnAPTEli3HteTFLwk4eUWsV+Jkr3Os5e5leh4JQz3Htxc1SklOV6Y+4Jeit
         Ug6zVBDSNTL9rCM/sCKT0jbPOB1CgrYtiLwjXF2f8fqIxQt3+Ajzl53tTd0d3MRagyY4
         meL+qcdB8PM/9/uFVQIfbNLUHsPNCzEdJAeMAcbNYehDo2RXDOCFvh3yii8/USUmUEj5
         KDl0rwJje1aUZ+P9CvVJEbnO85558T0IDbY1NUqxCU+L7U19sE2Tm2y5ooYrwQ9s5XL+
         RD3w==
X-Gm-Message-State: APjAAAWAYFZtqDCA9hdInHMe0LHcCvPkGPEIfR63k7Hoo9E8jaT2gau8
        Jo566W4ZWKSpw91/kfGLIWTOnaDQ
X-Google-Smtp-Source: APXvYqxTYssZqcVkqd2WiftErf3CWcuoZDU4RUT5rQ0mSHFxL+sP2Eq1cxR5zulm8zqbatlkjaD42Q==
X-Received: by 2002:aca:3a0b:: with SMTP id h11mr1629034oia.97.1552395454741;
        Tue, 12 Mar 2019 05:57:34 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id n25sm3529851otj.76.2019.03.12.05.57.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 05:57:33 -0700 (PDT)
Subject: Re: [PATCH] drivers/net/wireless/realtek/rtlwifi/usb.c - fix some
 non-kerneldoc comments
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <15731.1552388757@turing-police>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <69ce20a8-4342-5852-20fa-1e7369b629f4@lwfinger.net>
Date:   Tue, 12 Mar 2019 07:57:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <15731.1552388757@turing-police>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/12/19 6:05 AM, Valdis Klētnieks wrote:
> Building with W=1:
>    CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
> drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  *
>   on line 243 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  *
>   on line 760 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  *
>   on line 790 - I thought it was a doc line
> 
> Fix comment blocks so they don't look like kerneldoc lines
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
> index e24fda5e9087..9478cc0d4f8b 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
> @@ -239,7 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
>   	mutex_destroy(&rtlpriv->io.bb_mutex);
>   }
>   
> -/**
> +/*
>    *
>    *	Default aggregation handler. Do nothing and just return the oldest skb.
>    */
> @@ -756,7 +756,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
>   	return err;
>   }
>   
> -/**
> +/*
>    *
>    *
>    */
> @@ -786,7 +786,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>   	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
>   }
>   
> -/**
> +/*
>    *
>    * We may add some struct into struct rtl_usb later. Do deinit here.
>    *

As these comments are 1 line at most, I would have changed the first and third 
instance to /* <contents of line> */, and deleted the second empty comment, but 
the content of this patch is OK. The subject line needs to be changed. It should 
start with "rtlwifi: rtl_usb: Fix some ...".

Once this change is made in v2, then

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

