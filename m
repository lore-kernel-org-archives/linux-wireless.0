Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790C6C77B60
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Apr 2023 15:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjD2PAt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Apr 2023 11:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjD2PAs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2023 11:00:48 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B2C19B9
        for <linux-wireless@vger.kernel.org>; Sat, 29 Apr 2023 08:00:47 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6a5f6349ec3so412286a34.0
        for <linux-wireless@vger.kernel.org>; Sat, 29 Apr 2023 08:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682780446; x=1685372446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hxCcphzHKsgwBSqSThef3vPtIBWM7ciRS2Y6UXdBq1o=;
        b=ZSSsuyuWtLXPY+KrPHQWvsviMQpOrI2BSFFBDmkRbDNWxuEDDetFs4wCcssBxjZlLN
         aVX20dcFfie47W7ecyz5IT/iaaeZc2My6lAJLKC79IR2tadEGDFmeXJ+AT3zcYXw6ae4
         bmgrgvh+urRpRR9rggb5tj8Im8O/r0D62gNJVOwsIoe1mCkxQE2aQJyfzn9e1R7vPI1+
         DCOB1YuyHDnwLM3Pp+Jbk4OekXPOPT42TFsv9w8jAQP2Nq98DsO04zmPrSElVQ5LXhgE
         xODMuyRR80IKXauzyPdOc6iDQLimpgNahMsaokToMpQmpnBum85qFy1p5hVCowlHbnKU
         duhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682780446; x=1685372446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hxCcphzHKsgwBSqSThef3vPtIBWM7ciRS2Y6UXdBq1o=;
        b=cic1YFvr0M0fhXnIBJ94p37dWcGslnD8FAz/vQVT75aJYxe8+eql6UblVTzRjEv6MK
         s1q9yA0364o0xVGA9DQyVEQTTGJ7VhIgu8Njz3tXjI8yEXqKpMarzr1DPsYMI4tckFZc
         0qGi4tSmcDnXwk+ENljs0HloEUMhmLG1Nd/BHDZdlSHnxkRW+6h8hi7zULNgUH5mtHMG
         zN6nXJw2jmivtpP7PmOTtMFq1vdPtCGIi/EVHGDjUi0JJSkuISOiYmVidr768PuTVF3C
         LRltqpFD8lSVf2MvcpR7m8AbB8oR8BC2c4XH+xLlRRaBvLqM5/ygAaJZ0yTvyOQCeTwl
         j3mQ==
X-Gm-Message-State: AC+VfDxmrWJb3i1yxVXNnpN9TBMsjJy+e3Wey/Am2NWoLYXUkuffo+8S
        Jm1YfArSbR3ONnZ8/dNiA6M=
X-Google-Smtp-Source: ACHHUZ6J3XFHXp9yDwGLS6LJMnAKN/CotirgLtKIYPnldsfEbCYi0LKMzM5b+cTFezIaEx6vSEgifA==
X-Received: by 2002:a05:6808:1801:b0:390:9228:c772 with SMTP id bh1-20020a056808180100b003909228c772mr4246490oib.52.1682780446546;
        Sat, 29 Apr 2023 08:00:46 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id z23-20020a056808029700b0038c66c39131sm9921655oic.5.2023.04.29.08.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Apr 2023 08:00:46 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <bab0c273-cf13-38e5-40ff-78285e746d47@lwfinger.net>
Date:   Sat, 29 Apr 2023 10:00:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] wifi: rtlwifi: rtl8192cu: Remove driver
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20230428182933.19157-1-Larry.Finger@lwfinger.net>
 <87pm7nqn61.fsf@kernel.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <87pm7nqn61.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/29/23 00:20, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> The functionality of these devices has been replaced by the rtl8xxxu
>> driver, thus the version under rtlwifi can be removed.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Should I take this to wireless tree for v6.4?

That is your choice, but I see no problems with including it in 6.4.

Larry


