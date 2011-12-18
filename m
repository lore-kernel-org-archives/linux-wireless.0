Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51233 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1LRWQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 17:16:26 -0500
Received: by iaeh11 with SMTP id h11so7505142iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 14:16:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcexCXc00-oH9O=3TeQuzzm3kkpR+e0u2ycyaeM-3Qdrg@mail.gmail.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
	<1324232745-22928-2-git-send-email-eliad@wizery.com>
	<CA+XVXfcexCXc00-oH9O=3TeQuzzm3kkpR+e0u2ycyaeM-3Qdrg@mail.gmail.com>
Date: Mon, 19 Dec 2011 00:16:25 +0200
Message-ID: <CAB3XZEczUq3Yh26w4AmpTsU81hNozJC8wkDBEghcUnhoNyXBtQ@mail.gmail.com> (sfid-20111218_231629_891323_292D4B65)
Subject: Re: [PATCH 1/7] wl12xx: implement change_interface
From: Eliad Peller <eliad@wizery.com>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 18, 2011 at 8:37 PM, Arik Nemtsov <anamtsov@gmail.com> wrote:
> On Sun, Dec 18, 2011 at 20:25, Eliad Peller <eliad@wizery.com> wrote:
>> Implement the change_interface callback by simply removing the
>> current vif and adding a new one after updating the vif type.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/wl12xx/main.c |   11 +++++++++++
>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index c305841..86a7ee3 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -2269,6 +2269,16 @@ out:
>>        cancel_work_sync(&wl->recovery_work);
>>  }
>>
>> +static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
>> +                                     struct ieee80211_vif *vif,
>> +                                     enum nl80211_iftype new_type, bool p2p)
>> +{
>> +       wl1271_op_remove_interface(hw, vif);
>> +
>> +       vif->type = ieee80211_iftype_p2p(new_type, p2p);
>
> Isn't this internal?

it's usually read-only (for the low-level drivers), but here we have
to change it...
otoh, i've just noticed that i forgot to update vif->p2p as well :)

Eliad.
