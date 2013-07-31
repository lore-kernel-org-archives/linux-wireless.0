Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3GaTRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:17:06 -0400
Message-ID: <1375298223.8289.18.camel@jlt4.sipsolutions.net> (sfid-20130731_211711_087744_77CA0953)
Subject: Re: [PATCH 3.11] mac80211: continue using disabled channels while
 connected
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: chrisw@sous-sol.org
Date: Wed, 31 Jul 2013 21:17:03 +0200
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

Applied.

(ok, so this was a short time, but it's kinda an important fix ...)

johannes

