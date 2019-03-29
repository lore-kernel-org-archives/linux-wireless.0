Return-Path: <SRS0=IiY2=SA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721D3C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 07:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 391DE2173C
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 07:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lt/abiOl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbfC2Hrh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:47:37 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41467 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbfC2Hrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Mar 2019 03:47:37 -0400
Received: by mail-lf1-f67.google.com with SMTP id 10so769434lfr.8
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2019 00:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=16RBw0sHtutcmtKVgf3xkE3boQ6rSkgjVpd92UD/a+E=;
        b=lt/abiOl1fHdNjOEaZ3soZj7OXwAGpyK7finCpprCnDZjQW8hw7uALGsdxq6IVdoAW
         tPjE1EnTfEn/51gXVBkNuwbMSFmPIBjvmN0FQSNRmrIx1xMuRpRx8Kyv4uS9VIwp34iJ
         yLgvRir6XKbrkPbHatEqKgJjZZwUewCKrGoqlFRC1b4+X+f0HWdT7rpP4+ii33GLF8CN
         va4RS5IaAtj8ozIUs5JRinx8LIhne5ckRQbk6qDKK8kuQYq0ZkGv+4aHA62Ghfrcr3rk
         Ayq0WsDnICJeN2kcbZOd3Py0Z+dXhQ+tyMH8IiL5ucnJSccpnEHvauhLOOfoZV7TzQXx
         OHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=16RBw0sHtutcmtKVgf3xkE3boQ6rSkgjVpd92UD/a+E=;
        b=sYiiK0Kqu6MlS72l3SAOwc2/w4XA0FWswMO2jS4Aekax+7usKEM+/GQHWvm76LX3Re
         S8ffy129SJmCPm0SlEASYv4A1YdPYo06cYwx+kVVuAg3O+w0PZFtvFLPEClXDJGgR3RY
         i3a8uAJDCJ0uvOWfjfoh+3mNV/3nRFKEbRahpqj/1jZtCVzz6f0blry6EYtvpONj0HNq
         3Q4EB2Rd64D1Owka+EKTG1+YSiUK6gNljnm8TCK9vxaecEjBphkF19c7r2aVlxZ1C93j
         lXv+cF7akjV26dSMAxTwera6xKYslxydWGG84qlwMhqrDgFbJTZeCx/ZrqHcbT0g0tpp
         VQzg==
X-Gm-Message-State: APjAAAXChnI1Pue+BGx6sSBxV4fItRxBZYXbV2ZMbxgJRO+VoVOUzp4i
        ENMHln86elwPRLruGxwj8wM=
X-Google-Smtp-Source: APXvYqwEwhtASnOe8d1Kj/SQPuz7eM6KrY3dyn4O6rudjMagmxQ4QfafcOkwYQhUwsL1NvUVhmMMmA==
X-Received: by 2002:ac2:4354:: with SMTP id o20mr10742506lfl.62.1553845654913;
        Fri, 29 Mar 2019 00:47:34 -0700 (PDT)
Received: from [192.168.1.244] (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id n5sm177748lfh.6.2019.03.29.00.47.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Mar 2019 00:47:33 -0700 (PDT)
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
To:     Peter Oh <peter.oh@bowerswilkins.com>,
        "kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc:     "yiboz@codeaurora.org" <yiboz@codeaurora.org>
References: <20190327162906.6010-1-erik.stromdahl@gmail.com>
 <ba7a88e5-10ff-2ec2-feee-6d4adf472833@bowerswilkins.com>
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <fd76296d-e88e-1dbd-b3d2-e9e7edc7f49d@gmail.com>
Date:   Fri, 29 Mar 2019 08:47:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <ba7a88e5-10ff-2ec2-feee-6d4adf472833@bowerswilkins.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 3/27/19 6:49 PM, Peter Oh wrote:
> 
> 
> On 03/27/2019 09:29 AM, Erik Stromdahl wrote:
>> Iterating the TX queue and thereby dequeuing all available packets in the
>> queue could result in performance penalties on some SMP systems.
>>
> Please share the test results and numbers you've run to help others
> thoughts.
> 

I haven't run any tests with ath10k PCIe, but Yibo Zhao had noticed a 10%
degradation without this patch.

Yibo:
Can you provide iperf results etc. that shows the performance gain?

--
Erik
