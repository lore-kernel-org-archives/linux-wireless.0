Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59592 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaEZSAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 14:00:01 -0400
Received: by mail-oa0-f44.google.com with SMTP id o6so8525657oag.17
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 11:00:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrVpvFk+qhq3PFgK+5kTnBcbtv8H_Ko+kHV0jay0ZTfmcQ@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
	<CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
	<CANUX_P22a2eC0VAw-NCKrnVQRs9t=uy1VHrBF-2dAsW+s=YfUQ@mail.gmail.com>
	<CALCETrUXGKpHfTwYti9Rzgv-ZM--_d9pW8_Jx9oR1L+GsBeZcQ@mail.gmail.com>
	<CANUX_P2sH1yzx5aeLbHXBGHAsXmkZ70ioEhH1Ad_xNrCEJbJRg@mail.gmail.com>
	<CANUX_P2XpeDOmNOX=p4yMUe5ZAZv-UQ97M0ayFcFSsTrEDS3CA@mail.gmail.com>
	<CALCETrVpvFk+qhq3PFgK+5kTnBcbtv8H_Ko+kHV0jay0ZTfmcQ@mail.gmail.com>
Date: Mon, 26 May 2014 21:00:00 +0300
Message-ID: <CANUX_P3NrA2GgZ-Nqgvk7do7Kzqa9kgjtpn4t9TuLKzhmqTqjQ@mail.gmail.com> (sfid-20140526_200012_333422_6C78BA40)
Subject: Re: Help debugging iwldvm / ath10k stalls
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>>>> Every now and then, my connection drops out.  From wireshark on the
>>>>>>> station, it looks like traffic from the AP to the STA is coming
>>>>>>> through but traffic from the STA to the AP is not.  I could be wrong
>>>>>>> here, though.  Nothing is logged in either machine's kernel log.
>>>>>>> After 5 seconds to a couple minutes, everything starts working again.
>>>>>>>
>>>>>>> A couple of Apple devices using the same radio on the same AP seem to work fine.
>>>>>>>
>>>>>>> Any advice for debugging this?  I don't know where to start.
>>>>>>
>>>>>> I caught one of the stalls with iwlwifi debugging on.  I've attached
>>>>>> the dmesg.  The stall ended ten seconds or so before the end of this
>>>>>> trace.  Is this an indication that something's wrong with iwlwifi?
>>>>>>
>>>>>> [151258.096091] iwlwifi 0000:03:00.0: U iwlagn_good_plcp_health plcp health thre
>>>>>> shold 50 delta 96 msecs 103
>>>>>> [151258.096095] iwlwifi 0000:03:00.0: U iwl_force_rf_reset perform radio reset.
>>>>>>
>>>>> Can you please disable powersave?
>>>>> It seems that it should be disabled by default, but you enabled it?
>>>>> I might be confused though... Looking again at the code...
>>>>
>>>> This?
>>>>
>>>> $ cat /sys/module/iwlwifi/parameters/power_save
>>>> N
>>>>
>>>> I have pcie_aspm.policy=powersave, but I don't think that should
>>>> matter.  Or am I missing something?
>>>
>>> That should be ok.
>>
>> Does this help?
>>
>> diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c
>> b/drivers/net/wireless/iwlwifi/dvm/power.c
>> index f2c1439..e5a6b70 100644
>> --- a/drivers/net/wireless/iwlwifi/dvm/power.c
>> +++ b/drivers/net/wireless/iwlwifi/dvm/power.c
>> @@ -288,6 +288,9 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>>         bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
>>         int dtimper;
>>
>> +       iwl_power_sleep_cam_cmd(priv, cmd);
>> +       return;
>> +
>>         dtimper = priv->hw->conf.ps_dtim_period ?: 1;
>>
>>         if (priv->wowlan)
>
> This patch has survived for about 15 minutes on 3.15-rc.  It certainly
> has some effect: pinging from the AP to the STA now takes a consistent
> ~3.8ms instead of taking varying amounts of time between 5 and 200 ms
> or so.
>
> I wonder if this is something 802.11n/802.11ac-specific?  I remember
> having all kinds of problems with 802.11n on this laptop that were
> resolved by turning off 11n or turning off power saving.
>

well... my patch really turns off power saving. The hard way.
But since you are having issues - I guess I'll post it and disable
power save for these devices. Note that today most of the power save
features are disabled anyway.
