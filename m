Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44363 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYKLSbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 13:31:09 -0500
Date: Wed, 12 Nov 2008 13:28:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] lib80211: absorb crypto bits from net/ieee80211
Message-ID: <20081112182814.GD2411@tuxdriver.com> (sfid-20081112_193114_409736_C6ABA22C)
References: <1226440265-21240-1-git-send-email-linville@tuxdriver.com> <1226508514.5368.21.camel@brick> <20081112180228.GC2411@tuxdriver.com> <1226513943.16649.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226513943.16649.0.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2008 at 10:19:03AM -0800, Harvey Harrison wrote:
> On Wed, 2008-11-12 at 13:02 -0500, John W. Linville wrote:
> > On Wed, Nov 12, 2008 at 08:48:34AM -0800, Harvey Harrison wrote:
> > > On Tue, 2008-11-11 at 16:51 -0500, John W. Linville wrote:
> > > > These bits are shared already between ipw2x00 and hostap, and could
> > > > probably be shared both more cleanly and with other drivers.  This
> > > > commit simply relocates the code to lib80211 and adjusts the drivers
> > > > appropriately.
> > > > 
> > > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > > > ---
> > > 
> > > Wouldn't it have been better to start from the mac80211 crypto bits
> > > as lib80211 and modify hostap/ipw2x00 to use the 'new' lib80211
> > > crypto bits?
> > 
> > I'm sorry, but you forgot to attach your patches...
> > 
> 
> I will if it's desired, I just wanted to know if there was a particular
> reason for going this way.

Those bits are already shared between ieee80211 and the hostap driver.
Unfortunately, they are not shared with a clean API.  I don't think
hacking on mac80211's crypto code is worthwhile until these drivers
are given a bit more discipline in this area.  IMHO, this is the
better way to start.

Perhaps you should find something more helpful to do instead.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
