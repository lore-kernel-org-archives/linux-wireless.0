Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:51170 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbZGPXvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:51:54 -0400
Received: by yxe14 with SMTP id 14so841011yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 16:51:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907161643v28a621e7ne29ec1e032e0ae95@mail.gmail.com>
References: <4A5D0374.5040702@mandriva.org> <1247611024.1796.21.camel@johannes.local>
	<4A5D0A7F.5090108@mandriva.org> <1247672725.17896.1974.camel@rc-desk>
	<4A5FA52D.7030701@mandriva.org> <1247782731.31442.3.camel@johannes.local>
	<1247783433.31442.11.camel@johannes.local> <4A5FB957.80407@mandriva.org>
	<43e72e890907161643v28a621e7ne29ec1e032e0ae95@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 16:51:33 -0700
Message-ID: <43e72e890907161651s4f2861a2x84c5d08ba33619df@mail.gmail.com>
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6 to
	2.6.31-rc3
To: Thomas Backlund <tmb@mandriva.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 4:43 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Thu, Jul 16, 2009 at 4:35 PM, Thomas Backlund<tmb@mandriva.org> wrote:
>> Johannes Berg skrev:
>>>
>>> On Fri, 2009-07-17 at 00:18 +0200, Johannes Berg wrote:
>>>
>>>>> And pressing it again gets this:
>>>>> [root@tmb-laptop rfkill]# ./rfkill list
>>>>> 0: acer-wireless: Wireless LAN
>>>>>        Soft blocked: no
>>>>>        Hard blocked: no
>>>>> 1: acer-bluetooth: Bluetooth
>>>>>        Soft blocked: yes
>>>>>        Hard blocked: no
>>>>> 2: phy0: Wireless LAN
>>>>>        Soft blocked: yes
>>>>>        Hard blocked: no
>>>>>
>>>>> And after that I cant get wireless back until I again do a:
>>>>> ./rfkill unblock 2
>>>>> (works only when acer-wireless is no/no and Wireless LAN is yes/no)
>>>>
>>>> Right. This is bad. The button press shouldn't have affected the
>>>> soft-state of the rfkill #2.
>>>>
>>>>> Applying this patch:
>>>>> [PATCH] rfkill: fix rfkill_set_states() to set the hw state
>>>>> sent by Alan Jenkins does not help this issue either...
>>>>>
>>>>> Any  suggestions how to fix the rfkill ?
>>>>
>>>> I'll poke at the acer code to see what it's doing wrong...
>>>
>>> Can't see anything wrong. I wonder if the button you have sends both the
>>> ACPI event _and_ an input event.
>>>
>>> Can you try this patch and tell us what happens?
>>>
>>
>> pressing rfkill when I have a working wireless gets this:
>>
>> Jul 17 02:24:35 tmb-laptop klogd: rfkill_schedule_toggle(1)
>> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending
>> REPLY_RXON_ASSOC: enqueue_hcmd failed: -5
>> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error setting
>> RXON_ASSOC (-5)
>> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending
>> REPLY_ADD_STA: enqueue_hcmd failed: -5
>> Jul 17 02:24:35 tmb-laptop klogd: mac80211-phy0: failed to remove key (0,
>> 00:19:5b:51:dc:27) from hardware (-5)
>> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending
>> REPLY_ADD_STA: enqueue_hcmd failed: -5
>> Jul 17 02:24:35 tmb-laptop klogd: mac80211-phy0: failed to remove key (1,
>> ff:ff:ff:ff:ff:ff) from hardware (-5)
>> Jul 17 02:24:35 tmb-laptop dhclient: receive_packet failed on wlan0: Network
>> is down
>> Jul 17 02:24:35 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [1]
>> Jul 17 02:24:36 tmb-laptop ifplugd(wlan0)[1790]: Link beat lost.
>>
>>
>> After that I only get (when pressing rfkill several times...):
>> Jul 17 02:30:16 tmb-laptop klogd: rfkill_schedule_toggle(1)
>> Jul 17 02:30:16 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [0]
>>
>> Jul 17 02:30:28 tmb-laptop klogd: rfkill_schedule_toggle(1)
>> Jul 17 02:30:28 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [1]
>>
>> Jul 17 02:30:31 tmb-laptop klogd: rfkill_schedule_toggle(1)
>> Jul 17 02:30:31 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [0]
>>
>> Jul 17 02:30:45 tmb-laptop klogd: rfkill_schedule_toggle(1)
>> Jul 17 02:30:45 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [1]
>>
>> Jul 17 02:32:23 tmb-laptop klogd: rfkill_schedule_toggle(1)
>> Jul 17 02:32:23 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [0]
>>
>> And no wireless network...
>>
>> Issuing ./rfkill unblock 2 gets the wireless back
>> Jul 17 02:32:48 tmb-laptop klogd: Registered led device: iwl-phy0::radio
>> Jul 17 02:32:48 tmb-laptop klogd: Registered led device: iwl-phy0::assoc
>> Jul 17 02:32:48 tmb-laptop klogd: Registered led device: iwl-phy0::RX
>> Jul 17 02:32:48 tmb-laptop klogd: Registered led device: iwl-phy0::TX
>> Jul 17 02:33:00 tmb-laptop ifplugd(wlan0)[1790]: Link beat detected.
>
> I think we're missing two rfkill defines for compat. Give me a second to review.

nevermind

  Luis
