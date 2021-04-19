Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E8FC433B4
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Apr 2021 19:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534326135F
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Apr 2021 19:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhDSTY0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Apr 2021 15:24:26 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:48498 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233253AbhDSTYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Apr 2021 15:24:25 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lYZUn-0001Ii-WE; Mon, 19 Apr 2021 21:23:46 +0200
Subject: Re: [PATCH] rtlwifi: implement set_tim by update beacon content
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        kvalo@codeaurora.org
References: <20210419065956.6085-1-pkshih@realtek.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <ed0d5d2a-9860-d157-5104-63faf98d68bd@maciej.szmigiero.name>
Date:   Mon, 19 Apr 2021 21:23:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419065956.6085-1-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 19.04.2021 08:59, Ping-Ke Shih wrote:
> Once beacon content is changed, we update the content to wifi card by
> send_beacon_frame(). Then, STA with PS can wake up properly to receive its
> packets.
> 
> Since we update beacon content to PCI wifi devices every beacon interval,
> the only one usb device, 8192CU, needs to update beacon content when
> mac80211 calling set_tim.
> 
> Reported-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/core.c | 32 +++++++++++++++++++++
>   drivers/net/wireless/realtek/rtlwifi/core.h |  1 +
>   drivers/net/wireless/realtek/rtlwifi/usb.c  |  3 ++
>   drivers/net/wireless/realtek/rtlwifi/wifi.h |  1 +
>   4 files changed, 37 insertions(+)

Tested-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

Thanks.
