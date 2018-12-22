Return-Path: <SRS0=36rf=O7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F8DC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 23:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39693206A3
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 23:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405016AbeLVXJr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 18:09:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404344AbeLVXJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 18:09:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::cf9])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30DD114A8F325;
        Sat, 22 Dec 2018 15:09:47 -0800 (PST)
Date:   Sat, 22 Dec 2018 15:09:46 -0800 (PST)
Message-Id: <20181222.150946.778308321544627589.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: af_nfc: Fix Spectre v1 vulnerability
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20181221214753.GA2799@embeddedor>
References: <20181221214753.GA2799@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Dec 2018 15:09:47 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Fri, 21 Dec 2018 15:47:53 -0600

> proto is indirectly controlled by user-space, hence leading to
> a potential exploitation of the Spectre variant 1 vulnerability.
> 
> This issue was detected with the help of Smatch:
> 
> net/nfc/af_nfc.c:42 nfc_sock_create() warn: potential spectre issue 'proto_tab' [w] (local cap)
> 
> Fix this by sanitizing proto before using it to index proto_tab.
> 
> Notice that given that speculation windows are large, the policy is
> to kill the speculation on the first load and not worry if it can be
> completed with a dependent load/store [1].
> 
> [1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

I'll take this directly, and queued up for -stable.

Thanks.
