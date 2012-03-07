Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab2CGOuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 09:50:55 -0500
Subject: Re: Hw Accel in Secured Mesh No Longer Work
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
In-Reply-To: <CAEFj984W5PEwJ4ruXbwn0PwZV2s+fXkL=PzFX0DZm1gAyiGA3g@mail.gmail.com> (sfid-20120307_154743_314516_32C26C90)
References: <CAEFj984b_Aihd9hc-dMArPxZPod8eKsxzekLwO74XbTUKGX9LQ@mail.gmail.com>
	 <CAEFj984gKDRtjP9NJYqjvWCZ=HxwW3DQ036guVY6Vbj=yx1H6g@mail.gmail.com>
	 <1331105902.3519.2.camel@jlt3.sipsolutions.net>
	 <CAEFj985EYVeAYef1-G3uVPOxZqwjose9Ge7=MRsbmFWrLNz_RQ@mail.gmail.com>
	 <CAEFj984tNRXvBL4cCdJAq2VL7_AgeFYDB=w1b=aLy89pCM5UdA@mail.gmail.com>
	 <1331130686.3519.14.camel@jlt3.sipsolutions.net>
	 <1331130810.3519.16.camel@jlt3.sipsolutions.net>
	 <CAEFj984W5PEwJ4ruXbwn0PwZV2s+fXkL=PzFX0DZm1gAyiGA3g@mail.gmail.com>
	 (sfid-20120307_154743_314516_32C26C90)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 15:50:53 +0100
Message-ID: <1331131853.3519.17.camel@jlt3.sipsolutions.net> (sfid-20120307_155058_374701_FE09C43F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-07 at 22:47 +0800, Yeoh Chun-Yeow wrote:
> Hi, Johannes
> 
> > Does meshd-nl80211 set the station flag NL80211_STA_FLAG_AUTHENTICATED
> > before the key?
> 
> The key is installed before the set the station flag
> NL80211_STA_FLAG_AUTHENTICATED.
> 
> /* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
> install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);
> .....
> set_authenticated_flag(&nlcfg, peer);

Does it work if you turn it around? Are there any problems with doing
so?

This is solvable in the kernel, but probably harder, and impossible if
you wanted to use crypto algorithms that mac80211 doesn't support in
software.

johannes

