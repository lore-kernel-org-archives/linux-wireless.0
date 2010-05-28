Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab0E1ICf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 04:02:35 -0400
Subject: Re: [PATCH] cfg80211: Removed warning from cfg80211_send_rx_auth
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1275029755.20619.1261.camel@paavo-desktop>
References: <1274870625-19712-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1274872877.3658.4.camel@jlt3.sipsolutions.net>
	 <1274950081.20619.18.camel@paavo-desktop>
	 <1274952442.3669.28.camel@jlt3.sipsolutions.net>
	 <1275029755.20619.1261.camel@paavo-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 10:02:47 +0200
Message-ID: <1275033767.3909.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 09:55 +0300, Teemu Paasikivi wrote:

> > Yes .. I understand the scenario. You don't want to filter it out, you
> > want to abort the authentication so you kill the work for it and never
> > send the timeout to cfg80211.


> Isn't that already done? Aborting the authentication, I mean. 

Evidently not? ieee80211_rx_mgmt_deauth() doesn't touch the work.

> The
> warning is triggered by the authentication response in the
> cfg80211_send_rx_auth function.

Right, ieee80211_rx_mgmt_deauth() removed the auth work, that frame
would never make it up to cfg80211.

>  Removal of the warning would keep logs
> clean. I suppose that in the case where wdev->sme_state !=
> CFG80211_SME_CONNECTING we could just bail out from the
> cfg80211_send_rx_auth function instead of removing the warning.

No ... don't modify cfg80211.

johannes

