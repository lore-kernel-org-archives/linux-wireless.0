Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56817 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaESVpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 17:45:17 -0400
Date: Mon, 19 May 2014 17:41:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k_htc: use 'struct ath_htc_rx_status
 *' in call to ath9k_htc_err_stat_rx
Message-ID: <20140519214146.GM7650@tuxdriver.com> (sfid-20140519_234521_173874_22FBFCCB)
References: <1400533670-23340-1-git-send-email-linville@tuxdriver.com>
 <537A778A.5050205@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <537A778A.5050205@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 11:28:42PM +0200, Oleksij Rempel wrote:
> Am 19.05.2014 23:07, schrieb John W. Linville:
> >   CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
> > drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function ‘ath9k_rx_prepare’:
> > drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1006:2: warning: passing argument 2 of ‘ath9k_htc_err_stat_rx’ from incompatible pointer type [enabled by default]
> >   ath9k_htc_err_stat_rx(priv, &rx_stats);
> >   ^
> > In file included from drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:17:0:
> > drivers/net/wireless/ath/ath9k/htc.h:380:20: note: expected ‘struct ath_htc_rx_status *’ but argument is of type ‘struct ath_rx_status *’
> >  static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> > Compile-test only...seems reasonable?
> 
> Hm... that is incorrect. Some missing patch?
> "[PATCH 06/10] ath9k & ath9k_htc: move ath_rx_stats to cmn" did correct
> change.
> your patch will brake it.

The patch you mention is in wireless-next and wireless-testing.
The warning only shows-up in my wireless-testing build, although the
configs are slightly different.

Would you be interested in tracking down the problem?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
