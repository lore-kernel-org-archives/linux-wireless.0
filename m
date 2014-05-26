Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:45795 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaEZR2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 13:28:36 -0400
Received: by mail-vc0-f171.google.com with SMTP id lc6so9441965vcb.16
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 10:28:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P2XpeDOmNOX=p4yMUe5ZAZv-UQ97M0ayFcFSsTrEDS3CA@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
 <CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
 <CANUX_P22a2eC0VAw-NCKrnVQRs9t=uy1VHrBF-2dAsW+s=YfUQ@mail.gmail.com>
 <CALCETrUXGKpHfTwYti9Rzgv-ZM--_d9pW8_Jx9oR1L+GsBeZcQ@mail.gmail.com>
 <CANUX_P2sH1yzx5aeLbHXBGHAsXmkZ70ioEhH1Ad_xNrCEJbJRg@mail.gmail.com> <CANUX_P2XpeDOmNOX=p4yMUe5ZAZv-UQ97M0ayFcFSsTrEDS3CA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 10:28:15 -0700
Message-ID: <CALCETrVpvFk+qhq3PFgK+5kTnBcbtv8H_Ko+kHV0jay0ZTfmcQ@mail.gmail.com> (sfid-20140526_192844_568027_AC4904BB)
Subject: Re: Help debugging iwldvm / ath10k stalls
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 1:39 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Mon, May 26, 2014 at 11:29 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>>>
>>>>>> Every now and then, my connection drops out.  From wireshark on the
>>>>>> station, it looks like traffic from the AP to the STA is coming
>>>>>> through but traffic from the STA to the AP is not.  I could be wrong
>>>>>> here, though.  Nothing is logged in either machine's kernel log.
>>>>>> After 5 seconds to a couple minutes, everything starts working again.
>>>>>>
>>>>>> A couple of Apple devices using the same radio on the same AP seem to work fine.
>>>>>>
>>>>>> Any advice for debugging this?  I don't know where to start.
>>>>>
>>>>> I caught one of the stalls with iwlwifi debugging on.  I've attached
>>>>> the dmesg.  The stall ended ten seconds or so before the end of this
>>>>> trace.  Is this an indication that something's wrong with iwlwifi?
>>>>>
>>>>> [151258.096091] iwlwifi 0000:03:00.0: U iwlagn_good_plcp_health plcp health thre
>>>>> shold 50 delta 96 msecs 103
>>>>> [151258.096095] iwlwifi 0000:03:00.0: U iwl_force_rf_reset perform radio reset.
>>>>>
>>>> Can you please disable powersave?
>>>> It seems that it should be disabled by default, but you enabled it?
>>>> I might be confused though... Looking again at the code...
>>>
>>> This?
>>>
>>> $ cat /sys/module/iwlwifi/parameters/power_save
>>> N
>>>
>>> I have pcie_aspm.policy=powersave, but I don't think that should
>>> matter.  Or am I missing something?
>>
>> That should be ok.
>
> Does this help?
>
> diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c
> b/drivers/net/wireless/iwlwifi/dvm/power.c
> index f2c1439..e5a6b70 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/power.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/power.c
> @@ -288,6 +288,9 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>         bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
>         int dtimper;
>
> +       iwl_power_sleep_cam_cmd(priv, cmd);
> +       return;
> +
>         dtimper = priv->hw->conf.ps_dtim_period ?: 1;
>
>         if (priv->wowlan)

This patch has survived for about 15 minutes on 3.15-rc.  It certainly
has some effect: pinging from the AP to the STA now takes a consistent
~3.8ms instead of taking varying amounts of time between 5 and 200 ms
or so.

I wonder if this is something 802.11n/802.11ac-specific?  I remember
having all kinds of problems with 802.11n on this laptop that were
resolved by turning off 11n or turning off power saving.

-- 
Andy Lutomirski
AMA Capital Management, LLC
