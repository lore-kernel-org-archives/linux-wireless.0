Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58794 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbbAFLIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 06:08:43 -0500
Message-ID: <1420542520.1966.22.camel@sipsolutions.net> (sfid-20150106_120846_288398_08EA776F)
Subject: Re: [PATCH v2 1/2] cfg80211: Add API to change the indoor
 regulatory setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@suse.com,
	Arik Nemtsov <arik@wizery.com>
Date: Tue, 06 Jan 2015 12:08:40 +0100
In-Reply-To: <1420519942-16109-1-git-send-email-ilan.peer@intel.com> (sfid-20150106_115554_035119_41B9E557)
References: <1420519942-16109-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150106_115554_035119_41B9E557)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-05 at 23:52 -0500, Ilan Peer wrote:
> As the operating environment of a device can change, add
> API for user space to indicate a change of indoor settings.
> In addition modify the handling of the indoor processing as
> follows:
> 
> 1. Directly update the indoor setting without wrapping it as a
>    regulatory request.
> 2. Track the socket on which the indoor hint is issued, and reset
>    indoor setting if the socket was released.

This probably needs to be wrapped with a request flag from userspace to
have the new behaviour - but if not then at least explain why not?

johannes

