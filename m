Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:57843 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0EEVhR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 17:37:17 -0400
Message-ID: <4BE1E505.5030008@free.fr>
Date: Wed, 05 May 2010 23:37:09 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe responses.
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>	 <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>	 <1272955622-6987-3-git-send-email-benoit.papillault@free.fr> <1273060014.3728.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1273060014.3728.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 05/05/2010 13:46, Johannes Berg a écrit :
> On Tue, 2010-05-04 at 08:47 +0200, Benoit Papillault wrote:
>> When an HT IBSS is configured, we add HT Information and HT Capabilities
>> IE to beacon&  probe responses. This is done according to channel_type
>> transmitted by iw/cfg80211.
>
> Just noticed something else -- this allows creating an HT40 IBSS on an
> invalid channel pair -- do we want to catch that?
>
> johannse
>

Do you mean creating an ht40+ over channel 112, where only ht40- is 
allowed by 802.11 ? Since it's the same for AP & IBSS, maybe it could be 
done in the regulatory code?

Anyway, since this latter issue was already there for a while, it could 
be fixed in a follow up patch.

Regards,
Benoit
