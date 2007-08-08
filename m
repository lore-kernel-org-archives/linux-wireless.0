Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760718AbXHHXo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 19:44:57 -0400
Date: Wed, 8 Aug 2007 16:43:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-Id: <20070808164327.45803a64.akpm@linux-foundation.org>
In-Reply-To: <46BA4E24.3060400@aurel32.net>
References: <200708071744.40287.mb@bu3sch.de>
	<20070808154813.abf55801.akpm@linux-foundation.org>
	<46BA4E24.3060400@aurel32.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 09 Aug 2007 01:13:40 +0200
Aurelien Jarno <aurelien@aurel32.net> wrote:

> Andrew Morton a __crit :
> > mips allmodconfig:
> > 
> > drivers/ssb/driver_pcicore.c: In function `ssb_fixup_pcibridge':
> > drivers/ssb/driver_pcicore.c:98: error: implicit declaration of function `pcibios_enable_device'
> > drivers/ssb/driver_pcicore.c: At top level:
> > drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expression
> > drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expression
> 
> Those looks like real errors.

They seems to have gone away after I droped the duplicated patches.

> > drivers/ssb/driver_extif.c:125: error: redefinition of 'extif_read32'
> > drivers/ssb/driver_extif.c:21: error: previous definition of 'extif_read32' was here
> > drivers/ssb/driver_extif.c:130: error: redefinition of 'extif_write32'
> > drivers/ssb/driver_extif.c:26: error: previous definition of 'extif_write32' was here
> > drivers/ssb/driver_extif.c:136: error: redefinition of 'serial_exists'
> > drivers/ssb/driver_extif.c:32: error: previous definition of 'serial_exists' was here
> > drivers/ssb/driver_extif.c:150: error: redefinition of 'ssb_extif_serial_init'
> > drivers/ssb/driver_extif.c:46: error: previous definition of 'ssb_extif_serial_init' was here
> > drivers/ssb/driver_extif.c:181: error: redefinition of 'ssb_extif_timing_init'
> > drivers/ssb/driver_extif.c:77: error: previous definition of 'ssb_extif_timing_init' was here
> > drivers/ssb/driver_extif.c:203: error: redefinition of 'ssb_extif_get_clockcontrol'
> > drivers/ssb/driver_extif.c:99: error: previous definition of 'ssb_extif_get_clockcontrol' was here
> > 
> 
> All the versions of driver_extif.c I have seen have at maximum around
> 100 lines. It looks like a patch applied twice, which make the same code
> appearing twice in the .c file.

Yeah.  I dropped a bunch of things which seemed to help.

I'm hopelessly confused by the ssb stuff.  I'm not sure if I have all the
right stuff, all the latest stuff and I don't understand why some is going
into git-wireless and some is not.

I'd prefer to be dumbly pulling a tree which Michael controls rather than
trying to master it all in -mm, if possible.  A git tree or a quilt tree in
some open dir somewhere would suit?


