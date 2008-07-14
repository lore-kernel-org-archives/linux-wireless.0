Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:18374 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYGNNOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 09:14:04 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	<1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	<1216039127.11189.15.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 14 Jul 2008 16:13:06 +0300
In-Reply-To: <1216039127.11189.15.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 14 Jul 2008 14\:38\:47 +0200")
Message-ID: <87od50obh9.fsf@nokia.com> (sfid-20080714_151408_396441_E109584A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2008-07-14 at 15:31 +0300, Tomas Winkler wrote:
>> This patch makes listen_interval configurable by low level driver.
>
> I'm not sure we we really want that.

Me neither.

> With this, you're again putting more features and more decision making
> processes with the driver, I would much prefer this to be worked out in
> mac80211 so we can do it across all drivers.

I was just thinking the same. In my opinion the driver should be as
simple as possible, and all the logic should be in mac80211 or, if
possible, even in user space.

> If this is a knob that should be adjusted then we want to enable users
> to do it, and if it isn't then we can put a value into mac80211 and fix
> it.

Listen interval is very much dependent on the DTIM period and for
which beacons firmware wakes up (every beacon, every DTIM beacon,
every second DTIM beacon etc). For user space making this decision is
very difficult because it would need to know the current DTIM setting
and capabilities of the driver/hardware. It will get complicated
pretty quickly and I don't see any advantage to push this decision to
user space.

I think we need to soon come up with an idea what kind of PSM control
interface are we going to offer for the user space. Is it going to be
very low level (eg. based on listen interval and DTIMs and what not),
a higher level (eg. levels from one to five, five being the most
aggressive level from powersaving point of view) or what? We have a
plenty of options and I think we should discuss about this at the
summit.

> Having drivers make these kinds of decisions is very bad for uniform
> wireless behaviour.

I agree. 

On the other hand different hardware have different ways to configure,
and support, PSM so the implementation might get complicated. But
still I believe that the driver shouldn't be making this kind of
decisions.

-- 
Kalle Valo
