Return-Path: <SRS0=Sl5Z=XU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B74DC432C2
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 05:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F199921D7B
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 05:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dHje5Ybp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZuUtTWbV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411805AbfIYFvq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Sep 2019 01:51:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404696AbfIYFvq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Sep 2019 01:51:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 21C78602F2; Wed, 25 Sep 2019 05:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569390704;
        bh=NeEFZDrD5NaVYEmvXkuToUi48FcsuLzZxJyEwdPTkGE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dHje5Ybpl+BFyuvGMxmQgEIBoDShRh9U8IGBMu2iYbTFRPoibBBPa4Nzrfux2wXKX
         uBThAC0R5vZOFONZo4SfJQt8o1ZZyVtosG9IApi9GTapPWhHxQfrGrxECoCXLvAFbe
         hfsVWPLkw9xJ5MOAIg1PgBgnewEPlaklEqSJ/lrA=
Received: from x230.qca.qualcomm.com (37-136-106-186.rev.dnainternet.fi [37.136.106.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3996C602F2;
        Wed, 25 Sep 2019 05:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569390703;
        bh=NeEFZDrD5NaVYEmvXkuToUi48FcsuLzZxJyEwdPTkGE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZuUtTWbVRuRvXPCjtRcyqxH4jRE/x0q3ryyGQHBc15TZiOj/YHlCVRo1VS3bUkCqU
         6gbckZcqXlVzTWVE6jdEizsCc7CihjxyZo775K1Jjlv9mPgG39/X0Hy7F4DQwgK+c2
         Pe3ysytiP8HcV5nTLkEyOuDHTOe0FpQeWxGcxHQo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3996C602F2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 3/5] ath10k: sdio: read RX packets in bundles
References: <20190417191503.18814-4-erik.stromdahl@gmail.com>
        <20190925054517.11D3E611FA@smtp.codeaurora.org>
Date:   Wed, 25 Sep 2019 08:51:39 +0300
In-Reply-To: <20190925054517.11D3E611FA@smtp.codeaurora.org> (Kalle Valo's
        message of "Wed, 25 Sep 2019 05:45:17 +0000 (UTC)")
Message-ID: <87o8z82aac.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
>
>> From: Alagu Sankar <alagusankar@silex-india.com>
>> 
>> The existing implementation of initiating multiple sdio transfers for
>> receive bundling is slowing down the receive speed.
>> 
>> Instead of having one sdio transfer for each packet in the bundle, we
>> read all packets in one sdio transfer.
>> 
>> This results in significant performance improvement on some targets.
>> 
>> On an imx6dl together with a QCA9377 SDIO device, the following
>> performance increase was obtained with iperf:
>> 
>> Before:
>> 
>> [  3]  0.0- 1.0 sec  3.38 MBytes  28.3 Mbits/sec
>> 
>> After:
>> 
>> [  3]  0.0- 1.0 sec  7.12 MBytes  59.8 Mbits/sec
>> 
>> Co-developed-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>
> Wen is working on this:
>
> [v5,2/8] ath10k: enable RX bundle receive for sdio
>
> https://patchwork.kernel.org/patch/11132661/
>
> So I'll drop this version. Patch set to Superseded.

There were invalid characters and linux-wireless dropped my mail,
resending now.

-- 
Kalle Valo
