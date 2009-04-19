Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f211.google.com ([209.85.218.211]:64669 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZDSFfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 01:35:16 -0400
Received: by bwz7 with SMTP id 7so697128bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2009 22:35:14 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W.Linville" <linville@tuxdriver.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix beacon loss detection after scan
References: <20090418204614.32075.19851.stgit@tikku>
	<1240087765.25100.4.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 19 Apr 2009 08:35:12 +0300
In-Reply-To: <1240087765.25100.4.camel@johannes.local> (Johannes Berg's message of "Sat\, 18 Apr 2009 22\:49\:25 +0200")
Message-ID: <87r5zp6wa7.fsf@litku.valot.fi> (sfid-20090419_073523_767640_3CEC6572)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> +	if (local->scan_sdata->vif.type == NL80211_IFTYPE_STATION)
>> +		/*
>> +		 * Need to update last_beacon to avoid beacon loss
>> +		 * test to trigger.
>> +		 */
>> +		local->scan_sdata->u.mgd.last_beacon = jiffies;
>> +
>
> A little lower is a hook function for the MLME -- it would be good to
> put this in there, see ieee80211_mlme_notify_scan_completed()

I agree. I'll send v2 after a quick test.

-- 
Kalle Valo
