Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E7BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 02:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE4D12087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 02:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VrC8mhV3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VrC8mhV3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfCLCXf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 22:23:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44416 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfCLCXf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 22:23:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC0FB60386; Tue, 12 Mar 2019 02:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552357414;
        bh=SjbaDMDlTbxDKaRAqRvFo7pKMyGV74MGHyp10wfNfW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VrC8mhV3CgF+sc1H43M0Pb54fsx0ZVm2xPGYJWu3e6vGm9336KLdAaBQqutiZU3Yw
         Z8b3L9/f14gdu8mJi9Sgd0qZTDTuROZcX5e/yrO9OKobLjnV6yYIwpiXP10y3vpGxD
         pwyx1nV9xUSSYTq0l9jpfprAzyNSlmL2RhutzjvU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 5008B60A24;
        Tue, 12 Mar 2019 02:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552357414;
        bh=SjbaDMDlTbxDKaRAqRvFo7pKMyGV74MGHyp10wfNfW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VrC8mhV3CgF+sc1H43M0Pb54fsx0ZVm2xPGYJWu3e6vGm9336KLdAaBQqutiZU3Yw
         Z8b3L9/f14gdu8mJi9Sgd0qZTDTuROZcX5e/yrO9OKobLjnV6yYIwpiXP10y3vpGxD
         pwyx1nV9xUSSYTq0l9jpfprAzyNSlmL2RhutzjvU=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 12 Mar 2019 10:23:34 +0800
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless-owner@vger.kernel.org
Subject: Re: FW: [PATCH] ath10k: fix return value check in wake_tx_q op
In-Reply-To: <8c882c7d-41e3-cdc9-34ae-6446970dbc52@gmail.com>
References: <20180506132500.16888-1-erik.stromdahl@gmail.com>
 <6dc00772b826410e930306891fd13ed9@euamsexm01f.eu.qualcomm.com>
 <c77a1c0961f34ee68b7266444d2207f5@aptaiexm02e.ap.qualcomm.com>
 <66a74025a23795f305de37989c1b8aa3@codeaurora.org>
 <87sgwz8ylw.fsf@kamboji.qca.qualcomm.com>
 <a1c113622b9aec9b32393c0a3e159e32@codeaurora.org>
 <4dadbeebe8dc1e911cc4871d767b4ed1@codeaurora.org>
 <8c882c7d-41e3-cdc9-34ae-6446970dbc52@gmail.com>
Message-ID: <671c9c3a172ecc164c1ee45cfb1ccd71@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-11 14:44, Erik Stromdahl wrote:
> Hi Yibo,
> 
> Sorry for a late reply, but I have been busy with other projects 
> lately.
> I have added my comments below
> 
> On 3/4/19 2:56 AM, Yibo Zhao wrote:
>> 在 2019-02-25 12:40，Yibo Zhao 写道：
>>> 在 2019-02-07 22:25，Kalle Valo 写道：
>>>> Yibo Zhao <yiboz@codeaurora.org> writes:
> 
> I have a few patches related to bundling of TX packets on my private 
> repo.
> I have not yet had the time to prepare them for submission.
> This patch is related to that work, but I decided to submit it 
> separately
> since I considered it a bugfix.

Great! Really looking forward to your new patch.

> 
> <snip>
> 
>>> 
>>> IMHO, with Erik's change, Erik's change has changed the way fq's
>>> schedule behavior and it looks like there is no other packets in the
>>> fq after a packet has been dequeued. And as a result, this flow's
>>> deficit will be refill and then removed from fq list at once in the
>>> same CPU. And during this time, the other CPU could be blocked. When
>>> new packet comes, same thing happens. So we get equal new flows and
>>> tx-packets.
>>> 
>>> Things would be different without Erik's change. After a packet has
>>> been dequeued, this flow's deficit will not be refill immediately in
>>> CPU0. It is possible that the deficit to be refilled in CPU1 while at
>>> the same time CPU0 can fetch data from ethernet. So we can see more
>>> tx-packets delivered to FW from aqm.
>>> 
>>> 
>>>> Why does this happen only WDS mode? Did you test other modes, like 
>>>> AP or
>>>> client mode?
>>> AP mode has same issue. UDP throughput drops more than 10%. As for
>>> TCP, CPU usage rising a lot although throughput stays similiar.
>>> So, I'd say Erik's change does not work for us.
>> 
>> Hi Kalle,
>> 
>> May I have your comments?
>> 
> 
> As I wrote in the commit message, the original code will always break 
> out of
> the loop after just one iteration.
> 
> It is OK with me to bring back the old logic, but I think we should 
> skip the
> loop entirely then.
> 
> Something like this:
> 
> if (ath10k_mac_tx_can_push(hw, txq)) {
> 	ath10k_mac_tx_push_txq(hw, txq);
> }
Yes, it is the exact way we tried in our private repo. And it works fine 
in our setup so far. Not sure it is ok for other situations. Have you 
tested on your sdio setup with this change? Any issue observed?
> 
> 
> Btw, I noticed that the "fair scheduling" mechanism (derived from 
> ath9k) from
> Toke have been integrated.
> 
> I haven't rebased my tree for a while, so I will most likely have to 
> rewrite
> my patches anyway in order to make them work with the new TX 
> scheduling.

-- 
Yibo
