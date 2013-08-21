Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:52016 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3HUItO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 04:49:14 -0400
Received: by mail-vb0-f47.google.com with SMTP id h10so88567vbh.20
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 01:49:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377072922.15268.4.camel@jlt4.sipsolutions.net>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	<1377020479-16935-10-git-send-email-k.eugene.e@gmail.com>
	<1377022333.2016.59.camel@joe-AO722>
	<CAFSJ42ZMk6sN6povWHkSodk0J7pBvyak8sH-MqNXVhi_iSmq9Q@mail.gmail.com>
	<1377072922.15268.4.camel@jlt4.sipsolutions.net>
Date: Wed, 21 Aug 2013 10:49:13 +0200
Message-ID: <CAFSJ42YY=9sxX8HrmA248KuXTQjMJ9=WQHATeuQzxPL_ur6utQ@mail.gmail.com> (sfid-20130821_104925_683814_0ACD5610)
Subject: Re: [PATCH 09/16] wcn36xx: Add smd.c
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> >> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
>> > []
>> >> +int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
>> >> +{
>> > []
>> >> +             /* Add NV body itself */
>> >> +             /* Rework me */
>> >> +             memcpy(wcn->smd_buf + sizeof(msg_body),
>> >> +                    (void *)(&nv_d->table) + fm_offset,
>> >> +                    msg_body.nv_img_buffer_size);
>> >
>> > Does this really do what you want?
>> >
>> > Perhaps it should be:
>> >
>> >                 memcpy(wcn->smd_buf + sizeof(msg_body),
>> >                        ((void *)&nv_d->table) + fm_offset,
>> >                        msg_body.nv_img_buffer_size);
>> >
>>
>> Yes, this line is working. Tested it for ARM. Do you see any potential
>> problems with this pointer operation?
>
> It should really be u8* instead of void*, since void* pointer arithmetic
> isn't really defined I think?
>
> Other than that, this was just about precedence rules, and casts have a
> higher precedence.
>

Aha, now i understand what you mean. You are absolutely right it must
be u8*. Will fix in the next round.

-- 
Best regards,
Eugene
