Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EE5C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 12:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 677622082C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 12:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DGRpYMe7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ss/HqHCP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfDAMRc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:17:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44608 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfDAMRc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 08:17:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 17F4561230; Mon,  1 Apr 2019 12:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554121051;
        bh=g2p1PEMJCnMGUFi2ezHIsIUqBTIvs0vNwTLSEO0vqB4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DGRpYMe7Nu8YjGhGRfeU5iPfEaGnxhchlyedEhbA9aFypxP2m6oq19LwtSzkrB0mU
         9ZGteXlqynBZy2iVO7sFhEv9uJm7MRfTVdrJ4ybOGhr4ul7EwWESDyWBfJMfG1ED3X
         PpWC3iOudT9Y9uG6kPe2dbLLCR4sMIV6IKlyBHRM=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 12EBD6086B;
        Mon,  1 Apr 2019 12:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554121049;
        bh=g2p1PEMJCnMGUFi2ezHIsIUqBTIvs0vNwTLSEO0vqB4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ss/HqHCPT9aalJ3h9R53zxMQ2uRo4jNmmYCg/Af8hNW4Xu5jP7JvP7fYZHlmdUiNJ
         TPyZhF10ONpu3BSJLIx0rcjMvFwy85OV17Ooor27XPVeFdRTpVa9jRAW1wQCr5SHWN
         4ilkB+NNv5eMVfjhpYwTTEfV5wGSsukNJ7P9ePYc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Apr 2019 20:17:28 +0800
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     Peter Oh <peter.oh@bowerswilkins.com>, kvalo@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
In-Reply-To: <fd76296d-e88e-1dbd-b3d2-e9e7edc7f49d@gmail.com>
References: <20190327162906.6010-1-erik.stromdahl@gmail.com>
 <ba7a88e5-10ff-2ec2-feee-6d4adf472833@bowerswilkins.com>
 <fd76296d-e88e-1dbd-b3d2-e9e7edc7f49d@gmail.com>
Message-ID: <07f403379ca955f2867b29d8f6a2e457@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-29 15:47, Erik Stromdahl wrote:
> On 3/27/19 6:49 PM, Peter Oh wrote:
>> 
>> 
>> On 03/27/2019 09:29 AM, Erik Stromdahl wrote:
>>> Iterating the TX queue and thereby dequeuing all available packets in 
>>> the
>>> queue could result in performance penalties on some SMP systems.
>>> 
>> Please share the test results and numbers you've run to help others
>> thoughts.
>> 
> 
> I haven't run any tests with ath10k PCIe, but Yibo Zhao had noticed a 
> 10%
> degradation without this patch.
> 
> Yibo:
> Can you provide iperf results etc. that shows the performance gain?

My tests are based on ixchariot with cabled setup(two-core AP system).
WDS mode--10% deviation:
With previous change: UDP DL-1246 Mbps
W/O previous change:  UDP DL-987 Mbps

Normal mode:
With previous change: UDP DL-1380 Mbps
W/O previous change:  UDP DL-1310 Mbps

Also attached the aqm status.

With previous change:

tid ac backlog-bytes backlog-packets new-flows drops marks overlimit 
collisions tx-bytes tx-packets flags
0 2 0 0 5342229 0 0 0 0 3867657029 5342229 0x0(RUN)
1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
6 0 0 0 2 0 0 0 0 144 2 0x0(RUN)
7 0 0 0 2 0 0 0 0 282 2 0x0(RUN)
8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)

we see no difference between tx-packets and new-flows.

W/O previous change:

tid ac backlog-bytes backlog-packets new-flows drops marks overlimit 
collisions tx-bytes tx-packets flags
0 2 0 0 2233059 3 0 9236 12 1159661783 6380867 0x0(RUN)
1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
6 0 0 0 1 0 0 0 0 144 2 0x0(RUN)
7 0 0 0 1 0 0 0 0 282 2 0x0(RUN)
8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)

new-flows are roughly one-third of the total tx-packets.

> 
> --
> Erik

-- 
Yibo
