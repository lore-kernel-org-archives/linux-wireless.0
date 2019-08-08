Return-Path: <SRS0=CQZP=WE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20888C433FF
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Aug 2019 17:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B932173C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Aug 2019 17:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="b8VQux5Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404272AbfHHRRf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Aug 2019 13:17:35 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44429 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404269AbfHHRRe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Aug 2019 13:17:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id k18so89578946ljc.11
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2019 10:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8DcWJXWzPDCP1JXkMB6+PoHDqx7nBE00NIoMaM7Ozbo=;
        b=b8VQux5YwOICD7XuArcifCNwpSeSePlDeHW0RU0X23qjWJBdu5O5CDcOpDxUalRFBd
         K8HOGLcHMcXaDikcUr6qItoyMntTwTChBXApwxhIbh6nCIa4djUkCTBEqvzdgROerSj1
         QhoGDaN10bByJXvRlRjDudZ2WhUJj73xmHTpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8DcWJXWzPDCP1JXkMB6+PoHDqx7nBE00NIoMaM7Ozbo=;
        b=FqgWQ/1S/WT4EFVMG7lYg4zwVcRUzcvgnuhiBQ00PmBqUsyw1AN+eWOIjltY/tS+r1
         av/KvOsy10zVrmglMahN+bPE9rLXQFjBAKWw7tybZd5LlYyxZQbTOucCNncWvOwF7Ssz
         aQlhOt08uIxrlsGI9jjprDAuvvYccMCV7Xv3+KyT8NJtjMJoY0AknjRlfsksGvo1t2Kv
         PT/+4zcm6HCdglAMJhmQfyjIj5ZENIrQ8/i+McOv5QRyyKvpqiSCXcxg9gntiufDPlPv
         8YecupKmWgw8v69jaBT563awUErh+5VNMgW8ILChqQA87fYrPQEXijppIdLjqPtqqoy9
         +jZg==
X-Gm-Message-State: APjAAAV4XxnXatFxluXWZcCUVKMPy6nniHtaZrvonq4U7t0Ro1X6cmhJ
        PuaKsoBwCxk4cXRGlpyjS8Wc5OSlHAk=
X-Google-Smtp-Source: APXvYqyl+6+Gp7QC0Xas1JCrAlDJhZr/KNN3AcIbRcwuq+v2X2qcMgtHQxvoOgWyp52f/K0OXBWONQ==
X-Received: by 2002:a2e:9116:: with SMTP id m22mr8739555ljg.216.1565284652239;
        Thu, 08 Aug 2019 10:17:32 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id d3sm35583ljj.55.2019.08.08.10.17.31
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 10:17:31 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id t28so89611893lje.9
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2019 10:17:31 -0700 (PDT)
X-Received: by 2002:a2e:55db:: with SMTP id g88mr138639lje.27.1565284650940;
 Thu, 08 Aug 2019 10:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190227012139.188973-1-matthewmwang@chromium.org> <20190415223744.GD6979@w1.fi>
In-Reply-To: <20190415223744.GD6979@w1.fi>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 8 Aug 2019 10:17:19 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPkNA6B9PqM8+VaEM2GoZW0PurJdDzon6M6UOt0HpZDxg@mail.gmail.com>
Message-ID: <CA+ASDXPkNA6B9PqM8+VaEM2GoZW0PurJdDzon6M6UOt0HpZDxg@mail.gmail.com>
Subject: Re: [PATCH] check for driver SME support when selecting FT suites
To:     Jouni Malinen <j@w1.fi>
Cc:     Matthew Wang <matthewmwang@chromium.org>,
        hostap@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Johannes, linux-wireless

I see Matthew resent this with the proper sign-off, but it's not going
anywhere, likely because of the below:

On Mon, Apr 15, 2019 at 3:38 PM Jouni Malinen <j@w1.fi> wrote:
> That said, I'd also like to understand how this has been tested with
> drivers that do not use wpa_supplicant for SME, but that do support FT.
> There are such drivers especially in number of Android devices and I'd
> rather not break those use cases..

I see exactly 1 upstream driver that implements
NL80211_CMD_UPDATE_FT_IES. We didn't really get anywhere so far on
this thread:

https://lore.kernel.org/linux-wireless/211816ff03cf188d834a21b1fbc98b4f8c5b81f4.camel@sipsolutions.net/

Brian
