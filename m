Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0LPLR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 06:17:56 -0500
Received: from kpbe15.cbf.corp.google.com (kpbe15.cbf.corp.google.com [172.25.105.79])
	by smtp-out.google.com with ESMTP id oBGBHtdg026009
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:17:55 -0800
Received: from iwn3 (iwn3.prod.google.com [10.241.68.67])
	by kpbe15.cbf.corp.google.com with ESMTP id oBGBHrLd012436
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:17:54 -0800
Received: by iwn3 with SMTP id 3so3580383iwn.26
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:17:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292482775.3542.8.camel@jlt3.sipsolutions.net>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	<1292482775.3542.8.camel@jlt3.sipsolutions.net>
Date: Thu, 16 Dec 2010 03:17:53 -0800
Message-ID: <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 10:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-12-15 at 10:54 -0800, Paul Stewart wrote:
>> Sometimes mac80211 doesn't push idle state downwards to the
>> driver.  Specifically, there are times in some functions where
>> the "local->hw.conf.flags & IEEE80211_CONF_IDLE" may change but
>> the equivalent of "drv_config(local, IEEE80211_CONF_CHANGE_IDLE)"
>> does not end up being called.  This is usually not all that
>> problematic except, for example, suspending and resuming an idle
>> ath9k device.  If the device isn't marked idle when
>> ieee80211_stop_device() is called, the device never gets put to
>> sleep, and will end up in an unresponsive state on resume.
>
> I thought this was solved in ath9k differently? Was that somehow
> inadequate?

Unfortunately previous attempts to solve this problem failed.

>> As a precaution, explicitly call drv_config() before
>> ieee80211_stop_device(), which should be a no-op under normal
>> circumstances, but where this problem arises, it will shut down
>> the ath9k where necessary.
>
> I'm not convinced that this makes a lot of sense. I'm sure you can come
> up with other scenarios in which we stop a device and expect it to come
> back. I'm not sure why mac80211 should be responsible for all this?
>
>> One example where this problem occurs is when I down an interface
>> while a scan is in progress on ath9k.  If the device was not shut
>> down correctly and the system suspends and resumes repeatedly with
>> ath9k, I end up with a fatal register read error (0x7000/deadbeef)
>> when trying to bring the interface back up.
>>
>> Signed-off-by: Paul Stewart <pstew@google.com>
>> ---
>>  net/mac80211/iface.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
>> index b6db237..5af5a89 100644
>> --- a/net/mac80211/iface.c
>> +++ b/net/mac80211/iface.c
>> @@ -536,6 +536,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>>               if (local->ops->napi_poll)
>>                       napi_disable(&local->napi);
>>               ieee80211_clear_tx_pending(local);
>> +             drv_config(local, IEEE80211_CONF_CHANGE_IDLE);
>>               ieee80211_stop_device(local);
>>
>>               /* no reconfiguring after stop! */
>
> I don't like this anyway -- you're calling a driver callback directly,
> and there's no guarantee that just that particular change will be used
> by the driver -- it's free to look at other state given to it in each
> callback as well. That seems problematic because of all the other logic
> that we have in ieee80211_hw_config().
>
> At the very least I think you need to provide a better rationale for
> this patch and explain why the ath9k change isn't sufficient?

Here's a slightly better rationale, as I'm getting to understand the problem.
ieee80211_do_stop() decrements "open_count" so early during the function
that if the device is not idle at this point (e.g, due to scanning),
drv_config()
will never be called on the the lower-level driver, since ieee80211_hw_config()
tests for "open_count > 0" and silently returns no-error.

--
Paul
