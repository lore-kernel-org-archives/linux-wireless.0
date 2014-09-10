Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46666 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaIJGCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 02:02:05 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: Re: [PATCH] cfg802111/nl80211: Add device motion indication API
References: <1410268021-9529-1-git-send-email-emmanuel.grumbach@intel.com>
	<85725D0A-E038-44CF-9894-BDA93231FA62@holtmann.org>
Date: Wed, 10 Sep 2014 09:02:01 +0300
In-Reply-To: <85725D0A-E038-44CF-9894-BDA93231FA62@holtmann.org> (Marcel
	Holtmann's message of "Tue, 9 Sep 2014 19:15:47 -0700")
Message-ID: <877g1c8146.fsf@purkki.adurom.net> (sfid-20140910_080209_884500_14D6057D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

> Hi Emmanuel,
>
>> Add API to notify user-space when the device is in motion
>> and the motion type.
>> This information can be used to react to the changing environment when
>> the device is on the move, or avoid some unnecessary activities when
>> the device is not moving. For example, longer scan intervals when the
>> device is not moving and there are probably no new AP's, shorter scan
>> intervals while the device is moving slowly and the environment is
>> constantly changing, and not scanning at all when the device is moving
>> fast and it is very unlikely to be able to connect to anything.
>
> if we have WiFi chips that have these kind of information, then
> shouldn't it be better exposed via a generic subsystem for motion
> events. Having this exposed over nl80211 seems a bit too limited.

I agree. Just because the functionality is in a wifi chip we should not
use nl80211 to expose the information.

And doesn't this mean that a user space application making decisions
would have to listen two interfaces now, nl80211 and the real gyro based
interface (whatever that is, if there is even one now)? That doesn't
sound like a good idea.

-- 
Kalle Valo
