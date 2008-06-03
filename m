Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:56882 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYFCUgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 16:36:32 -0400
Received: by nf-out-0910.google.com with SMTP id d3so669024nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 13:36:30 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 01/11 v2] rt2x00: Calculate register offset during compile time
Date: Tue, 3 Jun 2008 22:44:05 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032205.17071.IvDoorn@gmail.com> <1212525130.14371.0.camel@johannes.berg>
In-Reply-To: <1212525130.14371.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806032244.05382.IvDoorn@gmail.com> (sfid-20080603_223635_390215_81D384E8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 June 2008, Johannes Berg wrote:
> 
> > +#define compile_ffs2(__x) \
> > +	( ((__x) & 0x1) ? 0 : 1 )
> > +
> > +#define compile_ffs4(__x) \
> > +	( ((__x) & 0x3) ? \
> > +	    compile_ffs2(__x) : (compile_ffs2(__x >> 2) + 2) )
> 
> It seems you should also add parentheses around the __x used in the
> recursive macro invocation, like this:
> 
> ... : (compile_ffs2((__x) >> 2) + 2) )
> 
> or am I missing something?

Nope, you are right. :)
Version 3 on its way.

Thanks,

Ivo
