Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38424 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755881AbXD0Olr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 10:41:47 -0400
Date: Fri, 27 Apr 2007 16:42:08 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Dan Williams <dcbw@redhat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070427164208.25434f11@griffin.suse.cz>
In-Reply-To: <1177684132.21025.36.camel@localhost.localdomain>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<200704251634.16604.flamingice@sourmilk.net>
	<46312067.9090005@linux.intel.com>
	<200704262023.52833.flamingice@sourmilk.net>
	<1177684132.21025.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Apr 2007 10:28:52 -0400, Dan Williams wrote:
> We shouldn't be ignoring discrete hardware functionality just because
> it's in the firmware and also may be in the stack.  Hardware crypto like
> somebody mentioned.  TCP offload.  etc.  Not allowing a driver writer to
> take advantage of hardware functionality is quite short-sighted.  Having
> a pure host-CPU software stack is not utopia; it's entirely unrealistic
> for a variety of reasons, some of which are below [1].

I'm not saying no (see my other mail in this thread), I see some
reasons myself, but I don't think your reasons are valid.

> 1) power-critical situations like embedded devices where some pieces
> must be offloaded to the wireless part

Such solutions will use fullmac. See e.g. OLPC.

> 2) lower-speed devices that may not have cycles to burn on functions
> that the hardware can also do, even if most of the stack is software

Such solutions have no other way than using fullmac.

> 3) timing critical functions

Such as? Scanning? That's not timing critical at all. Or something
other?

> 4) hybrid parts that are mostly softmac (ipw2100, ipw2200)

Supporting of halfmacs in a softmac stack is hardly possible. You can
write something like a "halfsoftmac" but you need to do that for each
such chipset again. Because (by definition) every halfmac chipset needs
a different set of functionality from the stack.

> 5) we don't make hardware

But we are also not required to support every obscure feature of the
hardware.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
