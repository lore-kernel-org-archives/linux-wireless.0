Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35780 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbcGNJuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2016 05:50:13 -0400
Received: by mail-io0-f174.google.com with SMTP id m101so70582196ioi.2
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2016 02:50:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANXECd4T6xohJMhLZzXN8jphowQjWyc7DmxsRhfQJRi5u69mmQ@mail.gmail.com>
References: <CANXECd56kVUKF1xjiSjLiDTKAqrv9_TJxgPgxu7F-dBSmXcjLA@mail.gmail.com>
 <759e547e-347e-f787-9888-e09aba102be7@broadcom.com> <CANUX_P3A5YohcustmZzC9A6b5DKyaY9dGDpYAxWWFKc8wH1Gng@mail.gmail.com>
 <CANXECd4T6xohJMhLZzXN8jphowQjWyc7DmxsRhfQJRi5u69mmQ@mail.gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 14 Jul 2016 12:50:11 +0300
Message-ID: <CANUX_P0txVkS2APVARtWn_U7Y3rki4rSmvxenimxf8y2sD1pCA@mail.gmail.com> (sfid-20160714_121547_541004_DCD0042A)
Subject: Re: iwlwifi + wpa2-leap + multiple AP's = call trace
To: =?UTF-8?Q?Ismael_Farf=C3=A1n?= <sulfurfff@gmail.com>,
	linuxwifi <linuxwifi@intel.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2016 at 9:33 PM, Ismael Farfán <sulfurfff@gmail.com> wrote:
> Hi
>
> I'm using wicd, so changed from wext to nl80211 and I don't see the
> trace anymore... it still refuses to connect though, so I'll check
> what's wrong with my configuration.
>
> Do you want me to collect some information regarding wpa_supplicant
> and wext from my system?
> If so, how?

I am very busy right now, so I doubt  I will have the time to look at
it. So let's drop it unless it still doesn't work for you.

>
>
> 2016-07-13 11:31 GMT-05:00 Emmanuel Grumbach <egrumbach@gmail.com>:
>> On Jul 13, 2016 9:23 AM, "Arend Van Spriel" <arend.vanspriel@broadcom.com>
>> wrote:
>>>
>>>
>>>
>>> On 13-7-2016 2:29, Ismael Farfán wrote:
>>> > Hello list
>>> >
>>> > I searched this error around and didn't find anything, so here it goes.
>>> >
>>> > Today I tried to connect to an enterprise network, which means,
>>> > literally, tens of AP's sharing the same name... the network requieres
>>> > user/password authentication (wpa2-leap).
>>> >
>>> > I'm using Arch
>>> > $ uname -a
>>> > Linux 4.6.3-1-ARCH #1 SMP PREEMPT Fri Jun 24 21:19:13 CEST 2016 x86_64
>>> > GNU/Linux
>>> >
>>> > Since the thing just didn't connect, I checked dmesg and found this:
>>> >
>>> > Any ideas?
>>>
>>> From the stack trace it seems wpa_supplicant on Arch is using WEXT API.
>>> You could try and change it to use NL80211 API. Personally, I have not
>>> used Arch Linux so no idea where to change that.
>>>
>>> The warning is here [1]:
>>>
>>> 503         IWL_DEBUG_TE(mvm, "Add new TE, duration %d TU\n",
>>> 504                      le32_to_cpu(te_cmd->duration));
>>> 505
>>> 506         spin_lock_bh(&mvm->time_event_lock);
>>> 507         if (WARN_ON(te_data->id != TE_MAX)) {
>>> 508                 spin_unlock_bh(&mvm->time_event_lock);
>>> 509                 return -EIO;
>>> 510         }
>>>
>>> It seems this function is called with te_data that is already in use,
>>> but that is my uneducated guess so I may be wrong.
>>>
>>
>> This is right :)
>>
>> Can you please record tracing of this?
>>
>> Thank you.
>>
>>> Regards,
>>> Arend
>>>
>>> [1]
>>>
>>> http://lxr.free-electrons.com/source/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c#L507
>>> >
>>> > [   83.030072] wifi0: aborting authentication with xx:xx:xx:xx:xx:xx
>>> > by local choice (Reason: 3=DEAUTH_LEAVING)
>>> > [   83.030073] ------------[ cut here ]------------
>>> > [   83.030082] WARNING: CPU: 2 PID: 1087 at
>>> > drivers/net/wireless/intel/iwlwifi/mvm/time-event.c:507 iwl_mvm_tim
>>> > e_event_send_add+0x1c6/0x200 [iwlmvm]
>>> > [   83.030157] CPU: 2 PID: 1087 Comm: wpa_supplicant Tainted: G
>>> >    O    4.6.3-1-ARCH #1
>>> > [   83.030158] Hardware name: Notebook
>>> > P65_P67SA                       /P65_P67SA
>>> >                 , BIOS 1.03.01 07/22/2015
>>> > [   83.030160]  0000000000000286 0000000009e998bc ffff880403a5b940
>>> > ffffffff812e54c2
>>> > [   83.030162]  0000000000000000 0000000000000000 ffff880403a5b980
>>> > ffffffff8107a6bb
>>> > [   83.030164]  000001fb81a8a180 ffff88041b443580 ffff88041c329548
>>> > 00000000fffffffb
>>> > [   83.030167] Call Trace:
>>> > [   83.030172]  [<ffffffff812e54c2>] dump_stack+0x63/0x81
>>> > [   83.030174]  [<ffffffff8107a6bb>] __warn+0xcb/0xf0
>>> > [   83.030176]  [<ffffffff8107a7ed>] warn_slowpath_null+0x1d/0x20
>>> > [   83.030181]  [<ffffffffa0b068d6>]
>>> > iwl_mvm_time_event_send_add+0x1c6/0x200 [iwlmvm]
>>> > [   83.030184]  [<ffffffff810c4772>] ? up+0x32/0x50
>>> > [   83.030187]  [<ffffffff810d371b>] ? wake_up_klogd+0x3b/0x50
>>> > [   83.030189]  [<ffffffff810d3c19>] ? console_unlock+0x4e9/0x590
>>> > [   83.030193]  [<ffffffffa0b07520>]
>>> > iwl_mvm_protect_session+0x220/0x280 [iwlmvm]
>>> > [   83.030196]  [<ffffffffa0af100e>] ? iwl_mvm_ref_sync+0x2e/0x140
>>> > [iwlmvm]
>>> > [   83.030199]  [<ffffffff810d423f>] ? vprintk_default+0x1f/0x30
>>> > [   83.030202]  [<ffffffffa0af154a>]
>>> > iwl_mvm_mac_mgd_prepare_tx+0x5a/0xa0 [iwlmvm]
>>> > [   83.030216]  [<ffffffffa0c8e198>] ieee80211_mgd_deauth+0x338/0x4d0
>>> > [mac80211]
>>> > [   83.030219]  [<ffffffff810b2333>] ? enqueue_entity+0x323/0xd70
>>> > [   83.030228]  [<ffffffffa0c579b8>] ieee80211_deauth+0x18/0x20
>>> > [mac80211]
>>> > [   83.030237]  [<ffffffffa05a1b8f>] cfg80211_mlme_deauth+0x9f/0x1a0
>>> > [cfg80211]
>>> > [   83.030242]  [<ffffffffa05a62da>] cfg80211_disconnect+0x9a/0x200
>>> > [cfg80211]
>>> > [   83.030248]  [<ffffffffa05c4529>]
>>> > cfg80211_mgd_wext_siwessid+0xa9/0x170 [cfg80211]
>>> > [   83.030255]  [<ffffffffa05c3512>] cfg80211_wext_siwessid+0x22/0x40
>>> > [cfg80211]
>>> > [   83.030258]  [<ffffffff815af803>] ioctl_standard_iw_point+0x133/0x350
>>> > [   83.030264]  [<ffffffffa05c34f0>] ?
>>> > cfg80211_wext_giwessid+0x50/0x50 [cfg80211]
>>> > [   83.030266]  [<ffffffff810a4a82>] ? wake_up_q+0x32/0x70
>>> > [   83.030268]  [<ffffffff815b0930>] ? iw_handler_get_private+0x60/0x60
>>> > [   83.030271]  [<ffffffff815afd07>] ioctl_standard_call+0x87/0xd0
>>> > [   83.030273]  [<ffffffff815afc80>] ?
>>> > call_commit_handler.part.4+0x30/0x30
>>> > [   83.030275]  [<ffffffff815afc10>] wireless_process_ioctl+0x1f0/0x230
>>> > [   83.030278]  [<ffffffff814b52fe>] ? dev_get_by_name_rcu+0x5e/0x80
>>> > [   83.030280]  [<ffffffff815aff58>] wext_handle_ioctl+0x78/0xd0
>>> > [   83.030283]  [<ffffffff814d7777>] dev_ioctl+0x2a7/0x5a0
>>> > [   83.030285]  [<ffffffff8149dc86>] sock_ioctl+0x126/0x290
>>> > [   83.030287]  [<ffffffff81209be3>] do_vfs_ioctl+0xa3/0x5d0
>>> > [   83.030290]  [<ffffffff811f7362>] ? vfs_write+0x142/0x190
>>> > [   83.030292]  [<ffffffff8120a189>] SyS_ioctl+0x79/0x90
>>> > [   83.030294]  [<ffffffff815c71b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
>>> > [   83.030296] ---[ end trace 8247b235a66a1a21 ]---
>>> >
>>> >
>>> >
>>> >
>>> >
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Do not let me induce you to satisfy my curiosity, from an expectation,
> that I shall gratify yours. What I may judge proper to conceal, does
> not concern myself alone.
