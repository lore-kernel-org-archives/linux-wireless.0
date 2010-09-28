Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0I1TLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 15:11:07 -0400
Subject: Re: RFC:  Store premable and g-mode flags in ieee80211_tx_info
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CA23B7A.7020602@candelatech.com>
References: <4CA224FF.3030103@candelatech.com>
	 <1285696089.32597.0.camel@jlt3.sipsolutions.net>
	 <4CA22C34.1000107@candelatech.com>
	 <1285699998.32597.1.camel@jlt3.sipsolutions.net>
	 <4CA23B7A.7020602@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 21:11:05 +0200
Message-ID: <1285701065.32597.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 12:01 -0700, Ben Greear wrote:
> On 09/28/2010 11:53 AM, Johannes Berg wrote:
> > On Tue, 2010-09-28 at 10:56 -0700, Ben Greear wrote:
> >
> >> Anyway, the reason is that the driver may not know the VIF (and
> >> vif may be deleted) when calling the ieee80211_rts_duration, so it needs to be stored
> >> in the tx_info structure.
> >
> > But the vif pointer in the tx_info structure is valid during the entire
> > tx() call, why would you need to call rts_duration during TX status?
> 
> Err, I guess you are right.  I was thinking it might retransmit sometime
> later, but at least ath5k doesn't appear to do this.

mac80211 has retransmit support, but that'll go through TX with a valid
vif pointer again ...

johannes

