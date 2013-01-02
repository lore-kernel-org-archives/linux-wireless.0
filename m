Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3ABKuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 05:50:14 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TqLtl-0004Db-P9
	for linux-wireless@vger.kernel.org; Wed, 02 Jan 2013 11:50:13 +0100
Message-ID: <1357123839.9839.1.camel@jlt4.sipsolutions.net> (sfid-20130102_115018_051855_D64AC84F)
Subject: Re: [PATCH 0/4] mac80211: refine TX aggregation session stop
 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 11:50:39 +0100
In-Reply-To: <1356685781-6758-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_100936_158377_93399A38)
References: <1356685781-6758-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121228_100936_158377_93399A38)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-28 at 10:09 +0100, Johannes Berg wrote:
> We ran into problems when an aggregation session is stopped
> when disconnecting, we can't clean it up completely and drop
> all packets right away because we don't know this is valid
> but when we don't doing it later when the station is removed
> gets tricky.
> 
> To solve this, split out the STOP action into the different
> kinds of stop: "stop and continue transmitting" (normal stop),
> "stop and flush packets" (connection drop) and "stop and flush
> a previously stopped session" (can happen when the connection
> drops while a session is still stopping.)

Applied all.

johannes

