Return-Path: <SRS0=AXTt=SI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B79C282DD
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 22:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F2E8213A2
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 22:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfDFWEu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Apr 2019 18:04:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfDFWEt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Apr 2019 18:04:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39FBE14BA6E98;
        Sat,  6 Apr 2019 15:04:49 -0700 (PDT)
Date:   Sat, 06 Apr 2019 15:04:48 -0700 (PDT)
Message-Id: <20190406.150448.531006720566146319.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     sameo@linux.intel.com, christophe.ricard@gmail.com,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 net] nfc: nci: Potential off by one in ->pipes[]
 array
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190403071351.GB5758@kadam>
References: <20190403071248.GA5758@kadam>
        <20190403071351.GB5758@kadam>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 06 Apr 2019 15:04:49 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 3 Apr 2019 10:13:51 +0300

> This is similar to commit e285d5bfb7e9 ("NFC: Fix the number of pipes")
> where we changed NFC_HCI_MAX_PIPES from 127 to 128.
> 
> As the comment next to the define explains, the pipe identifier is 7
> bits long.  The highest possible pipe is 127, but the number of possible
> pipes is 128.  As the code is now, then there is potential for an
> out of bounds array access:
> 
>     net/nfc/nci/hci.c:297 nci_hci_cmd_received() warn: array off by one?
>     'ndev->hci_dev->pipes[pipe]' '0-127 == 127'
> 
> Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
