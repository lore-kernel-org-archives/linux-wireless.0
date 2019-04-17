Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95C5C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 13:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8559E2183F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 13:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ijXJ4Hk5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbfDQN3p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:29:45 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44278 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfDQN3p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 09:29:45 -0400
Received: by mail-lj1-f195.google.com with SMTP id h16so22422913ljg.11
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 06:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k34N3gps91EU20+ydS5LyclJPetqIy2+W1gaqPnsdmU=;
        b=ijXJ4Hk5esNaiDWYkbYfmDm6wQ6B5elHGgJ9Dx41TMaLbEgv74CgrFQawnrMHJqJhy
         GD8ia4QN94I3l31Rs9JgPc/VmygNNJPM3GvyO1lgXR5bLvy/rSYCjh02A7ZzEuurZ4R5
         3MQkU3YmjdVIuvNAZ53uCj5KNVDJbeiLXD0PPPUHkk/ASYx498AaiF6qGf3tWq0PrREO
         OfiGmGoxs22EIiK/5aUNEgsM2pv7VNSpQnWZXHYIiaHDrmeeqBQbMHCoPDI8sL0MVj5a
         lp7B31pbWqP9QQfGhqWON27d6QZgibDHgnD1xOZfQwYNVdnBdEQYVSgQWE3kN8FluvZc
         yvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k34N3gps91EU20+ydS5LyclJPetqIy2+W1gaqPnsdmU=;
        b=E//R1CS+GmXB59UJNOINiKNnLuT4dH9GXIyDEOGGzbQxz8xVBfmGSaHTQMob6RmLpI
         li6d1R7tMpa9RPxI8cd8sQUuDTZdV5XmKtPKj9DzTc1VCD/zwIrNcoTnqiEm3cGLXPWa
         JCnFDjDNmlGTKlbeaNWi9sHA9M5FmcM2DfqPvF/ecGD2uYHV23W3x0sxcoqs/uVZrw37
         3oRsa4xk/pHBQMeP5gj3wnOhu7SBUZSTDxNrpFrzdmv5K75Q0Q8QbK0wBbs/T1loSgYY
         q+vuwit5IaC+2d1mL02mcUZXbYer+hGiBYZi832583Xus9XjiP3HasMz4ZyZjMoO6yS+
         OK4Q==
X-Gm-Message-State: APjAAAWcZuPVDSrrxUtNKa9K6zBFCSflF8HJeCCGxF+nJjzvSuDz8fyl
        Y/VJESTRqjWHvxsTsWJOcpI=
X-Google-Smtp-Source: APXvYqz8B3YOAno4I4uofiK8laz18i2nDED+/vlWkGfnQNZnRdjJYGutl7hs885vAkymYLOlfCUhEw==
X-Received: by 2002:a2e:8149:: with SMTP id t9mr50113825ljg.2.1555507783484;
        Wed, 17 Apr 2019 06:29:43 -0700 (PDT)
Received: from [192.168.1.244] (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id e17sm10808270ljj.20.2019.04.17.06.29.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 06:29:42 -0700 (PDT)
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     yiboz@codeaurora.org
References: <20190327162906.6010-1-erik.stromdahl@gmail.com>
 <87bm1qq92j.fsf@toke.dk> <8772dfe6-3f52-05ca-f55a-b7eae14fa7ac@gmail.com>
 <87imvdu5u8.fsf@toke.dk>
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <f915fa20-a4e1-7312-dea2-d60b716e4877@gmail.com>
Date:   Wed, 17 Apr 2019 15:29:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <87imvdu5u8.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 4/16/19 9:07 PM, Toke Høiland-Jørgensen wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> On 4/1/19 1:05 PM, Toke Høiland-Jørgensen wrote:
>>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>>
>>>> Iterating the TX queue and thereby dequeuing all available packets in the
>>>> queue could result in performance penalties on some SMP systems.
>>>>
>>>> The reason for this is most likely that the per-ac lock (active_txq_lock)
>>>> in mac80211 will be held by the CPU iterating the current queue.
>>>>
>>>> This will lock up other CPUs trying to push new messages on the TX
>>>> queue.
>>>>
>>>> Instead of iterating the queue we fetch just one packet at the time,
>>>> resulting in minimal starvation of the other CPUs.
>>>
>>> Did you test this with Felix' patches reducing the time the lock is held
>>> in mac80211?
>>>
>>> -Toke
>>>
>> Hi Toke,
>>
>> I am not aware of these patches. Can you please point them out for me?
> 
> They've already been merged. Commits dcec1d9bc8a7 and 7ef769459f14 in
> mac80211-next :)
> 
> -Toke
> 

I see. I am using the ath tree and I couldn't find them there.
I can cherry-pick them to my own tree and try them out
(or wait until Kalle updates ath.git).

--
Erik
