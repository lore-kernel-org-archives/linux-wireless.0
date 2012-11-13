Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2KMVoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 16:44:37 -0500
Date: Tue, 13 Nov 2012 13:44:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Jason Baron <jbaron@redhat.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v7 1/2] wireless: Driver for 60GHz card wil6210
Message-Id: <20121113134436.de5df090.akpm@linux-foundation.org> (sfid-20121113_224440_794716_C733E8E3)
In-Reply-To: <1352811970.24230.22.camel@joe-AO722>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1352809427-29682-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1352811970.24230.22.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 Nov 2012 05:06:10 -0800
Joe Perches <joe@perches.com> wrote:

> On Tue, 2012-11-13 at 14:23 +0200, Vladimir Kondratiev wrote:
> []
> > diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
> []
> > +/* Candidate to merge into printk.h and dynamic_debug.h */
> > +#if defined(CONFIG_DYNAMIC_DEBUG)
> > +#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
> > +			 groupsize, buf, len, ascii)		\
> > +do {								\
> > +	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, prefix_str);	\
> > +	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
> > +		print_hex_dump(KERN_DEBUG, prefix_str,		\
> > +			       prefix_type, rowsize, groupsize,	\
> > +			       buf, len, ascii);		\
> > +} while (0)
> > +
> > +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> > +		       groupsize, buf, len, ascii)		\
> > +		       dynamic_hex_dump(prefix_str, prefix_type,\
> > +					rowsize, groupsize, buf,\
> > +					len, ascii)
> > +#else
> > +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> > +		       groupsize, buf, len, ascii)		\
> > +		       print_hex_dump(KERN_DEBUG, prefix_str,	\
> > +				      prefix_type, rowsize,	\
> > +				      groupsize, buf, len, ascii)
> > +#endif
> 
> Thanks Vladimir.  I think so too.
> 
> Jason?  Andrew?

(I'm not on linux-wireless)

Agree that the above should be in a core header file.

Disagree with placing it in a wireless header.

Please split it out into a standalone patch.

Does it have to be done as macros?  Can't do at least some of
this in C?

Some interface documentation would be nice, especially if it's
implemented in macros - that's an awful lot of arguments to have to
guess about.
