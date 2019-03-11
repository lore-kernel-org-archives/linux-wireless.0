Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4EDC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 09:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E058A206BA
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 09:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfCKJQJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfCKJQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 05:16:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65CC187624;
        Mon, 11 Mar 2019 09:16:09 +0000 (UTC)
Received: from localhost (unknown [10.40.205.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E067019C71;
        Mon, 11 Mar 2019 09:16:08 +0000 (UTC)
Date:   Mon, 11 Mar 2019 10:16:08 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: iwlegacy: fix potential NULL pointer dereferences
Message-ID: <20190311091607.GC3310@redhat.com>
References: <20190311073758.31038-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311073758.31038-1-kjlu@umn.edu>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 11 Mar 2019 09:16:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 02:37:57AM -0500, Kangjie Lu wrote:
> In case create_singlethread_workqueue fails, the fix immediately
> return to avoid NULL pointer dereferences.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/net/wireless/intel/iwlegacy/3945-mac.c | 2 ++
>  drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> index 271977f7fbb0..d23ee2ca0c8e 100644
> --- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> +++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
> @@ -3403,6 +3403,8 @@ static void
>  il3945_setup_deferred_work(struct il_priv *il)
>  {
>  	il->workqueue = create_singlethread_workqueue(DRV_NAME);
> +	if (!il->workqueue)
> +		return;

This is not full fix since we will crash later without setup various
structures in il3945_setup_deferred_work. The driver is pretty
much legacy and worked for decade (or maybe more) without NULL
dereference of il->workqueue. I do not see need to fix _potential_
problems as fix can introduce more harm than good.

Stanislaw 
