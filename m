Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19954 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2HLFaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 01:30:08 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20519.15997.154761.163636@gargle.gargle.HOWL> (sfid-20120812_073054_212217_4CC99520)
Date: Sun, 12 Aug 2012 10:56:21 +0530
To: Antonio Quartulli <ordex@autistici.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 1/2] mac80211: add sta_update_rates callback
In-Reply-To: <20120809093245.GG6767@ritirata.org>
References: <1344474712-22561-1-git-send-email-ordex@autistici.org>
	<1344492897.4494.1.camel@jlt3.sipsolutions.net>
	<20120809093245.GG6767@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli wrote:
> mh, at the very beginning I thought it was not correct what you said, but indeed
> we should be able to do the job in sta_rc_update().
> 
> But then why does the ath9k_htc driver implement ath9k_htc_update_rate() to
> update the rate used to talk to the AP? Should it use sta_rc_update() as well?

We didn't have this new callback back then, and sta_rc_update() is sufficient to
fix this. Maybe with a new flag - IEEE80211_RC_BASIC_RATES_CHANGED.

Sujith
