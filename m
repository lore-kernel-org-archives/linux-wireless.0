Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1LSQlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 11:41:39 -0500
Subject: Re: [PATCH] mac80211: Fix frame classification in AP mode for
 relayed frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAGXE3d_dH1jeSVrmANd_OARqwY_NUkKu3He6Y7mP8atzas88pA@mail.gmail.com> (sfid-20111219_173726_642965_66436AD1)
References: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com>
	 <1324310130.3414.3.camel@jlt3.sipsolutions.net>
	 <CAGXE3d_dH1jeSVrmANd_OARqwY_NUkKu3He6Y7mP8atzas88pA@mail.gmail.com>
	 (sfid-20111219_173726_642965_66436AD1)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Dec 2011 17:41:36 +0100
Message-ID: <1324312896.3414.16.camel@jlt3.sipsolutions.net> (sfid-20111219_174141_394573_D2207553)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-19 at 17:36 +0100, Helmut Schaa wrote:

> >> We could also reuse the TID used by the source STA but I guess we should
> >> always classify frames according to our own mapping instead of relying
> >> on the associated STAs to do the right thing.
> >
> > Not sure that's useful, since we classify almost nothing anyway.
> 
> Currently we only use the IPv4 DSCP field for assigning TIDs to
> frames. That seems to be sufficient for VOIP traffic at least.
> 
> > If this was somehow hooked up to tc or iptables that would be
> > more useful I guess?
> 
> Agreed. This would make sense in the future but I don't feel like
> implementing this right now.
> 
> So, you'd prefer to just copy over the TID as used by the source
> STA (via the priority+256 hack maybe)?

Seems simpler to me really, at least right now and as default. Not sure,
maybe other people have more opinion? :)

I just don't expect anyone to hack the kernel for their local policy,
and using what the STA wanted seems OK? If you run wifi networks you
kinda trust them already anyway :)

johannes

