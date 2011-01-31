Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1AaL1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:27:43 -0500
Subject: Re: [RFC] mac80211: deauthenticate STAs before suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296468391-12268-1-git-send-email-rmanoharan@atheros.com>
References: <1296468391-12268-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:27:41 +0100
Message-ID: <1296473261.3812.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 15:36 +0530, Rajkumar Manoharan wrote:
> The STA is not deauthenticated before the system goes to sleep,
> when the vif was configured by iw/iwconfig. This holds the AP
> resources unnecessarily, till the STA entry got expired in AP.

Is that a big problem? We actually had this intentionally, and we go to
PS before going to sleep, so if the sleep is very short then we will not
be disconnected. Also, it's much easier this way to implement WoWLAN.

> So before going to sleep ensure that all stations
> got deauthenticated.

Also your text and subject and code is really confusing -- I thought you
wanted to deauthenticate stations that are associated to mac80211 acting
as an AP.

johannes

