Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CGQHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 11:07:09 -0500
Received: by iagz16 with SMTP id z16so8807150iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 08:07:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEFj98638JoG8cuU1bjtn-cOLP_L0=Gud1HDROCQ4srQXxO8Dg@mail.gmail.com>
References: <CAEFj984b_Aihd9hc-dMArPxZPod8eKsxzekLwO74XbTUKGX9LQ@mail.gmail.com>
	<CAEFj984gKDRtjP9NJYqjvWCZ=HxwW3DQ036guVY6Vbj=yx1H6g@mail.gmail.com>
	<1331105902.3519.2.camel@jlt3.sipsolutions.net>
	<CAEFj985EYVeAYef1-G3uVPOxZqwjose9Ge7=MRsbmFWrLNz_RQ@mail.gmail.com>
	<CAEFj984tNRXvBL4cCdJAq2VL7_AgeFYDB=w1b=aLy89pCM5UdA@mail.gmail.com>
	<1331130686.3519.14.camel@jlt3.sipsolutions.net>
	<1331130810.3519.16.camel@jlt3.sipsolutions.net>
	<CAEFj984W5PEwJ4ruXbwn0PwZV2s+fXkL=PzFX0DZm1gAyiGA3g@mail.gmail.com>
	<1331131853.3519.17.camel@jlt3.sipsolutions.net>
	<CAEFj98638JoG8cuU1bjtn-cOLP_L0=Gud1HDROCQ4srQXxO8Dg@mail.gmail.com>
Date: Thu, 8 Mar 2012 00:07:09 +0800
Message-ID: <CAEFj984TfHYQZpCBqAAYh6Oic40TCZXXSANpW6r9JwP+JVedMA@mail.gmail.com> (sfid-20120307_170723_131789_356933DF)
Subject: Re: Hw Accel in Secured Mesh No Longer Work
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes,

I miss out the configuration of HT mode in authsae.cfg, After redo the
test, it works by altering the following in mesh-nl80211.c

        set_authenticated_flag(&nlcfg, peer);

        /* key to encrypt/decrypt unicast data AND mgmt traffic
to/from this peer */
            install_key(&nlcfg, peer, CIPHER_CCMP,
NL80211_KEYTYPE_PAIRWISE, 0, mtk);

Thanks

Hi, Javier

Are you going to make change to this?

Regards,
Chun-Yeow

On Wed, Mar 7, 2012 at 11:29 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Johannes
>
>> Does it work if you turn it around? Are there any problems with doing
>> so?
>
> Nope. Unfortunately, not working.
>
> Regards,
> Chun-Yeow
