Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1FVPw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 11:52:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QZPj9-0002lj-Q1
	for linux-wireless@vger.kernel.org; Wed, 22 Jun 2011 17:52:27 +0200
Subject: Re: [RFC] mac80211: notify driver about auth/assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1305292460.3487.36.camel@jlt3.sipsolutions.net> (sfid-20110513_151435_631931_4E03E74D)
References: <1305292460.3487.36.camel@jlt3.sipsolutions.net>
	 (sfid-20110513_151435_631931_4E03E74D)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 17:52:25 +0200
Message-ID: <1308757945.29571.17.camel@jlt3.sipsolutions.net> (sfid-20110622_175232_936971_1D57B46F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 15:14 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In P2P client mode, the GO (AP) to connect to might
> have periods of time where it is not available due
> to powersave. To allow the driver to sync with them
> and send frames to the GO only when it is available
> add a new callback prepare_auth_assoc (and also the
> corresponding finish_auth_assoc). They are invoked
> for each authentication/association as described in
> the documentation.

Doesn't anybody have comments on this?

I can't really decide whether I want to change the bss_config flow to
maybe set the BSSID first and add a preauth flag there or something, or
use this way. This way certainly has less impact on existing drivers...

johannes

