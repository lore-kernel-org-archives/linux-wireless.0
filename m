Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:30423 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbZBCP1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 10:27:17 -0500
Received: by yx-out-2324.google.com with SMTP id 8so723648yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 07:27:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233655905.5460.2.camel@johannes.local>
References: <1233637313-16786-1-git-send-email-lrodriguez@atheros.com>
	 <1233637313-16786-2-git-send-email-lrodriguez@atheros.com>
	 <1233655905.5460.2.camel@johannes.local>
Date: Tue, 3 Feb 2009 07:27:16 -0800
Message-ID: <43e72e890902030727t4720ddcby7a65294084872602@mail.gmail.com> (sfid-20090203_162748_625628_1A350118)
Subject: Re: [RFC 1/2] cfg80211/mac80211: add regulatory_hint_found_beacon()
	to make help world roaming
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 3, 2009 at 2:11 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-02 at 21:01 -0800, Luis R. Rodriguez wrote:
>> This adds some initial intelligence to help world roaming. When we
>> are world roaming we have no idea what country we are in yet and
>> because of this our regulatory domain will be pretty restrictive.
>> Country information elements help and we have code to handle that already,
>> however, not many APs enable country IEs. We can help the situation
>> by adding checks on ours scans for beacons from APs, if we are world roaming
>> and an AP beacon is found on a channel we will make the bet that we can
>> also beacon and do active scanning -- when not on radar channels.
>>
>> Since this goes in as part of cfg80211 all devices present will benefit
>> from any device's found beacons, this includes new devices connected or
>> when you disconnect and reconnect the same device.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> NACK. If we do this _after_ cfg80211 scanning it becomes so much
> simpler.

How's that coming along?

  Luis
