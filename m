Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37036 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754776AbXGJTNL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 15:13:11 -0400
Date: Tue, 10 Jul 2007 21:13:18 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211: build failure if enabled - 2.6.22 vanilla
Message-ID: <20070710211318.227f8af5@griffin.suse.cz>
In-Reply-To: <4693D60F.7010003@intel.com>
References: <4693D60F.7010003@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 10 Jul 2007 11:55:11 -0700, Kok, Auke wrote:
> I realize mac80211 isn't really helpfull if you don't build any drivers that use 
> it,

Nevertheless, it should build.

> but I currently get:
> 
> ...
>    CC [M]  drivers/scsi/ch.o
>    LD [M]  net/llc/llc.o
>    LD      net/mac80211/built-in.o
> make[2]: *** No rule to make target `net/mac80211/ieee80211.o', needed by 
> `net/mac80211/mac80211.o'.  Stop.
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [net/mac80211] Error 2
> make: *** [net] Error 2
> make: *** Waiting for unfinished jobs....
> 
> if I enable CONFIG_MAC80211=m without selecting any drivers that use this subsystem.

That's strange. I downloaded 2.6.22 and built it with no problems
(mac80211 as a module, without any drivers). Are you sure you haven't
accidentally deleted net/mac80211/ieee80211.c? Can you send me
your .config?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
