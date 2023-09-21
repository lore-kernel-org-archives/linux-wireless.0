Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8325E7D0B3
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Sep 2023 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjIUVFs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjIUVEl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2023 17:04:41 -0400
Received: from forward501c.mail.yandex.net (forward501c.mail.yandex.net [IPv6:2a02:6b8:c03:500:1:45:d181:d501])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10714CB1B
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2023 10:14:47 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-54.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-54.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1e27:0:640:d1a0:0])
        by forward501c.mail.yandex.net (Yandex) with ESMTP id AC6755ED2F;
        Thu, 21 Sep 2023 12:23:00 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-54.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id xMGZ28SWsW20-wAQ5AxgU;
        Thu, 21 Sep 2023 12:23:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
        t=1695288180; bh=LLPJ62DcAGjFgvyRpPHunnikAKB11T1EEApYi5z9gCw=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=vG4vhQHF+vMP/uUyKDenMHyC7zkt8me92jW1xWvwMUCuzuPOcTj2Y+EzwCIrpMDQ7
         xUCyOYLUBjZvfShe8fjlXFWmIPeP0Ex4i77neSBFUlHHGMpOdqTiOP7R0G6Df16o+n
         FCjMzgVPRetn7tfij15K3NdS6tSzC6aIeIcDtadg=
Authentication-Results: mail-nwsmtp-smtp-production-main-54.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <cc57fb2f-1eca-f366-bec3-d4cdbb2c39ec@yandex.ru>
Date:   Thu, 21 Sep 2023 12:22:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] wifi: mwifiex: fix SDIO firmware dump wait
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20230920112259.18656-1-dmantipov@yandex.ru>
 <ZQt89BPMN6Fg3H6z@google.com>
From:   Dmitry Antipov <dmantipov@yandex.ru>
In-Reply-To: <ZQt89BPMN6Fg3H6z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/21/23 02:15, Brian Norris wrote:

> Have you tested this patch? You've certainly caught a logic bug, but
> that doesn't mean the seemingly obvious solution actually works.

Unfortunately by eyes only :-(. IIUC there should be a weird hardware
stall to trigger an execution of the branch in subject, so I'm not sure
how to actually test it even if I would have an access to the hardware.

Dmitry

