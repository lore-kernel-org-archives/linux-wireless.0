Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4166AC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 01:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E89D20835
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 01:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jRfQuXg4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mENzBKWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfCDB4n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 20:56:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfCDB4m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 20:56:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4A5EB601FE; Mon,  4 Mar 2019 01:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551664601;
        bh=BQAjh8vr0NrWhgNZRrWmgdTYeD0kWc5QrI2K6+oZq24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jRfQuXg40bEcouhEehox2XjXhJ8c9UBJRIajWr9acrGijEn262DFoGXjwWcb0c4ZW
         4fxQr9rVcRsAWsrmsDGAtwPm3FM8wwDToGlbOXMk8wv55CEa6nbETuEKXef0qANBQ7
         WwNMw78d7jWgy0BWqMFXaenofHD/Fgp5puKfYJ3I=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 54E19601FE;
        Mon,  4 Mar 2019 01:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551664600;
        bh=BQAjh8vr0NrWhgNZRrWmgdTYeD0kWc5QrI2K6+oZq24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mENzBKWU2UNR91ugIeF6oi+TISNo3Jm1p8qb0yYYfBN56y02Yw6QS+UD3i9GLY8V6
         9yKy4CGcCrlMIEXj10+MyKS7v6AFovmMxrzb4dkvT5N8xTbwy2wLONFDFr6DWdEN6r
         99PodYa/WahpKvUnIKfSKOKqJ4QcvsCG478AaE8E=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 04 Mar 2019 09:56:40 +0800
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     erik.stromdahl@gmail.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless-owner@vger.kernel.org
Subject: Re: FW: [PATCH] ath10k: fix return value check in wake_tx_q op
In-Reply-To: <a1c113622b9aec9b32393c0a3e159e32@codeaurora.org>
References: <20180506132500.16888-1-erik.stromdahl@gmail.com>
 <6dc00772b826410e930306891fd13ed9@euamsexm01f.eu.qualcomm.com>
 <c77a1c0961f34ee68b7266444d2207f5@aptaiexm02e.ap.qualcomm.com>
 <66a74025a23795f305de37989c1b8aa3@codeaurora.org>
 <87sgwz8ylw.fsf@kamboji.qca.qualcomm.com>
 <a1c113622b9aec9b32393c0a3e159e32@codeaurora.org>
Message-ID: <4dadbeebe8dc1e911cc4871d767b4ed1@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

在 2019-02-25 12:40，Yibo Zhao 写道：
> 在 2019-02-07 22:25，Kalle Valo 写道：
>> Yibo Zhao <yiboz@codeaurora.org> writes:
>> 
>>> We have met performance issue on our two-core system after applying
>>> your patch. In WDS mode, we found that the peak throughput in TCP-DL
>>> and UDP-DL dropped more than 10% compared with previous one. And in
>>> some cases, though throughput stays the same, one CPU usage rises
>>> about 20% which leads to 10% in total CPU usage. With your change, I
>>> think driver will try its best to push as many packets as it can.
>>> During this time, the driver's queue lock will be held for too much
>>> time in one CPU and as a result, the other CPU will be blocked if it
>>> wants to acquired the same lock. Working in this way seems not
>>> efficiency.
>>> 
>>> So I think it is better to revert the change till we come up with a
>>> new solution.
>> 
>> I don't think reverting is a clear option at this stage because that
>> again creates problems for SDIO. IIRC without this patch SDIO was
>> sending one packet a time (or something like that, can't remember all
>> the details right now).
>> 
> 
> Below is the aqm result after 1 min test with Erik's patch.
> 
> target 19999us interval 99999us ecn yes
> tid ac backlog-bytes backlog-packets new-flows drops marks overlimit
> collisions tx-bytes tx-packets flags
> 0 2 0 0 5342229 0 0 0 0 3867657029 5342229 0x0(RUN)
> 1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 6 0 0 0 2 0 0 0 0 144 2 0x0(RUN)
> 7 0 0 0 2 0 0 0 0 282 2 0x0(RUN)
> 8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 
> we see no difference between tx-packets and new-flows.
> Whereas if we revert the patch, we get：
> 
> target 19999us interval 99999us ecn yes
> tid ac backlog-bytes backlog-packets new-flows drops marks overlimit
> collisions tx-bytes tx-packets flags
> 0 2 0 0 2233059 3 0 9236 12 1159661783 6380867 0x0(RUN)
> 1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 6 0 0 0 1 0 0 0 0 144 2 0x0(RUN)
> 7 0 0 0 1 0 0 0 0 282 2 0x0(RUN)
> 8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
> 
> new-flows are roughly one-third of the total tx-packets.
> 
> IMHO, with Erik's change, Erik's change has changed the way fq's
> schedule behavior and it looks like there is no other packets in the
> fq after a packet has been dequeued. And as a result, this flow's
> deficit will be refill and then removed from fq list at once in the
> same CPU. And during this time, the other CPU could be blocked. When
> new packet comes, same thing happens. So we get equal new flows and
> tx-packets.
> 
> Things would be different without Erik's change. After a packet has
> been dequeued, this flow's deficit will not be refill immediately in
> CPU0. It is possible that the deficit to be refilled in CPU1 while at
> the same time CPU0 can fetch data from ethernet. So we can see more
> tx-packets delivered to FW from aqm.
> 
> 
>> Why does this happen only WDS mode? Did you test other modes, like AP 
>> or
>> client mode?
> AP mode has same issue. UDP throughput drops more than 10%. As for
> TCP, CPU usage rising a lot although throughput stays similiar.
> So, I'd say Erik's change does not work for us.

Hi Kalle,

May I have your comments?

-- 
Yibo
