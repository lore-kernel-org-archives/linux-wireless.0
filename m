Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXDAAwJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 20:52:09 -0400
Subject: Re: mac80211 does not support WPA when used with wext
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200703311503.53445.flamingice@sourmilk.net>
References: <460E2B8C.4030002@gmail.com>
	 <1175335211.23438.45.camel@johannes.berg>
	 <1175363333.9349.10.camel@localhost.localdomain>
	 <200703311503.53445.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 20:55:40 -0400
Message-Id: <1175388940.10282.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-03-31 at 15:03 -0400, Michael Wu wrote:
> On Saturday 31 March 2007 13:48, Dan Williams wrote:
> > On Sat, 2007-03-31 at 12:00 +0200, Johannes Berg wrote:
> > > On Sat, 2007-03-31 at 11:36 +0200, dragoran wrote:
> > > > Hello
> > > > While testing the iwlwifi driver I noticed that the mac80211 does
> > > > provide a wext interface but does not support wpa with it.
> > >
> > > You must have done something wrong, it works well.
> >
> > Nope!  This time it's really mac80211 :)
> >
> > Take a look at ieee80211_sta_scan_result() in mac80211/ieee80211_sta.c.
> > Note that it returns custom events for the WPA & RSN IEs.  That's just
> > wrong.  We should be using already-defined events.
> >
> What does that have to do with WPA not working? wpa_supplicant works fine with 
> the custom events on my system. Also works fine with the standard events 
> which the following patch makes mac80211 use.

wpa_supplicant works fine with it because it parses the custom events.

NetworkManager will not parse custom events by design, in the same way
that it will not allow WPA to be used on a card unless the driver
explicitly advertises WPA support, and requires the use of the
wpa_supplicant WEXT driver.  I'm not going to spend my time implementing
stuff 3 different ways; we need to standardize this stuff and stick with
it.

Draw a line in the sand and all that.  Sure, it's made some people's
lives harder, but NetworkManager was the reason madwifi added WE-19
support, for example.

Patch looks good though; thanks!  One thing I just thought of, which no
drivers probably do.  Should mac80211 check that there's enough space
left in the WE stream to actually add the IE?  There are usually checks
to ensure that there's enough space to add the next whole BSS, but I
don't know if we do checks to during the addition of each BSS.  Maybe
I'm wrong and this isn't an issue.

Dan

> --
> 
> mac80211: use IWEVGENIE
> 
> From: Michael Wu <flamingice@sourmilk.net>
> 
> Use IWEVGENIE which was defined in WE-18.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---
> 
>  net/mac80211/ieee80211_sta.c |   40 ++++++++++------------------------------
>  1 files changed, 10 insertions(+), 30 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 087f176..a227c38 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -2839,39 +2839,19 @@ ieee80211_sta_scan_result(struct net_device *dev,
>  	current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, "");
>  
>  	if (bss && bss->wpa_ie) {
> -		char *buf, *p;
> -		int i;
> -		buf = kmalloc(30 + bss->wpa_ie_len * 2, GFP_ATOMIC);
> -		if (buf) {
> -			p = buf;
> -			p += sprintf(p, "wpa_ie=");
> -			for (i = 0; i < bss->wpa_ie_len; i++)
> -				p+= sprintf(p, "%02x", bss->wpa_ie[i]);
> -			memset(&iwe, 0, sizeof(iwe));
> -			iwe.cmd = IWEVCUSTOM;
> -			iwe.u.data.length = strlen(buf);
> -			current_ev = iwe_stream_add_point(current_ev, end_buf,
> -							  &iwe, buf);
> -			kfree(buf);
> -		}
> +		memset(&iwe, 0, sizeof(iwe));
> +		iwe.cmd = IWEVGENIE;
> +		iwe.u.data.length = bss->wpa_ie_len;
> +		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
> +						  bss->wpa_ie);
>  	}
>  
>  	if (bss && bss->rsn_ie) {
> -		char *buf, *p;
> -		int i;
> -		buf = kmalloc(30 + bss->rsn_ie_len * 2, GFP_ATOMIC);
> -		if (buf) {
> -			p = buf;
> -			p += sprintf(p, "rsn_ie=");
> -			for (i = 0; i < bss->rsn_ie_len; i++)
> -				p+= sprintf(p, "%02x", bss->rsn_ie[i]);
> -			memset(&iwe, 0, sizeof(iwe));
> -			iwe.cmd = IWEVCUSTOM;
> -			iwe.u.data.length = strlen(buf);
> -			current_ev = iwe_stream_add_point(current_ev, end_buf,
> -							  &iwe, buf);
> -			kfree(buf);
> -		}
> +		memset(&iwe, 0, sizeof(iwe));
> +		iwe.cmd = IWEVGENIE;
> +		iwe.u.data.length = bss->rsn_ie_len;
> +		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
> +						  bss->rsn_ie);
>  	}
>  
>  	if (bss) {

