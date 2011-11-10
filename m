Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab1KJJc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 04:32:57 -0500
Subject: Re: [PATCH v3] mac80211/cfg80211: report monitor channel in
 wireless extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CA+XFjirhwYeU2fJJ7ua6XxGyG+oKBK9xhxnjOKZqV8-rN9u6nQ@mail.gmail.com> (sfid-20111110_102934_143930_76429D40)
References: <1320778327.24797.36.camel@jlt3.sipsolutions.net>
	 <1320778887.24797.38.camel@jlt3.sipsolutions.net>
	 <1320831021.3845.14.camel@jlt3.sipsolutions.net>
	 <CA+XFjirhwYeU2fJJ7ua6XxGyG+oKBK9xhxnjOKZqV8-rN9u6nQ@mail.gmail.com>
	 (sfid-20111110_102934_143930_76429D40)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 10:32:51 +0100
Message-ID: <1320917571.3967.17.camel@jlt3.sipsolutions.net> (sfid-20111110_103303_161039_EA0657D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-10 at 10:28 +0100, Gábor Stefanik wrote:

> > @@ -1342,6 +1342,9 @@ struct cfg80211_gtk_rekey_data {
> >  *     doesn't verify much. Note, however, that the passed netdev may be
> >  *     %NULL as well if the user requested changing the channel for the
> >  *     device itself, or for a monitor interface.
> > + * @get_channel: Get the current operating channel, should return %NULL if
> > + *     there's no single defined operating channel if for example the
> > + *     device implements channel hopping for multi-channel virtual interfaces.
> 
> Why not return the the channel the radio is tuned to at the moment of
> the request in that case?

Mostly, you won't even know. In many cases the device will switch
internally. And even if you could know, since it's switching many times
per second it'll be completely useless.

Frankly, I think this whole thing is completely useless. IMNSHO aircrack
or whatever tool uses this is brain-dead since radiotap reports the
correct frequency for each frame *anyway*.

johannes

