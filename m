Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A04DC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA81321571
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:21:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mc0MhElm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA81321571
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbeI0Vju (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:39:50 -0400
Received: from mail-oi1-f170.google.com ([209.85.167.170]:45481 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbeI0Vju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:39:50 -0400
Received: by mail-oi1-f170.google.com with SMTP id d63-v6so2463055oic.12
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 08:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A6YtqZewen9bOZz7bMmUQzrH7quAxAtMEV602kBUHE4=;
        b=mc0MhElmz3ouCJOLHnZy5U5Lohl+FJJWHVMjoLw2xvSzXLOLPb1uRtAr+MZLzQWO4+
         qxw/qWOYZvO6lfPkUt7eBa51IXa2EWUC93urQ7SQls7mhqQ/RC6gu1Xt9KbsSo+EjFBL
         u/Nnuy8JY1nv0fRDytgS+jHWkJo25YB9O6Ns875xyi0R8ychYHxaKYaRvm6DpB1doJxB
         hEikYlZ2wcLovg9CDfwIvIdAxZppKoh5dykq9z/2HeAUM7GsnxF7YcPIUK0x9HisKO5S
         pgCPD1+RsmkSGF/Cw6UpENXMnIxpSz8xS6JPfWZWQfr2EwPwXb/LEhbkvfbN3rr9DUbE
         c+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A6YtqZewen9bOZz7bMmUQzrH7quAxAtMEV602kBUHE4=;
        b=IAgqoScwqhRTXtSeITzYMwTn/KIAL9rjjr76CaVmz2l5t/lKJtZ/TOR592uTioYOZY
         nfXsHjvLRbvkCYirot/NjBWGHsP5d8uQE/dXexpWEvF2q/9scufVEuTMvXHcHB0FfT8c
         3IBuBcwpJLLMShxGAcZzd096uWy7Ljjia5Zr/GnS4uMpX13UJc1in4zDWP0T97/1WsUg
         ps/yRlj3tf1D79uZpXNj3G6qoBpJTW6W7mPW3klAK84OwMSmZWW3TJR27i2GWKAra+S4
         ohUXIh6OMSVwXLSe8s7FK9clCtsNQQDfvG4vvduHsU5IenbAC3TasIu56WwzF+e/8jhj
         EpYQ==
X-Gm-Message-State: ABuFfoiF9NMMwai92971KGNzGW6gMcSL83yd/aXLtyCO5He4COylhnMu
        0ZtByAyBKLsDHMiVLq5qA2d0nmWg
X-Google-Smtp-Source: ACcGV63Ve6yW4kr1aTl53BqsN8R0+xSIxN2WAH006clVc7W7aiKqMCGRznbw0apOtSuiCu3rbfnvbw==
X-Received: by 2002:aca:d785:: with SMTP id o127-v6mr488029oig.33.1538061664178;
        Thu, 27 Sep 2018 08:21:04 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v124-v6sm511645oia.10.2018.09.27.08.21.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 08:21:02 -0700 (PDT)
Subject: Re: Problems and suggestions to the kernel module r8723bs
To:     Simon Beginn <simonmicro@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <83c86a2a-0d2a-8119-2831-e9cfab7a43d7@simonmicro.de>
 <f0b67da4-747a-08e3-9744-fce2c74aaddc@lwfinger.net>
 <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
 <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
 <3a0468ee-e391-3b03-bfc5-36df484bce9d@simonmicro.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <9a7105c0-fd23-c7ff-3e28-62533c24cdb9@lwfinger.net>
Date:   Thu, 27 Sep 2018 10:21:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <3a0468ee-e391-3b03-bfc5-36df484bce9d@simonmicro.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/27/18 3:33 AM, Simon Beginn wrote:
>> Use the following command to get the baseline values: 
> Done - aand nothing changes (The access point has a strength of -60dB on my 
> desk). Well maybe the manufacturer has two antennas builtin. Yay - sorry for that.

That value means that the signal strength is way too low. One other possibility 
is that the chip has retained the setting and is not obeying the antenna number 
command. To check that, create a file (as root) named 
/etc/modprobe.d/50-r8723bs.conf, and add a single line containing "options 
r8723bs rtw_ant_num=2" (without the quotation marks). After that file is ready, 
then do a cold boot so that the chip has been power cycled. Finally, redo the 
signal test. Note: If your patch is applied, the above will not work!

> 
>> In dmesg
> Yep, too late. I've already installed the necessary firmware-files. But I didn't 
> wrote it, because the WiFi test wasn't performed until yet.
> 
> 
>> o the work to get the driver into the condition necessary for it to be in the 
>> regular tree. 
> Did my patch made it?

Your patch was not in the correct format to be accepted. Even if it had been 
correctly done, I would have NACKed it. Given the location of the driver, the 
name is what it should be. Once you, or someone else, has done the many hours to 
put that Realtek crap into proper kernel form, then it could be placed in the 
normal wireless tree and given the name rtl8723bs.

Larry

