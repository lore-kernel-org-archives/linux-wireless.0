Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4900 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbXEQQDG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 12:03:06 -0400
Date: Thu, 17 May 2007 11:31:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Message-ID: <20070517153126.GA7720@tuxdriver.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705122156.43796.flamingice@sourmilk.net> <20070514202929.GD6999@tuxdriver.com> <200705170148.06683.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705170148.06683.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 17, 2007 at 01:48:02AM -0400, Michael Wu wrote:
> On Monday 14 May 2007 16:29, John W. Linville wrote:
> > If you don't know why it is there, how about a comment indicating
> > what gave you the notion of putting it there?  E.g. "copied from
> > realtek example code" or somesuch?
> >
> The driver is mostly a port of the original r8187 driver.
 
OK.  We still could use a "reminder" comment before magic bits.

> > For this block in particular, I think you had stated that the
> > hardware works without it.  Is there any reason not to just remove it?
> > Just precaution?
> >
> Yes. Don't want to change code that's known to be working at this point.

Understandable.  Please add a "magic from realtek" comment.
 
> > > > More magic number tables of unknown origin...you get the idea. :-)  I
> > > > realize that these are either copied straight from a datasheet or from
> > > > someone's reverse engineered sources -- let's just have a comment
> > > > saying so for each block of these.
> > >
> > > The *entire* rtl8187_rtl8225.c file is full of magic numbers. I'm not
> > > willing to put comments saying so for every single function/definition. I
> > > really don't know what's going on in that file.
> >
> > OK, "each block" would be excessive if they all come from the
> > same place.  A single comment is probably fine.  I do see "Based on
> > the r8187 driver" at the top, but more information would be better.
> > Since Andrea is still around maybe the origin of that information is
> > still identifiable?
> >
> The r8187 driver is still around. (Realtek has it on their website) For the 
> most part, that information is comes from some Realtek engineer(s).

Fine.  How about a (hopefully permanent) URL?

> > [linville-t43.mobile]:> sparse example.c
> > example.c:15:12: warning: mixing different enum types
> > example.c:15:12:     int [signed] enum bar  versus
> > example.c:15:12:     int [signed] enum foo
> >
> That's what I thought.. but it's not that useful for me. Using the wrong 
> register bit definition is extremely unlikely to happen. (I've never done 
> it.) However, using the wrong size register read or write function happens 
> and has been caught a number of times by the register typechecking.

At the risk of belaboring the point... :-)

--------------------------------------------------------------------------------

/* definitions to make things work outside of kernel... */

#define __bitwise __attribute__((bitwise))
#define __force __attribute__((force))

typedef unsigned int __u32;
typedef __u32 __bitwise __le32;

typedef unsigned short __u16;
typedef __u16 __bitwise __le16;

/* example starts here... */

enum foo {
	FOO_BIT_BLAH	= (__force __le32)(1 << 1),
	FOO_BIT_BLECH	= (__force __le32)(1 << 2),
};

enum bar {
	BAR_BIT_BLAH	= (__force __le16)(1 << 3),
	BAR_BIT_BLECH	= (__force __le16)(1 << 4),
};

static void blather(void)
{
	enum foo drizzle;
	__le16 drazzle;

	drizzle = BAR_BIT_BLAH;

	drazzle = (__force __le16)5;
	drizzle = drazzle;
}

--------------------------------------------------------------------------------

[linville-t43.mobile]:> sparse -Wall example.c
example.c:29:10: warning: incorrect type in assignment (different base types)
example.c:29:10:    expected restricted unsigned int enum foo drizzle
example.c:29:10:    got restricted unsigned short enum bar [toplevel] BAR_BIT_BLAH
example.c:29:12: warning: mixing different enum types
example.c:29:12:     restricted unsigned short enum bar  versus
example.c:29:12:     restricted unsigned int enum foo
example.c:32:10: warning: incorrect type in assignment (different base types)
example.c:32:10:    expected restricted unsigned int enum foo drizzle
example.c:32:10:    got restricted unsigned short [assigned] [usertype] drazzle

Again, I don't really see this as a merge blocker.  But, it is worth
considering.

So, how about you sprinkle-in a couple more comments for the magic
copied from Realtek and resubmit?  Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
