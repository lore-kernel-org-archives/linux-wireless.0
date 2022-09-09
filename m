Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A52ECAAA1
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Sep 2022 09:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiIIJGH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiIIJFf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2022 05:05:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B0E9FA84
        for <linux-wireless@vger.kernel.org>; Fri,  9 Sep 2022 02:05:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63C81B82403
        for <linux-wireless@vger.kernel.org>; Fri,  9 Sep 2022 09:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBDBC433D7;
        Fri,  9 Sep 2022 09:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662714298;
        bh=x0+8r++HF6A1wPLEFxJcCLQRHIbcMl/u00vuBrLUSTs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XhsNmAgKg/oro78SWFyn0ig2b+K2ELW8bWCBbEIw1JDmwYrLmNeosblU3CpbgHPDa
         bs9gNvsMHL03hFc752YjVKAygCCcf08XTt/7TSKt3VFXPCslHS3AO4QJXci19h2suE
         PtqgE3WbzstaA7/5j/A0s7WqPLtqIZtfCv9nC9PlWPCuyPucYlAKK34fGhXIMmpZ1T
         9U0krSfCqgSXQ6mo3EADJOpJvGQDusCtnxaAlvFRhxoqA2vnd+MP03cwMlhVDZ0kB1
         dJM0MG8YORbGRXBKe5/RykjwZyn9QfeEdAxVDaK6oU+NcR+DHWUJOuCzCZRMTdh+ip
         cK0YjiqSwpN/A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wifi: cfg80211: Fix MCS divisor value
References: <20220908181034.9936-1-quic_tamizhr@quicinc.com>
Date:   Fri, 09 Sep 2022 12:04:51 +0300
In-Reply-To: <20220908181034.9936-1-quic_tamizhr@quicinc.com> (Tamizh Chelvam
        Raja's message of "Thu, 8 Sep 2022 23:40:34 +0530")
Message-ID: <87fsh0c40c.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tamizh Chelvam Raja <quic_tamizhr@quicinc.com> writes:

> Bitrate for HE/EHT MCS6 is calculated wrongly due to the incorrect
> MCS divisor value for mcs6. Fix it with the proper value.
>
> previous mcs_divisor value = (11769/6144) = 1.915527
>
> fixed mcs_divisor value = (11377/6144) = 1.851725
>
> Fixes 9c97c88d2 ("cfg80211: Add support to calculate and report 4096-QAM HE rates")

The format for Fixes tag should be:

Fixes: 9c97c88d2f4b ("cfg80211: Add support to calculate and report 4096-QAM HE rates")

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
