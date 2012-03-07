Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58289 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab2CGOVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 09:21:53 -0500
Received: by yhmm54 with SMTP id m54so2891455yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 06:21:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEFj985EYVeAYef1-G3uVPOxZqwjose9Ge7=MRsbmFWrLNz_RQ@mail.gmail.com>
References: <CAEFj984b_Aihd9hc-dMArPxZPod8eKsxzekLwO74XbTUKGX9LQ@mail.gmail.com>
	<CAEFj984gKDRtjP9NJYqjvWCZ=HxwW3DQ036guVY6Vbj=yx1H6g@mail.gmail.com>
	<1331105902.3519.2.camel@jlt3.sipsolutions.net>
	<CAEFj985EYVeAYef1-G3uVPOxZqwjose9Ge7=MRsbmFWrLNz_RQ@mail.gmail.com>
Date: Wed, 7 Mar 2012 22:21:52 +0800
Message-ID: <CAEFj984tNRXvBL4cCdJAq2VL7_AgeFYDB=w1b=aLy89pCM5UdA@mail.gmail.com> (sfid-20120307_152156_861413_69983598)
Subject: Re: Hw Accel in Secured Mesh No Longer Work
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

> Huh? Well that's odd, maybe there's a race condition and you program the
> key before the peer was added to the device?

Not so sure. The adding of key is actually done by the meshd-nl80211
(authsae) daemon running in userspace.

https://github.com/cozybit/authsae/blob/master/linux/meshd-nl80211.c

/* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);

> What device are you working with?
I am using atheros 11n chipset (ath9k).

Regards,
Chun-Yeow
