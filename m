Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14851 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765007AbXFHIRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 04:17:43 -0400
Subject: Re: IEEE802.11e/WMM TS management and DLS support
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1181160060.3398.35.camel@johannes.berg>
References: <20070606082152.GA28639@mail.intel.com>
	 <1181160060.3398.35.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 16:16:57 +0800
Message-Id: <1181290617.3039.158.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-06 at 22:00 +0200, Johannes Berg wrote:
> On Wed, 2007-06-06 at 16:21 +0800, Zhu Yi wrote:
> 
> > This is a patch series for IEEE802.11e/WMM support against
> > linux-2.6.22-rc4.
> 
> Great :)
> 
> What I'm missing though is a sane userspace interface. Having all the
> information in debugfs is great, but I don't think debugfs should be
> writable here. Could you define this in terms of nl80211/cfg80211? I'm
> not sure what exactly would be required.

Yes, the user space API should be in the cfg80211 format. End users
definitely don't want to play with debugfs, it's only for developer's
debugging. Defining a good API is not easy, but since the core code is
there, we can begin the API discussion now.

> Also, can you explain how you plan to use this? I don't think that users
> will want to manually use the interfaces to add a direct link etc.
> Hence, it has to be done automatically. What do we base the decision on?
> If we're sending a whole bunch of data to another STA do we
> automatically try to negotiate DLS? If so, do we do that in the kernel?
> Or do we have enough information to do that in userspace?
> 
> Essentially I see two choices:
>  1) we do it in the kernel, and do it automagically somehow
>  2) we do it in userspace in some daemon
> 
> In the first case, somehow I'm missing how the kernel is supposed to
> make the decision that it wants to use a direct link. But in case 2),
> why do we need the kernel to send all these management frames? Couldn't
> we just have some API to tell the kernel that we have negotiated a
> direct link (yes, it'd require the injection patches, but that work is
> available)?

I think 2) is the way to go. Kernel shouldn't involve in the decision
making of DLS. Switch to DLS intelligently in the user space sounds good
but it doesn't relate to the kernel <-> user space API, you can do it
all in the user space. I think there should be 2 APIs for DLS.

1) User requests kernel to setup or tear down a DLS link with another
STA (sync and async)

2) Kernel notifies the user space (daemon) a DLS request is sent from
another STA and let user space to make the decision or an existed DLS
connection is torn down by the peer (via event).


BTW, I'd agree move the kernel MLME to user space if possible. I
implemented in the kernel because a) it's simple and other MLMEs are
also there, i.e ASSOC_REQ.  b) I don't know where to implement it in the
user space, wpa_supplicant?  But if we 

Thanks,
-yi
