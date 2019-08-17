Return-Path: <SRS0=m094=WN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834E7C3A59D
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 01:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5039121721
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Aug 2019 01:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TZYT4xz7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfHQB37 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Aug 2019 21:29:59 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35600 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfHQB37 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Aug 2019 21:29:59 -0400
Received: by mail-lj1-f195.google.com with SMTP id l14so6839477lje.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2019 18:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l5zP82JIYM+AT8kTl8ZmKqYDGrjqjh9d+SLlcon2/QI=;
        b=TZYT4xz78WrPzadsQM99gC83MiiDHBheOTOyqzQwC6FLLt8yKfHks971YWhfqPp3N2
         IIhLRW73hxVqQZEjIfzKn9Scb9Wifx991UouIuNn1bkM2EQlNWRQ9Wc6OUHOPvYnKlMY
         DNd6Z+/CUao+9rblo8g6Go9PiJoGncYvrrAik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l5zP82JIYM+AT8kTl8ZmKqYDGrjqjh9d+SLlcon2/QI=;
        b=jMZ3//k0lsIsY+eyZbxoiLc29oNfEFJNsBBfHVF0biLRZGM1K7f6BgT0/hIgNrmjRu
         2MaLf5DQhMm2zZzZ5tBqbkDkfkcI8GEuP08WMMeJzDDZndpDTqpMrkM0gX4yd+E5VwXR
         DNdJmFRTrCQ90SL13j6lf4+SjBWYQ4duJ+8zASzrhVYx9FvPYK6hHk9so6oM+p99WF/I
         Hm/whpAQYwzsUiauuTRyFJ2JJs6l9VO6VZUz3s0GxvRSyZXbtDsshGM709lUzO0zPwZc
         lfsFMZhFRUoQdbeC5UlWut3J3m5TNeLiHHZr+vQlvyuY2oWUg9A7oCNNBnHdeM6zyTOi
         m+6A==
X-Gm-Message-State: APjAAAUSdjaNdc17nczO3+dnvbgoxMVKe79UzOBERkmgrMexUMSHe0IV
        RzvVAA4Eggqz7ZFxuepT42JYQ1cQ3tk=
X-Google-Smtp-Source: APXvYqw4OFW25ZOqTYJCdLYyw+6UQpRUBrRQq3Xn5ELzeYbuKz+pMhisZmfI4RXf81Gk3lZi0vkSgA==
X-Received: by 2002:a2e:5c8:: with SMTP id 191mr7017478ljf.241.1566005396427;
        Fri, 16 Aug 2019 18:29:56 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id m23sm1207786ljh.97.2019.08.16.18.29.54
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2019 18:29:55 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id x4so6822743ljj.6
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2019 18:29:54 -0700 (PDT)
X-Received: by 2002:a05:651c:1135:: with SMTP id e21mr6947295ljo.83.1566005394425;
 Fri, 16 Aug 2019 18:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <1564575767-27557-1-git-send-email-yhchuang@realtek.com>
 <1564575767-27557-3-git-send-email-yhchuang@realtek.com> <CA+ASDXPJiNTXAihzohT06RS57gkJU9Q-u3kpp0piJP-3U1miFw@mail.gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D18914D3@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D18914D3@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 16 Aug 2019 18:29:43 -0700
X-Gmail-Original-Message-ID: <CA+ASDXO2eoHW62Nmw1XNK_HAMgD=8AVNpAtsEod2RZibWZEy9g@mail.gmail.com>
Message-ID: <CA+ASDXO2eoHW62Nmw1XNK_HAMgD=8AVNpAtsEod2RZibWZEy9g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] rtw88: enclose c2h cmd handle with mutex
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Aug 15, 2019 at 7:45 PM Tony Chuang <yhchuang@realtek.com> wrote:
> I think the problem here is I should give a better comment to better
> describe the usage of the mutex. And I also want to keep it short.

I don't think we have limits on comments in source code -- better to
document too much than not enough.

Brian
