Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:51800 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751474Ab2KMWjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 17:39:41 -0500
Message-ID: <1352846384.17444.18.camel@joe-AO722> (sfid-20121113_233945_146174_4F681143)
Subject: Re: [PATCH v7 1/2] wireless: Driver for 60GHz card wil6210
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Jason Baron <jbaron@redhat.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 13 Nov 2012 14:39:44 -0800
In-Reply-To: <20121113134436.de5df090.akpm@linux-foundation.org>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352809427-29682-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352811970.24230.22.camel@joe-AO722>
	 <20121113134436.de5df090.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 13:44 -0800, Andrew Morton wrote:
> On Tue, 13 Nov 2012 05:06:10 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > On Tue, 2012-11-13 at 14:23 +0200, Vladimir Kondratiev wrote:
> > []
> > > diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
> > []
> > > +/* Candidate to merge into printk.h and dynamic_debug.h */
> > > +#if defined(CONFIG_DYNAMIC_DEBUG)
> > > +#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
> > > +			 groupsize, buf, len, ascii)		\
> > > +do {								\
> > > +	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, prefix_str);	\
> > > +	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
> > > +		print_hex_dump(KERN_DEBUG, prefix_str,		\
> > > +			       prefix_type, rowsize, groupsize,	\
> > > +			       buf, len, ascii);		\
> > > +} while (0)
> > > +
> > > +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> > > +		       groupsize, buf, len, ascii)		\
> > > +		       dynamic_hex_dump(prefix_str, prefix_type,\
> > > +					rowsize, groupsize, buf,\
> > > +					len, ascii)
> > > +#else
> > > +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> > > +		       groupsize, buf, len, ascii)		\
> > > +		       print_hex_dump(KERN_DEBUG, prefix_str,	\
> > > +				      prefix_type, rowsize,	\
> > > +				      groupsize, buf, len, ascii)
> > > +#endif
> > 
> > Thanks Vladimir.  I think so too.
> > 
> > Jason?  Andrew?
> 
> (I'm not on linux-wireless)
> 
> Agree that the above should be in a core header file.
> 
> Disagree with placing it in a wireless header.
> 
> Please split it out into a standalone patch.
> 
> Does it have to be done as macros?  Can't do at least some of
> this in C?

Macros are required here because of CONFIG_DYNAMIC_DEBUG
It's how it's done currently for all dynamic_<foo> uses.

> Some interface documentation would be nice, especially if it's
> implemented in macros - that's an awful lot of arguments to have to
> guess about.

kernel-doc should probably be added for all printk forms,
not just for this.


