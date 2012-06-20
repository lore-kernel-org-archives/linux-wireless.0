Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2FTJLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:11:37 -0400
Message-ID: <1340183495.4655.54.camel@jlt3.sipsolutions.net> (sfid-20120620_111141_886353_4CA3B5FC)
Subject: Re: [PATCH] cfg80211: fix regression in multi-vif AP start
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 11:11:35 +0200
In-Reply-To: <1340067057-56601-1-git-send-email-nbd@openwrt.org>
References: <1340067057-56601-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 02:50 +0200, Felix Fietkau wrote:
> Commit "cfg80211: provide channel to start_ap function" assumes that the
> channel is always passed to the NL80211_CMD_START_AP command, however
> in case of multi-BSSID, hostapd only passes the channel for the first vif.
> This makes starting beaconing on secondary vifs fail with -EINVAL.
> 
> Fix this by storing the channel provided to .start_ap in wdev->preset_chan
> and picking the first AP vif's channel for secondary vifs if not provided.

Applied, thanks.

johannes

