Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab3B0Kqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 05:46:37 -0500
Message-ID: <1361961991.8172.4.camel@jlt4.sipsolutions.net> (sfid-20130227_114640_965690_4407068D)
Subject: Re: [PATCH 2/6] mac80211: sync suspend and stop interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 27 Feb 2013 11:46:31 +0100
In-Reply-To: <20130227104247.GA3016@redhat.com>
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
	 <1361793008-2857-2-git-send-email-sgruszka@redhat.com>
	 <1361911440.8440.12.camel@jlt4.sipsolutions.net>
	 <20130227104247.GA3016@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 11:42 +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 26, 2013 at 09:44:00PM +0100, Johannes Berg wrote:
> > More generally, does this really make much sense? There are other things
> > here, e.g. ieee80211_configure_filter(), ieee80211_recalc_ps(),
> > ieee80211_hw_config() and probably more that can be executed in this
> > function -- I don't think protecting these two calls is really
> > sufficient?
> 
> Seems all other drv calls like those on ieee80211_confgure_fitler() do
> not require sdata. So this is most likely sufficient. I'm able to
> reporduce warnings on rt2x00 usb with commit 
> 761ce8c41ed20ee3af77f2df527edc3f92e6f3bf reverted. This patch make
> them gone.

Well, we're talking about different things. You're concerned about
warnings, while I'm saying that semantically this shouldn't be called
while the device is stopped as the driver might not expect it. That
might not cause a warning today, but that's only because we didn't put
in a warning like

	WARN_ON(!local->device_started);

johannes

