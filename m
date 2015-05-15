Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34889 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843AbbEOSfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 14:35:53 -0400
Message-ID: <1431714949.2117.0.camel@sipsolutions.net> (sfid-20150515_203617_106073_A7B09F77)
Subject: Re: mac80211 drops packet with old IV after rekeying
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 May 2015 20:35:49 +0200
In-Reply-To: <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com> (sfid-20150515_095254_231754_1FF752D2)
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
	 <1431674716.2426.2.camel@sipsolutions.net>
	 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
	 (sfid-20150515_095254_231754_1FF752D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-15 at 10:52 +0300, Emmanuel Grumbach wrote:
> >> I'd be glad if someone could take a look. If not, I'll have someone
> >> from our team to look at it, but I don't know how long it will take...
> >
> > Without looking too much - it seems to me that this is a fundamental
> > problem with PTK rekeying, in that it re-uses the key index that is
> > intended to avoid this.
> 
> In this case, the AP is openWRT. I guess the Key idx is chosen in
> software, so maybe the proper fix would be to have openWRT increment
> the key index when it rekeys?

Neither the spec nor the code allow that.

johannes

