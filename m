Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:14071 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZBTUe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 15:34:56 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1343978wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 12:34:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235149610.4023.76.camel@johannes.local>
References: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
	 <1235109874-3966-4-git-send-email-lrodriguez@atheros.com>
	 <1235149610.4023.76.camel@johannes.local>
Date: Fri, 20 Feb 2009 12:34:55 -0800
Message-ID: <43e72e890902201234v6600d633k9fde952427b309ae@mail.gmail.com> (sfid-20090220_213459_654597_8D38E1C5)
Subject: Re: [PATCH 3/5] cfg80211: Add AP beacon regulatory hints
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, marcel@holtmann.org, kalle.valo@nokia.com,
	kyle@mcmartin.ca, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2009 at 9:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-20 at 01:04 -0500, Luis R. Rodriguez wrote:
>
>> +/**
>> + * regulatory_hint_found_beacon - hints a beacon was found on a channel
>> + * @wiphy: the wireless device where the beacon was found on
>> + * @beacon_chan: the channel on which the beacon was found on
>> + * @gfp: context flags
>> + *
>> + * This informs the wireless core that a beacon from an AP was found on
>> + * the channel provided. This allows the wireless core to make educated
>> + * guesses on regulatory to help with world roaming. This is only used for
>> + * world roaming -- when we do not know our current location. This is
>> + * only useful on channels 12, 13 and 14 on the 2 GHz band as all other
>> + * channels are already enabled by the world regulatory domain (channels
>> + * 1-11); and on non-radar 5 GHz channels.
>> + */
>> +extern int regulatory_hint_found_beacon(struct wiphy *wiphy,
>> +                                     struct ieee80211_channel *beacon_chan,
>> +                                     gfp_t gfp);
>
> Remove the extern please; also, you don't need to export this function
> in a public header file, reg.h should be fine.

Ah that's right your new scan stuff ensures even cfg80211 drivers
benefit from all this already. Sweet, will change it.

  Luis
