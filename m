Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:38902 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXKWAX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 19:23:29 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IvMKP-0001gc-0w
	for linux-wireless@vger.kernel.org; Thu, 22 Nov 2007 19:23:29 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <20071122132635.GA3372@tuxdriver.com>
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <1195736752.6323.97.camel@johannes.berg>
	 <20071122132635.GA3372@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 19:23:25 -0500
Message-Id: <1195777405.11966.12.camel@dv> (sfid-20071123_002332_888132_DC71CF75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-11-22 at 08:26 -0500, John W. Linville wrote:

> As it stands, setting the SSID is the closest thing we have to an
> "associate now" trigger.  I would have to advise distros and users to
> always set it last in the wireless init, just before running dhclient
> or whatever.

Maybe mac80211 should have a "grace period" of 0.5 seconds or so to
allow other settings to be set before the scanning starts?  The same
applies to other events causing scanning, such as bringing up the
interface.  It's too short to be noticeable, yet long enough for the
next command to run even on slow systems.

I think setting the key should not cause reassociation if there is an
association.  It can break some schemes where the WEP key changes
periodically on both sides.

-- 
Regards,
Pavel Roskin

