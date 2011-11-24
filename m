Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:52499 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab1KXV2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 16:28:13 -0500
Date: Thu, 24 Nov 2011 23:28:05 +0200
From: Jouni Malinen <j@w1.fi>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: AP mode - question about Tx buffered unicast frames
 drop timeout
Message-ID: <20111124212805.GA10164@jm.kir.nu> (sfid-20111124_222816_973406_6D9355AC)
References: <CAFED-j=5-s7V9HZvYJDJ14KbVm+ioa=KnoBh1fj2ueT05QusTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFED-j=5-s7V9HZvYJDJ14KbVm+ioa=KnoBh1fj2ueT05QusTQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 07:36:40PM +0100, Janusz Dziedzic wrote:
> in sta_info.c I see function we call to remove expired unicast buffered frames.
> 
> sta_info_buffer_expired()
> {
> ...
> 	timeout = (sta->listen_interval *
> 		   sta->sdata->vif.bss_conf.beacon_int *
> 		   32 / 15625) * HZ;
> 	if (timeout < STA_TX_BUFFER_EXPIRE)
> 		timeout = STA_TX_BUFFER_EXPIRE;
> ...
> }
> 
> STA_TX_BUFFER_EXPIRE is define as 10 seconds.
> Do you remember why we set this as 10 seconds in case we calculate lower value?

Too old code to remember.. That's from almost 10 years ago, I think.

> This "listen_interval" calculation seems to be correct.

I would not agree with that. It seems to result in timeout being 0 in
most cases. (unsigned int) sta->listen_interval *
sta->sdata->vif.bss_conf.beacon_int * 32 / 125 * HZ / 125 could be a
more useful order for the calculation. Or maybe use something like
min(sta->listen_interval *
sta->sdata->vif.bss_conf.beacon_int, 100000) to avoid integer overflow
in more or less theoretical cases without having to split the operation
that much..

Anyway, yes, it should be fine to make STA_TX_BUFFER_EXPIRE smaller.

-- 
Jouni Malinen                                            PGP id EFC895FA
