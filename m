Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:56542 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3HZHXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 03:23:25 -0400
Received: by mail-vb0-f53.google.com with SMTP id i3so1895979vbh.12
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 00:23:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377298929.2816.15.camel@joe-AO722>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	<1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
	<1377298929.2816.15.camel@joe-AO722>
Date: Mon, 26 Aug 2013 09:23:23 +0200
Message-ID: <CAFSJ42abOvdkUjGwqKJOHapwrv2y1PV=tLeHVFfC0w3vKYhHCg@mail.gmail.com> (sfid-20130826_092328_385126_556E0A69)
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since wcn36xx soon will become a part of ath family and all ath
drivers are using printk i thought it's reasonable to use common
approach everywhere:) May be in future all ath debug functions will be
united into one debug framework and the same code will be used
everywhere.

2013/8/24 Joe Perches <joe@perches.com>:
> On Fri, 2013-08-23 at 10:58 +0200, Eugene Krasnikov wrote:
>> Adding wcn36xx.h
> []
>> +#define wcn36xx_err(fmt, arg...)                             \
>> +     printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg);
>> +
>> +#define wcn36xx_warn(fmt, arg...)                            \
>> +     printk(KERN_WARNING pr_fmt("WARNING " fmt), ##arg)
>> +
>> +#define wcn36xx_info(fmt, arg...)            \
>> +     printk(KERN_INFO pr_fmt(fmt), ##arg)
>> +
>
> I these would be better using:
>
> #define wcn36xx_err(fmt, ...)                                   \
>         pr_err("ERROR " fmt, ##__VA_ARGS__)
>
> etc...
>
>> +#define wcn36xx_dbg(mask, fmt, arg...) do {                  \
>> +     if (debug_mask & mask)                                  \
>> +             printk(KERN_DEBUG pr_fmt(fmt), ##arg);  \
>> +} while (0)
>
> And maybe this one using pr_debug so dynamic_debug
> can work too.
>
>



-- 
Best regards,
Eugene
