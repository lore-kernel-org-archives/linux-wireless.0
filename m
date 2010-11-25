Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46395 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648Ab0KYRut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 12:50:49 -0500
Date: Thu, 25 Nov 2010 19:50:43 +0200
From: Jouni Malinen <j@w1.fi>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
Message-ID: <20101125175043.GA6907@jm.kir.nu>
References: <4CE6EA98.3020300@gmx.net>
 <20101120112753.GA12225@jm.kir.nu>
 <201011201304.48821.helmut.schaa@googlemail.com>
 <4CEBE834.9000303@gmx.net>
 <4CED27A0.70001@gmx.net>
 <20101125164724.GA6269@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101125164724.GA6269@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 25, 2010 at 06:47:24PM +0200, Jouni Malinen wrote:
> Interestingly enough, that seems to be exactly what the current
> wireless-testing.git snapshot is doing.. I was trying to reproduce this
> issue by modifying my AP not to reply to Probe Request frames on 2.4 GHz
> band and did not see any problems in getting connected. The station saw
> both the 2.4 and 5 GHz BSSes from the AP and the 2.4 GHz BSS was
> selected based on signal strength. mac80211 went through the
> authentication and association frame exchanges without any problems (and
> without sending out a directed Probe Request frame). Whether this change
> was done by design is another question, but at least this seems to be
> the current behavior.

Well, maybe not. I could not reproduce that after adding more debug code
to mac80211. In other words, the Probe Request is still there before
authentication is attempted. Anyway, with this, I did get to reproduce
the problem that shows up wpa_supplicant blacklisting not working
properly in this case at least with -Dnl80211.

-- 
Jouni Malinen                                            PGP id EFC895FA
