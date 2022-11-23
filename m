Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03828C433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Nov 2022 18:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiKWS3a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Nov 2022 13:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbiKWS3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2022 13:29:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B88D2AE6;
        Wed, 23 Nov 2022 10:29:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A1861E50;
        Wed, 23 Nov 2022 18:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1319CC433B5;
        Wed, 23 Nov 2022 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669228154;
        bh=hzJueNzbO/9Acji4eb9royz8LgQfKzYqzYDs+LWuxAA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rhEjkxqLultIdTJdkgy4Gy0NqEm2qx0gSzqX6INOvcxiHJw5frx3Xcf1CFqYawpBg
         haAjqeBAO0TDYqlrgq6AvOpkPysOgcxAgZzbxmjYkQ6pp+qjj0024rYn2bdGt6WrZd
         kTPEhnOIndGB9bndrvQ2rBNIkMX0jWIwa5nQUvowq/AuSXExmjqT5okmKcnx3aUMnz
         FkyQv7HuYG9WuDOOzdPydpfgvPSY4LEFNUo/78aQUd4qmxj5uf2QDloNCeF3KG1Td4
         vHG2ZZhYs1kKjvvmXy+n/EEH0mvRiMho4ThJlHzdymI866huhY7rOOTiQb7Vzv1iQY
         5d0Y93gN3heug==
Date:   Wed, 23 Nov 2022 10:29:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
Message-ID: <20221123102913.20108617@kernel.org>
In-Reply-To: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 23 Nov 2022 13:46:20 +0100 Greg Kroah-Hartman wrote:
> I can take this through the USB tree if the networking maintainers have
> no objection.

Acked-by: Jakub Kicinski <kuba@kernel.org>
