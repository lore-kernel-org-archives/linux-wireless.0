Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3IZK6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 06:58:43 -0400
Message-ID: <1380193118.14806.0.camel@jlt4.sipsolutions.net> (sfid-20130926_125846_733636_80D6DF2A)
Subject: Re: [PATCH] cfg80211: Provision to pass probe response ie along
 with remain on channel request
From: Johannes Berg <johannes@sipsolutions.net>
To: Sreenath Sharma <sreenats@broadcom.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Thu, 26 Sep 2013 12:58:38 +0200
In-Reply-To: <20130926073414.GA15283@sreenath-Precision-M4700>
References: <20130926073414.GA15283@sreenath-Precision-M4700>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-26 at 13:04 +0530, Sreenath Sharma wrote:
> The probe response ie should be set in driver before the listen state
> for a listen only P2P device. Right now probe response ie is set using
> driver specific private command implementations. This commit enhances the
> remain_on_channel command handler to pass probe response ie along with
> rest of the arguments.
> 
> Another approach is the addition of a new nl80211 command specific to pass
> ies to driver. This will give more flexibilty to upper layer.

Umm, no, nack. this is totally bogus. You're implementing something like
"P2P-listen offload" but hiding it inside the "remain-on-channel"
command. That's totally the wrong way to go about it.

NACK. Not going to accept this.

johannes

