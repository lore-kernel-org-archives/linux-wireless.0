Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38569 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaL0AQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 19:16:13 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Y4f3C-0007y5-BH
	for linux-wireless@vger.kernel.org; Sat, 27 Dec 2014 01:16:10 +0100
Received: from cpe-67-11-235-53.satx.res.rr.com ([67.11.235.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 01:16:10 +0100
Received: from chrischavez by cpe-67-11-235-53.satx.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 01:16:10 +0100
To: linux-wireless@vger.kernel.org
From: Christopher Chavez <chrischavez@gmx.us>
Subject: Re: p54usb kernel panic on recent mainline kernels
Date: Sat, 27 Dec 2014 00:15:58 +0000 (UTC)
Message-ID: <loom.20141227T010207-869@post.gmane.org> (sfid-20141227_012032_145583_6B7679CB)
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> <549CCAD8.70704@lwfinger.net> <loom.20141226T052138-41@post.gmane.org> <2868661.A1AiatZ287@debian64> <549DB187.3090003@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I have not yet confirmed Christian's workaround, but thank you both for testing.

> My bisection led to a branch commit d17ec4d as the "bad" commit. Rather than
> finding out where the bisection went bad, I added code to check skb->tail, 
> skb->end, and the length to be added. At the time of the call that panics,
> there are 6 bytes between tail and end with 8 bytes needed.
> 
> I will be looking for the place where the driver calculates how large the skb 
> should be.

In the few remaining revisions from "git bisect visualize",
this one mentions skbs:

commit c70f59a2a007c57843195a93c3b7308204e0a5ab
Author: Ido Yariv <ido@wizery.com>
Date:   Tue Jul 29 15:39:14 2014 +0300

    mac80211: don't resize skbs needlessly
    
    Header-less cloned skbs with sufficient headroom need not be cloned
    unless the tailroom is going to be modified.
    
    Fix ieee80211_skb_resize so it would only resize cloned skbs if either
    the header isn't released or the tailroom is going to be modified.
    
    Some drivers might have assumed that skbs are never cloned, so add a HW
    flag that explicitly permits cloned TX skbs. Drivers which do not modify
    TX skbs should set this flag to avoid copying skbs.
    
    Signed-off-by: Ido Yariv <idox.yariv@intel.com>
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>


