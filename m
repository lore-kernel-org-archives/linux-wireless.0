Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B27EC4338F
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Jul 2021 12:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414716044F
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Jul 2021 12:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhGZLvL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:51:11 -0400
Received: from lpdvsmtp11.broadcom.com ([192.19.166.231]:56846 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234092AbhGZLvK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jul 2021 07:51:10 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 4081721822;
        Mon, 26 Jul 2021 05:31:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 4081721822
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1627302685;
        bh=v3d6+4+yAoRhE7r6Y/PXDeF3dgC/V0HpxAO5onTUykE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=n1DrYe0F8U3Y/aaZMC2EwNmXE+3W6ErmetndjKaJmalV7nqmFBcO3ldxIXwg2XlRY
         7vD9s3BmxqDlnuiUbO/We4ffBDwK5Y9tNaqXGJg5eoqgKAGAbEYC88Ciw8iKD/gHMc
         AZqNgXW6EFBgrxDKEqxx1yCSW7GFwfDa9ZFOrphY=
Received: from [10.176.68.80] (39y1yf2.dhcp.broadcom.net [10.176.68.80])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 965601874BD;
        Mon, 26 Jul 2021 05:31:24 -0700 (PDT)
Subject: Re: Current mainline brcmfmac reports error on supposedly supported
 ap6256 chip
To:     Piotr Oniszczuk <piotr.oniszczuk@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>
References: <CB0AA0D2-A8F3-4217-A3C1-E14D7E9FF11E@gmail.com>
 <17ad94781a0.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <6F6333F3-0BDB-48AF-B445-723958ABA8C9@gmail.com>
 <be6c2b7f-2c85-59fb-3013-d0590c487c51@broadcom.com>
 <53E7119F-D158-4EF0-940C-D0AA59C23CF6@gmail.com>
 <3da7f271-0c5c-50de-375a-a8c67ca127f5@broadcom.com>
 <286E2774-FAA5-47E3-A1FC-FDB09EB37FDC@gmail.com>
 <1a5588e2-38fc-1ec2-580a-30ae03ee73e1@broadcom.com>
 <28fdbe0c-023d-82a3-877b-7b158b109e52@broadcom.com>
 <A76C51D0-C73B-43B0-9AE3-ABB4AED6AB86@gmail.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7365182a-ab99-899b-7ac9-c13b31e02f06@broadcom.com>
Date:   Mon, 26 Jul 2021 14:31:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <A76C51D0-C73B-43B0-9AE3-ABB4AED6AB86@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 7/26/2021 2:21 PM, Piotr Oniszczuk wrote:
> Arend,
> 
> Neil Armstrong hinted me issue might be related to usage of memcpy() to/from an iomem mapping.
> arm64 memcpy update (285133040e6c ("arm64: Import latest memcpy()/memmove() implementation")) triggers a memory abort when dram-access-quirk
> is used on the G12A/G12B platforms.
> 
> I reverted https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/mmc/host/meson-gx-mmc.c?h=v5.13.4&id=103a5348c22c3fca8b96c735a9e353b8a0801842
> 
> and got nicely working wifi.
> 
> So it looks root cause is amlogic specific - not brcmfmac.
> 
> Sorry for false report and many many thx for Your head-up!

Hi Piotr,

Thanks for letting me know. I hadn't worked yet on the patch I had in 
mind and I suspect it would not have helped.

Regards,
Arend
