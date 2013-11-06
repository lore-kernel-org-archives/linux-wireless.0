Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3KFTDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 14:03:49 -0500
Message-ID: <1383764624.14307.46.camel@jlt4.sipsolutions.net> (sfid-20131106_200352_927601_F2D0398F)
Subject: Re: Crash related to scanning in 'ath' tree (3.12.0-rc5 + minor
 patches)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 06 Nov 2013 20:03:44 +0100
In-Reply-To: <527A9124.5000306@candelatech.com> (sfid-20131106_195744_890692_15B02E5D)
References: <527A9124.5000306@candelatech.com>
	 (sfid-20131106_195744_890692_15B02E5D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 10:57 -0800, Ben Greear wrote:
> This is from the 'ath' tree, which is 3.12.0-rc5.  There are just a few printk patches
> to mac80211, and some moderate amount of patches to ath10k.  I left the ath10k logs in
> this crash in case it provides some clue, but I think it may not be an ath10k problem
> as I have seen what I think is the same crash a few times before in 3.11+ with ath9k.

You couldn't have seen the same crash with ath9k - it's in
ieee80211_prep_hw_scan() which doesn't get called in that case.

johannes

