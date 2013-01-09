Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59175 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab3AIN2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 08:28:03 -0500
Date: Wed, 9 Jan 2013 07:27:53 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/3] mac80211: Disable off-channel powersave when software
 scans are suspended
Message-ID: <20130109132753.GB18778@thinkpad-t410> (sfid-20130109_142807_675975_87EED14F)
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
 <1357668645-5101-4-git-send-email-seth.forshee@canonical.com>
 <20130109110343.GA13544@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130109110343.GA13544@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 09, 2013 at 12:03:44PM +0100, Stanislaw Gruszka wrote:
> Hi
> 
> On Tue, Jan 08, 2013 at 12:10:45PM -0600, Seth Forshee wrote:
> > Leaving powersave enabled while the scan is suspended requires the use
> > of PS-Poll to retrieve frames buffered at the AP. PS-Poll isn't a very
> > efficient means of data transfer and may not even work with drivers not
> > supporting powersave. These problems can largely be avoided by simply
> > disabling off-channel powersave when the scan is suspended and enabling
> > it again when returning to off-channel operation.
> > 
> > The results of this change are fantastic. Previously when using iperf I
> > would see greatly decreased throughput (often dropping to 0 bits/sec for
> > several seconds) and very high packet loss during software scans. This
> > patch completely eliminates the packet loss and reduces the loss in
> > throughput to very reasonable levels.
> 
> I posted a patch, which remove offchannel_ps_disable argument from
> ieee80211_offchannel_return, since there were possible AP and STA power
> save state mismash:
> 
> http://marc.info/?l=linux-wireless&m=135601089321822&w=2
> 
> It should give the same effect on performance as this patch.

I guess I missed that one in my pile of post-holiday emails. I agree, it
ought to have the same effect as this patch.

Seth
