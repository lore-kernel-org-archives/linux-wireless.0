Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD2FC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 22:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0646F21872
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 22:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aAuRd+Rs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfCOWqg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 18:46:36 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41178 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfCOWqf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 18:46:35 -0400
Received: by mail-ed1-f68.google.com with SMTP id a25so1673298edc.8
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 15:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eajXAAAi7XNKaWrha17Hvvp0Tfkt+YEk+XHIyNYuSn8=;
        b=aAuRd+RsU8QmVHfkVFv4fkQdP6WACYWBIQ+mbt9zBA42D6fznzXL0qmRhLko3x2bS2
         zQHEU4fo4/+iQ01pro8K39BKALjScNJTGXDKn6i5MpWJxx+6pih+zhOTiOq6Keg4N+Js
         yGEQNIAwoaa0JJP8YjT45OJLHtW9vIEsEJ8gE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eajXAAAi7XNKaWrha17Hvvp0Tfkt+YEk+XHIyNYuSn8=;
        b=LogpWYkCJXB5fWSTlCU/wcnEpb4pWjNjhjHOyvH3kH/OCZh7yPFiDjuJNdQ0NZuHUd
         S/3mJMTcA01BrAz4zYg+y0/zqg5vzCGGXkAzr41HdXoP7t8noQhldf7GwAQWXgfdLo9z
         O/l5ycPlLK2jcXxjWiZAhoGkoE1YTDqK26HGOM6TTmY9MHQXU0Qjo6zYkofm+xiHRA1N
         mEFXO9s6a7yiUyfx0BUTNN8mywGBHw/nc9e9OdF1snyKTJ1MCGlVjrqoYMaa2f+O60PD
         jREJ+GKA1RqdLAoHijsV5H5PnkESlR25WwnmTj/LpblOe9Ja0uExJbbNiYmCev7/sDw6
         i2Cg==
X-Gm-Message-State: APjAAAVjWOBslaQuh7nOmrz53fdTXVzfaKIdS4aObiEy5rZe/yZsspBW
        +kVE1q0bMqi4UM0my8viBMa4Vg==
X-Google-Smtp-Source: APXvYqyZEe4DTSSTBaG6JBTZkCjRVeCh17wd/rr6cnR6XJh2VRJBHC1JwHI+dv0bSUXC0AM+NbrC/Q==
X-Received: by 2002:a17:906:8401:: with SMTP id n1mr3442167ejx.143.1552689994185;
        Fri, 15 Mar 2019 15:46:34 -0700 (PDT)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id q3sm962338eds.41.2019.03.15.15.46.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 15:46:33 -0700 (PDT)
Subject: Re: [PATCH v3] brcmfmac: fix missing checks for kmemdup
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <d712dd26-8b51-143a-b3ff-ad44f2774944@broadcom.com>
 <20190315170433.3845-1-kjlu@umn.edu>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0b85b931-d9a7-46c8-2fc2-1c554793d35d@broadcom.com>
Date:   Fri, 15 Mar 2019 23:46:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190315170433.3845-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/15/2019 6:04 PM, Kangjie Lu wrote:
> In case kmemdup fails, the fix sets conn_info->req_ie_len and
> conn_info->resp_ie_len to zero to avoid buffer overflows.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
>   1 file changed, 4 insertions(+)
