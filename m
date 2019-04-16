Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D3EC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 18:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77EF3206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 18:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWj/nbdB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfDPSyF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 14:54:05 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42602 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfDPSyF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 14:54:05 -0400
Received: by mail-lf1-f68.google.com with SMTP id w23so16815352lfc.9
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 11:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NF+hpszAjMCGeABt4p7v4UV2C6Ozg+UG8rAWDtvfDg4=;
        b=aWj/nbdBwhof/d0MA93fDk7v1k7VwbJtT3kUTkgQpy5gi6YEAX90wj/ZWvIPav/Kek
         wx1uGyhSeSJrCwY7TcJTE9T+UDBaxsmVHYkxoVHW52El/2BtxOACMPOH0x/4EKyUQZne
         FZjl9Hm7WZD0gZDwcHnMHVBnpglkgNhkpM9/cAmbGVY2Djw856nrbMw724aGl9LKaVAh
         3eFNMm6iPHbJMvObv3TFCJXL8wcw+uEOBHCCqjRJAl1ekZm7XRv6gn+RqvGEp7vpHwwB
         cb/x4x4aQ51Rlm8Z8R9UQuFM7SCDN/4Ai/IUQnzByiRF/v0dIJ4uoIwDdU/A48H80OFL
         pniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NF+hpszAjMCGeABt4p7v4UV2C6Ozg+UG8rAWDtvfDg4=;
        b=inCYBp1dJSmELER86WClDgOlnjXJE5SuUKUmL7pyZoLmhxBzGCMjq5Y8ffxDLwBzy1
         QfKosDQUck4agAbbFE0wHESv5IOJGiMHFx/hbxZ1oElMgYAFEFuwXilyu/UllBu8KIY7
         bzIR2Uq5sG37cp+oVGXqiraWFSZl+LsXDnhFsR4Y2/d5kXECMRvlyfpeHH/gnweqqyLT
         i+0mhKmuUzYVmCdZuqeS1NEJW7ZPTsZs+5IiOKuIUVZsxnrmRXQgoZqgfw19Mg+Oc2nx
         9BvLfFmfPyuPyKXbRpYXoC1q6JHFHHIwIvaYcbVUVUcVYsI3c3cNgrY9PpNBBbtCeEW6
         TW1g==
X-Gm-Message-State: APjAAAWDrNdCrfpaNDJfmWGmRvyPgeHhLaagqeDC8PmrLvHkV4CWl5Pm
        t520yCpSn6KFc/XsSc3WjSo=
X-Google-Smtp-Source: APXvYqwsE2xpRPRLAam0ddwBlEHvzkrTZ3vYThpUbhFvYx3dMuq8dI098DeZgr4T30llz3ZXd0b0Tg==
X-Received: by 2002:a19:cc52:: with SMTP id c79mr18715010lfg.30.1555440843147;
        Tue, 16 Apr 2019 11:54:03 -0700 (PDT)
Received: from [192.168.1.244] (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id d192sm1273790lfg.79.2019.04.16.11.54.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 11:54:02 -0700 (PDT)
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     yiboz@codeaurora.org
References: <20190327162906.6010-1-erik.stromdahl@gmail.com>
 <87bm1qq92j.fsf@toke.dk>
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <8772dfe6-3f52-05ca-f55a-b7eae14fa7ac@gmail.com>
Date:   Tue, 16 Apr 2019 20:54:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <87bm1qq92j.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 4/1/19 1:05 PM, Toke Høiland-Jørgensen wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> Iterating the TX queue and thereby dequeuing all available packets in the
>> queue could result in performance penalties on some SMP systems.
>>
>> The reason for this is most likely that the per-ac lock (active_txq_lock)
>> in mac80211 will be held by the CPU iterating the current queue.
>>
>> This will lock up other CPUs trying to push new messages on the TX
>> queue.
>>
>> Instead of iterating the queue we fetch just one packet at the time,
>> resulting in minimal starvation of the other CPUs.
> 
> Did you test this with Felix' patches reducing the time the lock is held
> in mac80211?
> 
> -Toke
> 
Hi Toke,

I am not aware of these patches. Can you please point them out for me?

--
Erik
