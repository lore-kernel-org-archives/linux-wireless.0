Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42308 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaIJCPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 22:15:12 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] cfg802111/nl80211: Add device motion indication API
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1410268021-9529-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Tue, 9 Sep 2014 19:15:47 -0700
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Message-Id: <85725D0A-E038-44CF-9894-BDA93231FA62@holtmann.org> (sfid-20140910_041523_195858_8100F627)
References: <1410268021-9529-1-git-send-email-emmanuel.grumbach@intel.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

> Add API to notify user-space when the device is in motion
> and the motion type.
> This information can be used to react to the changing environment when
> the device is on the move, or avoid some unnecessary activities when
> the device is not moving. For example, longer scan intervals when the
> device is not moving and there are probably no new AP's, shorter scan
> intervals while the device is moving slowly and the environment is
> constantly changing, and not scanning at all when the device is moving
> fast and it is very unlikely to be able to connect to anything.

if we have WiFi chips that have these kind of information, then shouldn't it be better exposed via a generic subsystem for motion events. Having this exposed over nl80211 seems a bit too limited.

I am thinking that either an input event or maybe via hwmon or IIO. Since at the end of the day such an event should be considered just a sensor. It doesn't matter which piece of hardware is doing the sensing or who it is doing for.

We are also not exposing RFKILL switches over nl80211. We have a dedicated RFKILL subsystem where all kinds of switches can integrate into.

Regards

Marcel

