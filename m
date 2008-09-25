Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYIYQtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 12:49:13 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1222317983.10563.20.camel@johannes.berg>
References: <>  <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20080925_010455_582253_D66BE03B)  <1222317983.10563.20.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 12:48:12 -0400
Message-Id: <1222361292.14444.7.camel@localhost.localdomain> (sfid-20080925_184917_786459_7F5889BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-25 at 06:46 +0200, Johannes Berg wrote:
> On Wed, 2008-09-24 at 18:15 -0400, John W. Linville wrote:
> > This is also an excuse to create the long rumored lib80211 module...
> 
> Let's also take the chance to clean up the mess Intel has, once again,
> created here.
> 
> >  		switch (info_element->id) {
> >  		case MFIE_TYPE_SSID:
> > -			if (ieee80211_is_empty_essid(info_element->data,
> > -						     info_element->len)) {
> > +			if (is_empty_essid(info_element->data,
> > +					   info_element->len)) {
> >  				network->flags |= NETWORK_EMPTY_ESSID;
> >  				break;
> >  			}
> 
> You can remove the whole NETWORK_EMPTY_ESSID flag and this whole test;
> the code slightly below needs to take care to actually escape the SSID
> for the debug output.
> 
> > @@ -1411,7 +1412,7 @@ static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct iee
> >  			network->mode |= IEEE_B;
> >  	}
> >  
> > -	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
> > +	if (is_empty_essid(network->ssid, network->ssid_len))
> >  		network->flags |= NETWORK_EMPTY_ESSID;
> 
> drop the whole if
>  
> >  
> > -	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
> > +	if (is_empty_essid(network->ssid, network->ssid_len))
> >  		network->flags |= NETWORK_EMPTY_ESSID;
> 
> ditto.
> 
> that leaves once place using the NETWORK_EMPTY_ESSID flag, in
> ieee80211_wx.c:
> 
>         /* Add the ESSID */
>         iwe.cmd = SIOCGIWESSID;
>         iwe.u.data.flags = 1;
>         if (network->flags & NETWORK_EMPTY_ESSID) {
>                 iwe.u.data.length = sizeof("<hidden>");
>                 start = iwe_stream_add_point(info, start, stop,
>                                              &iwe, "<hidden>");
>         } else {
>                 iwe.u.data.length = min(network->ssid_len, (u8) 32);
>                 start = iwe_stream_add_point(info, start, stop,
>                                              &iwe, network->ssid);
>         }
> 
> which is of course *completely* *wrong*. There's no excuse for messing
> up the values passed to userspace like that.
> 
> > +const char *escape_essid(const char *essid, u8 essid_len)
> > +{
> > +	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
> > +	const char *s = essid;
> > +	char *d = escaped;
> > +
> > +	if (is_empty_essid(essid, essid_len)) {
> > +		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
> > +		return escaped;
> > +	}
> 
> Once you've done the above, is_empty_essid is only used here. I'll leave
> it to you whether you want to print <hidden> or not, I'd prefer if the
> function was to just escape the ASCII-NULs as normal since then you can
> actually distinguish the various forms of hidden SSIDs which might help.
> Maybe that needs quotes around the escaped SSID then.
> 
> > +	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
> > +	while (essid_len--) {
> > +		if (*s == '\0') {
> > +			*d++ = '\\';
> > +			*d++ = '0';
> > +			s++;
> > +		} else {
> > +			*d++ = *s++;
> > +		}
> > +	}
> > +	*d = '\0';
> > +	return escaped;
> > +}
> > +EXPORT_SYMBOL(escape_essid);
> 
> Also, we could take the chance to stop making Jean's mistake in calling
> this thing the _E_SSID, there's no such thing, it's Jean's invention,
> based on his misguided thought that this might somehow be less confusing
> to the user.

+1

Dan

