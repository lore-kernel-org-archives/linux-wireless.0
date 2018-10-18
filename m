Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144A6C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 10:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B65C1208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 10:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UgYpAa4j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B65C1208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbeJRSnC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 14:43:02 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36387 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbeJRSnB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 14:43:01 -0400
Received: by mail-yb1-f193.google.com with SMTP id 5-v6so11647201ybf.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 03:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Ek9KH0qYT8QgrN+g76JWbHQRlWEBXAZbC7RQz6XZk+s=;
        b=UgYpAa4jfaJzhXL9GP4b2imIvSEY34nIUdqeeH7AIycOlixluY505anoDXUgnVxriU
         uqrZeSLaXxb+LEBUPIdUkkooAtQenbKWMP+BTeAEZFEIwRULrdaTVSF+N9YND9+SGIaC
         MNYpKqU2rde1tRwxw7pwcRNDMPRxgp8tqedTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Ek9KH0qYT8QgrN+g76JWbHQRlWEBXAZbC7RQz6XZk+s=;
        b=CBdhoRNTVJAM+LxA+mn6cbl2OZKnAQU+5YqrXa+2SGdXomUnCVN2+VkPiuZMw5apWn
         nDyYhXdjOFSt3s+AjFMhuPf3Vb8aVJVVU4pCVnIxBcaSZ0rt43hMgIbHLvKce9boIDyJ
         t5tSzcUBQbtygwGq4Oo5Tqov5otltTD5rerIio+TlUlqucZtw/4iDqTsjLHgeYLxoeNw
         eiwdQaOVm9B6zZ2NCvKuhYSYI1Rsoc1OkRt8IwNi31MpYWUCAB6be1lCp6hkXi5z/2aJ
         4x+nsIvk1xRFHfy8Hecoxci1JF8qgiD9F4vvTda7gXctrbiYC7GOjXHAQ/nihqC1Vut0
         thxQ==
X-Gm-Message-State: ABuFfojcuZk/IJ2BGaq/fp1pg8DVlhuLsZ7WuboDNZmcmfuBWL7xaWHL
        hPoBBg4B3Cn1GjFZu6gZNgHkTw==
X-Google-Smtp-Source: ACcGV61eNUoxZjwVp0dvhxAd2L9ZEDab9/XKmXIN/+4eTARwZrXLuYjejVAp8oepMQ7CVLk5BSN2zQ==
X-Received: by 2002:a5b:f43:: with SMTP id y3-v6mr17477858ybr.296.1539859357122;
        Thu, 18 Oct 2018 03:42:37 -0700 (PDT)
Received: from [10.177.251.241] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id x13-v6sm9360391ywj.89.2018.10.18.03.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 03:42:36 -0700 (PDT)
Subject: Re: [PATCH] mac80211: allow hardware scan to fall back to software
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20181018083547.23262-1-johannes@sipsolutions.net>
Cc:     Sushant Kumar Mishra <sushant2k1513@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Johannes Berg <johannes.berg@intel.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <eba7f8e3-9b51-b82b-fdf6-d440214ec653@broadcom.com>
Date:   Thu, 18 Oct 2018 12:42:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181018083547.23262-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/18/2018 10:35 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> In some cases, like in the rsi driver hardware scan offload, there
> may be scenarios in which hardware scan might not be available or
> desirable.
>
> Allow drivers to cope with this by letting them fall back to software
> scan by returning the special value 1 from the hardware scan method.
>
> Requested-by: Sushant Kumar Mishra <sushant2k1513@gmail.com>
> Requested-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/mac80211.h |  5 +++++
>  net/mac80211/scan.c    | 22 ++++++++++++++++++----
>  2 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 71985e95d2d9..4631b3b6fc37 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -3239,6 +3239,11 @@ enum ieee80211_reconfig_type {
>   *	When the scan finishes, ieee80211_scan_completed() must be called;
>   *	note that it also must be called when the scan cannot finish due to
>   *	any error unless this callback returned a negative error code.
> + *	This callback is also allowed to return the special return value 1,
> + *	this indicates that hardware scan isn't desirable right now and a
> + *	software scan should be done instead. A driver wishing to use this
> + *	capability must ensure its (hardware) scan capabilities aren't
> + *	advertised as more capable than mac80211's software scan is.

Hi Johannes,

Not sure what is meant by the last sentence. What does "more capable" 
mean? What are (or where to find) the mac80211 software scan capabilities?

Regards,
Arend
