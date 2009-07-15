Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40505 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZGOQQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:16:16 -0400
Subject: Re: Unable to load iwlagn module: Failed to register hw (error -17)
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Ranson <ranson@analager.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1247674310.10754.19.camel@johannes.local>
References: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
	 <1247673740.17896.1983.camel@rc-desk>
	 <1247674310.10754.19.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 09:16:13 -0700
Message-Id: <1247674573.17896.1989.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-15 at 09:11 -0700, Johannes Berg wrote:
> Hi,
> 
> > On Tue, 2009-07-14 at 21:25 -0700, John Ranson wrote:
> > > [    4.252445] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13
> > > 802.11a channels
> > > [    4.252556] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
> > > [    4.252945] iwlagn 0000:03:00.0: Failed to register hw (error -17)
> > > [    4.253255] iwlagn 0000:03:00.0: PCI INT A disabled
> > > [    4.253263] iwlagn: probe of 0000:03:00.0 failed with error -17
> > 
> > This is ieee80211_register_hw() returning error 17 (EEXIST). One spot I
> > saw where this can happen is if you are trying to register with the same
> > name (wlanX) already used by another netdevice. Does this sound possible
> > in your setup?
> > 
> > Johannes - do you perhaps have an idea when this can happen?
> 
> This is strange -- I've had one report of this with 3945 which went away
> and seemed to have been a compat only issue, I suspect this is also just
> a compat-wireless issue, but I have no idea.
> 
> -EEXIST should only happen if something has already claimed something in
> sysfs, but not with netdevs (i.e. wlan0 would just be renamed to wlan1)
> and phy0 is numbered all the time so that can't be it either. I don't
> know.

fyi ... I based my response on register_netdevice() being able to return
-EEXIST at the time it checks for the existence of "name".

Reinette


