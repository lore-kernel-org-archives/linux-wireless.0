Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED54DC0032E
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Oct 2023 09:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjJYJJX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Oct 2023 05:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjJYJJW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2023 05:09:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E99136
        for <linux-wireless@vger.kernel.org>; Wed, 25 Oct 2023 02:09:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8A9C433C8;
        Wed, 25 Oct 2023 09:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698224958;
        bh=ItsyWWnSe2Fsg7MQVBc0Wc5NeoaWrB1B1RIE7BbXM9U=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=P5Hm5noUQ3/FU0gD9NuyWUcrj1IFnS4d0FKD1VWjsyoX5qnFw9qquA4LhmLXJr9D5
         mcaRIedklfXM8K9Ubaq1dLkWoLoY5IsIsUuI6/giNXxnxhneYr4/KhlkZ/AeYmKoxb
         KMAkbcgniaLeHMZ6F8NyNN9FxkcYSENcXX08FtT08ENkGZze+hVX9jveVNzzD01Uu8
         SimCF8E/Y1IdZtmvVZezm8psurcA+kyUuXVt5zN1xtAYdMKbPbuZntp5CqO8sv5XX1
         ZOOrGNs2eWQTe5UETIXW7/DqvDL9g9+1dsnqWydZyZaLyDmKNp+70FHVr1kAKa4WCP
         DSWaKq8NPxr/w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v2] wifi: rtw89: cleanup firmware elements parsing
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20231020040940.33154-1-dmantipov@yandex.ru>
References: <20231020040940.33154-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Tom Rix <trix@redhat.com>,
        linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169822495599.836535.4324036715351093593.kvalo@kernel.org>
Date:   Wed, 25 Oct 2023 09:09:17 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> When compiling with clang-18, I've noticed the following:
> 
> drivers/net/wireless/realtek/rtw89/fw.c:389:28: warning: cast to smaller
> integer type 'enum rtw89_fw_type' from 'const void *' [-Wvoid-pointer-to-enum-cast]
>   389 |         enum rtw89_fw_type type = (enum rtw89_fw_type)data;
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/realtek/rtw89/fw.c:569:13: warning: cast to smaller
> integer type 'enum rtw89_rf_path' from 'const void *' [-Wvoid-pointer-to-enum-cast]
>   569 |                 rf_path = (enum rtw89_rf_path)data;
>       |                           ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> So avoid brutal everything-to-const-void-and-back casts, introduce
> 'union rtw89_fw_element_arg' to pass parameters to element handler
> callbacks, and adjust all of the related bits accordingly. Compile
> tested only.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Patch applied to wireless-next.git, thanks.

7d7b6f2953b3 wifi: rtw89: cleanup firmware elements parsing

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20231020040940.33154-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

