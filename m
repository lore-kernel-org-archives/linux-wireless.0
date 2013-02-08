Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947122Ab3BHV5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 16:57:54 -0500
Message-ID: <1360360665.29851.37.camel@jlt4.sipsolutions.net> (sfid-20130208_225808_512761_8AD772AE)
Subject: Re: [RFCv2 2/3] mac80211: mesh power save doze scheduling
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Fri, 08 Feb 2013 22:57:45 +0100
In-Reply-To: <5114CECD.2040508@cozybit.com> (sfid-20130208_110921_709130_DD21AFD9)
References: <1360151325-6368-1-git-send-email-marco@cozybit.com>
	  <1360151325-6368-3-git-send-email-marco@cozybit.com>
	  (sfid-20130206_124915_323291_448699F4) <1360315234.29851.15.camel@jlt4.sipsolutions.net>
	 <5114CECD.2040508@cozybit.com> (sfid-20130208_110921_709130_DD21AFD9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 11:09 +0100, Marco Porsch wrote:

> >> For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
> >> a timer which triggers a doze call on expiry.
> >
> > That seems questionable -- drivers are not required to request each
> > beacon. I know you only want to make it work on ath9k, but I don't think
> > "stretching" the API, without even documenting it, is a good idea.
> 
> Currently, we already use ieee80211_beacon_get_tim as time reference for 
> mesh sync's adjust_tbtt. And, as far as I know, all mesh-capable drivers 
> use the call for each and every beacon.

Oops, why did I miss that before? :-)

> So what would you recommend: keep using beacon_get and adding 
> documentation - or - creating an exported callback for awake_window_start?

I guess you could add it... However, I don't really fully understand.
There's no guarantee that fetching the beacon is done anywhere close to
TBTT? Or does ath9k happen to do it just after TXing a beacon? You're
encoding quite a lot of ath9k-specific assumptions here it seems?

johannes

