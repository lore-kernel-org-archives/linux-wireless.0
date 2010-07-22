Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54295 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVMEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 08:04:06 -0400
Received: by vws3 with SMTP id 3so46052vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 05:04:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C47F706.4060102@iki.fi>
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
	<1279780458.2322.25.camel@powerslave>
	<4C47F706.4060102@iki.fi>
Date: Thu, 22 Jul 2010 08:04:02 -0400
Message-ID: <AANLkTimh-2cuWdJKgf2TUkCQmGXDC0-86xVhbA-kiPGR@mail.gmail.com>
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 3:45 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>>> @@ -191,11 +191,13 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
>>>      if (control->control.hw_key &&
>>>          control->control.hw_key->alg == ALG_TKIP) {
>>>              int hdrlen;
>>> -            u16 fc;
>>> +            __le16 fc;
>>> +            u16 length;
>>>              u8 *pos;
[...]
>>> +            length = le16_to_cpu(tx_hdr->length) + WL1251_TKIP_IV_SPACE;
>>> +            tx_hdr->length = cpu_to_le16(length);
>>
>> ...which is treated correctly here.
>
> This is different. Here we are adding something to a __le16 value, not
> calculating with pointers.

Just throwing in my 2 cents, unless there's some other reason to add the
length temporary, here you can just do:

    le16_add_cpu(&tx_hdr->length, WL1251_TKIP_IV_SPACE);

-- 
Bob Copeland %% www.bobcopeland.com
