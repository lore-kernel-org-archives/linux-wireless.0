Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2CUHlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 03:41:20 -0400
Subject: Re: About the .start function in ieee80211_ops.
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Chen <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALx5=V_0pio6ycdEmChs18747Rvxr_-m-pyicx-hQWdhEb+Y8g@mail.gmail.com>
References: <CALx5=V_czM-3sqhutbYx27wHnLtQL_PvcSjKHd4RGtopkKqf3A@mail.gmail.com>
	 <1332224377.3329.1.camel@jlt3.sipsolutions.net>
	 <CALx5=V-CLY2QE=BuYoYOdBSELmFUxNXQ+Ws5Gh=rCND0SbJL1g@mail.gmail.com>
	 <1332246689.3329.16.camel@jlt3.sipsolutions.net>
	 <CALx5=V_0pio6ycdEmChs18747Rvxr_-m-pyicx-hQWdhEb+Y8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 08:41:09 +0100
Message-ID: <1332315669.3418.0.camel@jlt3.sipsolutions.net> (sfid-20120321_084124_198452_05520066)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-21 at 14:57 +0800, Matt Chen wrote:

> >> > That's a bug in the driver then -- it should probably start the rfkill
> >> > stuff without mac80211's start() command. start() is only called when
> >> > the first interface comes up, but that will never happen if it's in
> >> > rfkill block.
> >> Do you have any idea which part of code would make the first interface
> >> comes up ?  :)
> >> Would that be in cfg80211 ?
> >
> > No code? You, as the user, running "ip link set wlan0 up" or
> > network-manager doing something similar etc.
> Big thank you for the information. :)
> For rt2x00, is this the only way to make the driver executing the .run
> function in ieee80211_ops structure definition ?

You mean .start, and yes :)

johannes

