Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49753 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDAHyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 03:54:11 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so4308450wib.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 00:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEew5X5Ux9Wpi0g0xqiMk2ULxoeEQvb8SkXBkpmQDjMCxQ@mail.gmail.com>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-14-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEcYPPruXSxndMcbaek0ozLZV9GGpqKOAO0WPC6CcT-j7Q@mail.gmail.com>
	<CA+BoTQkXWscUL-XLL1sBNb=eXahafoCUazsNKVFU08X9bPdBPQ@mail.gmail.com>
	<CAB3XZEew5X5Ux9Wpi0g0xqiMk2ULxoeEQvb8SkXBkpmQDjMCxQ@mail.gmail.com>
Date: Tue, 1 Apr 2014 09:54:09 +0200
Message-ID: <CA+BoTQ=DXmWuYtX8XmHuD1Lia=h8pFhJ1wXOSBv+bURzrFREmQ@mail.gmail.com> (sfid-20140401_095414_908195_4F0BB526)
Subject: Re: [PATCH v3 13/13] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 April 2014 09:46, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, Apr 1, 2014 at 8:10 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 31 March 2014 18:15, Eliad Peller <eliad@wizery.com> wrote:
>>> On Mon, Mar 31, 2014 at 1:39 PM, Michal Kazior <michal.kazior@tieto.com> wrote:

[...]

>>>> +err_unassign:
>>>> +       list_for_each_entry_continue_reverse(sdata, &ctx->reserved_vifs,
>>>> +                                            reserved_chanctx_list)
>>>> +               drv_unassign_vif_chanctx(local, sdata, ctx);
>>>> +       ieee80211_del_chanctx(local, new_ctx);
>>>> +err_revert:
>>>> +       kfree_rcu(new_ctx, rcu_head);
>>>> +       WARN_ON(ieee80211_add_chanctx(local, ctx));
>>>> +       list_add_rcu(&ctx->list, &local->chanctx_list);
>>>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>>>> +               sdata->radar_required = sdata->reserved_radar_required;
>>>> +               rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
>>>> +               WARN_ON(drv_assign_vif_chanctx(local, sdata, ctx));
>>>> +       }
>>> seems like the list_for_each_entry should actually be under err_unassign?
>>
>> No. This is correct. The err_unassign is used to bail out if any
>> drv_assign_vif_chanctx fails mid-way. We want to unassign only those
>> vif-chanctx we only managed to assign.
>>
> sure. i failed to explain - i'm referring only to the radar_required
> swapping - it seems to happen only later.

You mean to split the list_for_each_entry from err_revert into 2
parts: one that reverts the radar_required swapping and the other one
re-assigning vif-chanctx? I'm not really sure if that's necessary? The
`ctx` (old chanctx) should still be configured as it was wrt radar
detection. Or is there something that I'm missing?


Michał
