Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:45625 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753907AbdHUVln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 17:41:43 -0400
Date: Mon, 21 Aug 2017 14:41:36 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kvalo@codeaurora.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mt7601u: check memory allocation failure
Message-ID: <20170821144136.477bf655@cakuba.netronome.com> (sfid-20170821_234213_587727_032CF411)
In-Reply-To: <20170821143430.635e4b92@cakuba.netronome.com>
References: <20170821205956.20859-1-christophe.jaillet@wanadoo.fr>
        <20170821143430.635e4b92@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Aug 2017 14:34:30 -0700, Jakub Kicinski wrote:
> On Mon, 21 Aug 2017 22:59:56 +0200, Christophe JAILLET wrote:
> > Check memory allocation failure and return -ENOMEM in such a case, as
> > already done a few lines below
> > 
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>  
> 
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Wait, I take that back.  This code is a bit weird.  We would return an
error, then mt7601u_dma_init() will call mt7601u_free_tx_queue() which
doesn't check for tx_q == NULL condition.

Looks like mt7601u_free_tx() has to check for dev->tx_q == NULL and
return early if that's the case.  Or mt7601u_alloc_tx() should really
clean things up on it's own on failure.  Ugh.
