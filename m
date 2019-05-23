Return-Path: <SRS0=ngAs=TX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2353CC282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 23:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D455920879
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 23:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NfOm5pkk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388051AbfEWXS2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 May 2019 19:18:28 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45125 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfEWXS1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 May 2019 19:18:27 -0400
Received: by mail-lj1-f196.google.com with SMTP id r76so1539381lja.12
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2019 16:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C2BTRxtLLw78fa6kno1i9B0/BXhxWW4AzWK5CCqXNE8=;
        b=NfOm5pkktYdxYTbFoiBlpz4z5rB5egdzlT1fh+Q4OtzA9ZT/k3fC/AD0iOPnBmiaVK
         0WGZxfHoR1cwJUDilgEm7Q6p9eCbJXzhzxikXfdglcu7yisAsZwmBwojvr1mq20W1ime
         n7bXgYgqrqA98cTQ5W13KizyuLQZNJ0xQnmMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C2BTRxtLLw78fa6kno1i9B0/BXhxWW4AzWK5CCqXNE8=;
        b=AmSqtOuldiGAtRe2zdE/uPK1r1zwBtA7f8NRlvaCmoF1KNLBlG9YNq5iOtG8bAv+Kc
         JvJZmILRoyXUN11dZDnb7ydl4SZWjafL75mvQ9tv4o2cai7R5gZGdGkZvyBajufENNHs
         CUSMtn1TNRUX5IIsCmODHmMahQcWisIhwPT42GQ3BKzeZFEG9sEeYXebOOeFlyYIak/T
         iSpqg3nGNO5eWEwtmOKQ8scVDotjFBsmJfRSFtXfvxBMU1uJiqGoB4KTTTv0b1XEuPVu
         +o0FZXzUGvpIElNaJyRBefF/Wa75RbATqRnP/9k0rTyzrGZhk4P6OVf4JAVdwkpunojL
         23SQ==
X-Gm-Message-State: APjAAAX8ziXhTiYcVsUi68U6Ou5FInZz2ozPn5dzfBmPBL70R/totQPN
        93tndaQqm7GJgh42MOB+6JIGONywtFQ=
X-Google-Smtp-Source: APXvYqzH1rYnigqrLiXXz2PeYcsStxRgoQ6JZ1HXTEn57sBXPhvkS6C+llYLvv7YYfdm/s4Tt2yBbw==
X-Received: by 2002:a2e:914d:: with SMTP id q13mr29938419ljg.140.1558653505074;
        Thu, 23 May 2019 16:18:25 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id p3sm247511lfh.27.2019.05.23.16.18.23
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 16:18:23 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id j24so7026193ljg.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2019 16:18:23 -0700 (PDT)
X-Received: by 2002:a2e:9849:: with SMTP id e9mr1249837ljj.185.1558653502848;
 Thu, 23 May 2019 16:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190523071534.254611-1-tientzu@chromium.org> <CA+ASDXMaKpMWnLnKxeft-8eKfpM6qGDsmEzvh290JCCjeRRtxQ@mail.gmail.com>
In-Reply-To: <CA+ASDXMaKpMWnLnKxeft-8eKfpM6qGDsmEzvh290JCCjeRRtxQ@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 23 May 2019 16:18:11 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPn4fJeqnupzXqJqqCiSZfKqD827OUHg+VFrENfjrLzqQ@mail.gmail.com>
Message-ID: <CA+ASDXPn4fJeqnupzXqJqqCiSZfKqD827OUHg+VFrENfjrLzqQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: add missing error handling
To:     Claire Chang <tientzu@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, May 23, 2019 at 9:42 AM Brian Norris <briannorris@chromium.org> wrote:
> IIUC, you have basically the same failure case a few lines up, where
> ath10k_sdio_mbox_alloc_pkt_bundle() may fail. Do the same there?

Oh, I see Erik Stromdahl already got that one:

ath10k: sdio: add missing error check
https://patchwork.kernel.org/patch/10906009/
