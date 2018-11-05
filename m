Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3CBC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A2F42084F
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UE73fprh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A2F42084F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388131AbeKFHY3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 02:24:29 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42400 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387854AbeKFHY2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 02:24:28 -0500
Received: by mail-pf1-f194.google.com with SMTP id f26-v6so5069220pfn.9
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 14:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=OZxo+gm2aB0BOXCTrFO73DgYTbgCEUapMma32xYFIec=;
        b=UE73fprhlHvnloJPFU9DYczSaJFeBh7y3morvwmatxQ6K+wF4iz6CAFkSihGSlQ3Xy
         h+My48pyDLjsnG3qK2amm7jKEJITqoG2CIq6vdt4Fil1kEhJ6/gHt/km0WLQXuE0VPy0
         meuWlK+47i4qUH86KU2Wfc7kt6pvjOJtfOxh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=OZxo+gm2aB0BOXCTrFO73DgYTbgCEUapMma32xYFIec=;
        b=R+zrqRbrD8VKZA03aCnR4DqVtkKTdNYA50D6smoSaGEthJULA8Ymcw/agIeuSIvnLL
         27aeGhDkQi3Cz8q8o+f4wWmlB3Ro+++wDyLcuQJD+0JySmv/jqpYYoAB9pfN8DDeA8ta
         iV1m+v5LZ9Bvs/hrKHyO9M7v4KDcRVQSUXGKUvIiKIeuePySR1DGIfL208Bo7P25A1O+
         Aes7ABW/TxFrdD5lSe8ZLrxZuQ/bhw5+CEnSLvnU3ylIy23J2n+YiWso7IvpKms7T6AZ
         sXuUXqbf6iOXj9ZXEO8H6pxGOHv7oymECx3AwHQYTtUBW3p2hfMu081QxVryq+GXxQfI
         +KvQ==
X-Gm-Message-State: AGRZ1gIQ5PKJTqCo5hb/KLL9u6BON3gk3sG56HpXCOafWdCL5E0E+6Fo
        9mXk51B0Ne4l2X8Eu7q3xzyrDvzTONgXBQ==
X-Google-Smtp-Source: AJdET5fm8FH8THubvGVnksxcOPeZfcMmC/rUMVhoaG2TW3GCcMaTWSmqWklPXB2MK+3orNgnIw1/DA==
X-Received: by 2002:a63:81c7:: with SMTP id t190mr19113673pgd.393.1541455359260;
        Mon, 05 Nov 2018 14:02:39 -0800 (PST)
Received: from [10.177.251.60] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id q1sm25712165pgs.14.2018.11.05.14.02.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 14:02:38 -0800 (PST)
Subject: Re: [PATCH v2 1/3] lib: cordic: Move cordic macros and defines to
 header file
To:     Priit Laes <plaes@plaes.org>, linux-kernel@vger.kernel.org
References: <cover.9ec98292c595a111ae78f31383ff8618c9cb04da.1541446422.git-series.plaes@plaes.org>
 <3be396e01b33905e9ac5c80e7038b7aacf72eaf8.1541446422.git-series.plaes@plaes.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8eb0e232-d14b-60d9-e3c8-008c46659a30@broadcom.com>
Date:   Mon, 5 Nov 2018 23:02:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <3be396e01b33905e9ac5c80e7038b7aacf72eaf8.1541446422.git-series.plaes@plaes.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/5/2018 8:37 PM, Priit Laes wrote:
> Also append CORDIC_ prefix to nonprefixed macros.

Bit annoying that you made me look at LKML for this patch. Can you just 
post the entire series to linux-wireless so Kalle can take it all 
through his tree. Also the commit message is a bit thin. Please explain 
why these are moved to the header file.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Priit Laes <plaes@plaes.org>
> ---
>  include/linux/cordic.h |  9 +++++++++
>  lib/cordic.c           | 23 +++++++----------------
>  2 files changed, 16 insertions(+), 16 deletions(-)

