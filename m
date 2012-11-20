Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46957 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2KTJGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:06:05 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5714309obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 01:06:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353397163.10872.136.camel@cumari.coelho.fi>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-12-git-send-email-eliad@wizery.com>
	<1353397163.10872.136.camel@cumari.coelho.fi>
Date: Tue, 20 Nov 2012 11:06:03 +0200
Message-ID: <CAB3XZEcg+F-0soctWPuAS-nHBaU8N=Ycxwr4psfAYN4CDTFb2w@mail.gmail.com> (sfid-20121120_100609_766744_229281F6)
Subject: Re: [PATCH 11/15] wlcore: set active psm on association
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 9:39 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
>> The default ps mode of the fw is auto, while the default
>> ps mode of mac80211 is active (ps off).
>> In order to sync them, configure active ps on association.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/ti/wlcore/main.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
>> index e1f0606..0dd0ec1 100644
>> --- a/drivers/net/wireless/ti/wlcore/main.c
>> +++ b/drivers/net/wireless/ti/wlcore/main.c
>> @@ -2534,6 +2534,15 @@ static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>>                                          ACX_KEEP_ALIVE_TPL_VALID);
>>       if (ret < 0)
>>               goto out;
>> +
>> +     /*
>> +      * The default fw psm configuration is AUTO, while mac80211 default
>> +      * setting is off (ACTIVE), so sync the fw with the correct value.
>> +      */
>> +     ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE);
>> +     if (ret < 0)
>> +             goto out;
>> +
>
> Does mac80211 enable PS soon after this by default?
>
usually yes (unless userspace disabled it, etc.).
the problem is when mac80211 doesn't enable it - we won't get any
CHANGED_PSM notification, and then while mac80211 considers it as
active, the fw is configured (by default) to AUTO.

Eliad.
