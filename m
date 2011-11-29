Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1K2PTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 10:19:37 -0500
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com> (sfid-20111129_161520_149493_69E914E7)
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	 <1322555084.4110.2.camel@jlt3.sipsolutions.net>
	 <CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com>
	 (sfid-20111129_161520_149493_69E914E7)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 16:19:33 +0100
Message-ID: <1322579973.4110.22.camel@jlt3.sipsolutions.net> (sfid-20111129_161941_311578_D9E4E7BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nikolay,

> > Conceptually, this seems OK to me, although on broken APs it might mean
> > connection stalls every minute, not sure how desirable that is?
> 
>   Do APs broken is such way exist? I.e. APs which declare aggregation
> support but do not respond to addba.

I seem to remember something ... not really sure.

>   On the other hand looking at the code I've got an impression that
> connection doesn't stall while waiting for addba resp, i.e. packets
> still go though non-agg path. Did I miss something in this regards?

We queue up packets in ieee80211_tx_prep_agg() when
HT_AGG_STATE_WANT_START is clear but HT_AGG_STATE_OPERATIONAL is not
set, this is the case after we send the addBA request frame and before
we get a response. So since the timeout is 1 second, the connection can
stall for quite a while.

johannes


