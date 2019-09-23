Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12838C32755
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 12:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB7E820820
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 12:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TytkSqQe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbfIWMMq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 08:12:46 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37688 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfIWMMq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 08:12:46 -0400
Received: by mail-lj1-f196.google.com with SMTP id l21so13464028lje.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2019 05:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cSOHHjivV1tpWt691+9CebSPZrfknzz2+0HguMtHFSw=;
        b=TytkSqQertDRkcXenzbmR29AR8W1/T/pshUlT4PQDOojR9deHEzMOOuNsQOJ7UoPF8
         OvxMiEx+8s8TQv714rm28ot5fLXR5OLsHIy20m+TaF0CM0aTS+XdNmL4uBM7dLvt1oQr
         JO9RjZCRDmPIqDz/Bh0o6y0nYUdREeL7glkRDisDoKGP7mGRcQxkY8wfZDvFCsyILluY
         psI11f9dqtUCUZjpdY1XAI06DxSSd1SIV0auNoIJdpNjv8RnRERZ0fRVzabcmyKUGj1K
         iE3XU29+uzc8uNtEfd0Dkpqrfx35Y3f49TypsjGE9rpz7Fmwo+qJMxh4rCrRlrEOqqKA
         lBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cSOHHjivV1tpWt691+9CebSPZrfknzz2+0HguMtHFSw=;
        b=AFB/8NZIE9Rwz5iJpXOQjASaBBP3G52XgAkvw95LFUIY2lfpK+GGAjwp7nDljZ87fK
         mA95hMsfM4+6cTX1wr8tql3Itp/DY1sphADoBstDENq6WRxL3Nm5SWwBfxTwnzoaClTx
         ddZsYtYHYWKv9rv83WFF6tazPwi4L15YWXQNgDj6LYkn8Y5BCDG2BwbN7VKm2YkQPmON
         6/upA7eUD5K/ILr9NQsl5H009TnprmrU1kfqk1jS0gV4JAGWM05OxOWX859yaOWXMYPo
         hhI0aisfu8BBihmxyV6DAqn+bOaVYvmC23J/XzrAyudv1BG9xM4jcKgn8+tptVLtMIR1
         xD4w==
X-Gm-Message-State: APjAAAWPeagt74X7YktjWIYnW+fyQk8FNIcqHVmIwodq9IFrjtoewpQd
        pa2TfqorBAtQX8lkTwFMI6I=
X-Google-Smtp-Source: APXvYqxigxY0n/w4a8xDchnt2MCen7oMn1KhJBzYyMK8oTdWRO+p6Xncob2NPPneVmJ0H7fosHKDLQ==
X-Received: by 2002:a2e:b1ce:: with SMTP id e14mr13905036lja.135.1569240763652;
        Mon, 23 Sep 2019 05:12:43 -0700 (PDT)
Received: from [192.168.2.145] (ppp94-29-32-67.pppoe.spdop.ru. [94.29.32.67])
        by smtp.googlemail.com with ESMTPSA id m21sm2183811lfh.39.2019.09.23.05.12.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Sep 2019 05:12:42 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: initialize on-stack chandefs
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
References: <1569239475-I2dcce394ecf873376c386a78f31c2ec8b538fa25@changeid>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <4576d1ca-3af6-476b-7fb8-4b99dc77b92b@gmail.com>
Date:   Mon, 23 Sep 2019 15:12:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569239475-I2dcce394ecf873376c386a78f31c2ec8b538fa25@changeid>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

23.09.2019 14:51, Johannes Berg пишет:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In a few places we don't properly initialize on-stack chandefs,
> resulting in EDMG data to be non-zero, which broke things.
> 
> Additionally, in a few places we rely on the driver to init the
> data completely, but perhaps we shouldn't as non-EDMG drivers
> may not initialize the EDMG data, also initialize it there.
> 
> Fixes: 2a38075cd0be ("nl80211: Add support for EDMG channels")
> Reported-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/nl80211.c     | 4 +++-
>  net/wireless/reg.c         | 2 +-
>  net/wireless/wext-compat.c | 2 +-
>  3 files changed, 5 insertions(+), 3 deletions(-)

Johannes, thank you very much!

Tested-by: Dmitry Osipenko <digetx@gmail.com>
