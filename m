Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:49287 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZHMTrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:11 -0400
Received: by yxe5 with SMTP id 5so1281233yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 12:47:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250192346.21250.6.camel@johannes.local>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
	<1250191909-21682-11-git-send-email-lrodriguez@atheros.com>
	<1250192346.21250.6.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 Aug 2009 12:46:52 -0700
Message-ID: <43e72e890908131246t44fe8c3eya3d3894810aeea7f@mail.gmail.com>
Subject: Re: [PATCH 10/20] wireless: group Broadcom wireless drivers on
	kconfig
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 12:39 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-08-13 at 15:31 -0400, Luis R. Rodriguez wrote:
>> Cc: Michael Buesch <mb@bu3sch.de>
>> Cc: Gábor Stefanik <netrolller.3d@gmail.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/Kconfig |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
>> index 65397fe..1a8e9bd 100644
>> --- a/drivers/net/wireless/Kconfig
>> +++ b/drivers/net/wireless/Kconfig
>> @@ -378,6 +378,14 @@ config USB_ZD1201
>>
>>  endif # ZYDAS_80211
>>
>> +menuconfig BROADCOM_80211
>> +     bool "Broadcom Wireless Cards"
>> +     depends on WLAN_80211
>> +     ---help---
>> +       This will enable the support for Broadcom wireless drivers. This
>> +       includes b43 driver, b43legacy driver and the rndis_wlan driver.
>
> Ok ... so what's the point of all these patches?

Its stated on 0/20.

> Also, I don't think rndis wlan is always broadcom, and in an case it's
> almost never marked as such.

>From the rndis_wlan kconfig:

          "All of these devices are based on Broadcom 4320 chip which is the
          only wireless RNDIS chip known to date."

  Luis
