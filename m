Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59228 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZEORBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 13:01:36 -0400
Subject: Re: Automatic reassociate with AP
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20090515133359.GB2773@tuxdriver.com>
References: <alpine.LSU.2.00.0905151306240.4165@fbirervta.pbzchgretzou.qr>
	 <20090515133359.GB2773@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 13:02:29 -0400
Message-Id: <1242406949.10933.27.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-15 at 09:33 -0400, John W. Linville wrote:
> On Fri, May 15, 2009 at 01:10:28PM +0200, Jan Engelhardt wrote:
> 
> > when the AP flakes out, or I just appen to be out of range, the kernel 
> > drops the AP association, as dmesg shows:
> > 
> > wlan0: No ProbeResp from current AP 00:0b:0e:4f:cf:80 - assume out of 
> > range
> > 
> > Manually rerunning `iwconfig wlan0 essid FooNet channel 11` 
> > reassociates, but I wonder whether the kernel could not do that itself, 
> > given that it knows the previous settings like ESSID.
> 
> Patches welcome... :-)

This does cause problems in some cases, at least for WEXT.  iwl does
attempt to continually reassociate, and that results in some cases where
streams of disassoc events overwhelm userspace.  The supplicant should
obviously get fixed here, but before doing something like this, we
should make sure that all the nl80211 calls are implemented to tell the
driver "Stop whatever you're doing and idle yourself".  I've talked
about this with Johannes before so he may have already stuffed that into
nl80211 somewhere.

Dan

