Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CD3C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Oct 2022 15:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJLPa5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJLPaz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2022 11:30:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE70CA894;
        Wed, 12 Oct 2022 08:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC8B261556;
        Wed, 12 Oct 2022 15:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED87C433D6;
        Wed, 12 Oct 2022 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665588654;
        bh=XbTyHiZP7iedmm7OWxyWL6XwynJZBsCOZXG5smQEDEY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h5VkM9g3xva3tcH4oVEQmiSC6yrFLJ6fc30XwacHHqWZNmEcAVOPKAoKaCxAy24Fw
         kRqYXi9sD80EzZxNB8iDFt8iqFx3TSqAYKqN8/faBZNH3LLCq6y1lNIKZ3WxfnPTmY
         neGfZbH03nibY1yUoQ3NfVWuFr9r9YPiS7dlGrHs1SwMTSGRo/5WBg/+BRgqaUwv7h
         Yg5I79txZK6MXHEAq1MvodRBu/wlGsHOtte2WQ6MTC8mNm0Mg2BQfiB1airSknOQaY
         FUq4jm0qYS2s9H/m6lMggAZOpP+GmDrXAtkRd2ulEP+TxxolnxSoJ5b+QbA1yfb3vg
         f9CMJXJB6Enkg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Youghandhar Chintala <quic_youghand@quicinc.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2] wifi: ath10k: Delay the unmapping of the buffer
References: <20221012142733.32420-1-quic_youghand@quicinc.com>
        <1c64fe906b36438d63a7fc3fc9d0ab010b6db42f.camel@sipsolutions.net>
Date:   Wed, 12 Oct 2022 18:30:48 +0300
In-Reply-To: <1c64fe906b36438d63a7fc3fc9d0ab010b6db42f.camel@sipsolutions.net>
        (Johannes Berg's message of "Wed, 12 Oct 2022 16:49:03 +0200")
Message-ID: <87a661njo7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2022-10-12 at 19:57 +0530, Youghandhar Chintala wrote:
>> 
>> @@ -418,6 +426,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>>  		.dynamic_sar_support = false,
>>  		.hw_restart_disconnect = false,
>>  		.use_fw_tx_credits = true,
>> +		.delay_unmap_buffer = false,
>> 
>
> All the false are unnecessary and just distract from the content, imho.

In this case I actually prefer having explicitly set false (and zero),
it makes it easier to maintain the correct order and compare between
hardware values.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
