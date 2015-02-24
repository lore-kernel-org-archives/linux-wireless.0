Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41154 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbbBXULh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 15:11:37 -0500
Message-ID: <1424808692.2192.40.camel@sipsolutions.net> (sfid-20150224_211140_840201_9F2A0034)
Subject: Re: [PATCH 1/1] nl80211: add NL80211_CMD_GET_TSF
From: Johannes Berg <johannes@sipsolutions.net>
To: Rohan Joyce <rojoyce.github@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 21:11:32 +0100
In-Reply-To: <1424705885-20987-1-git-send-email-rojoyce.github@gmail.com> (sfid-20150223_163842_631527_DEEDB1C8)
References: <1424701880.3075.0.camel@sipsolutions.net>
	 <1424705885-20987-1-git-send-email-rojoyce.github@gmail.com>
	 (sfid-20150223_163842_631527_DEEDB1C8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-23 at 23:38 +0800, Rohan Joyce wrote:
> Hi,
> 
> The motivation for this patch is to assist using a WiiU Gamepad with Linux. 
> The WiiU Gamepad is an input device that also contains an LCD touchscreen,
> speakers and a variety of sensors. The Gamepad connects to an access
> point (usually the WiiU console itself, but it can be coerced to connect
> to a properly configured hostap). The Gamepad provides five services over
> UDP. Two of the services that are provided (audio and video streaming to
> the device) use the TSF as a timestamp in the application layer. The
> firmware on the Gamepad checks to make sure that incoming packets for
> these services have timestamps within 1000us of its own internal clock,
> which is synced to the TSF of the access point.

Oh, right, I remember now.

> At the moment, users who want to use this device have to manually apply 
> a kernel patch similar to that which was first posted to this list a year
> ago. This patch is my attempt to implement the functionality using a more
> conventional API and make it easier for end users.
> 
> Should I include protocol implementation details specific to this device in
> the documentation of the NL80211_CMD_GET_TSF command?

Not necessarily, but some information about why this is needed would be
good.

I guess since this has no way of using something like 11v this really is
the only chance.

Note that you'll need to add a feature capability flag for this - many
drivers, even ones based on mac80211, will not be able to implement this
properly so relying only on the presence of the callback will not work
properly.

johannes

