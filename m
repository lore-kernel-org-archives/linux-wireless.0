Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50288 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbYLDQyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 11:54:09 -0500
Date: Thu, 4 Dec 2008 18:20:03 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <lrodriguez@atheros.com>
Subject: Re: [PATCH] wireless: Incorrect LEAP authentication algorithm
	identifier.
Message-ID: <20081204162003.GA997@jm.kir.nu> (sfid-20081204_175414_597182_771982AF)
References: <20081204150813.GA7816@senthil-lnx.users.atheros.com> <20081204152224.GA4989@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081204152224.GA4989@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2008 at 10:22:25AM -0500, John W. Linville wrote:
> On Thu, Dec 04, 2008 at 08:38:13PM +0530, Senthil Balasubramanian wrote:
> > -#define WLAN_AUTH_LEAP 2
> > +#define WLAN_AUTH_LEAP 128

> What is the regression? What problem does this cause?

The current code fails to authenticate when the AP (most likely Cisco
AP) is configured for "Network EAP" mode. The old code (before the
cleanup) allowed the authentication to be completed successfully.

> AFAICT this value is only used internally, so it shouldn't matter
> what the actual value is.

Nope. WLAN_AUTH_* are the values used in Authentication frames
(Authentication Algorithm field). See ieee80211_send_auth() in
net/mac80211/mlme.c. The ifsta->auth_alg must have a value that matches
with the algorithm identifier in the frame and in the case of LEAP
("Network EAP"), this value is 128, not 2.

-- 
Jouni Malinen                                            PGP id EFC895FA
