Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4912CC61DA4
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Mar 2023 06:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCMGj0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Mar 2023 02:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCMGjZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2023 02:39:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF2D274BA
        for <linux-wireless@vger.kernel.org>; Sun, 12 Mar 2023 23:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6EBDB80DBE
        for <linux-wireless@vger.kernel.org>; Mon, 13 Mar 2023 06:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D845BC433EF;
        Mon, 13 Mar 2023 06:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678689561;
        bh=YhY5bTcA62cTrlA63Mq3LC3b1cNGNJkrBXgaaTWRNwc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UgqqTYOdf16PGs5hs0m+TNKJOHZ7DQ69VdD/DGaoqsivRfuQ2NYn4Z4i0k+ofsTvs
         nyiGMcVYBQ5o3lO6N0QjVQYm7HuHrhNw2Az2mlYf2Oo99eECKNQnPqA6O1K/3VGHdU
         C8a/UZEv8WCHNLCfblw330QNRi5e4oqu4JJGL52/bKFvzdvJ+4EX1IezA3GT6asx0A
         2Gl/37PXqwYSgdGJn23MjlC9t4MAUifGTnU1ExS9nRvGg7S5hdCNN+8P4b8vKarfje
         8Tw3rWC0cL8vUci1BQsUb9OKOzpxVomPzjYsAU/rf3GX53U/sM4IagGq+8Or21A4Pm
         MjcBfAXDrqoeg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Vincent Tremblay <vincent@vtremblay.dev>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wifi: ath10k: read qcom,coexist-support as a u32
References: <CA+RD57MwUfAzF2u31Ews4uT0+A6uhjwwd40O=9uyZihap4nxdA@mail.gmail.com>
Date:   Mon, 13 Mar 2023 08:39:17 +0200
In-Reply-To: <CA+RD57MwUfAzF2u31Ews4uT0+A6uhjwwd40O=9uyZihap4nxdA@mail.gmail.com>
        (Vincent Tremblay's message of "Sun, 12 Mar 2023 15:42:47 -0400")
Message-ID: <873569p33e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Vincent Tremblay <vincent@vtremblay.dev> writes:

> Read qcom,coexist-support as a u32 instead of a u8
>
> When we set the property to <1> in the DT (as specified in the doc),
> "of_property_read_u8" read 0 instead of 1. This is because of the data format.
>
> By default <1> is written with 32 bits.
> The problem is that the driver is trying to read a u8.
>
> The difference can be visualized using hexdump in a running device:
> Default 32 bits output:
> =======================
> 0000000 0000 0100
> 0000004
>
> 8 bits output:
> ==============
> 0000000 0001
> 0000001
>
> By changing "of_property_read_u8" by "of_property_read_u32", the driver
> is aligned with the documentation and is able to read the value without
> modifying the DT.
>
> The other solution would be to force the value in the DT to be saved as
> an 8 bits value (qcom,coexist-support = /bits/ 8 <1>),
> which is against the doc and less intuitive.
>
> Validation:
> ===========
> The patch was tested on a real device and we can see in the debug logs
> that the feature is properly initialized:
>
> [  109.102097] ath10k_ahb a000000.wifi: boot coex_support 1 coex_gpio_pin 52
>
> Signed-off-by: Vincent Tremblay <vincent@vtremblay.dev>

What are the changes in v2? Please always include a list of changes,
more info in the wiki below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
