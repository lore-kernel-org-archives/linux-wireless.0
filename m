Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56897 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaD2GKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 02:10:51 -0400
Received: by mail-wg0-f51.google.com with SMTP id z12so6193616wgg.10
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 23:10:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lhupo1oe.fsf@gmail.com>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	<87lhupo1oe.fsf@gmail.com>
Date: Tue, 29 Apr 2014 08:10:50 +0200
Message-ID: <CA+BoTQmtJhXrv3Emv27bUO-XcfOkPfK=13vhW6zoZ_9PpN5NFA@mail.gmail.com> (sfid-20140429_081054_989705_93B49DD7)
Subject: Re: [v4 13/13] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 April 2014 18:32, Zhao, Gang <gamerh2o@gmail.com> wrote:
> Hi Michal,
>
> +       kfree_rcu(ctx, rcu_head);
> +
> +       list_for_each_entry(sdata, &ctx->reserved_vifs,
> +                           reserved_chanctx_list) {
>
> I'm not very familiar with rcu, but this doesn't seems right ?
>
> I noticed it when rebasing my recalc refactoring code on your patches. :-)

Great catch, thanks! kfree_rcu() should be called just before the return 0.


Michał
