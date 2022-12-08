Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5E6C4332F
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Dec 2022 14:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiLHOxU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Dec 2022 09:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiLHOxJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2022 09:53:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949A452179;
        Thu,  8 Dec 2022 06:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44371B82430;
        Thu,  8 Dec 2022 14:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10E8C433B5;
        Thu,  8 Dec 2022 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670511186;
        bh=s3+CRbiAS1Mf7mwZjAfK8WQ6JhcbNz9b4X8Tl0txCHc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=P6QdbqA1xUHufUN8PgHMoIc3B8r7dQZWaC5ujqiIFNOdkUxNE7heOS6KTPeH+hUxw
         b5Tqo1sRSJ8E4MGY85sG475tu6ZZ6/aiXiFIJFVtELRwJmrnqBmRkuo+dJ4rSmsi03
         ky5rQOxgDhJBMLyltKt9z2qVJ70nmeHhct2BY951drI3r3IRPnH2B1Ifq0qNWtuud6
         fQzDVLeULuB447k9lX+cZ3ICN3l3hOqCYbDdU5PnfsEJ4muW8+nsBuH6dWqRLgW6YE
         ylpFle6PO6IKVIiv6phA2J2DNtEuuwfXiRece4dKhuForEnw0hRJQ1gwJ1mjyOUQAS
         XGkTRrNQc7Nag==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtlwifi: btcoexist: fix conditions branches that are never
 executed
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221206104919.739746-1-pkosyh@yandex.ru>
References: <20221206104919.739746-1-pkosyh@yandex.ru>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167051118209.9839.1379337821162033883.kvalo@kernel.org>
Date:   Thu,  8 Dec 2022 14:53:03 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Peter Kosyh <pkosyh@yandex.ru> wrote:

> Commit 40ca18823515 ("rtlwifi: btcoex: 23b 1ant: fine tune for wifi not
>  connected") introduced never executed branches.
> 
> Compile test only.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

e48c45318d3d wifi: rtlwifi: btcoexist: fix conditions branches that are never executed

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221206104919.739746-1-pkosyh@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

