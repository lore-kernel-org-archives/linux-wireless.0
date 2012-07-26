Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65296 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab2GZV0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 17:26:00 -0400
Date: Thu, 26 Jul 2012 17:25:55 -0400
From: Pavel Roskin <proski@gnu.org>
To: Mijzelf <Mijzelf@live.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Uknown symbols in rfkill_backport.ko on 2.6.25.17 on mips
Message-ID: <20120726172555.246a668c@mj> (sfid-20120726_232612_070363_64EC22E4)
In-Reply-To: <loom.20120725T195215-756@post.gmane.org>
References: <0621389a37a568a7ebd526b0adc87a48@fileserver.lan>
	<20120724175617.0a4206c4@mj>
	<loom.20120725T195215-756@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 25 Jul 2012 18:10:38 +0000 (UTC)
Mijzelf <Mijzelf@live.com> wrote:

> Thanks. I was able to compile the input module, and this issue is
> solved.
> 
> Now a new one pops up:
> /tmpfs/root # modprobe ath9k
> modprobe: can't load module mac80211
> (updates/net/mac80211/mac80211.ko): unknown symbol in module, or
> unknown parameter /tmpfs/root # dmesg 
> mac80211: Unknown symbol _flush_cache
> 
> I grepped the source tree, and the word 'flush_cache' only exists in
> the objects of mac80211.ko. So I suppose it's some macro expansion.
> But I also grepped all include files in my kernel tree, and
> flush_cache only appeared 4 times:
> 
> ./drivers/scsi/ips.h:   IPS_FC_CMD         flush_cache;
> ./drivers/video/i810/i810_main.h:static inline void flush_cache(void)
> ./drivers/video/i810/i810_main.h:#define flush_cache() do { } while(0)
> ./arch/powerpc/boot/ops.h:extern void flush_cache(void *, unsigned
> long);
> 
> It seems to me no one of these can cause a symbol _flush_cache in a
> module. 

I agree.

> Because the symbol is in the object files, I suppose it cannot added
> by some library either. (Are there any libraries linked against
> kernel modules?)

No.  Everything used by the modules should be provided by symbols
exported by the kernel.

> Where does this come from? 

My guess is that either it's a result of some clever macro expansion
(so that the source doesn't have "flush_cache") or gcc inserts that call
(perhaps hoping that libgcc has it) but the kernel doesn't satisfy it.

First of all, make sure that you are making a clean build and there are
no object files left from older builds.

Then find the object file that calls _flush_cache.  Recompile the
corresponding source file with "-save-temps".  Look for "flush_cache"
in the *.i and the *.s file.  Try to find out where it comes from.

-- 
Regards,
Pavel Roskin
