Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:36846 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcB2WbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:31:01 -0500
MIME-Version: 1.0
In-Reply-To: <20160226175925.GA9331@w1.fi>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
 <1456159001-20307-9-git-send-email-jprvita@endlessm.com> <20160226175925.GA9331@w1.fi>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Mon, 29 Feb 2016 17:30:20 -0500
Message-ID: <CA+A7VXUY=qVDQ-OqT+QJK8haN6AFX4Br=OPXi-6RCxpvH3=QRg@mail.gmail.com> (sfid-20160229_233135_420796_5FF1A81D)
Subject: Re: [PATCHv2 08/10] rfkill: Use switch to demux userspace operations
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni,

On 26 February 2016 at 12:59, Jouni Malinen <j@w1.fi> wrote:
> On Mon, Feb 22, 2016 at 11:36:39AM -0500, João Paulo Rechi Vita wrote:
>> Using a switch to handle different ev.op values in rfkill_fop_write()
>> makes the code easier to extend, as out-of-range values can always be
>> handled by the default case.
>
> This breaks rfkill.. There are automated test scripts for testing this
> area (and most of Wi-Fi for that matter. It would be nice if these were
> used for changes before they get contributed upstream..
>
> http://buildbot.w1.fi/hwsim/
>

Thanks for pointing that out, I haven't heard of this tool before.
I'll give it a try before my next submission.

> This specific commit broke all the rfkill_* test cases because of
> following:
>
>> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
>> @@ -1199,29 +1200,32 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
>> -     list_for_each_entry(rfkill, &rfkill_list, node) {
>> -             if (rfkill->idx != ev.idx && ev.op != RFKILL_OP_CHANGE_ALL)
>> -                     continue;
>> -
>> -             if (rfkill->type != ev.type && ev.type != RFKILL_TYPE_ALL)
>> -                     continue;
>
> Note that RFKILL_TYPE_ALL here..
>
>> +             list_for_each_entry(rfkill, &rfkill_list, node)
>> +                     if (rfkill->type == ev.type ||
>> +                         ev.type == RFKILL_TYPE_ALL)
>> +                             rfkill_set_block(rfkill, ev.soft);
>
> It was included for RFKILL_OP_CHANGE_ALL.
>
>> +     case RFKILL_OP_CHANGE:
>> +             list_for_each_entry(rfkill, &rfkill_list, node)
>> +                     if (rfkill->idx == ev.idx && rfkill->type == ev.type)
>> +                             rfkill_set_block(rfkill, ev.soft);
>
> but not for RFKILL_OP_CHANGE..
>
> This needs following to work:
>
>
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 59ff92d..c4bbd19 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -1239,7 +1239,9 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
>                 break;
>         case RFKILL_OP_CHANGE:
>                 list_for_each_entry(rfkill, &rfkill_list, node)
> -                       if (rfkill->idx == ev.idx && rfkill->type == ev.type)
> +                       if (rfkill->idx == ev.idx &&
> +                           (rfkill->type == ev.type ||
> +                            ev.type == RFKILL_TYPE_ALL))
>                                 rfkill_set_block(rfkill, ev.soft);
>                 ret = 0;
>                 break;
>

I agree there is a difference in the logic here, thanks for taking the
time to point it out so clearly, and sorry for missing this. But AFAIU
userspace should not call RFKILL_OP_CHANGE with ev.type ==
RFKILL_TYPE_ALL, as RFKILL_OP_CHANGE is intended to be used to
block/unblock one RFKill switch, and it is not possible to create a
RFKill switch with type == RFKILL_TYPE_ALL (rfkill_alloc() would
return NULL).

I tried to look into the source code of the test suite you pointed,
but couldn't easily figure out how it ends up with that combination.
Could you please explain (or point me in the code) how is that a valid
operation? If I'm not missing anything, we should probably return
EINVAL in this case.

Regards,

--
João Paulo Rechi Vita
http://about.me/jprvita
