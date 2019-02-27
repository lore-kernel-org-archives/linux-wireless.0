Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A95C00319
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 20:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23FC217F5
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 20:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbfB0Uti (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 15:49:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbfB0Uti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 15:49:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D2E7121605CA;
        Wed, 27 Feb 2019 12:49:37 -0800 (PST)
Date:   Wed, 27 Feb 2019 12:49:36 -0800 (PST)
Message-Id: <20190227.124936.703358805911286675.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: nfc: Fix NULL dereference on nfc_llcp_build_tlv
 fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190222073758.5352-1-yuehaibing@huawei.com>
References: <20190222073758.5352-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Feb 2019 12:49:37 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yue Haibing <yuehaibing@huawei.com>
Date: Fri, 22 Feb 2019 15:37:58 +0800

> From: YueHaibing <yuehaibing@huawei.com>
> 
> KASAN report this:
 . ..
> nfc_llcp_build_tlv will return NULL on fails, caller should check it,
> otherwise will trigger a NULL dereference.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: eda21f16a5ed ("NFC: Set MIU and RW values from CONNECT and CC LLCP frames")
> Fixes: d646960f7986 ("NFC: Initial LLCP support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied and queued up for -stable, thanks.
