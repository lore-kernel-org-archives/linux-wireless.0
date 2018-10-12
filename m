Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF54C67877
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 18:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B992087D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 18:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30B992087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbeJMBeW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 21:34:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48122 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbeJMBeW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 21:34:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1c06::4572])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAEAA133FBF04;
        Fri, 12 Oct 2018 11:00:41 -0700 (PDT)
Date:   Fri, 12 Oct 2018 11:00:41 -0700 (PDT)
Message-Id: <20181012.110041.612762946748585323.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        john.garry@huawei.com, johannes.berg@intel.com
Subject: Re: [PATCH v2] netlink: replace __NLA_ENSURE implementation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20181012105300.25747-1-johannes@sipsolutions.net>
References: <20181012105300.25747-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.7 on Emacs 26 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Oct 2018 11:00:42 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 12 Oct 2018 12:53:00 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> We already have BUILD_BUG_ON_ZERO() which I just hadn't found
> before, so we should use it here instead of open-coding another
> implementation thereof.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: remove all the language about -Wvla, I misunderstood John
>     and he was just referring to *other* VLA warnings in the
>     wifi stack (which we know about and are being fixed by the
>     crypto tree)

Applied to net-next.
