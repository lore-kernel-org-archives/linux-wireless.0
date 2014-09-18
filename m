Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51525 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaIRENP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 00:13:15 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21530.23545.178915.653622@gargle.gargle.HOWL> (sfid-20140918_061319_696683_026A8A9A)
Date: Thu, 18 Sep 2014 09:43:45 +0530
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
In-Reply-To: <21530.19430.782437.984290@gargle.gargle.HOWL>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	<21529.8110.26388.664223@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
	<21529.9155.323515.987489@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
	<21529.10109.308613.563543@gargle.gargle.HOWL>
	<CANUX_P3hdFeCPmqHCdP8JKwqvUUnjgp3SNy1GQDrQd0bG+WKng@mail.gmail.com>
	<21530.19430.782437.984290@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> I don't think trying to switch channel contexts in the flush() callback
> is a good idea. We would be changing the meaning of the callback if
> we do that. Moreover flush() is called from many other places too, like the
> PS code.
> 
> It seems appropriate to instruct a driver to make the necessary
> preparations before sending a deauth frame. Do you see any problems
> if mgd_prepare_tx() is called before initiating deauth ?

Calling mgd_prepare_tx() in ieee80211_send_deauth_disassoc(), which
was the case originally, is probably more correct, since there are other
situations where this will be a problem.

CSA is one example. The driver can receive a beacon, mac80211 begins to
process the CSA and if multiple contexts are active, initiates a disconnect
operation. But, in the meantime, if the driver has switched to a different
context, things will break.

Sujith
