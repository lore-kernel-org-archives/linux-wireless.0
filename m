Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE7AC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CF0D207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 13:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfBVNHk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:07:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38464 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfBVNHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 08:07:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gxAYE-0003bp-M9; Fri, 22 Feb 2019 14:07:38 +0100
Message-ID: <a5151441bdfe02cb11043aa0786185b8ee3c3ee9.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Change default tx_sk_pacing_shift to 7
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Grant Grundler <grundler@google.com>,
        Kalle Valo <kvalo@codeaurora.org>, wgong@qti.qualcomm.com,
        ath10k@lists.infradead.org, wgong@codeaurora.org,
        Kan Yan <kyan@google.com>
Date:   Fri, 22 Feb 2019 14:07:36 +0100
In-Reply-To: <87lg28vup0.fsf@toke.dk>
References: <20190221172936.21816-1-toke@redhat.com>
         <E1gx9x3-0002j0-1J@sipsolutions.net> <87lg28vup0.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-22 at 14:06 +0100, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > Toke Høiland-Jørgensen wrote:
> > 
> > > When we did the original tests for the optimal value of sk_pacing_shift, we
> > > came up with 6 ms of buffering as the default. Sadly, 6 is not a power of
> > > two, so when picking the shift value I erred on the size of less buffering
> > > and picked 4 ms instead of 8. This was probably wrong; those 2 ms of extra
> > > buffering makes a larger difference than I thought.
> > > 
> > > So, change the default pacing shift to 7, which corresponds to 8 ms of
> > > buffering. The point of diminishing returns really kicks in after 8 ms, and
> > > so having this as a default should cut down on the need for extensive
> > > per-device testing and overrides needed in the drivers.
> > > 
> > > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > 
> > Patch applied to wireless.git, thanks.
> > 
> > a41f56b9a17a (HEAD -> mac80211) mac80211: Change default
> > tx_sk_pacing_shift to 7

This mess came from Kalle's tool btw, so I can't really use it yet :-)

> Cool, thanks! What's the easiest way to backport this? I figure it's
> easier to just update sk_pacing_shift_update() in tx.c for 4.19 (which
> predates the addition of the driver override hook); shall I just send a
> separate patch to stable for that? Or do we need to backport the driver
> override hook as well?

Just update the value, no need to backport the hook.

johannes

