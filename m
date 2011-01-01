Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39640 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1AAJux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 04:50:53 -0500
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<lrodriguez@atheros.com>, Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] Revert "ath9k: Parse DTIM period from mac80211"
References: <1293691681-3574-1-git-send-email-mshajakhan@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 01 Jan 2011 11:50:50 +0200
In-Reply-To: <1293691681-3574-1-git-send-email-mshajakhan@atheros.com> (Mohammed Shafi Shajakhan's message of "Thu\, 30 Dec 2010 12\:18\:01 +0530")
Message-ID: <871v4xgdfp.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mshajakhan@atheros.com> writes:

> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> This reverts commit 0ce3bcfc84900a64347b0fe1140229bd81314008.
>
> Event though with the above commit we obtain the configured DTIM period
> from the AP rather than always hardcoding it to '1', this seems to cause
> problems under the following scenarios:
> * Preventing association with broken AP's

How can different dtim value cause problems with association? Power
save should not be even enabled during association. Or do you mean
there are problems after association, for example during eap
negotation?

> * Adds latency in roaming

We should try to solve this problem differently than hardcoding dtim.
There are other ways to trigger roaming than just following beacons.
And if there's no data, there's no need to roam either. 

I have been hoping to work on improving roaming, but never found the
time to do it :/

> So its better to always use the safe value of '1' for dtim period

By hardcoding dtim you increase the power consumption in the case when
there is no data traffic, so it's not definitely better in all cases.

I would prefer to fix the real issues instead of hardcoding dtim. And
if it's really essential to hardcode it now, please add a big fat
warning indicating that this is a temporary solution and should be
fixed properly without hardcoding anything.

-- 
Kalle Valo
