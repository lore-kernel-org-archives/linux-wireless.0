Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59716 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1LSLRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 06:17:33 -0500
Received: by iaeh11 with SMTP id h11so8397955iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 03:17:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324292350.2800.280.camel@cumari>
References: <1324288803-1666-1-git-send-email-eliad@wizery.com>
	<1324292350.2800.280.camel@cumari>
Date: Mon, 19 Dec 2011 13:17:32 +0200
Message-ID: <CAB3XZEeb1eLMHtqtEMpuswv1NiHExy+y0vVkykrzSWdHMoJxMQ@mail.gmail.com> (sfid-20111219_121736_970824_85C0CDB1)
Subject: Re: [PATCH v2 1/7] wl12xx: implement change_interface
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 12:59 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-12-19 at 12:00 +0200, Eliad Peller wrote:
>> Implement the change_interface callback by simply removing the
>> current vif and adding a new one after updating the vif type.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>> v2: update vif->p2p as well
>>
>>  drivers/net/wireless/wl12xx/main.c |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index c305841..82fc318 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -2269,6 +2269,17 @@ out:
>>       cancel_work_sync(&wl->recovery_work);
>>  }
>>
>> +static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
>> +                                   struct ieee80211_vif *vif,
>> +                                   enum nl80211_iftype new_type, bool p2p)
>> +{
>> +     wl1271_op_remove_interface(hw, vif);
>> +
>> +     vif->type = ieee80211_iftype_p2p(new_type, p2p);
>> +     vif->p2p = p2p;
>> +     return wl1271_op_add_interface(hw, vif);
>> +}
>> +
>
> As Arik already commented, this looks a bit weird.  Shouldn't the type
> and p2p elements be changed in mac80211 itself? What about doing so if
> the op_change_interface returns success? Currently, the opposite seems
> to happen (ie. mac80211 changes type back to the original vif.type if
> the op fails).
>
iwlegacy and ath9k are also setting vif->type and vif->p2p in a similar manner.
add_interface(vif) assumes vif->type and vif->p2p are correct, so it
makes sense to update the vif before adding it.
i also think this behavior is a bit ugly, but this is the current
mac80211 implementation, and i don't see a good enough reason to
change it :)

> Also, it seems that the p2p value will be overwritten in the
> ieee80211_setup_sdata() which is called just after this op returns, so
> there's no use to do it here.
this is needed as add_interface(vif) might assume vif->p2p is correct.

Eliad.
