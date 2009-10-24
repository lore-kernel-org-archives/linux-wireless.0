Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3461 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZJXNUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 09:20:03 -0400
Date: Sat, 24 Oct 2009 09:19:29 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k: no further txbuf available, dropping packet
Message-ID: <20091024131929.GB31897@hash.localnet>
References: <200910231608.18676.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910231608.18676.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 23, 2009 at 04:08:16PM +0200, Michael Buesch wrote:
> ath5k breaks in AP mode after some operation time and keeps throwing
> this message:
> 
> [2096249.446071] ath5k phy0: no further txbuf available, dropping packet
> 
> Driver is yesterday's compat-wireless on 2.6.31.1

Ok looked a bit more at this.  I don't see a leak, but I think the
txbufs aren't getting reaped.  Otherwise, we should reenable the queues
when we get back 40 TX completion interrupts.

I'm a bit short on time to track it down, but one thing to try is
commenting out the following from ath5k_beacon_send (will break buffering
but you can test non-ps clients):

        skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
        while (skb) {
                ath5k_tx_queue(sc->hw, skb, sc->cabq);
                skb = ieee80211_get_buffered_bc(sc->hw, sc->vif);
        }

-- 
Bob Copeland %% www.bobcopeland.com

