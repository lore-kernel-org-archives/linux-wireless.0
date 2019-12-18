Return-Path: <SRS0=gBLi=2I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7DCC43603
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 02:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE25E21582
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 02:12:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="rYsCqbyh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfLRCM2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Dec 2019 21:12:28 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:51381 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLRCM2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Dec 2019 21:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=6WLqXU5/gbK10W8fO9D9QGVt2yPBkaTAhbB6ArSqfrQ=;
        b=rYsCqbyhyjdCE+CC4UML99qXFhOW1lvyafL5pvD8WMYKFWIXyUQpeXPTriwKEL8htW8nJhn26QdQW6sm6+pcs29iDo7i7p4pttxRiPyvhV84FXXD7KD8wlztPz/vfhk/N3UxpUhja9ABAEfUdIskAvE9jt0nrtM2IF6E+KfpZFY=;
Subject: Re: [PATCH] ath10k: Per-chain rssi should sum the secondary channels
To:     Tom Psyborg <pozega.tomislav@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Cc:     Justin Capella <justincapella@gmail.com>,
        linux-wireless@vger.kernel.org, ath10k <ath10k@lists.infradead.org>
References: <20191216220747.887-1-greearb@candelatech.com>
 <a2af03e9-8b53-b297-467b-d0f07b8a002b@newmedia-net.de>
 <b5d63d96-4ba6-bbab-bf1c-a61c6c437f37@newmedia-net.de>
 <80700614-679a-336e-bd9a-e88622e75c9a@candelatech.com>
 <4775d91a-9719-46f8-b0f2-979b8d86cf9f@newmedia-net.de>
 <CAMrEMU-vGB8uR-JZbD2vj4vXgWNHfFqcbsqB=gOqBBDZWGkzQA@mail.gmail.com>
 <11290a30-46e8-638e-4110-86e6b2eb3d3f@candelatech.com>
 <CAKR_QV+xNbAzzw12x3Ku49bHnERTxYRAK8AfUSwp_uOgNMbY4Q@mail.gmail.com>
 <a95e7f6d-1cb8-3188-aea4-233dce6f9330@candelatech.com>
 <CAKR_QVL0P4qYidtqLwhhacCOpx2iq+4RRhTXbGhfRnf2PUj5tA@mail.gmail.com>
 <CAKR_QV+KV1dR_QKjANL34DGJuyf3OSN8J6gs3bqcmiRCCzkdXA@mail.gmail.com>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <5e3f22d1-b8ba-d756-a15c-1e7ae56c1dad@newmedia-net.de>
Date:   Wed, 18 Dec 2019 03:12:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAKR_QV+KV1dR_QKjANL34DGJuyf3OSN8J6gs3bqcmiRCCzkdXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f0e:3a00:383d:f7f7:6179:80c8]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1ihOnl-00065C-Qy; Wed, 18 Dec 2019 03:11:01 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

i dont know what you want to compare here.

1. you compare 2 different wifi chipsets. both have different 
sensititivy and overall output power spec

2. both have different amount of antenna chains. which does make a 
difference in input sensitivity

3. the patch ben made has no effect on qca9880 chipsets. it only takes 
effect on 10.4 based chipsets like 9984


about noise floors in general. noise floors of -108 are bogus. there is 
a physical limit a noise level can be.
since drivers like ath9k are doing a cyclic calibration, the noise value 
might indeed change. but this calibration is
not running in realtime. its cyclic. i'm not aware if chipsets like 
qca988x are going the same way, but since qca988x
has sime similaries with ath9k chipsets unlike the newer 9984 variants, 
it could be. the 30 seconds mentioned
in the bug report fits to my expectations of the early noisefloor 
calibration which has a short delay and after success
turning to use a long delay. anyway. in this early calibration phase 
signals might change and will stabilize after. this isnt a issue
since your connection will work anyway even if it might take a little 
bit longer if you have poor signal levels

@ben. am i wrong or what do think?

Sebastian

Am 18.12.2019 um 00:37 schrieb Tom Psyborg:
> also noticed now that the noise floor changes with signal strength as
> described in this bug report:
> https://www.mail-archive.com/ath10k@lists.infradead.org/msg11553.html
>
> after wifi restart
>
> iwinfo:
>
> signal: -59dBm noise: -108dBm
>
> then goes to
>
> signal: -52dBm noise: -103dBm
>
> and finally drops to
>
> signal: -59dBm noise: -103dBm
>
