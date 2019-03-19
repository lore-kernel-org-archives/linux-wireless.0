Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D1BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 11:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB9020857
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 11:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfCSLHO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfCSLHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 07:07:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9ABC81E0E;
        Tue, 19 Mar 2019 11:07:13 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 593A95D717;
        Tue, 19 Mar 2019 11:07:11 +0000 (UTC)
Date:   Tue, 19 Mar 2019 12:07:09 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190319110708.GA5360@redhat.com>
References: <cover.1552907276.git.lorenzo@kernel.org>
 <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 19 Mar 2019 11:07:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 18, 2019 at 12:09:32PM +0100, Lorenzo Bianconi wrote:
> Similar to pci counterpart, reduce locking in mt76u_tx_tasklet since
> q->head is managed just in mt76u_tx_tasklet and q->queued is updated
> holding q->lock
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index ac03acdae279..8cd70c32d77a 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -634,29 +634,33 @@ static void mt76u_tx_tasklet(unsigned long data)
>  	int i;
>  
>  	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
> +		u32 n_queued = 0, n_sw_queued = 0;
> +
>  		sq = &dev->q_tx[i];
>  		q = sq->q;
>  
> -		spin_lock_bh(&q->lock);
> -		while (true) {
> +		while (q->queued > n_queued) {
>  			buf = &q->entry[q->head].ubuf;
> -			if (!buf->done || !q->queued)
> +			if (!buf->done)
>  				break;

I'm still thinking if this is safe or not. Is somewhat tricky to
read variable outside the lock because in such case there is no time
guarantee when variable written on one CPU gets updated value on
different CPU. And for USB is not only q->queued but also buf->done.
 
Stanislaw

