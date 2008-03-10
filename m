Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:15622 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYCJANb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 20:13:31 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1970718wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 17:13:28 -0700 (PDT)
Subject: Re: [PATCH 1/2] tkip: remove unused function, other cleanups
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204959156.6387.34.camel@johannes.berg>
References: <1204946240.23455.19.camel@brick>
	 (sfid-20080308_031744_226744_CE5F76EA)  <1204959156.6387.34.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 17:03:46 -0700
Message-Id: <1205107431.6474.1.camel@brick> (sfid-20080310_001353_659799_0728BFDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-03-08 at 07:52 +0100, Johannes Berg wrote:
> > -static inline u16 tkip_S(u16 val)
> > +static u16 tkip_S(u16 val)
> >  {
> > -	u16 a = tkip_sbox[Hi8(val)];
> > -
> > -	return tkip_sbox[Lo8(val)] ^ Hi8(a) ^ (Lo8(a) << 8);
> > +	return tkip_sbox[val & 0xff] ^ __swab16(tkip_sbox[val >> 8]);
> 
> What's wrong with using the non-underscored versions? This is pure
> kernel code...

That was a thinko on my part, I resent this in a 5-patch series shortly
thereafter without the underscores (the alignment problems you noted in
2/2 still remain).

Thanks for the comments.

Harvey

