Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbXDAEsf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2007 00:48:35 -0400
Subject: Re: mac80211 does not support WPA when used with wext
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200703312121.26758.flamingice@sourmilk.net>
References: <460E2B8C.4030002@gmail.com>
	 <200703311503.53445.flamingice@sourmilk.net>
	 <1175388940.10282.7.camel@localhost.localdomain>
	 <200703312121.26758.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sun, 01 Apr 2007 00:51:57 -0400
Message-Id: <1175403117.10282.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-03-31 at 21:21 -0400, Michael Wu wrote:
> On Saturday 31 March 2007 20:55, Dan Williams wrote:
> > wpa_supplicant works fine with it because it parses the custom events.
> >
> > NetworkManager will not parse custom events by design, in the same way
> > that it will not allow WPA to be used on a card unless the driver
> > explicitly advertises WPA support, and requires the use of the
> > wpa_supplicant WEXT driver.  I'm not going to spend my time implementing
> > stuff 3 different ways; we need to standardize this stuff and stick with
> > it.
> >
> > Draw a line in the sand and all that.  Sure, it's made some people's
> > lives harder, but NetworkManager was the reason madwifi added WE-19
> > support, for example.
> >
> NetworkManager doesn't parse custom events? I'm pretty sure WPA/WPA2 was 
> reported correctly in the scan results before.. maybe because of this little 
> bit of code?
> 
> NetworkManager-0.6.4/src/nm-device-802-11-wireless.c:
> case IWEVCUSTOM:
>     clen = iwe->u.data.length;
>     if (custom + clen > end)
>         break;
>     if (clen > 7 && ((strncmp (custom, "wpa_ie=", 7) == 0) || (strncmp 
> (custom, "rsn_ie=", 7) == 0)))
> ...
> 
> But that's besides the point. It is true that proper events should be used, 
> but that issue has nothing to do with why WPA isn't working with 
> NetworkManager. That was my point.

Huh; right.  My bad :)  What's probably going on here then is that since
the driver wasn't reporting WPA capability via enc_capa, the applet
wont' show WPA as an option, and NM won't allow you to connect to
WPA-enabled access points.

In any case, with 0.7 all the scanning code is ripped out in favor of
using the D-Bus interface to wpa_supplicant, so this goes away and its
wpa_supplicant's problem and not mine.

Dan

> > Patch looks good though; thanks!  One thing I just thought of, which no
> > drivers probably do.  Should mac80211 check that there's enough space
> > left in the WE stream to actually add the IE?  There are usually checks
> > to ensure that there's enough space to add the next whole BSS, but I
> > don't know if we do checks to during the addition of each BSS.  Maybe
> > I'm wrong and this isn't an issue.
> >
> iwe_stream_add_point(char *     stream,         /* Stream of events */
>                      char *     ends,           /* End of stream */
>                      struct iw_event *iwe,      /* Payload length + flags */
>                      char *     extra)          /* More payload */
> {
>         int     event_len = IW_EV_POINT_LEN + iwe->u.data.length;
>         /* Check if it's possible */
>         if(likely((stream + event_len) < ends)) {
> 
> -Michael Wu

