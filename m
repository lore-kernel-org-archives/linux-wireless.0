Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:39756 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3HUH6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 03:58:42 -0400
Received: by mail-vb0-f43.google.com with SMTP id h11so62480vbh.30
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 00:58:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377022333.2016.59.camel@joe-AO722>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	<1377020479-16935-10-git-send-email-k.eugene.e@gmail.com>
	<1377022333.2016.59.camel@joe-AO722>
Date: Wed, 21 Aug 2013 09:58:39 +0200
Message-ID: <CAFSJ42ZMk6sN6povWHkSodk0J7pBvyak8sH-MqNXVhi_iSmq9Q@mail.gmail.com> (sfid-20130821_095852_398872_A90920C7)
Subject: Re: [PATCH 09/16] wcn36xx: Add smd.c
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/8/20 Joe Perches <joe@perches.com>:
> On Tue, 2013-08-20 at 19:41 +0200, Eugene Krasnikov wrote:
>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> []
>> +int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
>> +{
> []
>> +             /* Add NV body itself */
>> +             /* Rework me */
>> +             memcpy(wcn->smd_buf + sizeof(msg_body),
>> +                    (void *)(&nv_d->table) + fm_offset,
>> +                    msg_body.nv_img_buffer_size);
>
> Does this really do what you want?
>
> Perhaps it should be:
>
>                 memcpy(wcn->smd_buf + sizeof(msg_body),
>                        ((void *)&nv_d->table) + fm_offset,
>                        msg_body.nv_img_buffer_size);
>

Yes, this line is working. Tested it for ARM. Do you see any potential
problems with this pointer operation?


-- 
Best regards,
Eugene
