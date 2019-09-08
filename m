Return-Path: <SRS0=wUyo=XD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=BIGNUM_EMAILS,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689A9C433EF
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 00:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E7F1206BB
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 00:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="veoIEBwm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfIHAzV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 7 Sep 2019 20:55:21 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:38861 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfIHAzV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Sep 2019 20:55:21 -0400
Received: by mail-pf1-f172.google.com with SMTP id h195so6903573pfe.5
        for <linux-wireless@vger.kernel.org>; Sat, 07 Sep 2019 17:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o1+VAU3r1wnOC38/TQf5t+G28XJ3eh9QIfBuXGwopyo=;
        b=veoIEBwmywO6uWa+MCQuzqJEzevrIDRDEx8NkkUWvN4LkFRUBvICEkeembqVhOaG8x
         VGZRen20W0p+WKWdljuHPIchSR5FtI08sxIJ/6cwI60fPBaTeo13N6ciCSV7ic4SQCiI
         VIH1vP5VOPaQi4RCzEWrDvqhwF1k1bniUNotHD42yqDwE94RPh70kNDgqINyXmzDiY3n
         OQ7P+IaGMzJIuhbXNuUxc6ucwnOxpsmrNfiHMmuz7c07dUxHRsy2o2m84s3sQOhD38aY
         iWgqcrRkZm6YZSe136yLhy12N9wImM8ITsZ6f1sicecSupExEElJ9ed79IJQcCBYsXqB
         /ocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o1+VAU3r1wnOC38/TQf5t+G28XJ3eh9QIfBuXGwopyo=;
        b=RF7RrDMyTIewUclsc1I9WcGTFeztpMOSYcDVH3682RBkevx/VhkLgrf1j5FIOVffQw
         IHjiyV/8ZwfwOMhrquGHktLJLnZiV3nYC1ioa+2OITwmhFdQGuJJByLsg8k7116sDyLK
         wjJZZBqLKMFrTyEPUGXH5MIxtwAfPeSf16v0NJbqCCTBB1NVG651F/eFJkg66TLGfeBx
         g+vfStteI9F20F/9p9xxR2DzzJDlrVGufSVloJUVpJ3vG5eQG15OqL0JHIASBfSn0N8Q
         KR0vv4EJQPp+9O9dlGb/yhxTLNdUoUKdI1GlvKlwZmX3F4r1o/TD4vcaCiLnwohlFpii
         Kq8Q==
X-Gm-Message-State: APjAAAUNTesAZdkJSx1ktJS3DUT/Kb3GFZ+AUW2DWsjZ6eQXoOJxTVjZ
        Nn760HYhNnfOJPz7Kgn3LY1qtb6q
X-Google-Smtp-Source: APXvYqziC3mnPw9XCzhnhOK/aNU+BEToH/AyFs7sDNf4Ctvg1J1o+w0WtQtmBccWUwCLWQev9EStig==
X-Received: by 2002:aa7:8e08:: with SMTP id c8mr15259685pfr.238.1567904120162;
        Sat, 07 Sep 2019 17:55:20 -0700 (PDT)
Received: from ?IPv6:2409:11:53c0:1f00:6859:dd0a:96bf:4dec? ([2409:11:53c0:1f00:6859:dd0a:96bf:4dec])
        by smtp.gmail.com with ESMTPSA id p1sm1346915pfb.112.2019.09.07.17.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 17:55:19 -0700 (PDT)
Subject: Re: [bug report] nl80211: Fix possible Spectre-v1 for CQM RSSI
 thresholds
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-wireless@vger.kernel.org
References: <20190907130234.GA32057@mwanda>
From:   Masashi Honma <masashi.honma@gmail.com>
Message-ID: <4ec1ee46-d178-15e4-4918-f9a516ce23d2@gmail.com>
Date:   Sun, 8 Sep 2019 09:55:17 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190907130234.GA32057@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019/09/07 22:02, Dan Carpenter wrote:
> The patch 1222a1601488: "nl80211: Fix possible Spectre-v1 for CQM
> RSSI thresholds" from Sep 25, 2018, leads to the following static
> checker warning:
> 
> 	net/wireless/nl80211.c:10820 cfg80211_cqm_rssi_update()
> 	warn: disabling speculation after use: 'i'

Thanks.

I will send a patch to prevent accessing to rssi_thresholds[n].

Regards,
Masashi Honma.
