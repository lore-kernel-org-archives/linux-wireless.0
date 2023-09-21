Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10026E7D0AB
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Sep 2023 21:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjIUVDH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjIUVCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2023 17:02:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25058460C
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2023 10:37:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA16C3277E;
        Thu, 21 Sep 2023 09:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695288803;
        bh=FiyvDDyQXOk9mEoVrRM/ZvJn/EUsTPSIK411BiFrc0Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YD+izcjPV92elhwxpEyPnheRz4LMTobpTbkhbgPcr3+cHmjGMpZwdXNu7WvedEyqW
         FK8d8Degn8Nx/io9BYLzxM4ZzkTB85UuzLUig+mcOQ5TeZ/JvA7BlNWKjYtRaEwDdV
         7WzhkLVXHrIFYeeoKpu9bzblzK/smIfhaIZBml3oBDiTb6ausWw1nG4F6JMqLEjZ/K
         Xu/0qmPx62v3P47FyN9T0T7a18s60PpwzEE8Oljl3wbkp5rZgmkNKtSGjzcVXFembG
         rluYTVFhvr0pcC5kuTmh9R16Fw9EwytIe/GpKWkxMucVGDr2EnhMnHjxtvfVWCJGWI
         R9/TeuU0Dhw+g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-wireless@vger.kernel.org, lvc-project@linuxtesting.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 1/6] [v3] wifi: ath10k: cleanup CE ring initialization
References: <997f4b09-7087-4788-aa2a-ef835ce6ebb3@quicinc.com>
        <20230824055117.42309-1-dmantipov@yandex.ru>
        <874jjpashn.fsf@kernel.org>
        <75483209-4ac1-305f-83fb-9e9affc104fe@yandex.ru>
Date:   Thu, 21 Sep 2023 12:33:20 +0300
In-Reply-To: <75483209-4ac1-305f-83fb-9e9affc104fe@yandex.ru> (Dmitry
        Antipov's message of "Thu, 21 Sep 2023 11:58:13 +0300")
Message-ID: <87sf77an1b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> writes:

>> If most/all of the functions return the same error value type as int
>> it makes a lot easier to read the code.
>
> ...but still not sure that this is reasonable for any non-trivial piece
> of the source code.

What's the concrete benefit from having few functions which return void
instead of 'return 0'? For me the benefit would have to be significant
justifying the code churn and the time used.

> OTOH if both you and Jeff are agreed on preserving existing ath1x style,
> I will definitely take this decision into account and try to redesign
> this series in attempt to fit the current design as much as possible.

Please stop fixing the design (unless you are the driver maintainer or
asked specifically by one) as that doesn't really benefit anyone,
actually the opposite. Instead focus on fixing actual bugs. But if you
have no means for testing your fixes then stick to compiler warnings and
similar.

For example, didn't I suggest you about fixing all sparse warnings in
wireless code? I would be very happy to get such patches as we really
would want to be sparse warning free.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
