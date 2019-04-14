Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779E8C10F13
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 16:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FD732084E
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 16:53:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IljFZ1vc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfDNQx5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 12:53:57 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40662 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfDNQx5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 12:53:57 -0400
Received: by mail-lf1-f67.google.com with SMTP id a28so11197188lfo.7
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2019 09:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HG2Fi0GU+Ukb8JudfF2zHbWzqMfgk+eiIYEvopGArLM=;
        b=IljFZ1vc8Ul/c07Pg9goXG5Sx9lblJ8VPJpalxlEcEUnqutQlaNLmAZNUXZ6uGLal2
         F1zolVwkrze1BTCNQVrdIxlWZJCusgOBN1Y1jGH7VLzqkx1j6epMT48y9Xz0dfWvOiOW
         AIGv17xExUxygob6r7QiOxhsoXPaEw6BTlAd/ACQ7UwmeM7CGRPJCE3E7qPTbdMnRqqn
         KSvNDwedhNg2UdML/nJHz+BLCPLMabwOdC89lvkI7gxt63+HmxmTPSlUs3e7iFH/Eerc
         fZIq2hrF7XS/CaNpnA6Li7dVMdoyy2A1wi5fHYCBbID80pHcgZ1Hc5AfRefE+KNqKTeq
         GW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HG2Fi0GU+Ukb8JudfF2zHbWzqMfgk+eiIYEvopGArLM=;
        b=Dn/ydQOEkD6jOsbBzTUAZOLOnljNl61yBYZZqtxgG//Mu+2earOIwGOr1deONBb5U7
         7rNMWDi2NQ7Exko7H/RU4/7r95BOuAYb/Ao4ojIDlEfVp6a0fLi0HTcnWcJKQk7oFTq8
         qcA+B2VvoxyanL3qI3tsSJzOmlkl7+pafjySHV/qFMZBFXosPTBaoFIyu+S5GPe3UKkr
         g3vh8ofk6pj5T2iWxPrQfcGVDqYA4FgAEarYkbenZCVIp+SvUZsiHanfaRw5MZJTGDip
         dCGR/kR0X6HLqSC+rMr9UMQptnVYX2q8T58GHhz7EpLO7oGzd2kVg6Fmk1Uitcr5oxbY
         i+uQ==
X-Gm-Message-State: APjAAAVQRcTMAocTVGXTxhImdX6IJxQHn+u+W9b33ALqD/j2gTAbU5xA
        goy17IXWGW76R+ghA7w0GkjByyma
X-Google-Smtp-Source: APXvYqzkMBx2AKno58FwnlYZ0tMEKOkxUBeakG1i3jCiu+cV14/BQxk1OYZP89xCOinPG/pbKgOWTA==
X-Received: by 2002:a05:6512:c8:: with SMTP id c8mr18884295lfp.138.1555260835166;
        Sun, 14 Apr 2019 09:53:55 -0700 (PDT)
Received: from [192.168.1.244] (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id g6sm9537304lja.64.2019.04.14.09.53.53
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Apr 2019 09:53:54 -0700 (PDT)
Subject: Re: [PATCH 0/6] ath10k: SDIO and high latency patches from Silex
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
 <87pnprflj4.fsf@kamboji.qca.qualcomm.com>
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <7b74fac8-2f9e-12c8-bf83-8403aca55d06@gmail.com>
Date:   Sun, 14 Apr 2019 18:53:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <87pnprflj4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 4/12/19 2:36 PM, Kalle Valo wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> This series adds a few more fixes for SDIO and high latency devices.
>>
>> I have had these on my private tree for quite some time now so they
>> should be considered fairly well tested.
>>
>> 4 out of 6 patches are from Alagu Sankar at Silex.
>> I have made some adjustments to some of them in order to make them
>> smaller and easier to review.
>>
>> Alagu Sankar (4):
>>    ath10k: use clean packet headers
>>    ath10k: high latency fixes for beacon buffer
>>    ath10k: sdio: read RX packets in bundles
>>    ath10k: sdio: add MSDU ID allocation in HTT TX path
>>
>> Erik Stromdahl (2):
>>    ath10k: sdio: add missing error check
>>    ath10k: sdio: replace skb_trim with explicit set of skb->len
> 
> Bad timing as also me and Wen have been cleaning up these patches and
> finalising the SDIO support so our work overlapped. I'll send our
> version of patches soon and we can then compare.
> 
Ok, I will rework these patches and apply them on top of yours and Wen's.
I'll send a v2 set later.
