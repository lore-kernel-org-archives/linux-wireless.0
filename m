Return-Path: <SRS0=r36G=NP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0932CC32789
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 16:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B89D72082E
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 16:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7P9bQa1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B89D72082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbeKECIW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 4 Nov 2018 21:08:22 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:43044 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728970AbeKECIW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Nov 2018 21:08:22 -0500
Received: by mail-oi1-f177.google.com with SMTP id j202-v6so5478371oih.10
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2018 08:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4GJHArB8eAEvP/JGV5RZzd995655tMSJvbZFj6IKlbM=;
        b=B7P9bQa1AxCJpIEqlGZVEFrtJ12OdQTFUVDTDjvDMmBEBhkHOGNv2IG2iFfcvvU7Rf
         gYmkbDACcxo6XX4g7to6vwAKv61DsuGUlxXthWA/I1oz9GZi6yzHucRcQqA1/38J5cAa
         hOQxo4uSkGX2/3/aujq41laUIHkqsIdms/oW01D1SrYBq+dX8rr6gIHVBtCYMilH/Sfp
         AQJFpw3xZV/ozq8HJ4mlXJtmfmYXOSzhGnP/D/phOPUfY2DF2zME0tVL5RWiVh3S9wOT
         CgQQalJS33/hLDe/zioVEeQBVwug7JzyWMhkABX+jTf3gecnpJ3EA7peEyNNpAkcxyVv
         NHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4GJHArB8eAEvP/JGV5RZzd995655tMSJvbZFj6IKlbM=;
        b=kHLjZfAXug7XudHOuSdp92CoW9vT0jgfXh8xn3zVbNCjfpBw3dOYGYelxdmanBwgGX
         P65gDrgizbVoQgcjzSCuvKdh1tq9QKk5zfu9y6JaJ4TmX7jNuykYvLHuQPfZhDc0z6ia
         Yk/Ij+CtKLj5PFVQ0rsqJpxwja3mly30jG+kpsl/wtEXdF8ePOefl76LYHahJ0DRTuXr
         ztrbTAkfqiYL+fO8nl7o2WF86geGih7M2S+sRZIS/U1CsjdiyHTAezHpThdPOzEdVscz
         RvxjBpkrnqjMSuU9cmR3vQs8yFlLWRqHxlD1gjhQlxzXAi7lsWmYBSWUkbKlqYx64w+E
         0+kQ==
X-Gm-Message-State: AGRZ1gLiBZu4R0+i62oJ+Nv6fOWHgbnHd77gaU//YgPtSwgV2IIUQeeq
        v2Oj3YHSkitWh0h2oIOlOpB013oP
X-Google-Smtp-Source: AJdET5c7evd72X2DOC/gg1P+CJF7bSzCdet5lJ9S/WrxLsDlasv3/okASekAjumRTppDxWJoGlZowg==
X-Received: by 2002:aca:3d56:: with SMTP id k83-v6mr10677171oia.61.1541350365989;
        Sun, 04 Nov 2018 08:52:45 -0800 (PST)
Received: from [192.168.1.118] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t46sm6470981ota.31.2018.11.04.08.52.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Nov 2018 08:52:45 -0800 (PST)
Subject: Re: Driver for RealTek RTL8811AU dual-band USB WiFi adapter
To:     tjcw@cantab.net, linux-wireless@vger.kernel.org
References: <fed00b53-2468-55ea-fa98-0a324a469075@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <211805b1-7f4a-59ea-508a-3c56ef7f0803@lwfinger.net>
Date:   Sun, 4 Nov 2018 10:52:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <fed00b53-2468-55ea-fa98-0a324a469075@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/4/18 9:43 AM, Chris Ward wrote:
> I recently bought one of these 
> https://www.amazon.co.uk/gp/product/B07C4JQZSP/ref=oh_aui_detailpage_o01_s01?ie=UTF8&psc=1 
> ;
> a dual-band wifi adapter. It came with source for a Linux driver, which required 
> some patching to get it to work with the
> 4.19 kernel. Can I interest a kernel developer to integrate this into kernel.org 
> ? It would save me
> effort at further patching if someone else kept it current as the kernel changes.
> 
> The driver from Amazon is here 
> https://drive.google.com/open?id=1AYmjFk2l5jTpnAzLPNpetSGefm4khEBi
> and my patch is here http://tjcw.freeshell.org/Patches/rawhide-20181031.patch .
> 
> The Amazon driver is stated to be GPL, and I am content for my work to be GPL also.
> 
> If you need further information, please email me (tjcw at cantab.net)

Even though the driver is GPL, it would take roughly 6 months for an experienced 
kernel coder to rewrite the crappy code that Realtek provides, particularly for 
its USB devices, to get it into a form that would be accepted into the kernel. 
If you are offering $10K for the project, you might get some interest. :)

As I offer a number of USB drivers for Realtek USB devices at GitHub, and I keep 
them patched for changes in the kernel API, I might consider adding this one to 
the collection there. It would be useful if someone would provide me with a 
sample device. Without that, I would rely on remote testing. A quick look at 
your patches indicate that you are destroying the ability to build the driver on 
earlier kernels. That is what is done for in-kernel code, but for an external 
driver one needs to keep a lot of flexibility.

Larry
