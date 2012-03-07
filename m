Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2CGOb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 09:31:28 -0500
Subject: Re: Hw Accel in Secured Mesh No Longer Work
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
In-Reply-To: <CAEFj984tNRXvBL4cCdJAq2VL7_AgeFYDB=w1b=aLy89pCM5UdA@mail.gmail.com> (sfid-20120307_152224_978018_6FCBF45E)
References: <CAEFj984b_Aihd9hc-dMArPxZPod8eKsxzekLwO74XbTUKGX9LQ@mail.gmail.com>
	 <CAEFj984gKDRtjP9NJYqjvWCZ=HxwW3DQ036guVY6Vbj=yx1H6g@mail.gmail.com>
	 <1331105902.3519.2.camel@jlt3.sipsolutions.net>
	 <CAEFj985EYVeAYef1-G3uVPOxZqwjose9Ge7=MRsbmFWrLNz_RQ@mail.gmail.com>
	 <CAEFj984tNRXvBL4cCdJAq2VL7_AgeFYDB=w1b=aLy89pCM5UdA@mail.gmail.com>
	 (sfid-20120307_152224_978018_6FCBF45E)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 15:31:26 +0100
Message-ID: <1331130686.3519.14.camel@jlt3.sipsolutions.net> (sfid-20120307_153134_073534_E08EB414)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Huh? Well that's odd, maybe there's a race condition and you program the
> > key before the peer was added to the device?
> 
> Not so sure. The adding of key is actually done by the meshd-nl80211
> (authsae) daemon running in userspace.
> 
> https://github.com/cozybit/authsae/blob/master/linux/meshd-nl80211.c
> 
> /* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
> install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);

Yeah but that always required a station ... now you have a station but
it's not uploaded.

> > What device are you working with?
> I am using atheros 11n chipset (ath9k).

Ok.

I think you're probably trying to set a key before the station is set to
associated?

johannes

