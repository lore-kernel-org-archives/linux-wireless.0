Return-Path: <SRS0=ETdN=DG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCB8C47427
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD98E207C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601386975;
	bh=5RO0FIB4An+8TnRMhDir9GmpZkMdliSjg1+FOgj7wuU=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=Vp7+XoEHfI9YeAVbC1n8Y7wabbX+RUQK16Bi2BP7JfCCqlwVE+vZjh0a0MNGmzIVx
	 js32DMLAGr+plrsCjlEjEURr8bmsU1gL5jcP0GeAZiY1RmlPhya9IvMi/eb9kaDaRV
	 mhgQbrFYJpykWfUe42EC8LC2J+40A2khbuQCzgqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgI2Nmx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgI2Nmw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Sep 2020 09:42:52 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8F6C061755
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2020 06:42:52 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q21so4446487ota.8
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2020 06:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Re7sYUHoP/OO8RJy6m0dCE8FjQyDvN9idLxneZjSGs=;
        b=Z34rZ/ds72mfUVTwVAO13Bpz4khcxmzLmZRTJ6BeCzZVGwvFQBFtfTqV+Mw0LWRYNM
         uCrAI5JhrSTo6VZxNGORq4+uDlbuWvNn0BzZwcj+1vO5F++bvuicz0Q+A30JgXV/f7rA
         Rk9jpCrpw+utP3CvREty99qb9cv8smpJnWoLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Re7sYUHoP/OO8RJy6m0dCE8FjQyDvN9idLxneZjSGs=;
        b=nI5Sxy+3dwV6bKdaHyFHw8/iqq1yG+tfXe9AqXRxuq5RwCKSELdGh+G2sU36UwSMu1
         Pi7/JVgUE/h8b1zRZDG1cFn8aNlczDyejo6z79FtUbiAbvLTXvjobx5ZVlQ8CIFimgml
         KpcONPLPIehGAB8KZR9L2CY8dsThw0ZXoMcUUKlneSAvodC1hChZZepX/bLtPIZd8wuU
         /b+IzChdGFikxc+wM/tTEqYhJ0+wraaFHd0QOLNRrcphFq3fLK3wUE6gyrhIpl47q+1n
         hY5O/JpPbB+lKIpxhb62SelE5l8S8ng1wh/t3cqfCW/arIz9LeitmecLjAo1y/XHyC+t
         nPDw==
X-Gm-Message-State: AOAM530xXFuA45Tqw9HiaGLw0icEHfneggvvoIZG/KKAPUpjyvhwV+0s
        XU/+VTXGCNFJz97MzCsAhYXQlA==
X-Google-Smtp-Source: ABdhPJxomgEcCkXHcyd2u2LBzXalo3/5KY6BNqNVB1FRlJIPPq8bhwRXFJ9dfNYvva75m6zRbuIoZQ==
X-Received: by 2002:a05:6830:196:: with SMTP id q22mr2688536ota.221.1601386971432;
        Tue, 29 Sep 2020 06:42:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l4sm993642oie.25.2020.09.29.06.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:42:50 -0700 (PDT)
Subject: Re: [PATCH 00/18] use semicolons rather than commas to separate
 statements
To:     Joe Perches <joe@perches.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-iio@vger.kernel.org,
        drbd-dev@tron.linbit.com,
        =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        David Lechner <david@lechnology.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        linux-clk@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr>
 <CAMj1kXGh+CzuXkAnqsoMO2A3T1p=D6uFOV347Ym5+VFn5U1gWg@mail.gmail.com>
 <20200929124108.GY4282@kadam>
 <alpine.DEB.2.22.394.2009291445050.2808@hadrien>
 <5f0d2b20f5088281363bb4a35c5652a2c087f159.camel@perches.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cd75e2d1-9923-b725-78cd-fd5611431584@linuxfoundation.org>
Date:   Tue, 29 Sep 2020 07:42:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5f0d2b20f5088281363bb4a35c5652a2c087f159.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/29/20 7:34 AM, Joe Perches wrote:
> On Tue, 2020-09-29 at 14:47 +0200, Julia Lawall wrote:
>> On Tue, 29 Sep 2020, Dan Carpenter wrote:
>>> The times where commas are used deliberately to replace curly braces are
>>> just evil.  Either way the code is cleaner with semi-colons.
>>
>> I also found exaamples like the following to be particularly unforunate:
>>
>>                                  fprintf(stderr,
>>                                          "page_nr %lu wrong count %Lu %Lu\n",
>>                                         page_nr, count,
>>                                         count_verify[page_nr]), exit(1);
>>
>> The exit is very hard to see, unless you know to look for it.
> 
> I sent that patch last month.
> https://patchwork.kernel.org/patch/11734877/
> 

I see what happened. This patch touches lib, cpupower, and selftests.
Guess lost in the limbo of who takes it.

  tools/lib/subcmd/help.c                    |  10 +-
  tools/power/cpupower/utils/cpufreq-set.c   |  14 +-
  tools/testing/selftests/vm/gup_benchmark.c |  18 +-
  tools/testing/selftests/vm/userfaultfd.c   | 296 +++++++++++++--------
  4 files changed, 210 insertions(+), 128 deletions(-)

I can take it through one of my trees.

thanks,
-- Shuah
