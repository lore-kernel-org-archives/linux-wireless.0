Return-Path: <SRS0=23TN=ZT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1477C432C0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 19:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89EB220665
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 19:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfK0TXM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 14:23:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0TXM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 14:23:12 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3B8A14A6F7E4;
        Wed, 27 Nov 2019 11:23:10 -0800 (PST)
Date:   Wed, 27 Nov 2019 11:23:10 -0800 (PST)
Message-Id: <20191127.112310.1018809619618803508.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org,
        nicholas.johnson-opensource@outlook.com.au, kenny@panix.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL
 packet stalling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127094123.18161-1-alobakin@dlink.ru>
References: <20191127094123.18161-1-alobakin@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 11:23:11 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Wed, 27 Nov 2019 12:41:23 +0300

> Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()") has applied batched GRO_NORMAL packets processing
> to all napi_gro_receive() users, including mac80211-based drivers.
> 
> However, this change has led to a regression in iwlwifi driver [1][2] as
> it is required for NAPI users to call napi_complete_done() or
> napi_complete() and the end of every polling iteration, whilst iwlwifi
> doesn't use NAPI scheduling at all and just calls napi_gro_flush().
> In that particular case, packets which have not been already flushed
> from napi->rx_list stall in it until at least next Rx cycle.
> 
> Fix this by adding a manual flushing of the list to iwlwifi driver right
> before napi_gro_flush() call to mimic napi_complete() logics.
> 
> I prefer to open-code gro_normal_list() rather than exporting it for 2
> reasons:
> * to prevent from using it and napi_gro_flush() in any new drivers,
>   as it is the *really* bad way to use NAPI that should be avoided;
> * to keep gro_normal_list() static and don't lose any CC optimizations.
> 
> I also don't add the "Fixes:" tag as the mentioned commit was only a
> trigger that only exposed an improper usage of NAPI in this particular
> driver.
> 
> [1] https://lore.kernel.org/netdev/PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=205647
> 
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

Applied, thanks for the quick turnaround.
