Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60024 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbaHLIbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 04:31:12 -0400
Message-ID: <1407832263.21220.1.camel@jlt4.sipsolutions.net> (sfid-20140812_103117_090970_BFDBCE51)
Subject: Re: [PATCH] cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Aug 2014 10:31:03 +0200
In-Reply-To: <53E9CF20.8030500@broadcom.com>
References: <1407752997-12382-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1407769025.9844.0.camel@jlt4.sipsolutions.net>
	 <53E9CF20.8030500@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-08-12 at 10:24 +0200, Arend van Spriel wrote:
> On 08/11/2014 04:57 PM, Johannes Berg wrote:
> > On Mon, 2014-08-11 at 03:29 -0700, Vladimir Kondratiev wrote:
> >> In the cfg80211_rx_mgmt(), parameter @gfp was used for the memory allocation.
> >> But, memory get allocated under spin_lock_bh(), this implies atomic context.
> >> So, one can't use GFP_KERNEL, only variants with no __GFP_WAIT. Actually, in all
> >> occurrences GFP_ATOMIC is used (wil6210 use GFP_KERNEL by mistake),
> >> and it should be this way or warning triggered in the memory allocation code.
> >>
> >> Remove @gfp parameter as no actual choice exist, and use hard coded
> >> GFP_ATOMIC for memory allocation.
> 
> When I saw the patch I quickly checked and noticed brcmfmac using 
> GFP_ATOMIC. However, looking at bit closer into this it turns out that 
> the cfg80211_rx_mgmt() call could be done with GFP_KERNEL flag in 
> brcmfmac. I leave it to you what to do here :-p

Sorry - I'm confused - what do you mean?

johannes

