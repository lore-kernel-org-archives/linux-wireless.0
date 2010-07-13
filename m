Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14750 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0GMRjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 13:39:08 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 10:39:08 -0700
Date: Tue, 13 Jul 2010 10:39:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"br1@einfach.org" <br1@einfach.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"jirislaby@gmail.com" <jirislaby@gmail.com>,
	"mickflemm@gmail.com" <mickflemm@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 1/2] ath5k: move reset to mac80211 workqueue
Message-ID: <20100713173906.GB11519@tux>
References: <1279035161-10802-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1279035161-10802-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 13, 2010 at 08:32:40AM -0700, Bob Copeland wrote:
> We currently trigger a reset via a tasklet when certain error
> conditions are detected so that the card will (eventually)
> restart.  Unfortunately this makes locking complicated since
> reset can also be called in process context (e.g. for channel
> change).  Currently nothing protects against concurrent resets,
> which can be the source of corruption bugs.
> 
> Reset takes too long to spinlock the whole thing, so this
> patch moves deferred resets into the mac80211 workqueue to
> enable use of sc->lock mutex.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Neat! Good idea.

  Luis
