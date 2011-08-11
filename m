Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37821 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1HKQLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 12:11:37 -0400
Received: by yie30 with SMTP id 30so1417190yie.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 09:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEemkaz-dsyhq6x6rPLNvFj9+t=jPr9JtvcuzmRNG-8Y1g@mail.gmail.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
 <1312881233-9366-34-git-send-email-eliad@wizery.com> <1313054258.2407.820.camel@cumari>
 <CAB3XZEemkaz-dsyhq6x6rPLNvFj9+t=jPr9JtvcuzmRNG-8Y1g@mail.gmail.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Thu, 11 Aug 2011 19:11:17 +0300
Message-ID: <CA+XVXff4ThAJoW0kcXptk3WCji25n1r=WUgsg67CkuQiST5QgQ@mail.gmail.com> (sfid-20110811_181140_814983_3F689E5C)
Subject: Re: [PATCH 33/40] wl12xx: track freed packets in FW by AC
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 12:41, Eliad Peller <eliad@wizery.com> wrote:
>>> +     for (i = 0; i < NUM_TX_QUEUES; i++) {
>>> +             /* prevent wrap-around in freed-packets counter */
>>> +             wl->tx_allocated_pkts -=
>>> +                             (status->tx_released_pkts[i] -
>>> +                             wl->tx_pkts_freed[i] + 256) % 256;
>>
>> Isn't the "+ 256" useless here, since you'll mod the result anyway?
>>
> modulus of negative numbers is not well defined.
>
> Eliad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Actually (As pointed out by Ido) the whole (x+256) % 256 sequence can
be replaced by (x & 0xFF). I suspect the assembly code already
reflects this fact, but we can change it anyway.

Arik
