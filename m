Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35864 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HPQtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 12:49:55 -0400
Received: by qwk3 with SMTP id 3so57952qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 09:49:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfeXFZ-oLRWxROuQQji5+m2xeDnQWfc8kJ+m=hPPeq7wRw@mail.gmail.com>
References: <1312895383-3624-1-git-send-email-guy@wizery.com>
	<CA+XVXfeXFZ-oLRWxROuQQji5+m2xeDnQWfc8kJ+m=hPPeq7wRw@mail.gmail.com>
Date: Tue, 16 Aug 2011 19:49:54 +0300
Message-ID: <CAA03846szz-sBT1EFaHAAYxsvb3ng7Z6OsHVPE3aDKSUSj2uBg@mail.gmail.com> (sfid-20110816_184959_075381_79A884D7)
Subject: Re: [PATCH v2] wl12xx: use 2 spare TX blocks for GEM cipher
From: Guy Eilam <guy@wizery.com>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 8:59 PM, Arik Nemtsov <anamtsov@gmail.com> wrote:
> On Tue, Aug 9, 2011 at 16:09, Guy Eilam <guy@wizery.com> wrote:
>> Add tx_spare_blocks member to the wl1271 struct
>> for more generic configuration of the amount
>> of spare TX blocks that should be used.
>> The default value is 1.
>> In case GEM cipher is used by the STA, we need
>> 2 spare TX blocks instead of just 1.
>>
>> Signed-off-by: Guy Eilam <guy@wizery.com>
>> ---
>>  drivers/net/wireless/wl12xx/main.c   |   12 ++++++++++++
>>  drivers/net/wireless/wl12xx/tx.c     |    4 +---
>>  drivers/net/wireless/wl12xx/tx.h     |    1 +
>>  drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
>>  4 files changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index 1c56137..1d2b3e9 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -2736,6 +2736,17 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
>>                        0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>>                };
>>
>> +               /*
>> +                * A STA set to GEM cipher requires 2 tx spare blocks.
>> +                * Return to default value when GEM cipher key is removed
>> +                */
>> +               if (key_type == KEY_GEM) {
>> +                       if (action == KEY_ADD_OR_REPLACE)
>> +                               wl->tx_spare_blocks = 2;
>> +                       else if (action == KEY_REMOVE)
>> +                               wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
>> +               }
>> +
>
> What about recovery? Note this code won't be reached in case
> wl1271_op_set_key() is called when wl->state == OFF.
> We should probably always revert to 1 blocks on unjoin or remove_interface.

You are correct - this is fixed in a newer version of the patch.

>
>> --- a/drivers/net/wireless/wl12xx/tx.c
>> +++ b/drivers/net/wireless/wl12xx/tx.c
>> @@ -200,9 +200,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
>>        u32 len;
>>        u32 total_blocks;
>>        int id, ret = -EBUSY, ac;
>> -
>> -       /* we use 1 spare block */
>> -       u32 spare_blocks = 1;
>> +       u32 spare_blocks = wl->tx_spare_blocks;
>
> What about dummy packets? Perhaps we should still use 1 block for them?

Again, fixed in a newer version of the patch.

>
> Arik
>

Guy.
