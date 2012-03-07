Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50932 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab2CGOrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 09:47:11 -0500
Received: by iagz16 with SMTP id z16so8720198iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 06:47:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331130810.3519.16.camel@jlt3.sipsolutions.net>
References: <CAEFj984b_Aihd9hc-dMArPxZPod8eKsxzekLwO74XbTUKGX9LQ@mail.gmail.com>
	<CAEFj984gKDRtjP9NJYqjvWCZ=HxwW3DQ036guVY6Vbj=yx1H6g@mail.gmail.com>
	<1331105902.3519.2.camel@jlt3.sipsolutions.net>
	<CAEFj985EYVeAYef1-G3uVPOxZqwjose9Ge7=MRsbmFWrLNz_RQ@mail.gmail.com>
	<CAEFj984tNRXvBL4cCdJAq2VL7_AgeFYDB=w1b=aLy89pCM5UdA@mail.gmail.com>
	<1331130686.3519.14.camel@jlt3.sipsolutions.net>
	<1331130810.3519.16.camel@jlt3.sipsolutions.net>
Date: Wed, 7 Mar 2012 22:47:10 +0800
Message-ID: <CAEFj984W5PEwJ4ruXbwn0PwZV2s+fXkL=PzFX0DZm1gAyiGA3g@mail.gmail.com> (sfid-20120307_154715_749361_E495346E)
Subject: Re: Hw Accel in Secured Mesh No Longer Work
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

> Does meshd-nl80211 set the station flag NL80211_STA_FLAG_AUTHENTICATED
> before the key?

The key is installed before the set the station flag
NL80211_STA_FLAG_AUTHENTICATED.

/* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);
.....
set_authenticated_flag(&nlcfg, peer);

Chun-Yeow
