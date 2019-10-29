Return-Path: <SRS0=76X5=YW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E63CA9EAE
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 08:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF222086A
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 08:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfJ2Iap (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Oct 2019 04:30:45 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:39389 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728757AbfJ2Iap (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Oct 2019 04:30:45 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id DEBF1181D3042;
        Tue, 29 Oct 2019 08:30:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: idea97_7a7d88050d930
X-Filterd-Recvd-Size: 1582
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Tue, 29 Oct 2019 08:30:41 +0000 (UTC)
Message-ID: <055503c8dce7546a8253de1d795ad71870eeb362.camel@perches.com>
Subject: Re: [PATCH] b43: Fix use true/false for bool type
From:   Joe Perches <joe@perches.com>
To:     Simon Horman <simon.horman@netronome.com>,
        Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, swinslow@gmail.com,
        will@kernel.org, opensource@jilayne.com, baijiaju1990@gmail.com,
        tglx@linutronix.de, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
Date:   Tue, 29 Oct 2019 01:30:34 -0700
In-Reply-To: <20191029082427.GB23615@netronome.com>
References: <20191028190204.GA27248@saurav>
         <20191029082427.GB23615@netronome.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-10-29 at 09:24 +0100, Simon Horman wrote:
> I wonder why bools rather than a bitmask was chosen
> for this field, it seems rather space intensive in its current form.

4 bools is not intensive.

> > diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
[]
> > @@ -3600,7 +3600,7 @@ static void b43_tx_work(struct work_struct *work)
[]
> > -				wl->tx_queue_stopped[queue_num] = 1;
> > +				wl->tx_queue_stopped[queue_num] = true;


