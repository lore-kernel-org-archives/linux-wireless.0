Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C68C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 00:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0B62208E4
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 00:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfBSAaO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 19:30:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfBSAaO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 19:30:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD2CB108DE823;
        Mon, 18 Feb 2019 16:30:13 -0800 (PST)
Date:   Mon, 18 Feb 2019 16:30:13 -0800 (PST)
Message-Id: <20190218.163013.682270284461288074.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, weiyongjun1@huawei.com
Subject: Re: [PATCH net] mac80211: mesh: fix missing unlock on error in
 table_path_del()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190218102929.22276-1-johannes@sipsolutions.net>
References: <20190218102929.22276-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Feb 2019 16:30:14 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 18 Feb 2019 11:29:29 +0100

> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> spin_lock_bh() is used in table_path_del() but rcu_read_unlock()
> is used for unlocking. Fix it by using spin_unlock_bh() instead
> of rcu_read_unlock() in the error handling case.
> 
> Fixes: b4c3fbe63601 ("mac80211: Use linked list instead of rhashtable walk for mesh tables")
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Dave, can you take this directly? I see little value in sending a
> pull request for this one patch (but if you prefer can do so.)

Applied, thanks Johannes.
