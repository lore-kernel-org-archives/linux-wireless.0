Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E290CC43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 09:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC75820675
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 09:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfCGJqU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 04:46:20 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44103 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfCGJqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 04:46:20 -0500
Received: by mail-ed1-f67.google.com with SMTP id b20so12853898edw.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2019 01:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BtfS1JxvO5l5x76oAhH/IioKddwHqs1WM3Ak4UG8Dsc=;
        b=Y+pKob0UX9vJDMjqkqP0VOSRu3pt54RiUzRWDtdaBUBfmCoxxNefRHUeJOf7Hzk6mm
         zRo11YXDbcR5P3/ewiuJlSMiQLWmD/JySkb8SyMBRdx0DK/ziwPJu9vXwN/9rjjCdVNF
         ED5PcXBNC9FLdRfxIK8tmXJ3V3o2dPiP67LDO3CEALSPjbedIh+IEdD9sVH0PiX61F4P
         Ocgzh+CZfcRWOa226SJv0Tv2UGYezCe7icVgTdl+2G1V3AWe5ln4lFgsskSc9c9NWvy7
         IJEJp3C3FHW0K2emIhJA9lvpvJWDfxwpQf1XuZfL4e/AWV1vzdN9K8nwmyDrXdMCVdJ0
         U9OA==
X-Gm-Message-State: APjAAAX2a6afV/6z3IgdvKVXw4bIBXEiizyTDOwMLKnk8OCy8ZIYatFq
        Bi/SQpmGkJlebVkjcdmmUfI42g==
X-Google-Smtp-Source: APXvYqwHATPpAvubJGDzL0BAkCUHrZ8ZsSgPKqjkZCmnnmJ+Y3fnN1qAevFZtYYN3B3Eriqz4qzbsw==
X-Received: by 2002:a17:906:3fd1:: with SMTP id k17mr7137803ejj.87.1551951978473;
        Thu, 07 Mar 2019 01:46:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id t25sm790381ejr.30.2019.03.07.01.46.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Mar 2019 01:46:17 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6E886182F5B; Thu,  7 Mar 2019 10:46:17 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <69d22b9e3ea08a81fea8b8742cb697c5@codeaurora.org>
References: <20190215170512.31512-1-toke@redhat.com> <87va0x1g0j.fsf@toke.dk> <69d22b9e3ea08a81fea8b8742cb697c5@codeaurora.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 07 Mar 2019 10:46:17 +0100
Message-ID: <87wolbyq3a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2019-03-05 07:45, Toke Høiland-Jørgensen wrote:
>> Toke Høiland-Jørgensen <toke@redhat.com> writes:
>> 
>>> This switches the airtime scheduler in mac80211 to use a virtual 
>>> time-based
>>> scheduler instead of the round-robin scheduler used before. This has a
>>> couple of advantages:
>>> 
>>> - No need to sync up the round-robin scheduler in firmware/hardware 
>>> with
>>>   the round-robin airtime scheduler.
>>> 
>>> - If several stations are eligible for transmission we can schedule 
>>> both of
>>>   them; no need to hard-block the scheduling rotation until the head 
>>> of the
>>>   queue has used up its quantum.
>>> 
>>> - The check of whether a station is eligible for transmission becomes
>>>   simpler (in ieee80211_txq_may_transmit()).
>>> 
>>> The drawback is that scheduling becomes slightly more expensive, as we 
>>> need
>>> to maintain an rbtree of TXQs sorted by virtual time. This means that
>>> ieee80211_register_airtime() becomes O(logN) in the number of 
>>> currently
>>> scheduled TXQs. However, hopefully this number rarely grows too big 
>>> (it's
>>> only TXQs currently backlogged, not all associated stations), so it
>>> shouldn't be too big of an issue.
>>> 
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>>> This is basically the idea I mentioned earlier for a different way to
>>> handle the airtime scheduling.
>>> 
>>> I've tested it on ath9k, where it achieves the same fairness and
>>> weighing properties as the old scheduler. It would be good if you 
>>> could
>>> test it on your ath10k setup, Rajkumar; and all of you please comment 
>>> on
>>> whether you agree that this is better from an API point of view.
>> 
>> So no one has any comments on this? :)
>> 
> Toke,
>
> This is kind of design change. ;)

Yup, that was kinda the point ;)

> FMU w.r.t ath10k, earlier deficit adjustment and list rotation happens
> at next_txq and may_transmit. Now it seems the rbtree adjustment
> happens upon new txq insertion through wake_txq and whenever driver
> reports airtime by register_airtime. Am I right?

Yes. This change was, in part, motivated by the discussions we had
around your patches to ath10k, and the need to make the round-robin
schedulers sync up. I consider that a bit of a hack which this approach
avoids.

> We are using pretty old kernel (3.14, 4.4). It definitely needs backport 
> of rbtree.

Well I wasn't necessarily planning for this to be backported. It doesn't
change the driver API, and *in theory the aggregate fairness behaviour
should be the same between the two scheduling approaches (famous last
words). Verifying that this is actually the case is why I'm asking for
testing.

Also, isn't rbtree pretty old? A git blame on rbtree.c suggests it goes
all the way back to the 2.6 era...

> Have you used *Wrt image or validation on x86?

I have only tested this on x86 with a mac80211-next-based kernel...

-Toke
