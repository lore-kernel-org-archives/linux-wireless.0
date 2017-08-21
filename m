Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:43885 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753869AbdHUWI6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 18:08:58 -0400
Subject: Re: [PATCH] mt7601u: check memory allocation failure
To: Jakub Kicinski <kubakici@wp.pl>
Cc: kvalo@codeaurora.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20170821205956.20859-1-christophe.jaillet@wanadoo.fr>
 <20170821143430.635e4b92@cakuba.netronome.com>
 <20170821144136.477bf655@cakuba.netronome.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <f8db0e55-8480-ea91-e54a-1c83e7ff64a9@wanadoo.fr> (sfid-20170822_000930_791723_1707A231)
Date: Tue, 22 Aug 2017 00:08:54 +0200
MIME-Version: 1.0
In-Reply-To: <20170821144136.477bf655@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 21/08/2017 à 23:41, Jakub Kicinski a écrit :
> On Mon, 21 Aug 2017 14:34:30 -0700, Jakub Kicinski wrote:
>> On Mon, 21 Aug 2017 22:59:56 +0200, Christophe JAILLET wrote:
>>> Check memory allocation failure and return -ENOMEM in such a case, as
>>> already done a few lines below
>>>
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> Acked-by: Jakub Kicinski <kubakici@wp.pl>
> Wait, I take that back.  This code is a bit weird.  We would return an
> error, then mt7601u_dma_init() will call mt7601u_free_tx_queue() which
> doesn't check for tx_q == NULL condition.
>
> Looks like mt7601u_free_tx() has to check for dev->tx_q == NULL and
> return early if that's the case.  Or mt7601u_alloc_tx() should really
> clean things up on it's own on failure.  Ugh.
>
You are right. Thanks for the review.

I've sent a v2 which updates 'mt7601u_free_tx()'.
Doing so sounds more in line with the spirit of this code.

CJ
