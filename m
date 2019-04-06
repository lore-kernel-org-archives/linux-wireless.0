Return-Path: <SRS0=AXTt=SI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B874C282DC
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 22:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C8B213A2
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 22:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfDFWEi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Apr 2019 18:04:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfDFWEi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Apr 2019 18:04:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 753D514BA6E8F;
        Sat,  6 Apr 2019 15:04:37 -0700 (PDT)
Date:   Sat, 06 Apr 2019 15:04:33 -0700 (PDT)
Message-Id: <20190406.150433.1815979462207649083.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     sameo@linux.intel.com, christophe.ricard@gmail.com,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, surenb@google.com
Subject: Re: [PATCH 1/2 net] NFC: nci: Add some bounds checking in
 nci_hci_cmd_received()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190403071248.GA5758@kadam>
References: <20190403071248.GA5758@kadam>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 06 Apr 2019 15:04:37 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 3 Apr 2019 10:12:48 +0300

> This is similar to commit 674d9de02aa7 ("NFC: Fix possible memory
> corruption when handling SHDLC I-Frame commands").
> 
> I'm not totally sure, but I think that commit description may have
> overstated the danger.  I was under the impression that this data came
> from the firmware?  If you can't trust your networking firmware, then
> you're already in trouble.
> 
> Anyway, these days we add bounds checking where ever we can and we call
> it kernel hardening.  Better safe than sorry.
> 
> Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
