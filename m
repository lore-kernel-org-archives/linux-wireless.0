Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3GaTSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:18:32 -0400
Message-ID: <1375298308.8289.21.camel@jlt4.sipsolutions.net> (sfid-20130731_211835_293173_C16F65B9)
Subject: Re: [PATCH 3.11] mac80211: ignore HT primary channel while connected
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
	Andy Isaacson <adi@hexapodia.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 31 Jul 2013 21:18:28 +0200
In-Reply-To: <1375264234-31077-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_115057_319103_0639D869)
References: <1375264234-31077-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130731_115057_319103_0639D869)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 11:50 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> While we're connected, the AP shouldn't change the primary channel
> in the HT information. We checked this, and dropped the connection
> if it did change it.
> 
> Unfortunately, this is causing problems on some APs, e.g. on the
> Netgear WRT610NL: the beacons seem to always contain a bad channel
> and if we made a connection using a probe response (correct data)
> we drop the connection immediately and can basically not connect
> properly at all.
> 
> Work around this by ignoring the HT primary channel information in
> beacons if we're already connected.
> 
> Also print out more verbose messages in the other situations to
> help diagnose similar bugs quicker in the future.

Applied.

johannes

