Return-Path: <SRS0=K5U7=PM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D32C43387
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 13:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 919BB208E3
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Jan 2019 13:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PgZGiA7+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfADNar (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Jan 2019 08:30:47 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44266 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfADNar (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Jan 2019 08:30:47 -0500
Received: by mail-yw1-f66.google.com with SMTP id b63so13205111ywc.11
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2019 05:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+w9BuvjScTd37zUJI0e2vK8zLJaNtobZqRQcYrM1C3g=;
        b=PgZGiA7+jrh3gqcpww1fYob8W+O0le89VJBvpJIgxrLUMUD0PiXkrm+F7BNW6xZ6Na
         7ySJI9j0EmJlQ7sGtvaXKltJ0DfN3mtOcSJMZggX67GKAXPzsRAT+oWcLmq0Re7AkgjS
         GViQKnnjAsvjrMu56NB5QmiEwXrIss/kk08oQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+w9BuvjScTd37zUJI0e2vK8zLJaNtobZqRQcYrM1C3g=;
        b=tuT2frsLDNcJELAclEBatosk194EfMdBlFwBxcGGo6X3As7Jw6FDiA5tEItGXin7DQ
         UapdwLIKnN5D6fLaWrcnA5lPCwGpZM0fIrOFlcoVgBw+0lxTWi+IsJX79wb0RT0egB2O
         nbsFYGG6UBOrDgjs9l02v7ate5vqUCTayoqa0jFRovs0kRLppkyFn+V8TKKJ2gH+i53j
         A74dTDjjo7bGt6VRil97DHjiuPph0mIhHaLOb5lGy8wtDhUoCg5PtKdFJZy6sUhP1/HV
         bma2m/65Y+G7ujjYJoxUitBae+bQjveJyoROeWpRoi39NszVOal/eyk8lssd6SOLR/fq
         ZJQQ==
X-Gm-Message-State: AA+aEWYU4hPcEbPPyqh3q6zv3uMbgEXzC7NFS0sSmjmj/i2DSrZ3X3+m
        iz9J788hodf75PeYZrCuNxsTkmAOIcqS730wUZZqEnRng/YQPbpXXk1+G+OCLKn3DDw0hgo3axP
        NCk3qc8A50K8jOM5DsCNyURvczuxXVQY6WtswI1iaRVCi+cCoYDaudj+4VajnnSkI+RaMDIXETB
        esfrwjkMhr8/RAKA==
X-Google-Smtp-Source: AFSGD/V0C/k26wWo+OuR31QK2yuaq06QqKiWCwPMBganD/Lu5i763eamPeWaQDrX9q9dwcI+khg0cg==
X-Received: by 2002:a81:af58:: with SMTP id x24mr53401497ywj.362.1546608646314;
        Fri, 04 Jan 2019 05:30:46 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id f62sm17516450ywd.68.2019.01.04.05.30.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jan 2019 05:30:45 -0800 (PST)
Subject: Re: nl80211 related warning w/ 4-way handshake offload and failure to
 associate
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Eric Blau <eblau@eblau.com>, linux-wireless@vger.kernel.org
References: <CADU241NrgYUq+eEyaNXteTA+KkPgcLXRHraR9y1OZm2bYY7U3g@mail.gmail.com>
 <d3a083b8-f78d-fcf2-d27a-879eeb77b625@broadcom.com>
Message-ID: <85706b88-85be-c27a-a1c9-57aa57f65fa9@broadcom.com>
Date:   Fri, 4 Jan 2019 14:30:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <d3a083b8-f78d-fcf2-d27a-879eeb77b625@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 1/4/2019 2:23 PM, Arend Van Spriel wrote:
> On 1/3/2019 5:29 PM, Eric Blau wrote:
>> There is an Arch Linux bug open on this with a bunch of details here:
>>
>> https://bugs.archlinux.org/task/61119
> 
> The ArchLinux issue seems to be using broadcom-wl driver, while you have 
> issue with brcmfmac. Just to clarify I can only support the brcmfmac 
> driver.

Looking at the original log in the ArchLinux issue, it is completely 
something else so I ignore that for now and focus on your issue.

Regards,
Arend
