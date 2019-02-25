Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0CBC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 11:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8671A2147C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 11:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfBYLEq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:04:46 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43240 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfBYLEq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 06:04:46 -0500
Received: by mail-ed1-f66.google.com with SMTP id m35so7156436ede.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2019 03:04:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=b1idVCXsv1IvVIviNvpJvbTXP3RZ954g96CFAeH1TrA=;
        b=CBUfq0ATo68ur0SY7HwiZrNescGbBEqTjMbsPtIXh1ztzovAAjIyFopGNvFbMg7Rah
         ueUAgdP4v5g5bZmcgqmaB0xkcohI+EoVoGMVORsa6M0nxZexkXOQedVhDX8f8fjeoXVW
         Z+3avSjWjp20KLw21wlLIi5e4FLqh9CYCl0KXj3BDv0Tjp3MdR6hKh45/LotlrN4ht3G
         pLMZN/UqiawTr098vK+iQqItNVDApPcf6WTGkGXX80Rh4BSxu+5E5txvRUdEvP7vLjT3
         xjVFL+vOXNBkEsDe4pivSakGQ9BpLW0c/9veX0H2/idAro6Oab9qO7HziraN5+rT7Lym
         vLeg==
X-Gm-Message-State: AHQUAuY9nzJ05rfE78yWksm5uUQYP2OPTac3cgRtaYcuUYFsiEJ6qsti
        7tx0wt0t4jRiYTZfoTJllag8dQ==
X-Google-Smtp-Source: AHgI3IZAZrcmdP+OWRQNQeBTPczjTC7CAQNjI/F6ehDA+oFkih59uO3vyHqCqIGPyZsuxJnazTKDZg==
X-Received: by 2002:a50:b639:: with SMTP id b54mr13823604ede.229.1551092684534;
        Mon, 25 Feb 2019 03:04:44 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id n38sm2611330edn.95.2019.02.25.03.04.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 03:04:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7FC7218350A; Mon, 25 Feb 2019 12:04:43 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove set but not used variable 'acq'
In-Reply-To: <877edom8vl.fsf@kamboji.qca.qualcomm.com>
References: <20190225033246.127410-1-yuehaibing@huawei.com> <87lg24urgq.fsf@toke.dk> <87ftscmbh7.fsf@kamboji.qca.qualcomm.com> <87imx8uor2.fsf@toke.dk> <877edom8vl.fsf@kamboji.qca.qualcomm.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 Feb 2019 12:04:43 +0100
Message-ID: <877edouo1g.fsf@toke.dk>
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
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>
>>> Toke Høiland-Jørgensen <toke@redhat.com> writes:
>>>
>>>> YueHaibing <yuehaibing@huawei.com> writes:
>>>>
>>>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>>>
>>>>> drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_rx_count_airtime':
>>>>> drivers/net/wireless/ath/ath9k/recv.c:1010:18: warning:
>>>>>  variable 'acq' set but not used [-Wunused-but-set-variable]
>>>>>
>>>>> It's not used after 89cea7493a34 ("ath9k: Switch to mac80211 TXQ scheduling
>>>>> and airtime APIs"). Also remove related variables.
>>>>
>>>> Ah, right, seems I forgot to clean that up. I wonder why I didn't get a
>>>> compiler warning for it.
>>>
>>> I think the warning is not enabled by default and you need to use W=1
>>> Makefile variable to enable it.
>>
>> Hmm, right, thanks! Guess I should get into the habit of compiling with
>> warnings enabled before submitting patches :)
>
> But you might get a lot of warnings and it could be difficult to find
> new warnings from all the noise. In ath10k I just fixed all W=1 warnings
> which I saw with gcc 8.1 and only now I was able to enable W=1 on my
> build script.

Ah, that was what that patch series was about :)

Right, well, I guess I'll give it a shot at some point and if it's not
too annoying I'll try to keep an eye on the warnings output...

-Toke
