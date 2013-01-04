Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3ADNai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 08:30:38 -0500
Message-ID: <1357306259.11302.20.camel@jlt4.sipsolutions.net> (sfid-20130104_143044_848845_B7B126B0)
Subject: Re: WARNING: at net/wireless/mlme.c:517
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julian Wollrath <jwollrath@web.de>, linux-wireless@vger.kernel.org
Date: Fri, 04 Jan 2013 14:30:59 +0100
In-Reply-To: <50E325B5.205@lwfinger.net> (sfid-20130101_190652_609944_FB0A8B6D)
References: <20130101154507.351dfb03@ilfaris> <50E325B5.205@lwfinger.net>
	 (sfid-20130101_190652_609944_FB0A8B6D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-01 at 12:06 -0600, Larry Finger wrote:

> > [  436.155998] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> > [  436.158343] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411
> > status=0 aid=4) [  436.158478] wlan0: associated [  436.158538] IPv6:
> > ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready [  446.153705]
> > ------------[ cut here ]------------ [  446.153765] WARNING: at
> > net/wireless/mlme.c:517 cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]()
> 
> This one indicates that there was a call to disassociate when the device was not 
> associated. It might have been informative to have seen the logged messages 
> earlier than 436.155474 seconds.
> 
> Johannes: Why is this a WARN_ON condition? Certainly, the returned -ENOTCON does 
> the right thing, even though some part of the system got confused.

That's why it's a warning, it points to an internal state confusion --
current_bss should always be assigned if sme_state is SME_CONNECTED. Or
so I thought, evidently that's not the case. I don't see how this
happens in the code though.

johannes

