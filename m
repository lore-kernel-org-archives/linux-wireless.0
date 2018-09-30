Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9748C004D2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD45D2082A
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DUJ7QWiz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD45D2082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbeI3QXV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 12:23:21 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:34725 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeI3QXV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 12:23:21 -0400
Received: by mail-wm1-f41.google.com with SMTP id z25-v6so931049wmf.1;
        Sun, 30 Sep 2018 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:from:to:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GQQp6Fom4aI9PCu4Qk6DhR/4h3ZZ14OQgyszbTQVdm8=;
        b=DUJ7QWizzyOwRwRPIHuUmYeUe0PQps+VX7SRPjXoY5KBXlZcGOVCMBRHJxQ/r59Cwb
         2wh/zua5Q5vO978GKQfE7jEaO3/tUIx92njolBDT0cCvvE2ssswlOHnucb1Mx3xBDbFe
         ULvPyrrW+qPBkxnidLTX7IZJAzaq509pI0PRBADU+L/AJA0ePXQx9/ngPJhFI2XHrXdC
         zy08GRJpOYRB6IIgwTAmVvFqgbfm6wZ8uaZM5fK4cw6ZWBucHsI92vUk9e0H6sVC53Ud
         UOX9TXng25R25GpskJxPLncU1oOinGCWKO3i5cR2HBu2t3ZBEIYudauactrsGufCpc9V
         wIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GQQp6Fom4aI9PCu4Qk6DhR/4h3ZZ14OQgyszbTQVdm8=;
        b=qUK3XxITsfg2KkV24bPDmosP7+TXLx8r1U2dKdXZFDPqcX2XlgdZRBz6/WlYpSt57S
         dIwzQDjj7mqhjmqJ2MZllFFm8M8+GToFieXdBY0sx8kmFMNBENzo7uosgnzmGk/9tyS6
         rihhRwYox02AoeipnfGR7V9nVOySK80BmVSyUv3NzKD8+BSvWxXTrv9YjTynVEwhTETK
         8q+TJXWK0E3VBaZKYaoy2U0ScOODu1sbLM/BJePQdzNI50R0yTs0skf8+Cuy27hUrQJp
         l0YJMqHUy6WC496rMGPz2r0qQiVw4j8dVuavmQkgikquKBbExOPpKT/S431ZleXZG2A8
         i8dw==
X-Gm-Message-State: ABuFfohK+iZ2vSy8aW5CFYTnuulHRwEiu3Xy8BPcIJhv8+SD2OSstTsr
        sLkdUejCkz09qxrpNpyJXcARY/m5
X-Google-Smtp-Source: ACcGV639s6g1IkEvSAaun/VWyG9s4+ss6dYKXogpJV2jVQQWiyhjkt7ruZZQjQhLVWsKtzwYARRLFA==
X-Received: by 2002:a1c:8942:: with SMTP id l63-v6mr6417589wmd.66.1538301060649;
        Sun, 30 Sep 2018 02:51:00 -0700 (PDT)
Received: from [192.168.200.12] (p57B63A04.dip0.t-ipconnect.de. [87.182.58.4])
        by smtp.gmail.com with ESMTPSA id s1-v6sm466410wrw.35.2018.09.30.02.50.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 02:51:00 -0700 (PDT)
Subject: Re: SIOCGIWRATE (and others) leaking SLAB (kmalloc-2048)
From:   Stefan Seyfried <stefan.seyfried@googlemail.com>
To:     LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
References: <cfbf778f-8817-a6f4-f56a-680f13ef5723@message-id.googlemail.com>
 <97c6b1b3-d992-2466-81ee-b383ef7bd90c@message-id.googlemail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=stefan.seyfried@googlemail.com; prefer-encrypt=mutual;
 keydata=
 xsDiBDqoB5ARBACZn/K+5V0uoo0Wr9cI9hw5vPioOmIbPv30x47j/w/XNECPSzos078v9Fr2
 Mlz0MG9Gnpl9S1o0OIh//K5xxj2/LRLO2nL9/nqlnwmJ6W5qrjjn6Ch3mxz5mxMeRMRMY1cZ
 EkSj7GH3ZLviZlzrnpuJd12HWsXhAwVxUyQnvsvNzwCgpIO6EfQT33o9illpG/AxIk2Uu0cD
 /A4cgKbm5VZW5DPTlLe8P92eEgj5cN51SUXHXYgWBI0Fx+QwSYm6ON0U03B4oR5zDWMHkJfZ
 WgXROdwY/NqouBoV7lXvHsyInPzExNixe+1vcrhDJ3ow6nlCW77aCFp22iwumC4ouzFtOMXK
 kih0WPrxPKq27Hw9fq9EaR2oV2tUBACN6ZC+G7J21ruG9slJ+bFcY5cW7M5Um6Czk08T+vtd
 7fAg+fEUcGCtIdVdHrXBut07K9y6iy5IuqwAV5fJsE+JQO+f+X1pymdRgdWHGEoMMdEW4k3W
 IGjrmmMUtpqzr30h4WFgA4+0nR3jpmcGCWBSa4selQecyyOlM7rcmKyQNs0kU3RlZmFuIFNl
 eWZyaWVkIDxzZWlmZUBvcGVuc3VzZS5vcmc+wmAEExECACAFAkx9Sb0CGyMGCwkIBwMCBBUC
 CAMEFgIDAQIeAQIXgAAKCRAx00vNNldAmFZuAJ9xLbFShKeTTDgfwMUmO37qw07npACgmLIK
 fbArokRryKixiliTvxAgFHHOwE0EOqgHkhAEALGQaS9Hj25lKGsaTOMKMBBvjklv6brH8JdF
 WTA9dr37spc+PFFyc9686bcT+5nkbpjq3ndXUzGdGzfe0YwOlQh4fWXZT/oTXosIBqDWPShE
 ntDU8BX9JVqBBZwJ/ey+QF5tgYrICjCzp8S/mL6sqw8En4/AS84lulAoNJMJsUcDAAMFA/4p
 ik7hBklqJzYC7uNWZDL9dkYwIsUXM64kGenUhpgguLZvhuVeUeHU2iIsdTcNBbeBwvXgLnEu
 vVSdf4wtDwR7SjUYebymbGc/JLkXjqGntaWUr+wfHmAm3oXV2X+WFzZQJ+o8N5dJyBEUbrVX
 YvBD7wErgEuJAL+q/i28U9u7OcJGBBgRAgAGBQI6qAeSAAoJEDHTS802V0CYBL8An1gF2k4s
 UaMjAtoX/ixcOhAv44i4AJ9Yi+OgvhS8CbUp+XkI5Q352XU+BQ==
Message-ID: <653d1bde-6372-5f67-5b6e-d48eb912efe0@message-id.googlemail.com>
Date:   Sun, 30 Sep 2018 11:50:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <97c6b1b3-d992-2466-81ee-b383ef7bd90c@message-id.googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 30.09.18 um 11:43 schrieb Stefan Seyfried:
> Looking at the commit, the bug might have been already in 4.18, which
> I'm trying to confirm right now.

4.18.8 (which was easily available to me prebuilt) has the same problem.
-- 
Stefan Seyfried

"For a successful technology, reality must take precedence over
 public relations, for nature cannot be fooled." -- Richard Feynman
