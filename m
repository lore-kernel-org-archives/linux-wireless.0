Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47267 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108Ab1CIRji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 12:39:38 -0500
Received: by mail-iw0-f175.google.com with SMTP id 10so770607iwn.6
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 09:39:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299681430.1816.101.camel@cumari>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
	<1299421940-26292-11-git-send-email-shahar_levi@ti.com>
	<1299681430.1816.101.camel@cumari>
Date: Wed, 9 Mar 2011 19:39:37 +0200
Message-ID: <AANLkTimJMnjdqYQjKDFV01LTFCrvXoW+kRmn0VxdJ-Ab@mail.gmail.com>
Subject: Re: [PATCH 10/15] wl12xx: 1281/1283 support - Set WiFi & BT cox
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/9/11, Luciano Coelho <coelho@ti.com> wrote:
> On Sun, 2011-03-06 at 16:32 +0200, Shahar Levi wrote:
>> Set different Cox setting between wl127x and wl128x.
>>
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
>>  drivers/net/wireless/wl12xx/acx.c  |    5 +++++
>>  drivers/net/wireless/wl12xx/main.c |    6 +++++-
>>  2 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/acx.c
>> b/drivers/net/wireless/wl12xx/acx.c
>> index f0345e6..e970b71 100644
>> --- a/drivers/net/wireless/wl12xx/acx.c
>> +++ b/drivers/net/wireless/wl12xx/acx.c
>> @@ -554,6 +554,11 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
>>  		goto out;
>>  	}
>>
>> +	if (wl->chip.id == CHIP_ID_1283_PG20)
>> +		c->params[CONF_SG_BT_LOAD_RATIO] = 50;
>> +	else
>> +		c->params[CONF_SG_BT_LOAD_RATIO] = 200;
>> +
>
> You can't change this value in the global array.  This needs to be
> changed only in the allocated ACX.  I'll change it before taking it in.
>
> Also, I think it's cleaner to keep the correct value for wl127x in the
> global array (as was before) and only change the value for wl128x here
> in this function.
>
>> diff --git a/drivers/net/wireless/wl12xx/main.c
>> b/drivers/net/wireless/wl12xx/main.c
>> index 32d963d..f8e9e3f 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -54,7 +54,11 @@ static struct conf_drv_settings default_conf = {
>>  			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
>>  			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
>>  			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
>> -			[CONF_SG_BT_LOAD_RATIO]                     = 50,
>> +			/*
>> +			 * CONF_SG_BT_LOAD_RATIO has wl127x or wl128x dependency
>> +			 * (set in wl1271_acx_sg_cfg()
>> +			 */
>> +			[CONF_SG_BT_LOAD_RATIO]                     = 0,
>>  			[CONF_SG_AUTO_PS_MODE]                      = 1,
>>  			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
>>  			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
>
> Previously, the value used for wl127x was 50, from the default global
> settings.  Now you're using 200 for wl127x.  This looks suspicious.  You
> now use 50 (which was the value for wl127x) for wl128x and 200 for
> wl127x.
>
> At least the change for wl127x should be done in a separate patch.
It was incorrect value for wl127x. That patch fixes that and set
wl128x value. I can do the fix for wl127x in separate patch.

>
> --
> Cheers,
> Luca.
>
>
-- 
All the best,
Shahar
