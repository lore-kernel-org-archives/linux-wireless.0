Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0837C4332F
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Nov 2022 06:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiKSGmX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Nov 2022 01:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSGmX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2022 01:42:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8533EB6B32;
        Fri, 18 Nov 2022 22:42:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED9460A70;
        Sat, 19 Nov 2022 06:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C89C433C1;
        Sat, 19 Nov 2022 06:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668840141;
        bh=MYzMOrXhZYnAskvSQxTcQL89+bTXl9cw9C7LIKijM/c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Od5Lm8+/EupnP5GexQQjYDTfSUIKiMA0njT0lBLr/nxN2yCj5sEUSbyA56m5+1UUE
         CqSN9PyB778jTd8Pq/POM6aor1e+UH5BJM3o70aaE+130v/sT8Fzv1KWcZGzLqwrp5
         6aTRPFtRT71VwAseMSj9kUzxqJ+xS9v4lXmlsr8Vhpe6XTI/By/PbQfgkssmUAC+9+
         YRFRvYJoP9FGv78viXbPNXOZRao/yPkcl2zihMzt0dbPSXtvVQi/xlKM8PqLVQlD7M
         2Iq2yJ2167TAh3zSEWQLOCcgsURPE+7nD6q2XUfjF3YOygu65SOSs6vQNQ6d1vIR5H
         GFjimYY8vWaJA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <srini.raju@purelifi.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()
References: <20221119051900.1192401-1-william.xuanziyang@huawei.com>
Date:   Sat, 19 Nov 2022 08:42:16 +0200
In-Reply-To: <20221119051900.1192401-1-william.xuanziyang@huawei.com> (Ziyang
        Xuan's message of "Sat, 19 Nov 2022 13:19:00 +0800")
Message-ID: <87v8nbphrr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ziyang Xuan <william.xuanziyang@huawei.com> writes:

> urbs does not be freed in exception paths in __lf_x_usb_enable_rx().
> That will trigger memory leak. To fix it, add kfree() for urbs within
> "error" label. Compile tested only.
>
> Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/wireless/purelifi/plfxlc/usb.c | 1 +
>  1 file changed, 1 insertion(+)

plfxlc patches go to wireless tree, not net. But I think I'll take this
to wireless-next actually.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
