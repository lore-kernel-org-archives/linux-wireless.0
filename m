Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:47108 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE0RJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 13:09:54 -0400
Received: by mail-ve0-f169.google.com with SMTP id jx11so11026213veb.14
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 10:09:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrVPXwedhPGtDJQDSK5Kxa4NpeSDck4-nHyox_xriPBcZQ@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
 <CALCETrU58grNoqQh5ZutHa8CEt4rqS6FrMWwpC6DaQ0cXqxXhw@mail.gmail.com>
 <CANUX_P22a2eC0VAw-NCKrnVQRs9t=uy1VHrBF-2dAsW+s=YfUQ@mail.gmail.com>
 <CALCETrUXGKpHfTwYti9Rzgv-ZM--_d9pW8_Jx9oR1L+GsBeZcQ@mail.gmail.com>
 <CANUX_P2sH1yzx5aeLbHXBGHAsXmkZ70ioEhH1Ad_xNrCEJbJRg@mail.gmail.com>
 <CANUX_P2XpeDOmNOX=p4yMUe5ZAZv-UQ97M0ayFcFSsTrEDS3CA@mail.gmail.com>
 <CALCETrVpvFk+qhq3PFgK+5kTnBcbtv8H_Ko+kHV0jay0ZTfmcQ@mail.gmail.com>
 <CANUX_P3NrA2GgZ-Nqgvk7do7Kzqa9kgjtpn4t9TuLKzhmqTqjQ@mail.gmail.com>
 <CALCETrX1s504Ej7sQV292NfHgrKrV-Wigk0GP7wo6GyALaM9xA@mail.gmail.com>
 <CANUX_P3jMcV=7stRtPAFZBJVG9bE10iTC0sRK_o-7vTxpy9+9w@mail.gmail.com> <CALCETrVPXwedhPGtDJQDSK5Kxa4NpeSDck4-nHyox_xriPBcZQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 May 2014 10:09:31 -0700
Message-ID: <CALCETrW0NQ6aW06WD6ZAi8-o7fZSiKPOf0xYCSEw2egYBfqyQQ@mail.gmail.com> (sfid-20140527_190958_385842_46FA2E5D)
Subject: Re: Help debugging iwldvm / ath10k stalls
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf307c9bb6a87ca804fa64c349
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--20cf307c9bb6a87ca804fa64c349
Content-Type: text/plain; charset=UTF-8

On Mon, May 26, 2014 at 11:47 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, May 26, 2014 at 11:13 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>>>
>>>>>> diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>>> b/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>>> index f2c1439..e5a6b70 100644
>>>>>> --- a/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>>> +++ b/drivers/net/wireless/iwlwifi/dvm/power.c
>>>>>> @@ -288,6 +288,9 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>>>>>>         bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
>>>>>>         int dtimper;
>>>>>>
>>>>>> +       iwl_power_sleep_cam_cmd(priv, cmd);
>>>>>> +       return;
>>>>>> +
>>>>>>         dtimper = priv->hw->conf.ps_dtim_period ?: 1;
>>>>>>
>>>>>>         if (priv->wowlan)
>>>>>
>>>>> This patch has survived for about 15 minutes on 3.15-rc.  It certainly
>>>>> has some effect: pinging from the AP to the STA now takes a consistent
>>>>> ~3.8ms instead of taking varying amounts of time between 5 and 200 ms
>>>>> or so.
>>>>>
>>>>> I wonder if this is something 802.11n/802.11ac-specific?  I remember
>>>>> having all kinds of problems with 802.11n on this laptop that were
>>>>> resolved by turning off 11n or turning off power saving.
>>>>>
>>>>
>>>> well... my patch really turns off power saving. The hard way.
>>>> But since you are having issues - I guess I'll post it and disable
>>>> power save for these devices. Note that today most of the power save
>>>> features are disabled anyway.
>>>
>>> Would it make sense to do this only when connected to a VHT-supporting
>>> AP or whatever AP feature is probably triggering the problem?
>>
>> I am not sure it is related to some "VHT / whatever" feature. From
>> your logs, I'd say this bug could have happened with any AP. It is
>> down there in the PCI layer.
>>
>>>
>>> *sigh* I'd just plug in a new PCIe wireless card, except that I think
>>> that my evil BIOS will refuse to boot if I do that.
>>>
>> I can recommend 7260 :)
>
> http://www.thinkwiki.org/wiki/Problem_with_unauthorized_MiniPCI_network_card
>
> I'm not sure how I feel about flashing my BIOS with random things off
> the internet :(
>
>> Before you do that, can you check this one?
>>
>> diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c
>> b/drivers/net/wireless/iwlwifi/dvm/power.c
>> index f2c1439..047112c 100644
>> --- a/drivers/net/wireless/iwlwifi/dvm/power.c
>> +++ b/drivers/net/wireless/iwlwifi/dvm/power.c
>> @@ -292,6 +292,8 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>>
>>         if (priv->wowlan)
>>                 iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
>> +       if (!enabled)
>> +               iwl_power_sleep_cam_cmd(priv, cmd);
>>         else if (!priv->lib->no_idle_support &&
>>                  priv->hw->conf.flags & IEEE80211_CONF_IDLE)
>>                 iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
>> @@ -299,9 +301,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
>>                 /* in thermal throttling low power state */
>>                 iwl_static_sleep_cmd(priv, cmd,
>>                     iwl_tt_current_power_mode(priv), dtimper);
>> -       } else if (!enabled)
>> -               iwl_power_sleep_cam_cmd(priv, cmd);
>> -       else if (priv->power_data.debug_sleep_level_override >= 0)
>> +       } else if (priv->power_data.debug_sleep_level_override >= 0)
>>                 iwl_static_sleep_cmd(priv, cmd,
>>
>> priv->power_data.debug_sleep_level_override,
>>                                      dtimper);
>>
>> This is the final version I want to send.
>
> I'll test it tonight.  I'm away from both the network and the laptop right now.

No good :(  I got the same issue again, but it still sames rarer than unpatched.

It looks like your patch allows both:

iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);

and

iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);

I don't know whether that's a problem.

Also, is this bad?

iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control

lspci seems to think that L1 is enabled (see attached logs).

--Andy

--20cf307c9bb6a87ca804fa64c349
Content-Type: application/x-xz; name="iwl_stall_2.txt.xz"
Content-Disposition: attachment; filename="iwl_stall_2.txt.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvpglcse0

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
md+tXgcAAZhDzdUEAG5mOkaxxGf7AgAAAAAEWVo=
--20cf307c9bb6a87ca804fa64c349--
