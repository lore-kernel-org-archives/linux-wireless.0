Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E51C25B47
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Oct 2023 08:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbjJ0I3E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Oct 2023 04:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345562AbjJ0I2x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2023 04:28:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BFED42
        for <linux-wireless@vger.kernel.org>; Fri, 27 Oct 2023 01:22:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6B4C433C8;
        Fri, 27 Oct 2023 08:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698394975;
        bh=Nt7iWTc2zlF5adOjywSKI6AgxjT55FIpazXgJLLWuSY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RbBNacKVnk01cggLRGk6iVxpvrTpY3LGYVf1kZRGZQq8cZ/XYEOU7qVfQNRWPCwTY
         pbT+XeUeV4fCNi7HhIMpOPVqw4LvZ0VvdYj3OJ9nbC93mmos4qc22YW9+7C9/PBdPY
         qac08mOV+MHV1RAbcxkv7Y238h+mG4lqyy+zZBOp5rzeBOWNui/kXGS322NOZjrlGm
         7H9CK7hRHgDBHUN69mAhFlJU00OCadbZO3PYMhfBZpcqy4x/Zd8rOH9OcA+F/1gKrO
         25Y2PVhALfuINhdlsRUp05prz0P5q0MmZ5KbCsTgGiP+ZJkdkBP3BRWPg3+p4T32w6
         r7iEOfkG044tw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: rtlwifi: fix USB device initialization sequence
References: <20231027075920.116006-1-dmantipov@yandex.ru>
Date:   Fri, 27 Oct 2023 11:22:52 +0300
In-Reply-To: <20231027075920.116006-1-dmantipov@yandex.ru> (Dmitry Antipov's
        message of "Fri, 27 Oct 2023 10:59:17 +0300")
Message-ID: <87pm10wk2r.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> writes:

> Do not ignore possible errors in '_rtl_usb_init()' and tweak error
> handling in 'rtl_usb_probe()' to ensure that 'rtl_usb_cleanup()' is
> called when needed. Minor style adjustments, compile tested only.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Patches like this should be tested on a real device, compile testing is
not enough. We don't know if there are hidden errors which this patch
then exposes.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
