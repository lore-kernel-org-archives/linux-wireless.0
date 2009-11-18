Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:61159 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbZKRXeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 18:34:10 -0500
Received: by fxm21 with SMTP id 21so1808709fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 15:34:15 -0800 (PST)
Subject: Re: [PATCH 15/16] iwlwifi: handle unicast PS buffering
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1258150857.6167.28.camel@johannes.local>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
	 <1258142198-3223-16-git-send-email-reinette.chatre@intel.com>
	 <1258150491.4182.6.camel@maxim-laptop>
	 <1258150857.6167.28.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 01:34:10 +0200
Message-ID: <1258587250.8981.11.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-13 at 23:20 +0100, Johannes Berg wrote: 
> On Sat, 2009-11-14 at 00:14 +0200, Maxim Levitsky wrote:
> 
> > Does this cover iwl3945?
> 
> No, and I don't know if this functionality is present in 3945 devices...
> Maybe, but I think station handling is somewhat different... You can
> test it by allowing AP mode, connecting a PS station like an N810 (good
> test device!) and adding its mac addr with arp _manually_, see below.
> 
> > If so, AP mode would be possible?
> 
> No, because multicast buffering isn't working properly and I can't
> figure out how to do it. John's patch doesn't work at all. And if you
> want to test PS you need to use arp to add the mac addr manually since
> the arps either don't or do go out etc.

I understand now.
Still let me ask if I understand correctly this:

An AP has to do following things:


1) - send beacons (with DTIM data embedded)
2) - be capable sending frames that target several different stations.
3) - buffer frames for stations that are in sleep, and buffer multicast
frames, as long as any station is sleeping.

4) - handle regular association, handshaking, etc


1) & 2) are have to be done in hardware, but IBSS requires this feature.
I have never seen my iwl3945 sending beacons, but it should do so.

4) also needs hardware support, but any card that supports injection,
will work. My iwl3945 supports injection perfectly.


So, the multicast/unicast buffering is the sole problem that forbids AP
mode, right?

Now, there is need to know if any station is in PS mode, but to enter PS
mode, station should send something, right?
If it does, why not to implement multi-cast buffering in software?
In addition to that, I think it might be OK for users to use AP mode,
even if it doesn't work with power saving, it can be ensured that all
stations aren't using this feature. (Its usually broken anyway...)


Best regards,
Maxim Levitsky




