Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937AbXHHWu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:50:27 -0400
Date: Wed, 8 Aug 2007 15:48:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif  config
Message-Id: <20070808154813.abf55801.akpm@linux-foundation.org>
In-Reply-To: <200708071744.40287.mb@bu3sch.de>
References: <200708071744.40287.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


mips allmodconfig:

drivers/ssb/driver_pcicore.c: In function `ssb_fixup_pcibridge':
drivers/ssb/driver_pcicore.c:98: error: implicit declaration of function `pcibios_enable_device'
drivers/ssb/driver_pcicore.c: At top level:
drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expression
drivers/ssb/driver_pcicore.c:278: warning: integer overflow in expression
drivers/ssb/driver_extif.c:125: error: redefinition of 'extif_read32'
drivers/ssb/driver_extif.c:21: error: previous definition of 'extif_read32' was here
drivers/ssb/driver_extif.c:130: error: redefinition of 'extif_write32'
drivers/ssb/driver_extif.c:26: error: previous definition of 'extif_write32' was here
drivers/ssb/driver_extif.c:136: error: redefinition of 'serial_exists'
drivers/ssb/driver_extif.c:32: error: previous definition of 'serial_exists' was here
drivers/ssb/driver_extif.c:150: error: redefinition of 'ssb_extif_serial_init'
drivers/ssb/driver_extif.c:46: error: previous definition of 'ssb_extif_serial_init' was here
drivers/ssb/driver_extif.c:181: error: redefinition of 'ssb_extif_timing_init'
drivers/ssb/driver_extif.c:77: error: previous definition of 'ssb_extif_timing_init' was here
drivers/ssb/driver_extif.c:203: error: redefinition of 'ssb_extif_get_clockcontrol'
drivers/ssb/driver_extif.c:99: error: previous definition of 'ssb_extif_get_clockcontrol' was here

There are a bunch of cross-compiler binaries and instructions at 
http://userweb.kernel.org/~akpm/cross-compilers/
