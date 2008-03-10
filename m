Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:9078 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbYCJANg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 20:13:36 -0400
Received: by rv-out-0910.google.com with SMTP id k20so952886rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 17:13:35 -0700 (PDT)
Subject: Re: [PATCH 2/2] tkip: remove inlines duplicating byteorder macros
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204959424.6387.39.camel@johannes.berg>
References: <1204946250.23455.21.camel@brick>
	 (sfid-20080308_031745_516710_D5326048)  <1204959424.6387.39.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 17:07:17 -0700
Message-Id: <1205107642.6474.5.camel@brick> (sfid-20080310_001355_439234_2CA9EFF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-03-08 at 07:57 +0100, Johannes Berg wrote:
> On Fri, 2008-03-07 at 19:17 -0800, Harvey Harrison wrote:
> > Also remove Hi16/Lo16 and open code them in the one place they
> > are used.
> 
> >  	int i, j;
> > +	__le16 *ptr = (__le16 *)ta; /* address is held in LE byteorder */
> > +
> > +	p1k[0] = tsc_IV32 & 0xffff;
> > +	p1k[1] = tsc_IV32 >> 16;
> > +	p1k[2] = __le16_to_cpup(ptr++);
> > +	p1k[3] = __le16_to_cpup(ptr++);
> > +	p1k[4] = __le16_to_cpup(ptr);
> >  
> > -	p1k[0] = Lo16(tsc_IV32);
> > -	p1k[1] = Hi16(tsc_IV32);
> > -	p1k[2] = Mk16(ta[1], ta[0]);
> > -	p1k[3] = Mk16(ta[3], ta[2]);
> > -	p1k[4] = Mk16(ta[5], ta[4]);
> 
> NACK! Now the code assumes natural alignment of the u16s which is, as
> far as I can tell, completely bogus. Please review
> Documentation/unaligned-memory-access.txt.

I didn't think about the alignment constraints, true.  Maybe common
_unaligned versions should be added to the kernel infrastructure instead
of hiding these hand-rolled versions in tkip.c?

Harvey


