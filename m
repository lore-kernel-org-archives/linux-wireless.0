Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37271 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaLOXZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 18:25:30 -0500
Received: by mail-lb0-f179.google.com with SMTP id z11so9917049lbi.38
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 15:25:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418644802.5731.3.camel@sipsolutions.net>
References: <1416352495-82172-1-git-send-email-nbd@openwrt.org>
	<1418390516.2470.46.camel@sipsolutions.net>
	<548AF047.9080404@openwrt.org>
	<1418392866.2470.49.camel@sipsolutions.net>
	<548AFB9C.1060408@openwrt.org>
	<1418644802.5731.3.camel@sipsolutions.net>
Date: Tue, 16 Dec 2014 00:25:28 +0100
Message-ID: <CAJzaN5pix=R8RR5wzv7vbtYfHcGJytuUfd3f1QsNo-QqKUf-8Q@mail.gmail.com> (sfid-20141216_002534_145605_45C428AF)
Subject: Re: [PATCH] mac80211: add an intermediate software queue implementation
From: Bartosz Szczepanek <barteks7r@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As for drv_wake_tx_queue and ieee80211_tx_dequeue - is it really
necessary? There are ieee80211_tx_status and ieee80211_free_txskb
already, which can be used to decide from mac80211 level when to
dequeue packet. It could be used even in case of drivers that are not
aware of new mechanism at all. We could compute difference between
drv_tx and tx_status/free_txskb calls, therefore getting number of
frames in HW. What could help us to keep queues short.

I've already written some code. This http://pastebin.com/dSd1zWt7 is
patch that implements counter of frames in hardware in the way
described above. It was necessary to differentiate between free_txskb
and free_txskb. Information about frames in HW is exported to debugfs.
I thought I could submit it, but just now did I found this thread, so
I hope that it's adequate place to propose that. I tested it on ath5k
and brcmsmac.

One more thing - why not to use local->pending for holding packets?
There is tx_pending tasklet already. I'm not sure if I understand the
idea of local->pending queues correctly, but it seems to be a bit
incoherent to have both pending and proposed ieee80211_txq.

(It's my first post on linux kernel mailing list. Please, let me know
if I did something wrong.)

Best regards.

2014-12-15 13:00 GMT+01:00 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2014-12-12 at 15:28 +0100, Felix Fietkau wrote:
>
>> > Management (and maybe control) frames can have different priorities as
>> > well, this is only used for something with TDLS now I think though.
>> With my implementation, those would go through the normal tx codepath,
>> bypassing the software tx queues. Can you think of anything else that
>> would need per-AC vif queues?
>
> Not off the top of my head. I just didn't even quite understand that you
> were still using the normal tx path
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
