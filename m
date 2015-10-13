Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51431 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbbJMIe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 04:34:26 -0400
Message-ID: <1444725264.1961.4.camel@sipsolutions.net> (sfid-20151013_103432_778720_083D2836)
Subject: Re: [PATCH v2] nl80211: allow BSS data to include CLOCK_BOOTTIME
 timestamp
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Shmidt <dimitrysh@google.com>
Date: Tue, 13 Oct 2015 10:34:24 +0200
In-Reply-To: <1444210373-4508-1-git-send-email-johannes@sipsolutions.net> (sfid-20151007_113301_262875_A75BA800)
References: <1444210373-4508-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20151007_113301_262875_A75BA800)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-07 at 11:32 +0200, Johannes Berg wrote:
> From: Dmitry Shmidt <dimitrysh@google.com>
> 
> For location and connectivity services, userspace would often like
> to know the time when the BSS was last seen. The current "last seen"
> value is calculated in a way that makes it less useful, especially
> if the system suspended in the meantime.
> 
> Add the ability for the driver to report a real CLOCK_BOOTTIME stamp
> that can then be reported to userspace (if present).
> 
> Drivers wishing to use this must be converted to the new API to call
> cfg80211_inform_bss_data() or cfg80211_inform_bss_frame_data(). They
> need to ensure the reported value is accurate enough even when the
> frame might have been buffered in the device (e.g. firmware.)
> 
Applied.

johannes
