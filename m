Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3BDPm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2OBf-000357-Rn
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:42:28 +0100
Message-ID: <1359992573.10311.24.camel@jlt4.sipsolutions.net> (sfid-20130204_164304_849321_CB4513AC)
Subject: Re: [PATCH 1/2] mac80211: allow transmitting deauth with tainted key
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:42:53 +0100
In-Reply-To: <1359638107-15306-1-git-send-email-johannes@sipsolutions.net> (sfid-20130131_141448_355132_8437FAF0)
References: <1359638107-15306-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130131_141448_355132_8437FAF0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 14:15 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When we had a connection for WoWLAN and after resume it
> needed to be disconnected, the previous commit enabled
> sending a deauth frame to the AP. This frame would not
> go through on MFP-enabled networks as the key for it is
> marked tainted before the frame is transmitted.
> 
> Allow a tainted key to be used for deauth frames. Worst
> case, we'll use a wrong key because the PTK was rekeyed
> while suspended, but more likely the PTK is still fine
> and the taint flag really only applies to the GTK(s).

Applied both.

johannes

