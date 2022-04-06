Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518CDC433F5
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Apr 2022 11:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiDFLxS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Apr 2022 07:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiDFLwq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Apr 2022 07:52:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014484FD765;
        Wed,  6 Apr 2022 00:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30602CE1BEF;
        Wed,  6 Apr 2022 07:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CCFC385A1;
        Wed,  6 Apr 2022 07:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649228799;
        bh=+qHR/F28NpTwCRHANOdIvvIwSZLcHmNjSA+4wHvU6B8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gQBjvlC+YXsBjpc6P4TUkOsNfSP6YbP1F4dmX5vG2WMM/IxIf16OL7Q6pG7op+Vcw
         D7CBUywdqMEpklEvoaR3kiGsVUf9gmlmnKj0CpiFdI5n7DBR+ADkrJGI1fpqr499/Z
         Q8yN+1ksGqORLbGfgGCOFogK0h34EGVepcunKeeQ/zYH2N0piEFjYIziZIytGKWFoz
         6lJq2Q3jb/ObvwIvqzPPngZWhEdmUUpFsNq9CFHMymr05riZJxWU2wamGF5YtGN3dD
         Ktq8dEWfPb40bhgGphzVvKnsCAuHyfR4RUD5iWY2NueVSiB+4zDPwJ+eUeaIx6wr3V
         DSGLYpuOe7nDQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <YhojjHGp4EfsTpnG@kroah.com> <87wnhhsr9m.fsf@kernel.org>
        <5830958.DvuYhMxLoT@pc-42> <878rslt975.fsf@tynnyri.adurom.net>
        <20220404232247.01cc6567@kernel.org>
        <20220404232930.05dd49cf@kernel.org> <878rskrod1.fsf@kernel.org>
        <20220405092046.465ff7e5@kernel.org>
Date:   Wed, 06 Apr 2022 10:06:33 +0300
In-Reply-To: <20220405092046.465ff7e5@kernel.org> (Jakub Kicinski's message of
        "Tue, 5 Apr 2022 09:20:46 -0700")
Message-ID: <875ynmr8qu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 05 Apr 2022 10:16:58 +0300 Kalle Valo wrote:
>> Sure, that would technically work. But I just think it's cleaner to use
>> -rc1 (or later) as the baseline for an immutable branch. If the baseline
>> is an arbitrary commit somewhere within merge windows commits, it's more
>> work for everyone to verify the branch is suitable.
>> 
>> Also in general I would also prefer to base -next trees to -rc1 or newer
>> to make the bisect cleaner. The less we need to test kernels from the
>> merge window (ie. commits after the final release and before -rc1) the
>> better.
>> 
>> But this is just a small wish from me, I fully understand that it might
>> be too much changes to your process. Wanted to point out this anyway.
>
> Forwarded!

Awesome, thank you Jakub!

Greg, I now created an immutable branch for moving wfx from
drivers/staging to drivers/net/wireless/silabs:

git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git wfx-move-out-of-staging

The baseline for this branch is v5.18-rc1. If you think the branch is
ok, please pull it to staging-next and let me know. I can then pull the
branch to wireless-next and the transition should be complete. And do
let me know if there are any problems.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
