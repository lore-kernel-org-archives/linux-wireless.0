Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B197C432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 12:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 543F320715
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 12:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4moCnbf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfKVMxD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 07:53:03 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40744 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfKVMxD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 07:53:03 -0500
Received: by mail-lf1-f66.google.com with SMTP id v24so5425404lfi.7;
        Fri, 22 Nov 2019 04:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fY9hY9/A77YRE8iRO3MEb0mODAHbWB5BA4+3OzYa+58=;
        b=I4moCnbfLIK/FGGBTv1ITFNmnxyumB6muFPhLbyZeSPGEez0/xQ3wWjVPVe0+0L1OD
         TnwJ6itLYO3MaIFmUfvY47ax74TbrfgcRFm+w54ncP8Dnc5NDjd52k6y0kdj25PmVkmo
         PRmqVCkQiFo7+EFMbdzsem4zRg9l4xtJKGn4vHpz+HHuf3Abz0JNM5mseHHaFVZsr9gw
         HixY/+i421fOhnDjEvRGmplvIJ6uUBg1cchYw7qfnj7QyY4WXNKx6qWdZzNdIhBTyDnM
         yYfZo5G5yrcJh+CCQTIsbvNkc8A4NLCXLme9l94syxOy84rTy4pcKc5wpjtcSA7zwW62
         xcHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fY9hY9/A77YRE8iRO3MEb0mODAHbWB5BA4+3OzYa+58=;
        b=F8I8bkPU0PjYRXgZ+kq3XC/jVfuBXbuqPJ95BZQYmnKE5PpK0leT2ZdfCx5VO1G1Yt
         VNaaG94z0iP0c0YwBTGJFV+f/J1eWKUv7KlVCrxcMvc27dH0PDHJgoOPqADzBDFWNY0o
         1ijCgRnierWTCOHf6LAySzxruPTe5ZbTqyEIUGnpt+Lag3G7pS4y/2jdThX0IW+W9C/2
         s2cBP6Uhs6jeFRcjuF0jq27NCz454xlVbAeUSVAqVd6jjStEQfVocayw5cXKFBt0r4XS
         yQ4/xejH5a6c1ed/QJsHm49Z0++AHF8VB39igP3sO9Rdha0NMYmcGZqFZEYLtqzonHCV
         jRdw==
X-Gm-Message-State: APjAAAV1ub+JgywEAff7ZAsU9jAa6Cszf8Scx7CM9IWeOgqCTN81Zud8
        +NpYtIuJe8mDPcHG1mZVT2AC/wPSmqrHPRPPsf/MtMkQLX0=
X-Google-Smtp-Source: APXvYqxWD8dAPCY1GHpRE/7ed3l5OZ2IWo5VV9F02EO0Xqit0HgHe5Ermxto6xeWBId1m3JqVGIHRIcZ0qpFdHAOJ6g=
X-Received: by 2002:a19:ed19:: with SMTP id y25mr2307040lfy.13.1574427180402;
 Fri, 22 Nov 2019 04:53:00 -0800 (PST)
MIME-Version: 1.0
References: <20191108152013.13418-1-ramonreisfontes@gmail.com> <fe198371577479c1e00a80e9cae6f577ab39ce8e.camel@sipsolutions.net>
In-Reply-To: <fe198371577479c1e00a80e9cae6f577ab39ce8e.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Fri, 22 Nov 2019 09:52:49 -0300
Message-ID: <CAK8U23amVqf-6YoiPoyk5_za3dhVb4FJmBDvmA2xv2sD43DhQA@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: set the maximum EIRP output power for 5GHz
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> How is hwsim related to ETSI? What does it matter?

It's well known that the frequency bands 2,4 GHz and 5 GHz are mainly
used by Radio LANs and in many cases, the deployed technology is based
on the IEEE 802.11 standards family. However, other technologies such
as LTE-LAA are deployed in those frequency bands as well. That said,
considering that hwsim is an excellent module that can be used in
different network simulation scenarios; that it is not only used in
North America; and also considering that some regulatory power limits
are taken from the ETSI standards, why not set a maximum value
supported by a renowned Institute? Without this new value, regdomain
will not work as expected for some countries.

--
Ramon Fontes
