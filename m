Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43812C433FE
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Nov 2022 17:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiKDRdC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Nov 2022 13:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDRdB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2022 13:33:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061DC10B52;
        Fri,  4 Nov 2022 10:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4399B82EEA;
        Fri,  4 Nov 2022 17:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA6EC433D6;
        Fri,  4 Nov 2022 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667583177;
        bh=SWRatb17xTHl4s28Zj1jbA+PlvS1RrYpNXsGZweuD1w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WjBsxfxa0R/tEmF0Cx/sTQ6SLEZDsig41Fx+1eB8HtaEcomwn/g4SewcHrb0SAfv2
         Nf9fjtrEAdbc2WtDNk1aNRsxhJWHSWJ0r25bzTQZsXaf/MXauopyjrDWREICQ7WtBz
         TJ86MIZOPaoQ6Vc0Dzn2V3idAcMYE0sk4YvMMTZ2SdkL3kQVDTJtu+eoeUBkLSmG5/
         rYBQH06QLltS6Qc9z6kN4ELKR0R5suOP6R/xWZvo61EqNUeYpzYOkZo6J3yv0AG9H5
         HszUpHg+BfzgOYSOvfiNr9X+va606TM69YfzN0x5oqBwCCyJQG9udZ0Mh4iVnzTH7U
         tT1bvIWcLXNpA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: remove redundant variable len
References: <20221104135036.225628-1-colin.i.king@gmail.com>
Date:   Fri, 04 Nov 2022 19:32:53 +0200
In-Reply-To: <20221104135036.225628-1-colin.i.king@gmail.com> (Colin Ian
        King's message of "Fri, 4 Nov 2022 13:50:36 +0000")
Message-ID: <874jvevd4q.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> writes:

> Variable len is being assigned and modified but it is never
> used. The variable is redundant and can be removed.
>
> Cleans up clang scan build warning:
> warning: variable 'len' set but not used [-Wunused-but-set-variable]
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

For future wireless patches please add "wifi: " to the subject. I can
edit the subject during commit so no need to resend.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
