Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3GaTKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:10:52 -0400
Message-ID: <1375297845.8289.16.camel@jlt4.sipsolutions.net> (sfid-20130731_211055_326387_6D220131)
Subject: Re: [PATCH 3.11] mac80211: continue using disabled channels while
 connected
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: chrisw@sous-sol.org
Date: Wed, 31 Jul 2013 21:10:45 +0200
In-Reply-To: <1375297799-2023-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_211029_520496_7736CF8B)
References: <1375297799-2023-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130731_211029_520496_7736CF8B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 21:09 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In case the AP has different regulatory information than we do,
> it can happen that we connect to an AP based on e.g. the world
> roaming regulatory data, and then update our database with the
> AP's country information disables the channel the AP is using.
> If this happens on an HT AP, the bandwidth tracking code will
> hit the WARN_ON() and disconnect. Since that's not very useful,
> ignore the channel-disable flag in bandwidth tracking.
> 
> Reported-by: Chris Wright <chrisw@sous-sol.org>
> Tested-by: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Forgot Cc stable, will add.

johannes

