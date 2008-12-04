Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47529 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYLDSpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 13:45:15 -0500
Date: Thu, 4 Dec 2008 13:33:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <lrodriguez@atheros.com>
Subject: Re: [PATCH] wireless: Incorrect LEAP authentication algorithm
	identifier.
Message-ID: <20081204183346.GA3690@tuxdriver.com> (sfid-20081204_194525_162661_30CE6B40)
References: <20081204150813.GA7816@senthil-lnx.users.atheros.com> <20081204152224.GA4989@tuxdriver.com> <20081204162003.GA997@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081204162003.GA997@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2008 at 06:20:03PM +0200, Jouni Malinen wrote:
> On Thu, Dec 04, 2008 at 10:22:25AM -0500, John W. Linville wrote:

> > AFAICT this value is only used internally, so it shouldn't matter
> > what the actual value is.
> 
> Nope. WLAN_AUTH_* are the values used in Authentication frames
> (Authentication Algorithm field). See ieee80211_send_auth() in
> net/mac80211/mlme.c. The ifsta->auth_alg must have a value that matches
> with the algorithm identifier in the frame and in the case of LEAP
> ("Network EAP"), this value is 128, not 2.

OK, thanks for the specific reference.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
