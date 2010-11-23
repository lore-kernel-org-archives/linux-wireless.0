Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0KWGBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 01:01:01 -0500
Subject: Re: [PATCH 2/3] ath9k: avoid aggregation for VO traffic
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
In-Reply-To: <1290481367.3070.5.camel@Nokia-N900-51-1>
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
	 <1290475383-26911-2-git-send-email-lrodriguez@atheros.com>
	 <1290481367.3070.5.camel@Nokia-N900-51-1>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 07:00:58 +0100
Message-ID: <1290492058.3674.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-23 at 04:02 +0100, Johannes Berg wrote:
> > -        if (ieee80211_is_data_qos(fc)) {
> > +        if (ieee80211_is_data_qos(fc) &&
> > +               (ieee802_1d_to_ac[skb->priority] != IEEE80211_AC_VO)) {
> 
> Isn't skb queue mapping set up already so you could use that?

It must be set up, so you should use that, compare it to AC_VO, and drop
patch 1.

johannes

