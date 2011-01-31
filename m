Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46172 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1AaTAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 14:00:48 -0500
Received: by qyk12 with SMTP id 12so6498973qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 11:00:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110131181725.GA11054@sig21.net>
References: <201101311600.39486.IvDoorn@gmail.com>
	<20110131181725.GA11054@sig21.net>
Date: Mon, 31 Jan 2011 20:00:09 +0100
Message-ID: <AANLkTin+cpLWKbX4YaLUUiR_UAKqSPFy-9Lt1cjK3wOs@mail.gmail.com>
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while in
 powersave mode
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> +     if (test_bit(DRIVER_REQUIRE_PS_AUTOWAKE, &rt2x00dev->flags) &&
>> +         (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
>> +         (conf->flags & IEEE80211_CONF_PS))
>> +             queue_delayed_work(rt2x00dev->workqueue,
>> +                                &rt2x00dev->autowakeup_work,
>> +                                msecs_to_jiffies(rt2x00dev->beacon_int) - 1);
>> +
>
> I have doubts about this part.  Doesn't this just catch
> one beacon?  I'm not sure how often mac80211 calls the .config
> op, I thought it is called once when going to sleep, and then the
> hw/fw/driver is responsible to wakeup every n'th beacon
> (according to the configured listen interval).

Yes, I was also doubting about that. But is the listen_interval is TU, msecs,
or the number of beacons?

> Also, I think rt2x00dev->beacon_int is in TUs, not msecs.

Nope, it is in msecs :)

Ivo
