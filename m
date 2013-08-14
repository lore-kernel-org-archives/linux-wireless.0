Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580Ab3HNMAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 08:00:53 -0400
Message-ID: <1376481649.14574.1.camel@jlt4.sipsolutions.net> (sfid-20130814_140059_359061_13B06064)
Subject: Re: [PATCH 3.11] cfg80211: don't request disconnect if not connected
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: neilb@suse.de
Date: Wed, 14 Aug 2013 14:00:49 +0200
In-Reply-To: <1376378976-9588-1-git-send-email-johannes@sipsolutions.net> (sfid-20130813_092948_171352_CB47677C)
References: <1376378976-9588-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130813_092948_171352_CB47677C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-13 at 09:29 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Neil Brown reports that with libertas, my recent cfg80211
> SME changes in commit ceca7b7121795ef81bd598a240d53a92566
> ("cfg80211: separate internal SME implementation") broke
> libertas suspend because it we now asked it to disconnect
> while already disconnected.
> 
> The problematic change is in cfg80211_disconnect() as it
> previously checked the SME state and now calls the driver
> disconnect operation unconditionally.
> 
> Fix this by checking if there's a current_bss indicating
> a connection, and do nothing if not.

Applied.

johannes

