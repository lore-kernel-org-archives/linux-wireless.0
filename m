Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbaKNImf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 03:42:35 -0500
Date: Fri, 14 Nov 2014 09:39:37 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: remove net-pf-16-proto-16-family-nl80211
 module alias
Message-ID: <20141114083936.GA1949@redhat.com> (sfid-20141114_094240_083593_916E821F)
References: <20141113123313.GA1926@redhat.com>
 <1415882683.2021.3.camel@sipsolutions.net>
 <20141113132252.GB1926@redhat.com>
 <252AB6B9-9D33-4932-B75F-D3B2B057D3C0@holtmann.org>
 <20141113133928.GC1926@redhat.com>
 <4E8F3B23-EC77-4B53-8180-7DB12042E0B5@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E8F3B23-EC77-4B53-8180-7DB12042E0B5@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2014 at 10:48:11PM +0900, Marcel Holtmann wrote:
> Hi Stanislaw,
> 
> >>> With the alias cfg80211 module is loaded on systems without the wireless
> >>> hardware when user-space use nl80211 to discover if there are wireless
> >>> devices, what is considered as resources wastage. On systems with
> >>> wireless hardware cfg80211 module will be loaded anyway.
> >>> 
> >>> Cc: Marcel Holtmann <marcel@holtmann.org>
> >>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >>> ---
> >>> net/wireless/core.c | 1 -
> >>> 1 file changed, 1 deletion(-)
> >>> 
> >>> diff --git a/net/wireless/core.c b/net/wireless/core.c
> >>> index a4d2792..badcabe 100644
> >>> --- a/net/wireless/core.c
> >>> +++ b/net/wireless/core.c
> >>> @@ -34,7 +34,6 @@
> >>> MODULE_AUTHOR("Johannes Berg");
> >>> MODULE_LICENSE("GPL");
> >>> MODULE_DESCRIPTION("wireless configuration support");
> >>> -MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);
> >> 
> >> NAK.
> >> 
> >> We want to auto-load cfg80211 when userspace asked for nl80211 netlink family.
> > 
> > Could you elaborate more why?
> 
> you want to talk to the nl80211 family. The kernel has a module that allows you to talk to this family. So let it load the netlink family.

This is not strictly true. User-space does not wan to talk to nl80211, it
wants to talk to hardware via nl80211. If there is no hardware, there is
nothing to talk to.

> If you do not want cfg80211 loaded, then fix NetworkManager and not hack the kernel. NetworkManager asks to talk to nl80211 in the first place. That one is causing the loading of cfg80211 module.
> 
> You can also de-install the NetworkManager module for wireless, right. Then none of this should happen. Seriously, fix your userspace and do not blame the kernel for a perfect valid behavior.

Maybe this is perfectly valid behaviour, but if it makes perfect sense
is dubious.

Stanislaw 
