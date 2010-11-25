Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58371 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab0KYQra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 11:47:30 -0500
Date: Thu, 25 Nov 2010 18:47:24 +0200
From: Jouni Malinen <j@w1.fi>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
Message-ID: <20101125164724.GA6269@jm.kir.nu>
References: <4CE6EA98.3020300@gmx.net>
 <20101120112753.GA12225@jm.kir.nu>
 <201011201304.48821.helmut.schaa@googlemail.com>
 <4CEBE834.9000303@gmx.net>
 <4CED27A0.70001@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CED27A0.70001@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 03:56:32PM +0100, Wolfgang Breyha wrote:
> I have proof now, that the APs respond to authentication requests regardless
> of a successful probe before. Simply skipping the direct probe is sufficient
> to connect successfully.

Interestingly enough, that seems to be exactly what the current
wireless-testing.git snapshot is doing.. I was trying to reproduce this
issue by modifying my AP not to reply to Probe Request frames on 2.4 GHz
band and did not see any problems in getting connected. The station saw
both the 2.4 and 5 GHz BSSes from the AP and the 2.4 GHz BSS was
selected based on signal strength. mac80211 went through the
authentication and association frame exchanges without any problems (and
without sending out a directed Probe Request frame). Whether this change
was done by design is another question, but at least this seems to be
the current behavior.

There may still be some issues in wpa_supplicant blacklist handling
which I will try to reproduce in some other way since the station should
have actually managed to follow the not so polite hint from the AP and
try to use the 5 GHz band here.

-- 
Jouni Malinen                                            PGP id EFC895FA
