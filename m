Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:51059 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYCKQr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:47:26 -0400
Received: by el-out-1112.google.com with SMTP id v27so1494989ele.17
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 09:47:25 -0700 (PDT)
Subject: Re: [PATCH 1/5] mac80211: use kernel-provided bit
	rotation/byteordering
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1205251904.6387.50.camel@johannes.berg>
References: <1204968174.23455.36.camel@brick>
	 (sfid-20080308_092337_530827_4C02EB9D)  <1205251904.6387.50.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 09:17:16 -0700
Message-Id: <1205252236.22317.0.camel@brick> (sfid-20080311_164731_443630_AC9D261B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-11 at 17:11 +0100, Johannes Berg wrote:
> >  include/linux/bitops.h |   40 ++++++++++++++++++++++++++++++++++++++++
> 
> > +++ b/include/linux/bitops.h
> > @@ -65,6 +65,46 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
> >  	return (word >> shift) | (word << (32 - shift));
> >  }
> >  
> > +/**
> > + * rol16 - rotate a 16-bit value left
> > + * @word: value to rotate
> > + * @shift: bits to roll
> > + */
> > +static inline __u16 rol16(__u16 word, unsigned int shift)
> 
> I don't think we can take that via wireless, and I think architectures
> should be able to override this if they can optimise it (though the
> compiler might be good enough...)

OK, I'll get the common parts through Andrew and once that's in I'll
resubmit the wireless parts.

Harvey

