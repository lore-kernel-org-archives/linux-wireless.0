Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F6CC64E8A
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 11:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37622208FE
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 11:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgLCLdI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Dec 2020 06:33:08 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:59900 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgLCLdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Dec 2020 06:33:08 -0500
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 3222C3B16D1
        for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2020 11:32:26 +0000 (UTC)
X-Originating-IP: 103.82.80.94
Received: from localhost (unknown [103.82.80.94])
        (Authenticated sender: me@yadavpratyush.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id B562C40010;
        Thu,  3 Dec 2020 11:31:23 +0000 (UTC)
Date:   Thu, 3 Dec 2020 17:01:20 +0530
From:   Pratyush Yadav <me@yadavpratyush.com>
To:     linux-wireless@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>
Subject: Realtek RTL8723BE throttling network speed
Message-ID: <20201203113120.mdbhyiqn5zgf37li@yadavpratyush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GND-Spam-Score: 400
X-GND-Status: SPAM
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I have the Realtek RTL8723BE wireless network adapter on my laptop:

  $ lspci | grep -i wireless
  08:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8723BE PCIe Wireless Network Adapter

running kernel version "5.9.10-arch1-1".

I am seeing some strange behavior on it for some time now. When I power 
on my router and connect to it, I get the full download speed for about 
an hour or so. After that the speed throttles to around 60-70 KB/s. 
Other devices connected to the router continue work at full speed.

If I power cycle the router, it again works at full speed for about an 
hour or two and then throttles back to around 60-70 KB/s.

Has anybody ever seen any problem like this? Any fixes for this? Or at 
least any pointers to where I can start looking in the driver source?

Any help would be appreciated because this is quite annoying having to 
restart the router every hour or so.

-- 
Regards,
Pratyush Yadav
