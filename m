Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34111 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2DHMtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 08:49:08 -0400
Received: by obbtb18 with SMTP id tb18so4828613obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 05:49:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333735303.5577.8.camel@jlt3.sipsolutions.net>
References: <1333735303.5577.8.camel@jlt3.sipsolutions.net>
Date: Sun, 8 Apr 2012 15:49:07 +0300
Message-ID: <CAB3XZEe1kJ7bB08nm5p8nwJRfrE9Ew+THZN_Q=1KOf1=3QQULA@mail.gmail.com> (sfid-20120408_144913_711838_4EBD7444)
Subject: Re: [RFC] nl80211/mac80211: support full station state in AP mode
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 6, 2012 at 9:01 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Today, stations are added already associated. That is
> inefficient if, for example, the driver has no room
> for stations any more because then the station will
> go through the entire auth/assoc handshake, only to
> be kicked out afterwards.
>
> To address this a bit better, at least with drivers
> using the new station state callback, allow hostapd
> to add stations in unauthenticated mode, just after
> receiving the AUTH frame, before even replying. Thus
> if there's no more space at that point, it can send
> a negative auth frame back. It still needs to handle
> later state transition errors though, of course.
>
> Completely untested so far, just wanted to see what
> everybody thinks. I'll need to work on the hostapd
> patch as well, but I think TI had something there to
> fix a race which I need to look into.
>
The patch looks good -- i agree it's better to add the station as soon
as possible.

in our internal hostap tree, we use the following patches:
https://github.com/TI-OpenLink/hostap/commit/44e8fd28f9b2fc8da9c6f58a2731b4ffa65bc396
(https://github.com/TI-OpenLink/hostap/commit/bf21f3fe7541cd17b7b92aaf6bf06a00e9ec28bb)

These patches handle the race in which the EAPOL Start from the client
comes before the association response tx result, causing the EAPOL to
get dropped.
The first patch simply adds the station before sending the association
response. I guess that with the suggested patch we'll just have to set
the ASSOC state (before sending assoc response) instead of adding the
station (which will be done before sending auth response, i guess).

Eliad.
