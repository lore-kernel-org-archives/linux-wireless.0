Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:15577 "EHLO
	qualcomm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751900Ab2KRNxO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 08:53:14 -0500
From: Vladimir Kondratiev <vkondrat@qti.qualcomm.com>
To: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jason Baron <jbaron@redhat.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
Date: Sun, 18 Nov 2012 15:51:26 +0200
Message-ID: <1367870.EsNpLZfRqp@lx-vladimir> (sfid-20121118_145347_091717_BFA5E2BA)
In-Reply-To: <3304277.iqgq3GH3Yo@lx-vladimir>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <29414886.frl7IkqOMP@lx-vladimir> <3304277.iqgq3GH3Yo@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, November 18, 2012 11:47:58 AM Vladimir Kondratiev wrote:
> On Wednesday, November 14, 2012 07:27:47 PM Vladimir Kondratiev wrote:
> > +#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,     \
> > +                        groupsize, buf, len, ascii)            \
> > +do {                                                           \
> > +       DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, prefix_str);  \
> > +       if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  \
> > +               print_hex_dump(KERN_DEBUG, prefix_str,          \
> > +                              prefix_type, rowsize, groupsize, \
> > +                              buf, len, ascii);                \
> > +} while (0)
> 
> There is some problem with the code above. There are existing drivers
> that use print_hex_dump_bytes() with the prefix_str built dynamically,
> like this (see drivers/tty/ipwireless/hardware.c:362)
> 
> static void dump_data_bytes(const char *type, const unsigned char *data,
> 			    unsigned length)
> {
> 	char prefix[56];
> 
> 	sprintf(prefix, IPWIRELESS_PCCARD_NAME ": %s %s ",
> 			type, data_type(data, length));
> 	print_hex_dump_bytes(prefix, 0, (void *)data,
> 			length < DUMP_MAX_BYTES ? length : DUMP_MAX_BYTES);
> }
> 
> In this case, prefix_str is not constant, and this solution will not
> work.
> 
> I see 2 drivers that use dynamic prefix:
> 
> - mentioned above drivers/tty/ipwireless/hardware.c
> - drivers/isdn/hardware/mISDN/
> 
> I see several options:
> 
> 1) require prefix_str to be constant. Patch code mentioned. For example,
> code above may reads:
> 
> static void dump_data_bytes(const char *type, const unsigned char *data,
> 			    unsigned length)
> {
> 	pr_debug(IPWIRELESS_PCCARD_NAME ": %s %s\n",
> 			type, data_type(data, length));
> 	print_hex_dump_bytes(IPWIRELESS_PCCARD_NAME, 0, (void *)data,
> 			length < DUMP_MAX_BYTES ? length : DUMP_MAX_BYTES);
> }
> 
> 2) introduce fixed format string in DEFINE_DYNAMIC_DEBUG_METADATA, like
> 
> DEFINE_DYNAMIC_DEBUG_METADATA((descriptor, "hexdump");
> 
> 3) remove print_hex_dump_bytes from this patch
> 
> I think 1) is the best, opinions?
> 
> Thanks, Vladimir

In case of option 1), patches follows. Note there is change in the initial patch as well (I forgot to exclude print_hex_dump_bytes() from compilation in hexdump.c. Please, comment.


