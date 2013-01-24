Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3AXRve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 12:51:34 -0500
Message-ID: <1359049916.21908.18.camel@jlt4.sipsolutions.net> (sfid-20130124_185137_827900_0C55F6A0)
Subject: Re: [PATCH] mac80211: Add vif debugfs driver callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Date: Thu, 24 Jan 2013 18:51:56 +0100
In-Reply-To: <1359032923.4639.5.camel@jlt4.sipsolutions.net> (sfid-20130124_140824_496008_4D8D8056)
References: <1359028899-14202-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130124_130124_687174_8696D982) <1359032923.4639.5.camel@jlt4.sipsolutions.net>
	 (sfid-20130124_140824_496008_4D8D8056)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-24 at 14:08 +0100, Johannes Berg wrote:
> On Thu, 2013-01-24 at 13:01 +0100, Johannes Berg wrote:
> > From: Alexander Bondar <alexander.bondar@intel.com>
> > 
> > Add debugfs driver callbacks to be called upon interface addition,
> > removal and type change.
> 
> Never mind, apparently this doesn't work. I haven't tried myself yet.

The issue is that the driver might rely on mac80211 removing the dir
(recursively), but that only happens when the interface is destroyed.
However, add/remove here happens when the interface is added to/removed
from the driver, which is up/down not create/destroy.

johannes

