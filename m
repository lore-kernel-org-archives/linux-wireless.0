Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2KZK2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:28:52 -0500
Message-ID: <1353925760.9488.9.camel@jlt4.sipsolutions.net> (sfid-20121126_112855_206418_587C3074)
Subject: Re: [PATCH] cfg80211: change function signature of
 cfg80211_get_p2p_attr()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Mon, 26 Nov 2012 11:29:20 +0100
In-Reply-To: <1353925623.9488.8.camel@jlt4.sipsolutions.net> (sfid-20121126_112638_885319_E67ABCE9)
References: <1353867208-11429-1-git-send-email-arend@broadcom.com>
	 <1353925623.9488.8.camel@jlt4.sipsolutions.net>
	 (sfid-20121126_112638_885319_E67ABCE9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 11:27 +0100, Johannes Berg wrote:
> On Sun, 2012-11-25 at 19:13 +0100, Arend van Spriel wrote:
> > The function cfg80211_get_p2p_attr() can fail and returns
> > a negative error code. However, the return type is unsigned
> > int. The largest positive number is determined by desired_len
> > variable in the function, which is u16. So changing the return
> > type to int to allow easy error checking. Also change the type
> > for the attribute to enum for improved type checking.
> > 
> > Signed-off-by: Arend van Spriel <arend@broadcom.com>
> > ---
> > Hi Johannes,
> > 
> > I decided to make use of cfg80211_get_p2p_attr() in brcmfmac
> > and would like this minor change to it.
> > 
> > The only other "driver" using it is mac80211 and it seems it
> > will not mind this change ;-)
> 
> Yeah, well, it actually uses an int as this should, thanks for fixing!
> 
> Applied, but I've fixed your indentation:
> 
> > +int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
> > +				   enum ieee80211_p2p_attr_id attr_id,
> > +				   u8 *buf, unsigned int bufsize)
> >  {
> > +	u8 attr = (u8)attr_id;
> 
> Also this isn't actually needed, you can compare a u8 to attr later :)

And if we change it back, this patch also doesn't break
kernel-doc ... :P

johannes

