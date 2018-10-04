Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8E7C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 07:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BD1E21473
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 07:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BD1E21473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbeJDOvQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 10:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbeJDOvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 10:51:15 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C60627F6B0;
        Thu,  4 Oct 2018 07:59:16 +0000 (UTC)
Received: from localhost (unknown [10.40.205.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CAE52010D64;
        Thu,  4 Oct 2018 07:59:16 +0000 (UTC)
Date:   Thu, 4 Oct 2018 09:59:15 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: iwlegacy: Fix possible data races in
 il4965_send_rxon_assoc()
Message-ID: <20181004075914.GB20523@redhat.com>
References: <20181003140745.7650-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003140745.7650-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.25
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 04 Oct 2018 07:59:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 10:07:45PM +0800, Jia-Ju Bai wrote:
> These possible races are detected by a runtime testing. 
> To fix these races, the mutex lock is used in il4965_send_rxon_assoc() 
> to protect the data.

Really ? I'm surprised by that, see below.

> @@ -1297,6 +1297,7 @@ il4965_send_rxon_assoc(struct il_priv *il)
>  	const struct il_rxon_cmd *rxon1 = &il->staging;
>  	const struct il_rxon_cmd *rxon2 = &il->active;
>  
> +	mutex_lock(&il->mutex);
>  	if (rxon1->flags == rxon2->flags &&

For 4965 driver il4965_send_rxon_assoc() is only called by
il_mac_bss_info_changed() and il4965_commit_rxon().

il_mac_bss_info_changed() acquire il->mutex and
callers of  il4965_commit_rxon() acquire il->mutex
(but I did not check all of them).

So I wonder how this patch did not cause the deadlock ?
  
Anyway what can be done is adding:

lockdep_assert_held(&il->mutex);

il4965_commit_rxon() to check if we hold the mutex.

Thanks
Stanislaw
