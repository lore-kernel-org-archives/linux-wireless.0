Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BB9C433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Mar 2022 08:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244193AbiC3IQi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Mar 2022 04:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244170AbiC3IQ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Mar 2022 04:16:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB73E1D
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2022 01:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD867B81B7D
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2022 08:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2521EC340EC;
        Wed, 30 Mar 2022 08:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648628080;
        bh=+1RwX6F2j2MmjSrrH5cM4VGEZqDSuNw94o9ZslDfAYA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F0/f8CFKAIBZw9LjCsmlMhK+db7ka4XQNkLqy1HDPw3QzJmvrqcAKLIlN+IAO/Fw6
         E7QRyokrLMWcoEYSIjh8lOXfHiTT3OVPhZqndyubtrKMM7slBfZjqiM+ra25X1zMgR
         x2Q62mZtuahBK2kE4g8usIXdnOd4/RjRziNXIjalnYZQcW6T6Nhp+Z43BKuJyk536G
         TkCJ7cRFmKywcwebg9BJ4iaAOg11/ZClNlMkQSCxswYLmLKsSoQuCFs3M0EBOGH38B
         JWBkPaYKz2NZajsugiBwC5mq7elCayfWWL74tVHJnj6MuU4prfY4jGrx81b48NXF7G
         Tc4AqRYGtVWqQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH 1/2] ath10k: add support for MSDU IDs for USB devices
References: <20220327171340.7893-1-erik.stromdahl@gmail.com>
        <875yny1w8t.fsf@kernel.org>
        <1ca2ff88-4751-acce-6202-abc7d22e4494@gmail.com>
Date:   Wed, 30 Mar 2022 11:14:35 +0300
In-Reply-To: <1ca2ff88-4751-acce-6202-abc7d22e4494@gmail.com> (Erik
        Stromdahl's message of "Tue, 29 Mar 2022 18:00:06 +0200")
Message-ID: <87lewrx3f8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 3/28/22 07:28, Kalle Valo wrote:
>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>
>>> commit 93bbdec6683e1c8ba2cc4e6 ("ath10k: htt: support MSDU ids with
>>> SDIO") introduced MSDU ID allocation in the htt TX path for high latency
>>> devices. This feature needs to be enabled for USB as well in order to
>>> have a functional TX path.
>>>
>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>
>> On what hardware and firmware version did you test these patches? I'll
>> then add the Tested-on tag:
>>
>> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#tested-on_tag
>>
>
> Hardware: Linksys WUSB6100M
> Fw version: QCA9377 hw1.0 USB 1.0.0.299
>
> Above fw version is printed by the driver at startup:
>
> ath10k_log_dbg: usb 1-3 firmware 1.0.0.299 booted

Thanks, I added this:

Tested-on: QCA9377 hw1.0 USB 1.0.0.299

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
