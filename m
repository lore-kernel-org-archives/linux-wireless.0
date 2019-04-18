Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6425AC10F0B
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 08:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2690D214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 08:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387971AbfDRIPW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 04:15:22 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34153 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfDRIPV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 04:15:21 -0400
Received: by mail-ed1-f68.google.com with SMTP id a6so1076985edv.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2019 01:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ijbm3Iix0w0z8E7I3HpvHzANFijZg+oT1HFJFsblOw8=;
        b=To3CxK0kPNV38OiQsQJpACuiC/7n6paXDHPp0NPjpZBF6VTo5iKtK6D6ExGll1T91s
         Ri31y59cZYNSDlfaIrn+aokhJtPlLHiqqNq3JHYvBEPEjpDxk9BH9rTWsobQ/iCLqOUJ
         BVgt7wcyJ79ValpZ+hAhq8p0hesFam639d9G3/CVVWWAFzRibhOafp5jRSAzSSzamxFs
         BRUFkvNEUf1RKXOYmh6mC4kjR2mv+dZzwtFn7bBmaN5PfcYMZbOjHSbjQSz2PbOPLi6H
         kcXCCYQuXLgtqmG0uAAxmF/OId6p4OS0TdtyvRsW5iPYGXSY/5awm07L/rqkjsXSrXh+
         WRBw==
X-Gm-Message-State: APjAAAUMy262LLSdOqqpIPMdaHjXaiWkxAOS1BkokNCbYq5odpD9b+C3
        5Z7SOoFLAGed+B4g0HvjQPe3PAUJLDQ=
X-Google-Smtp-Source: APXvYqxhcFIzaOE2CEKkQ57kd6iET2IWbEB6iZIoYiL98D4LAc8eltTtUdTqSDlhZlcv9S8c+q7C7g==
X-Received: by 2002:a50:b3b1:: with SMTP id s46mr60004952edd.202.1555575319711;
        Thu, 18 Apr 2019 01:15:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id t9sm251257ejg.54.2019.04.18.01.15.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Apr 2019 01:15:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 714D21800E8; Thu, 18 Apr 2019 09:07:45 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     leiwa@codeaurora.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: fix different tx duration output
In-Reply-To: <298a645b17aac0f5c466f011225533b0@codeaurora.org>
References: <1555489045-18070-1-git-send-email-leiwa@codeaurora.org> <87mukprnie.fsf@toke.dk> <298a645b17aac0f5c466f011225533b0@codeaurora.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 18 Apr 2019 09:07:45 +0100
Message-ID: <875zrbrb1q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

leiwa@codeaurora.org writes:

> On 2019-04-17 17:26, Toke Høiland-Jørgensen wrote:
>> Lei Wang <leiwa@codeaurora.org> writes:
>> 
>>> TX duration output of tx_stats in debugfs and station dump had big
>>> difference because they got tx duration value from different statistic
>>> data. We should use the same statistic data.
>> 
>> So are you sure you picked the most accurate one of the two? :)
>> 
>> -Toke
>
> Hi Toke,
>
> Yes.
> Now for ath10k, there are two ways to get tx duration output.
> One is got from tx_stats in debugfs reported by firmware. It is a total 
> value including all the frames which created by host and firmware sent 
> to the peer.
> And the second is calculated from 
> ath10k_htt_rx_tx_compl_ind()-->ieee80211_sta_register_airtime(), here 
> the tx duration just includes the data frames sent from host to the 
> peer.

So the difference is that the former includes control frames as well? Is
that the only difference? And what exactly is a "big difference" (from
the commit message)?

> So the first value is preferable for station dump.

Hmm, I'm not sure if I agree with this. I specifically added the
tx_duration to the station dump to be able to get the values used by the
airtime scheduler. This breaks with this patch.

-Toke
