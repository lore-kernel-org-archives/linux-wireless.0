Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3JHIhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 04:37:48 -0400
Message-ID: <1381221445.13359.0.camel@jlt4.sipsolutions.net> (sfid-20131008_103753_454007_7C3FFF36)
Subject: Re: [PATCH] mac80211: Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(...))
From: Johannes Berg <johannes@sipsolutions.net>
To: David Laight <David.Laight@ACULAB.COM>
Cc: djduanjiong@gmail.com, "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Duan Jiong <duanj.fnst@cn.fujitsu.com>
Date: Tue, 08 Oct 2013 10:37:25 +0200
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7379@saturn3.aculab.com>
References: <1381190953-6362-1-git-send-email-duanj.fnst@cn.fujitsu.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7379@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-08 at 09:33 +0100, David Laight wrote:

> >  	if (IS_ERR(key))
> > -		return ERR_PTR(PTR_ERR(key));
> > +		return ERR_CAST(key);
> 
> I suspect the old code is a deliberate attempt to indicate that it
> the error value that is being returned rather than the pointer.

I was under the impression that's what ERR_CAST means.

> Looking higher up that file there seems to be a fubar when setting
> up the TKIP key.
> It seems to put the same 6 bytes into every TID.
> (I'm sure seq_len shouldn't be ignored either.0

Both are fine.

johannes

