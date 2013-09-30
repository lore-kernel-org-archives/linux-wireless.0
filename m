Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3I3O1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 10:27:25 -0400
Message-ID: <1380551237.14467.12.camel@jlt4.sipsolutions.net> (sfid-20130930_162728_987423_B22DBF41)
Subject: Re: Kernel panic in ieee80211_calculate_rx_timestamp
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Lindroth <thomas.lindroth@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 16:27:17 +0200
In-Reply-To: <523B3BEA.9000100@gmail.com> (sfid-20130919_200122_426878_A0C53351)
References: <523B3BEA.9000100@gmail.com>
	 (sfid-20130919_200122_426878_A0C53351)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-19 at 20:01 +0200, Thomas Lindroth wrote:
> I recently got a ath9k_htc based dongle and running kismet for a few
> hours results in a kernel panic (divide error) in
> ieee80211_calculate_rx_timestamp with kernel 3.11.0.
> 
> The problem seems to occur when the call to cfg80211_calculate_bitrate
> returns 0. I've used this patch to temporarily works around the problem.

Seems fair, but maybe it should print out the rate info so you can see
what was actually received - most likely this is a driver bug though.

If you submit a patch that can be applied with signed-off-by etc. I can
apply it.

johannes


