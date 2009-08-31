Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50236 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZHaRH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 13:07:29 -0400
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
 inserted
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1251538470.19422.23.camel@johannes.local>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	 <1251445557.4189.14.camel@johannes.local>
	 <1251474321.3805.73.camel@rc-desk>
	 <1251493298.3456.34.camel@johannes.local>
	 <1251497929.3805.173.camel@rc-desk>
	 <1251538470.19422.23.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 10:07:31 -0700
Message-Id: <1251738451.13180.14.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Sat, 2009-08-29 at 02:34 -0700, Johannes Berg wrote:
> I'd say we do the following: At startup, we program the broadcast STA
> into the device so we always have that, and do that synchronously so if
> that fails for some stupid reason. I think we already do that.

The station management in the driver is not entirely synchronous. That
is, adding a station and removing a station are not the only two
commands affecting the device's station knowledge. The often used "rxon"
command, when used without the association flag, always clears the
station table. This command is used frequently while not associated. So,
knowing when to add the broadcast station is not exact and is the reason
why it is currently done as part of the sending of the rxon command.
What I have been doing as part of testing here was to have a new
"restore stations" call which is called after sending the rxon command
to get device and driver in sync again wrt station management. If we
include something like this in the driver then it will be possible to
implement your proposal to add the broadcast station at the beginning.

> Then, we use a station private area that mac80211 can allocate for us to
> store the STA_ID for each station. Set this to the broadcast STA ID,
> which is always valid in some sense, at sta_notify(add) time. Then,
> asynchronously, tell the device about the station. Once that command
> finishes, look up the sta struct again and set the STA_ID to the new ID
> that we used in the device. This way, a sta struct will always have a
> valid sta ID in it.
> 
> Now, when we need to set a key for a station, we actually get the
> station struct. Thus, we can keep two separate flag in the station
> struct that tells us whether the STA_ADD was successful. If this flag is
> unset, then we reject the add_key with -ENOSPC. Or when we detect that
> the key command was too fast after the sta_notify we can wait for the
> ADD_STA to finish in the key notification since that can sleep.
> 
> And then rate stuff we can just also do as part of the async sta add
> command, so that the sta ID is only set after we have the sta programmed
> into the device and also initialised rate control properly for it.
> Ultimately the rate control algorithm could do nothing at all, and then
> we can remove it completely.

Thank you very much for these great suggestions. I'll look into this
implementation.

Reinette



