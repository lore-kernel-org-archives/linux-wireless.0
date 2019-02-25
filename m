Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0583C4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80BB620842
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfBYKtZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 05:49:25 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37573 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfBYKtY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 05:49:24 -0500
Received: by mail-ed1-f67.google.com with SMTP id m12so7147545edv.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2019 02:49:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ySnZJQb8HYXWHTXrW1Gz70w6DQKTKHNRsl/h8Oj7Kyw=;
        b=q11eBfsIpOKUfv0HgwWaVWJXlQEaZBF2jHzk/CYOrgVbTHoDblE8khQ8o/f/G6WKDB
         3iRnQf+3h9uip4uKM0jSnDATa1/R76Ma5w0UH9VgugGDj5sgS+wKoetKfhKWrTR9wKmu
         jXHHrBsoW7TngoQWmc/5nP2f/fXsFt6rZa3dmIG72LRI6rfp1fiC79bX0bZA6M2BZXAc
         O02cQK/iWBHMN/M92eFCtI8+zDET3yBEG2RoUeQFl6tSNea4p28aM+8DR7M0ub+D27N3
         pqpY48J+fW0Rm3hxm81MvYZczMucGeTnpC/IAAZ14dFRXx/Bqn7ytFXSOAwdX/VWvpgP
         xBVg==
X-Gm-Message-State: AHQUAuZrbDZINMW0bySbKOaSOu1cCVjXpbRC4GHwryFYoRdedZHoj/Ru
        LHR/Ky0lL8C9ZqKaSEysNTRIHw==
X-Google-Smtp-Source: AHgI3IYN9NdD01FAx3OiiqV/fPnqkNZIbaJ5/NdrK68+8R/WTDd6m7Nlv86gu8CXVarYywuFrKTVRQ==
X-Received: by 2002:aa7:d685:: with SMTP id d5mr13852294edr.203.1551091762875;
        Mon, 25 Feb 2019 02:49:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id b29sm2620611eda.48.2019.02.25.02.49.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 02:49:21 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1D4B118350A; Mon, 25 Feb 2019 11:49:21 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove set but not used variable 'acq'
In-Reply-To: <87ftscmbh7.fsf@kamboji.qca.qualcomm.com>
References: <20190225033246.127410-1-yuehaibing@huawei.com> <87lg24urgq.fsf@toke.dk> <87ftscmbh7.fsf@kamboji.qca.qualcomm.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 Feb 2019 11:49:21 +0100
Message-ID: <87imx8uor2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Toke Høiland-Jørgensen <toke@redhat.com> writes:
>
>> YueHaibing <yuehaibing@huawei.com> writes:
>>
>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>
>>> drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_rx_count_airtime':
>>> drivers/net/wireless/ath/ath9k/recv.c:1010:18: warning:
>>>  variable 'acq' set but not used [-Wunused-but-set-variable]
>>>
>>> It's not used after 89cea7493a34 ("ath9k: Switch to mac80211 TXQ scheduling
>>> and airtime APIs"). Also remove related variables.
>>
>> Ah, right, seems I forgot to clean that up. I wonder why I didn't get a
>> compiler warning for it.
>
> I think the warning is not enabled by default and you need to use W=1
> Makefile variable to enable it.

Hmm, right, thanks! Guess I should get into the habit of compiling with
warnings enabled before submitting patches :)

-Toke
