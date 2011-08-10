Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53472 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1HJJxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 05:53:34 -0400
Received: by ywf7 with SMTP id 7so541909ywf.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 02:53:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312967955.2407.452.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	<1312881233-9366-9-git-send-email-eliad@wizery.com>
	<1312967955.2407.452.camel@cumari>
Date: Wed, 10 Aug 2011 12:53:33 +0300
Message-ID: <CAB3XZEcdxPhw=L4EA6ZJVnEOw6EZTu+WfZR8NJj_vrPMmU6-vQ@mail.gmail.com> (sfid-20110810_115340_527845_FDAF1AA7)
Subject: Re: [PATCH 08/40] wl12xx: wl12xx-fw-3 - update commands & events
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Luca,

thanks for your (ongoing) reviews.
i'll apply your comments in the next version.
anyway, regarding some of non-trivial comments:

On Wed, Aug 10, 2011 at 12:19 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>>       /* unmask required mbox events  */
>>       wl->event_mask = BSS_LOSE_EVENT_ID |
>>               SCAN_COMPLETE_EVENT_ID |
>>               PS_REPORT_EVENT_ID |
>> -             JOIN_EVENT_COMPLETE_ID |
>>               DISCONNECT_EVENT_COMPLETE_ID |
>>               RSSI_SNR_TRIGGER_0_EVENT_ID |
>>               PSPOLL_DELIVERY_FAILURE_EVENT_ID |
>>               SOFT_GEMINI_SENSE_EVENT_ID |
>>               PERIODIC_SCAN_REPORT_EVENT_ID |
>> -             PERIODIC_SCAN_COMPLETE_EVENT_ID;
>> +             PERIODIC_SCAN_COMPLETE_EVENT_ID |
>> +             DUMMY_PACKET_EVENT_ID |
>> +             PEER_REMOVE_COMPLETE_EVENT_ID |
>> +             BA_SESSION_RX_CONSTRAINT_EVENT_ID |
>> +             REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID;
>>
>>       if (wl->bss_type == BSS_TYPE_AP_BSS)
>> -             wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID |
>> -                               INACTIVE_STA_EVENT_ID |
>> +             wl->event_mask |= INACTIVE_STA_EVENT_ID |
>>                                 MAX_TX_RETRY_EVENT_ID;
>
> Do we really need to mask this stuff separately?
>
we thought of masking the needed events according to the active role.
anyway, i since there is no overlapping, and in the future there will
be multiple roles, i guess we can just unmask them all together.


>> -int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
>> +int wl1271_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id)
>
> s/wl1271_cmd_role_enable/wl12xx_cmd_role_enable/
>
> Same thing for wl1271_cmd_role_disable and all the other functions whose
> declaration changed.
>
> I was thinking that we could use the role_id directly from the wl struct
> here, but then I changed my mind, because I think it's not good that the
> cmd functions themselves change the wl struct.  At some point we need to
> split the HW-related part of wl (phy) from the context-related elements

well, that exactly our plan. after applying the all the pending series
we'll start splitting up wl into global and per-vif data, in order to
support multiple vifs.

> (vif).  For most of the cases, if not all, the cmd functions only use
> the HW-related elements.
>
every command that takes role_id as param is basically per-vif, so i
guess you're wrong here :)

> Anyway, this small detour just supports the usage of role_id as a
> separate argument instead of taking it from wl. ;)
>
right :)

>> +
>> +       memcpy(cmd->mac_address, wl->mac_addr, ETH_ALEN);
>
> To keep aligned with my comment about phy vs. vif context, I think it
> would be nicer to pass the MAC address as an argument to this function
> as well.  When we implement multirole, we will need different MAC
> addresses for each role, so we can't really use the value from wl.
>
you are right, but let's leave it for a later stage.
(i have some patch that replaces all the wl->mac_addr to vif->addr)

>> +static int wl1271_allocate_link(struct wl1271 *wl, u8 *hlid)
>> +{
>> +     u8 alloced = find_first_zero_bit(wl->links_map, WL1271_MAX_LINKS);
>
> This is *very* netpicky, but could you call this variable "link" or
> something instead of "alloced"? Alloced is annoying to read because of
> the missing apostrophe! :P
>
whatever :)

>> +int wl1271_cmd_role_stop_sta(struct wl1271 *wl)
>> +{

>> +
>> +     cmd->role_id = wl->role_id;
>> +     cmd->disc_type = WL1271_DISC_IMMEDIATE;
>> +     cmd->reason = cpu_to_le16(1); /* STATUS_UNSPECIFIED */
>
> Isn't there a more reasonable reason? :) In any case, this should at
> least be in an enum together with the other possible reasons instead of
> hardcoded here.
>
in fact, i think it has meaning only if we configure the disassoc
template, so we can just delete it.


again, thanks for your reviews.
i'll just apply all the required changes instead of ACKing each one :)

Eliad.
