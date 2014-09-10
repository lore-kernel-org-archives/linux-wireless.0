Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51216 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIJF2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 01:28:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] cfg802111/nl80211: Add device motion indication API
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CANUX_P2sVqw=e8ZG5NnMme+TfsjXB36ymMUDUkzp90nB4cPdnw@mail.gmail.com>
Date: Tue, 9 Sep 2014 22:28:55 -0700
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Avraham Stern <avraham.stern@intel.com>
Message-Id: <2422DF2C-E036-4AAB-A710-6A9B215B6E21@holtmann.org> (sfid-20140910_072822_783234_19FB5939)
References: <1410268021-9529-1-git-send-email-emmanuel.grumbach@intel.com> <85725D0A-E038-44CF-9894-BDA93231FA62@holtmann.org> <CANUX_P2sVqw=e8ZG5NnMme+TfsjXB36ymMUDUkzp90nB4cPdnw@mail.gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

>> if we have WiFi chips that have these kind of information, then shouldn't it be better exposed via a generic subsystem for motion events. Having this exposed over nl80211 seems a bit too limited.
>> 
>> I am thinking that either an input event or maybe via hwmon or IIO. Since at the end of the day such an event should be considered just a sensor. It doesn't matter which piece of hardware is doing the sensing or who it is doing for.
>> 
>> We are also not exposing RFKILL switches over nl80211. We have a dedicated RFKILL subsystem where all kinds of switches can integrate into.
>> 
> 
> I can't sayI totally disagree, but the point here I guess is that the
> precision is very limited - WiFi based after all - and hence, I don't
> think we really want to expose a real motion detection device to the
> whole system. This is not a gyro or anything of this kind. The commit
> message gives example of use cases where the flows that are triggered
> by this kind of notifications. The user aren't aware of these flows.
> The frequency of the scan isn't something the user is aware of but
> more a WiFi system parameter. So basically, I don't think we can
> really talk about a real sensor, but more of a heuristic that will
> likely help WiFi to behave better. Might there be other components
> interested in this heuristic with its level of (im)precision, good
> question.

even if the precision is limited, I think exposing this in a generic way (maybe just an input event) is a lot cleaner. So what if you want to have Bluetooth LE background scanning also use this to adjust the scan intervals. Or when to spin up the GPS to get a more precise location. There might be other subsystems that can benefit from these notifications and it makes no sense for them to talk nl80211.

Regards

Marcel

