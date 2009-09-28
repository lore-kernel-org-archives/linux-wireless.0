Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36324 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZI1Xwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 19:52:35 -0400
Subject: Re: Firmware versioning best practices
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	Bob Copeland <me@bobcopeland.com>
In-Reply-To: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com>
References: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 16:52:17 -0700
Message-Id: <1254181937.2659.34.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> The ath_hif_usb driver will require the ar9271 firmware file but in
> the future an open firmware might become available. The ar9170 driver
> already is under the same situation already: a closed firmware is
> available but an open firmware can be used, only thing is ar9170 uses
> the same firmware name for both. We *could* change ar9170 to use the
> Intel practice of tagging a version at the end of each firmware
> release, like ar9170-1.fw but ar9170 originally was implemented with a
> 2-stage firmware requirement and so ar9170-1.fw is already taken.
> 
> ar9170 still needs a solution for the different firmwares, once we
> start supporting the open firmware through some sort of release but
> I'd like to address ath_hif_usb now early so that we don't run into
> these snags and use some decent convention that is easy to follow.
> 
> As I noted above, Intel seems to use the device-1.fw, device-2.fw
> naming convention. Is this the best approach? Or shall we have the
> same firmware filename and simply query the firmware for a map of
> capabilities? Any other ideas?

the general rule of thumb is that if you break the firmware API/ABI or
change it then the firmware name should be different. So for example if
you have some new driver functionality that requires new firmware then
you better use a new firmware name. Otherwise it is just fine to use the
same name if the functionality is not changing. If you can actually
detect the new firmware features from the firmware filename, then you
might not even have to bother with a different name. However keep in
mind that you still need to load at least the previous version of the
firmware and keep that working.

For open source firmware vs binary blobs, we don't really have a good
reference. In theory the driver should always try loading both and if
one succeeds then go with it. At no point the driver should stop working
only because a firmware is missing while either an open source or binary
one for that matter would have been available.

If you have a binary and an open source available, then you might wanna
have a Kconfig option which to try first. Like prefer the open source
over the binary one, but at the end of the day most system will ship
with only one anyway. And a module parameter would work here as well.

Regards

Marcel


