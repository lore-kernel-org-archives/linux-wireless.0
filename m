Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60231 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab1KQAFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 19:05:09 -0500
Received: by pzk36 with SMTP id 36so928398pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 16:05:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201111170007.58457.chunkeey@googlemail.com>
References: <20111116235546.096975f6@milhouse> <201111170007.58457.chunkeey@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 17 Nov 2011 11:04:49 +1100
Message-ID: <CAGRGNgVOmK+O7hifSuaKAL4vJCN1fkCZwZun4kchDpdLSLPZ7Q@mail.gmail.com> (sfid-20111117_010515_014811_23252532)
Subject: Re: [PATCH] p54spi: Fix workqueue deadlock
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian, Michael,

I'm not sure these patches made it to the list.

Thanks,

Julian Calaby

On Thu, Nov 17, 2011 at 10:07, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Wednesday, November 16, 2011 11:55:46 PM Michael Büsch wrote:
>> priv->work must not be synced while priv->mutex is locked, because
>> the mutex is taken in the work handler.
>> Move cancel_work_sync down to after the device shutdown code.
>> This is safe, because the work handler checks fw_state and bails out
>> early in case of a race.
>>
>> Signed-off-by: Michael Buesch <m@bues.ch>
> Cc: <stable@kernel.org>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
