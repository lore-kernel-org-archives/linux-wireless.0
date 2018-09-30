Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A44C64EAD
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 10:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D15E120833
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 10:58:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GypEnBz+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D15E120833
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbeI3Rb0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 13:31:26 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:37812 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbeI3Rb0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 13:31:26 -0400
Received: by mail-wm1-f44.google.com with SMTP id 185-v6so439442wmt.2;
        Sun, 30 Sep 2018 03:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:from:to:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/GwfmYVG9nWwd8/MfY1UkOA7XmC1SEPIY+UwQ/UWd9Q=;
        b=GypEnBz+Slqm3jFjmeXgiIHHdJCcVgOFJE4eiAwYtgpUVp+KPFH4fY0M1Qi4MSEX59
         tXJd7rImNrxhFnEx6YrqRAAXHSVXXdmfosAllTuMWkTeWlqKYoChK6nLgUkrF2D7j14+
         BLcQrITyue8kF9AO9HNNRr0Qll7Tz1bA1ndwDl6FweiuPxPGGLRa0jARk5pPw2OesviT
         6pwQ1QUHaKH6yJ+A9n0v2KVcxDnjH2zoXk7ha1Iibl4tXjCdVkr3QXmF5Ejs2rzfK1li
         zX7LrfW4BxI1+GWYwyqeutoZxb2U0Ux0Vjx8ljLQ4HoJSqCMEgYxQTgxoivQjm1RY2aA
         FHKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/GwfmYVG9nWwd8/MfY1UkOA7XmC1SEPIY+UwQ/UWd9Q=;
        b=EiFgFLiJOhNzTomEDTRoZxOJQ5O91E3g7ADP1bLwnxqf9c2YeqvdtUvqDHD6lh1Kv8
         Dl/5NP1CuDGqofyUuw7i296Rpz3dEVwBMXPqdZxZeMML2CcFwMlrk9NiOOvi2c/n6JWv
         Ck9fHYvwCqQhIOPh9F1WSBQkPZ84947Qr5aFkVxJfsEq5sacXvlfp9Bjc4YP/ptI/cYK
         eP8ustqEkB2JbfxvqGNQmb49P4TyzYHC7/FFh6ju0qf4TWkmG7gk+1bF4SEbXOT8Jpw6
         l5Lr0QzAdfJmC+FtrLrMzEUgLdwE7RsUJv5sGgURa5CIAujx9ME/RITHQNLkCdYYvZ7Y
         CQcg==
X-Gm-Message-State: ABuFfojFV08yzhnvWZIE2hAGeir9f82CR/LILJcK0juFIH08Hk4b7nNu
        3Bhe1DrrKoIZBfxCwi87EFdQ2txR
X-Google-Smtp-Source: ACcGV631w/fC5jRlYm5VeUcZUB9H1CzP3g8m/i3tDVrd11HPo8SnVxhl3BFpMHkaPwwo9TeHdn6ueQ==
X-Received: by 2002:a1c:b984:: with SMTP id j126-v6mr5774452wmf.25.1538305130646;
        Sun, 30 Sep 2018 03:58:50 -0700 (PDT)
Received: from [192.168.200.12] (p57B63A04.dip0.t-ipconnect.de. [87.182.58.4])
        by smtp.gmail.com with ESMTPSA id o7-v6sm310831wma.17.2018.09.30.03.58.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 03:58:50 -0700 (PDT)
Subject: Re: SIOCGIWRATE (and others) leaking SLAB (kmalloc-2048)
From:   Stefan Seyfried <stefan.seyfried@googlemail.com>
To:     LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
References: <cfbf778f-8817-a6f4-f56a-680f13ef5723@message-id.googlemail.com>
 <97c6b1b3-d992-2466-81ee-b383ef7bd90c@message-id.googlemail.com>
 <653d1bde-6372-5f67-5b6e-d48eb912efe0@message-id.googlemail.com>
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
Message-ID: <65c3516a-c8a5-a860-a31c-bbed005a6305@message-id.googlemail.com>
Date:   Sun, 30 Sep 2018 12:58:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <653d1bde-6372-5f67-5b6e-d48eb912efe0@message-id.googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 30.09.18 um 11:50 schrieb Stefan Seyfried:
> Am 30.09.18 um 11:43 schrieb Stefan Seyfried:
>> Looking at the commit, the bug might have been already in 4.18, which
>> I'm trying to confirm right now.
> 
> 4.18.8 (which was easily available to me prebuilt) has the same problem.

I think I found and fixed the problem, see
[PATCH] cfg80211: fix wext-compat memory leak

Best regards,

Stefan
-- 
Stefan Seyfried

"For a successful technology, reality must take precedence over
 public relations, for nature cannot be fooled." -- Richard Feynman
