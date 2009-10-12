Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37400 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbZJLGzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 02:55:51 -0400
Date: Mon, 12 Oct 2009 09:55:07 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: deauthentication and disassociation nl80211 commands
Message-ID: <20091012065507.GB25578@jm.kir.nu>
References: <1254708707.24430.68.camel@maxim-laptop> <1255191866.4095.32.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255191866.4095.32.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 10, 2009 at 06:24:26PM +0200, Johannes Berg wrote:
> On the other hand, I think Jouni's argument is that you should be able
> to authenticate (force an auth frame exchange) even while authenticated.
> I don't really disagree with that all that much, but I'm not sure how to
> cleanly fit it in. mac80211 would have to reset the auth state without
> sending a deauth.

Yes, this is exactly what I would like to see happening when using
mac80211. For now, I think we can work around the issue in
wpa_supplicant, but eventually, this change in mac80211 would allow the
code in wpa_supplicant to be cleaned up and the need for an extra
deauthentication frame could be removed.

-- 
Jouni Malinen                                            PGP id EFC895FA
