Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37076 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882AbYLQMDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 07:03:15 -0500
Date: Wed, 17 Dec 2008 14:02:50 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix a NULL pointer dereference in ath_rate_get
Message-ID: <20081217120250.GA19453@jm.kir.nu> (sfid-20081217_130326_354011_E7F573AA)
References: <20081217113031.GA18060@jm.kir.nu> <1229513456.4566.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229513456.4566.2.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 12:30:56PM +0100, Johannes Berg wrote:
> On Wed, 2008-12-17 at 13:30 +0200, Jouni Malinen wrote:
> > It looks like mac80211 may try to send unicast frames to a STA that
> > does not have a STA entry. We need to make sure that that is caught in
> > the rate control code before dereferencing STA data.
> 
> This should only happen for injected packets, can you verify? OTOH, AP
> mode obviously has injected packets (auth response, ...)

I did not check what the exact frame was, but this was indeed in AP mode
and the frame was most likely from hostapd and as such, an injected
packet.

-- 
Jouni Malinen                                            PGP id EFC895FA
