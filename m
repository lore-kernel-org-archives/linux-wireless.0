Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54228 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752616AbZHCUqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 16:46:17 -0400
Message-ID: <4A774C98.1070001@gmx.de>
Date: Mon, 03 Aug 2009 22:46:16 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: ar9170usb crashes during iwconfig for ad-hoc mode
References: <4A759341.1090006@gmx.de> <1249289274.4561.0.camel@johannes.local> <20090803123642.242160@gmx.net> <200908031509.55277.chunkeey@web.de>
In-Reply-To: <200908031509.55277.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

On 08/03/2009 03:09 PM, Christian Lamparter wrote:
> On Monday 03 August 2009 14:36:42 Joerg Albert wrote:
>>> On Mon, 2009-08-03 at 10:44 +0200, Johannes Berg wrote:
>>>
>>>>>>     ifconfig wlan1 down
>>>>>>     iwconfig wlan1 mode managed essid huhu
>>>>>>     ifconfig wlan1 up
>>>>>>     ifconfig wlan1 down
>>>>>>     iwconfig wlan1 mode ad-hoc essid huhu_a channel 1
>>>> No, it's a bug in cfg80211 :)
>>> But it's not making sense to me. I'll have to try to reproduce it. In
>>> any case, we shouldn't be calling in to mac80211 from cfg80211 while the
>>> interface is down.
>> I guess this is caused by the call to __cfg80211_leave_ibss()
>> in  net/wireless/ibss.c::cfg80211_ibss_wext_siwfreq() trying to
>> disable the beacon via net/mac80211::ieee80211_ibss_leave().

> what about this? (only compiled so far, don't have the device here...)

 > diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
 > index 099ed3c..9c97ad7 100644
 > --- a/drivers/net/wireless/ath/ar9170/main.c
 > +++ b/drivers/net/wireless/ath/ar9170/main.c
 > @@ -2177,7 +2177,7 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 >                         goto out;
 >         }
 >
 > -       if (changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED)) {
 > +       if (changed & BSS_CHANGED_BEACON_ENABLED) {
 >                 err = ar9170_update_beacon(ar);
 >               if (err)
 >                         goto out;

Thanks for the patch,  but I think it won't help. ar9170_op_bss_info_changed() is called
with BSS_CHANGED_BEACON_ENABLED set in changed, while ar->vif is NULL as _op_remove_interface() was called before
(by "ifconfig down"). This triggers the crash.

I've got a patch ready here, which uses the vif parameter of ar9170_op_bss_info_changed() instead of ar->vif.
I'll try Johannes' patch first.

Regards,
Joerg.
