Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52702 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbYJRRBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 13:01:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] Add nl80211 commands to get and set o11s mesh networking parameters.
Date: Sat, 18 Oct 2008 19:00:48 +0200
Cc: colin@cozybit.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net
References: <48f7dedf.16098e0a.7692.537e@mx.google.com> <1224341637.6324.29.camel@johannes.berg>
In-Reply-To: <1224341637.6324.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810181900.48707.mb@bu3sch.de> (sfid-20081018_190144_072360_A0F90FE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 18 October 2008 16:53:57 Johannes Berg wrote:
> > +	return (mask >> (attr-1)) & 0x1;
> 
> I think
> 
> 	return mask & (1<<(attr-1));
> 
> would be easier to understand.


I'm not sure if that would be correct.
The returned type is bool, which is 8bit. mask is 32bit.
So if attr is > 8 you end up with truncation, AFAICS.

So it should be

	return !!(mask & (1<<(attr-1)));

to explicitely convert the mask into a boolean with the LSB
indicating the state.

But the original contruct isn't that bad, either, IMO :)

-- 
Greetings Michael.
