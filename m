Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbXHBStp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 14:49:45 -0400
Subject: Re: chaning mode only when interface down?
From: Dan Williams <dcbw@redhat.com>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46B1A14B.2070808@warmcat.com>
References: <46B18B77.5020802@gmail.com>
	 <1186046044.24230.11.camel@johannes.berg>  <46B1A14B.2070808@warmcat.com>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 14:47:06 -0400
Message-Id: <1186080426.9527.6.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-02 at 10:18 +0100, Andy Green wrote:
> Somebody in the thread at some point said:
> 
> >> Because of this NM can't create ad-hoc networks because it does it while 
> >> the device is up.
> >> Any ideas?
> > 
> > Fix NM?
> 
> It can easily try it one way and if it fails, try the other.
> 
> NM has some other things that needed fixing last time I looked at it...
> it thought it knew better than I did if a wireless interface was in
> Monitor mode that I "really wanted it" to be in Managed.

Monitor mode is inconsistently implemented across drivers.  If the
device is in monitor mode, I assume you're not actually using it for any
traffic or anything?  NM has to set the mode on the device (adhoc or
infra) before doing any connection stuff, and NM also used to set the
mode to infra before scanning, because older cards don't deliver good
scan results when in adhoc mode.  Plus, NM scans periodically and keeps
the card up during that time.

It's only with mac80211 and prism54 that you really have to take the
card down to change from infra -> adhoc or back.  That's a _new_
requirement, even if it is a valid one.  I think it's fine, but
expecting existing NM to magically support that is sorta wrong.  Doesn't
mean we shouldn't change it though.

For example, if the device isn't being used, NM is still scanning on the
device, but the device doesn't actually need to (a) be up or (b) be put
into infra mode between the periodic scans.

dan


