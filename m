Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:58550 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3LQRJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 12:09:12 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3.13] ath9k: disable radar detection support
Date: Tue, 17 Dec 2013 18:09:09 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
References: <1387276187-16063-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1387276187-16063-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312171809.09180.sw@simonwunderlich.de> (sfid-20131217_180916_422425_6EE700D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since the cfg80211 and mac80211 radar detection support is
> rather broken right now, disable it in the only driver that
> advertises support for it. When all the bugs are resolved,
> support for it can be restored.
> 
as discussed already on IRC, what we consider "broken" is: the lockdep issue 
which Kalle (and maybe others?) reported for hwsim, but that does not affect 
ath9k. Probably a hwsim problem only.

For the other issue for which Marek Puzyniak sent a patch ("cfg80211: fix dfs 
channel state after stopping AP"), I don't think this is a bug which should be 
fixed, but intential to keep the channel AVAILABLE after leaving the AP on a 
channel. Let's discuss this in the thread for this patch ...

I don't know if there are other issues, but since it works for me I would 
suggest to drop this patch and keep DFS enabled for ath9k.

Thanks,
    Simon

