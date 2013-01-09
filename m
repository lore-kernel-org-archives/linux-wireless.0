Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51926 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab3AIIlk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 03:41:40 -0500
Message-ID: <50ED2CC7.5060609@ti.com> (sfid-20130109_094143_864007_6A889C8A)
Date: Wed, 9 Jan 2013 10:39:35 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix delayed ADDBA response
References: <1357654597-8493-1-git-send-email-victorg@ti.com> <20130108174111.GB20290@thinkpad-t410>
In-Reply-To: <20130108174111.GB20290@thinkpad-t410>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/13 19:41, Seth Forshee wrote:
> On Tue, Jan 08, 2013 at 04:16:37PM +0200, Victor Goldenshtein wrote:
>> Block frame processing during scan might delay the
>> ADDBA response, which eventually timeouts and
>> significantly reduces the device throughput.
>> Remove this constrain as it's not required for the
>> HW scan.
>>
>> Signed-off-by: Victor Goldenshtein<victorg@ti.com>
>> ---
>>   net/mac80211/iface.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
>> index 06fac29..a26ee36 100644
>> --- a/net/mac80211/iface.c
>> +++ b/net/mac80211/iface.c
>> @@ -1063,7 +1063,7 @@ static void ieee80211_iface_work(struct work_struct *work)
>>   	if (!ieee80211_sdata_running(sdata))
>>   		return;
>>
>> -	if (local->scanning)
>> +	if (local->scanning&&  !local->ops->hw_scan)
>
> Wouldn't checking for SCAN_HW_SCANNING be better?
>

IMHO it's totally the same, besides that mac80211 use this check in many 
other places, but lets see what Johannes thinks.

-- 
Thanks,
Victor.
