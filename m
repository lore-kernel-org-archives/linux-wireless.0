Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:27523 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYBIAla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 19:41:30 -0500
Received: by an-out-0708.google.com with SMTP id d31so950756and.103
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 16:41:28 -0800 (PST)
Subject: Re: [PATCH 08/13] o11s: other changes in mac80211 for mesh
	interface support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202346343.9965.88.camel@johannes.berg>
References: <47a78286.07045a0a.0fd0.ffff8bb1@mx.google.com>
	 (sfid-20080204_212428_285984_7DC49E60)  <1202346343.9965.88.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 16:42:28 -0800
Message-Id: <1202517748.7025.40.camel@localhost> (sfid-20080209_004135_891521_B87914D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-07 at 02:05 +0100, Johannes Berg wrote:
> > +int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
> > +{
> > +	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
> > +	/* 7.1.3.5a.2 */
> > +	switch (ae) {
> > +	case 0:
> > +		return 5;
> > +	case 1:
> > +		return 11;
> > +	case 2:
> > +		return 17;
> > +	case 3:
> > +		return 23;
> > +	default:
> > +		return 5;
> > +	}
> > +}
> 
> What the hell? This is utterly horrible! Can that be changed in the spec
> so the header is always a multiple of four bytes? :)

Well it actually can be changed as it is still a draft... Guess you just
need to convince a few hardware manufacturers that the change is in
their interest..

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.



-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


