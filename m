Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYLAR3g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 12:29:36 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1226969241.4014.24.camel@johannes.berg>
References: <1226969241.4014.24.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 09:30:31 -0800
Message-Id: <1228152631.10900.6.camel@rc-desk> (sfid-20081201_182940_520097_4E659E56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Mon, 2008-11-17 at 16:47 -0800, Johannes Berg wrote:
> [patch below, sorry for the long list of CCs]
> 
> So I dug deeper into the DMA problems I had with iwlagn and a kind soul
> helped me in that he said something about pci-e alignment and mentioned
> the iwl_rx_allocate function to check for crossing 4KB boundaries. Since
> there's 8KB A-MPDU support, crossing 4k boundaries didn't seem like
> something the device would fail with, but when I looked into the
> function for a minute anyway I stumbled over this little gem:
> 
>         BUG_ON(rxb->dma_addr & (~DMA_BIT_MASK(36) & 0xff));
> 
> Clearly, that is a totally bogus check, one would hope the compiler
> removes it entirely. (Think about it)
> 
> After fixing it, I obviously ran into it, nothing guarantees the
> alignment the way you want it,  because of the way skbs and their
> headroom are allocated. I won't explain that here nor double-check that
> I'm right, that goes beyond what most of the CC'ed people care about.
> 
> So then I came up with the patch below, and so far my system has
> survived minutes with 64K pages, when it would previously fail in
> seconds. And I haven't seen a single instance of the TX bug either. But
> when you see the patch it'll be pretty obvious to you why.
> 
> This should fix the following reported kernel bugs:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11596
> http://bugzilla.kernel.org/show_bug.cgi?id=11393
> http://bugzilla.kernel.org/show_bug.cgi?id=11983
> 
> I haven't checked if there are any elsewhere, but I suppose RHBZ will
> have a few instances too...
> 
> I'd like to ask anyone who is CC'ed (those are people I know ran into
> the bug) to try this patch.
> 
> I am convinced that this patch is correct in spirit, but I haven't
> understood why, for example, there are so many unmap calls. I'm not
> entirely convinced that this is the only bug leading to the TX reply
> errors.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---

Above you mention that this patch fixes bug #11596. Could you please
explain how this patch addresses that problem? A short summary of the
bug is that no data (ping packets) can be transmitted while station is
associated. We have, what appears to be, a similar bug in our bug
tracking system
(http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1807 ), but
this patch was not able to resolve this issue.

Bug #11596 was recently closed after the user tested with 2.6.27.4,
which does not have this patch. 

Thank you

Reinette


