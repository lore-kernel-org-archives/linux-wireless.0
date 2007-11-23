Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbXKWMQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:16:18 -0500
Subject: Re: [PATCH] mac80211: remove "bcn_int" and "capab" scan results
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1195736257.6323.89.camel@johannes.berg> (sfid-20071122_125756_937663_F323979F)
References: <1195664138-21789-1-git-send-email-linville@tuxdriver.com>
	 <1195664475.12000.54.camel@johannes.berg> <20071122043156.GB8672@jm.kir.nu>
	 <1195736257.6323.89.camel@johannes.berg>
	 (sfid-20071122_125756_937663_F323979F)
Content-Type: text/plain
Date: Fri, 23 Nov 2007 11:46:28 +0100
Message-Id: <1195814788.4149.92.camel@johannes.berg> (sfid-20071123_121621_123647_0258A82D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > If I understood correctly, the proposed change was removing 'capab'
> > information from scan results(?). If that is the case, that would break
> > wpa_supplicant network selection since there would be no information on
> > whether the network is using encryption or not (privacy flag) and
> > whether it is a BSS or an IBSS. Consequently, I obviously continue to
> > object this type of change as long as WE is used for getting scan
> > results.
> 
> Well, wpa_supplicant currently works, right? And this code is never
> triggered before the change to remove scan_flags because scan_flags
> cannot be set. Hence, I don't see how wpa_supplicant can possibly need
> this information.

In fact, wpa_supplicant isn't even using the capab= information from the
possibly present custom structure in the scan result, it uses
SIOCGIWMODE to figure out whether it's a BSS or an IBSS, and probably
IWEVGENIE to figure out encryption.

The only thing it can possibly read from the custom scan result is
wpa_ie= and rsn_ie= which are IWEVGENIE and tsf= which we never pass.

Therefore, we should merge this patch.

johannes

