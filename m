Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1KPK5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 05:57:52 -0500
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <20111116105120.GA6139@pandem0nium>
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1321429935.4773.10.camel@jlt3.sipsolutions.net>
	 <20111116105120.GA6139@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 11:57:47 +0100
Message-ID: <1321441067.4773.26.camel@jlt3.sipsolutions.net> (sfid-20111116_115755_479186_0EF5AA89)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Can you explain what for? :-)
> 
> We want to set NoAck for special traffic classes like video or voice where
> "old" packets are not useful, but keep it for background and best effort traffic.
> This can be applied on devices supporting both traffic classes (e.g. 
> laptops, smartphones with VoIP software) as well as for backhaul links.

Ok.

> > I'm not sure this API is really the best way to handle it either, like I
> > just said it might be nicer per connection or so to get reset properly.
> > 
> 
> I'm not sure what you mean by "per connection" - do you mean per AP/Sta
> connection? We need definitely need it per queue as explained above.

No, I mean ... it could be a parameter to connect() or associate(),
which would get a bitmap of ACs to use no-ack policy for, instead of an
explicit new configuration.

> > > I have tested this feature on ath9k as well as ath5k devices. There is
> > > an iw patch as well to make use of this feature.
> > 
> > Since you're adding 'real API' (unlike the debugfs file which you should
> > probably remove now!) you also should think about drivers like mwifiex
> > that don't support this and don't use mac80211.
> 
> mwifiex neither supports set_txq_params nor the new function, nl80211 should
> just return "-EOPNOTSUPP". A short grep revealed that no driver in wireless-testing
> implements set_txq_params so far, so at least for the drivers within the kernel
> this should be safe. I forgot to explicitly check for rdev->ops->set_txq_noack
> and will add this check in v2 ...

Good point -- but if you'd change to make it a parameter for connect and
associate (I think that is better since it will clean up by itself
properly when disconnecting) then you would need some flag indicating
that the driver/device supports this (with mac80211 obviously always
supporting it).

johannes


