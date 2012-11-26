Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2KZKYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:24:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tcvrt-0000EL-Em
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 11:24:49 +0100
Message-ID: <1353925518.9488.6.camel@jlt4.sipsolutions.net> (sfid-20121126_112453_167547_4DD5BF3E)
Subject: Re: [PATCH] cfg80211: use DS or HT operation IEs to determine BSS
 channel
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:25:18 +0100
In-Reply-To: <1353678324-32160-1-git-send-email-johannes@sipsolutions.net> (sfid-20121123_144502_888428_2B11BC8F)
References: <1353678324-32160-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121123_144502_888428_2B11BC8F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 14:45 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Currently, mac80211 checks the DS params IE if present and
> uses it for the (primary) BSS channel, instead of the one
> that the frame was received on. This is particularly useful
> in the 2.4 GHz band since a frame is often received on one
> of the adjacent channels due to overlap.
> 
> Move this code to cfg80211 so other drivers also do this.
> 
> Additionally, on 5 GHz, in particular with some (possibly)
> upcoming changes in 802.11ai and duplicate transmissions
> when wider channels are used, something similar happens.
> So if present, also use the (primary) channel information
> contained in the HT operation IE.

Applied.

johannes

