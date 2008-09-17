Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48991 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYIQU4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 16:56:13 -0400
Message-ID: <48D16EDB.8090700@lwfinger.net> (sfid-20080917_225618_887060_F07494FA)
Date: Wed, 17 Sep 2008 15:55:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Michael Buesch <mb@bu3sch.de>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rfkill: update LEDs for all state changes
References: <20080917023334.GA1187@khazad-dum.debian.net> <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> The LED state was not being updated by rfkill_force_state(), which will
> cause regressions in wireless drivers that had old-style rfkill support and
> are updated to use rfkill_force_state().
> 
> The LED state was not being updated when a change was detected through the
> rfkill->get_state() hook, either.
> 
> Move the LED trigger update calls into notify_rfkill_state_change(), where
> it should have been in the first place.  This takes care of both issues.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
>  John, this one is quite likely something that should be sent for
>  merge in mainline BEFORE 2.6.27 is released.
> 
>  I am NOT sure it fixes regressions, that depends on whether the drivers
>  using rfkill that are in 2.6.27 had working LED support before rfkill
>  support was added to them.  Unfortunately, it cannot fix the b43
>  regression by itself.

The b43 regression is not fixed with this patch and the one from
Matthew that starts out with "Oh, hey, I suck. This one might stand a
better chance of not falling over."

Larry


