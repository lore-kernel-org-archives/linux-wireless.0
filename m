Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44263 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2GYSZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 14:25:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Su6Gg-0006Xc-Pq
	for linux-wireless@vger.kernel.org; Wed, 25 Jul 2012 20:25:06 +0200
Received: from 81-57.bbned.dsl.internl.net ([92.254.57.81])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 20:25:06 +0200
Received: from Mijzelf by 81-57.bbned.dsl.internl.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 20:25:06 +0200
To: linux-wireless@vger.kernel.org
From: Mijzelf <Mijzelf@live.com>
Subject: Re: Uknown symbols in =?utf-8?b?cmZraWxsX2JhY2twb3J0Lmtv?= on 2.6.25.17 on mips
Date: Wed, 25 Jul 2012 18:10:38 +0000 (UTC)
Message-ID: <loom.20120725T195215-756@post.gmane.org> (sfid-20120725_202520_185450_90380419)
References: <0621389a37a568a7ebd526b0adc87a48@fileserver.lan> <20120724175617.0a4206c4@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@...> writes:

> 
> On Sun, 22 Jul 2012 21:11:34 +0200
> Mijzelf <Mijzelf@...> wrote:
> 
> > I'm trying to get ath9k from compat-wireless-2012-05-08 running on a 
> > 2.6.25.17 kernel on mips. The module refuses to load, due to unkown 
> > symbols.
> > # modprobe ath9k
> > modprobe: can't load module rfkill_backport 
> > (updates/net/rfkill/rfkill_backport.ko): unknown symbol in module, or 
> > unknown parameter
> > # dmesg
> > rfkill_backport: Unknown symbol input_register_handle
> > rfkill_backport: Unknown symbol input_open_device
> > rfkill_backport: Unknown symbol input_close_device
> > rfkill_backport: Unknown symbol input_unregister_handler
> > rfkill_backport: Unknown symbol input_register_handler
> > rfkill_backport: Unknown symbol input_unregister_handle
> > 
> > Any suggestions?
> 
> If you can recompile the kernel, enable CONFIG_INPUT in .config
> 

Thanks. I was able to compile the input module, and this issue is solved.

Now a new one pops up:
/tmpfs/root # modprobe ath9k
modprobe: can't load module mac80211 (updates/net/mac80211/mac80211.ko): 
unknown symbol in module, or unknown parameter
/tmpfs/root # dmesg 
mac80211: Unknown symbol _flush_cache

I grepped the source tree, and the word 'flush_cache' only exists in the 
objects of mac80211.ko. So I suppose it's some macro expansion. But I also 
grepped all include files in my kernel tree, and flush_cache only appeared 4 
times:

./drivers/scsi/ips.h:   IPS_FC_CMD         flush_cache;
./drivers/video/i810/i810_main.h:static inline void flush_cache(void)
./drivers/video/i810/i810_main.h:#define flush_cache() do { } while(0)
./arch/powerpc/boot/ops.h:extern void flush_cache(void *, unsigned long);

It seems to me no one of these can cause a symbol _flush_cache in a module. 

Because the symbol is in the object files, I suppose it cannot added by some 
library either. (Are there any libraries linked against kernel modules?)

Where does this come from? 



