Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33553 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab1HHQ0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 12:26:33 -0400
Received: by pzk37 with SMTP id 37so8541760pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 09:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110808081635.GA2938@sapphire.tkos.co.il>
References: <52f0e75d7b2308f8ede85362ed96e6af71e39dd3.1311832184.git.baruch@tkos.co.il>
 <20110808081635.GA2938@sapphire.tkos.co.il>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 8 Aug 2011 09:26:12 -0700
Message-ID: <CAPjQAd_=J8EgGcvsQ6C+DtbB3q0Tot7ujcD-i8P+=gUZsq4OiQ@mail.gmail.com> (sfid-20110808_182636_730702_0D5B8AF6)
Subject: Re: [PATCH] mac80211/mesh: make the preq queue lock consistent
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 1:16 AM, Baruch Siach <baruch@tkos.co.il> wrote:
> Hi linux-wireless list,
>
> On Thu, Jul 28, 2011 at 08:51:05AM +0300, Baruch Siach wrote:
>> Make mesh_preq_queue_lock locking consistent with mesh_queue_preq() using
>> spin_lock_bh().

Signed-off-by: Javier Cardona <javier@cozybit.com>

Javier

> Ping?
>
> baruch
>
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>> ---
>>  net/mac80211/mesh_hwmp.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
>> index 2b18053..fc8cb1a 100644
>> --- a/net/mac80211/mesh_hwmp.c
>> +++ b/net/mac80211/mesh_hwmp.c
>> @@ -792,9 +792,9 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
>>               return;
>>       }
>>
>> -     spin_lock(&ifmsh->mesh_preq_queue_lock);
>> +     spin_lock_bh(&ifmsh->mesh_preq_queue_lock);
>>       if (ifmsh->preq_queue_len == MAX_PREQ_QUEUE_LEN) {
>> -             spin_unlock(&ifmsh->mesh_preq_queue_lock);
>> +             spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
>>               kfree(preq_node);
>>               if (printk_ratelimit())
>>                       mhwmp_dbg("PREQ node queue full\n");
>> @@ -806,7 +806,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
>>
>>       list_add_tail(&preq_node->list, &ifmsh->preq_queue.list);
>>       ++ifmsh->preq_queue_len;
>> -     spin_unlock(&ifmsh->mesh_preq_queue_lock);
>> +     spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
>>
>>       if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
>>               ieee80211_queue_work(&sdata->local->hw, &sdata->work);
>
> --
>                                                     ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
