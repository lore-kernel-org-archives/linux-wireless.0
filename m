Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:38333 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaEZSsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 14:48:06 -0400
Received: by mail-ve0-f180.google.com with SMTP id db12so9675236veb.11
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 11:48:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3jMcV=7stRtPAFZBJVG9bE10iTC0sRK_o-7vTxpy9+9w@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
 <CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
 <CANUX_P22a2eC0VAw-NCKrnVQRs9t=uy1VHrBF-2dAsW+s=YfUQ@mail.gmail.com>
 <CALCETrUXGKpHfTwYti9Rzgv-ZM--_d9pW8_Jx9oR1L+GsBeZcQ@mail.gmail.com>
 <CANUX_P2sH1yzx5aeLbHXBGHAsXmkZ70ioEhH1Ad_xNrCEJbJRg@mail.gmail.com>
 <CANUX_P2XpeDOmNOX=p4yMUe5ZAZv-UQ97M0ayFcFSsTrEDS3CA@mail.gmail.com>
 <CALCETrVpvFk+qhq3PFgK+5kTnBcbtv8H_Ko+kHV0jay0ZTfmcQ@mail.gmail.com>
 <CANUX_P3NrA2GgZ-Nqgvk7do7Kzqa9kgjtpn4t9TuLKzhmqTqjQ@mail.gmail.com>
 <CALCETrX1s504Ej7sQV292NfHgrKrV-Wigk0GP7wo6GyALaM9xA@mail.gmail.com> <CANUX_P3jMcV=7stRtPAFZBJVG9bE10iTC0sRK_o-7vTxpy9+9w@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 11:47:42 -0700
Message-ID: <CALCETrVPXwedhPGtDJQDSK5Kxa4NpeSDck4-nHyox_xriPBcZQ@mail.gmail.com> (sfid-20140526_204810_889013_A8F7CC4E)
Subject: Re: Help debugging iwldvm / ath10k stalls
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 11:13 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>>
>>>>> diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>> b/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>> index f2c1439..e5a6b70 100644
>>>>> --- a/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>> +++ b/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>> @@ -288,6 +288,9 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>>>>>         bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
>>>>>         int dtimper;
>>>>>
>>>>> +       iwl_power_sleep_cam_cmd(priv, cmd);
>>>>> +       return;
>>>>> +
>>>>>         dtimper = priv->hw->conf.ps_dtim_period ?: 1;
>>>>>
>>>>>         if (priv->wowlan)
>>>>
>>>> This patch has survived for about 15 minutes on 3.15-rc.  It certainly
>>>> has some effect: pinging from the AP to the STA now takes a consistent
>>>> ~3.8ms instead of taking varying amounts of time between 5 and 200 ms
>>>> or so.
>>>>
>>>> I wonder if this is something 802.11n/802.11ac-specific?  I remember
>>>> having all kinds of problems with 802.11n on this laptop that were
>>>> resolved by turning off 11n or turning off power saving.
>>>>
>>>
>>> well... my patch really turns off power saving. The hard way.
>>> But since you are having issues - I guess I'll post it and disable
>>> power save for these devices. Note that today most of the power save
>>> features are disabled anyway.
>>
>> Would it make sense to do this only when connected to a VHT-supporting
>> AP or whatever AP feature is probably triggering the problem?
>
> I am not sure it is related to some "VHT / whatever" feature. From
> your logs, I'd say this bug could have happened with any AP. It is
> down there in the PCI layer.
>
>>
>> *sigh* I'd just plug in a new PCIe wireless card, except that I think
>> that my evil BIOS will refuse to boot if I do that.
>>
> I can recommend 7260 :)

http://www.thinkwiki.org/wiki/Problem_with_unauthorized_MiniPCI_network_card

I'm not sure how I feel about flashing my BIOS with random things off
the internet :(

> Before you do that, can you check this one?
>
> diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c
> b/drivers/net/wireless/iwlwifi/dvm/power.c
> index f2c1439..047112c 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/power.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/power.c
> @@ -292,6 +292,8 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>
>         if (priv->wowlan)
>                 iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
> +       if (!enabled)
> +               iwl_power_sleep_cam_cmd(priv, cmd);
>         else if (!priv->lib->no_idle_support &&
>                  priv->hw->conf.flags & IEEE80211_CONF_IDLE)
>                 iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
> @@ -299,9 +301,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>                 /* in thermal throttling low power state */
>                 iwl_static_sleep_cmd(priv, cmd,
>                     iwl_tt_current_power_mode(priv), dtimper);
> -       } else if (!enabled)
> -               iwl_power_sleep_cam_cmd(priv, cmd);
> -       else if (priv->power_data.debug_sleep_level_override >= 0)
> +       } else if (priv->power_data.debug_sleep_level_override >= 0)
>                 iwl_static_sleep_cmd(priv, cmd,
>
> priv->power_data.debug_sleep_level_override,
>                                      dtimper);
>
> This is the final version I want to send.

I'll test it tonight.  I'm away from both the network and the laptop right now.

--Andy
