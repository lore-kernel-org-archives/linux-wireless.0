Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbYBGSuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 13:50:44 -0500
Date: Thu, 7 Feb 2008 10:49:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, deller@gmx.de,
	jt@hpl.hp.com, rjw@sisk.pl, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-Id: <20080207104912.c719deed.akpm@linux-foundation.org> (sfid-20080207_185048_617939_BA24FEA7)
In-Reply-To: <20080207155152.GA3025@tuxdriver.com>
References: <200801131516.34567.deller@gmx.de>
	<20080202224515.20a09553.akpm@linux-foundation.org>
	<200802062150.23930.deller@gmx.de>
	<20080206130448.564f18bb.akpm@linux-foundation.org>
	<20080206214747.GG32245@flint.arm.linux.org.uk>
	<20080206135950.d48ffa36.akpm@linux-foundation.org>
	<20080207155152.GA3025@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 7 Feb 2008 10:51:52 -0500 "John W. Linville" <linville@tuxdriver.com> wrote:

> On Wed, Feb 06, 2008 at 01:59:50PM -0800, Andrew Morton wrote:
> > On Wed, 6 Feb 2008 21:47:47 +0000
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > > I assume that it's the second BUILD_BUG_ON() which is triggering?
> > 
> > yup.
> > 
> > > Given that:
> > > 
> > > #define MMW_SIZE        37
> > > 
> > > is not a multiple of sizeof(unsigned long) this is hardly surprising.
> > > 
> > > If structures are used to define a layout of something and must not
> > > contain compiler padding, it must be packed.  Given these structures
> > > contain just unsigned char, there's no concerns about >8bit loads
> > > becoming less efficient.
> 
> Does a patch like this suffice?  I haven't checked whether such a
> patch implies that the BUILD_BUG_ON()'s become unnecessary...

With your patch applied and arm allmodconfig, this

        BUILD_BUG_ON(sizeof(ha_t) != HA_SIZE);

triggers

Without your patch applied, these two

        BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);
        BUILD_BUG_ON(sizeof(ha_t) != HA_SIZE);

are triggering.

