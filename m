Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:51508 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3HUHzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 03:55:11 -0400
Received: by mail-vc0-f180.google.com with SMTP id gf11so56108vcb.25
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 00:55:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377021890.2016.55.camel@joe-AO722>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	<1377020479-16935-14-git-send-email-k.eugene.e@gmail.com>
	<1377021890.2016.55.camel@joe-AO722>
Date: Wed, 21 Aug 2013 09:55:10 +0200
Message-ID: <CAFSJ42YMogHrFBzn1mVQf86GV8kzZ0iVPXWaHMUsU-CAA6AwWw@mail.gmail.com> (sfid-20130821_095516_636348_87FF8837)
Subject: Re: [PATCH 13/16] wcn36xx: Add wcn36xx.h
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

Thank you very much for your comments.

Please find my comments bellow:

>> Adding wcn36xx.h
> []
>> +#define DRIVER_PREFIX "wcn36xx: "
> []
>
> I think you should use pr_fmt and/or netdev_<level>

Thanx, will add pr_fmt in the next round.

>> +#define wcn36xx_error(fmt, arg...) do {                      \
>> +     pr_err(DRIVER_PREFIX "ERROR " fmt "\n", ##arg); \
>> +     __WARN();                                       \
>> +} while (0)
>
> What value is there in this __WARN?

This warn is there just to scream louder every time when error happens:)

> Please use _err rather than _error

Thanx, will fix in the next patch set.

>> +#define wcn36xx_warn(fmt, arg...)                            \
>> +     pr_warn(DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
>> +
>> +#define wcn36xx_info(fmt, arg...)            \
>> +     pr_info(DRIVER_PREFIX fmt "\n", ##arg)
>> +
>> +#define wcn36xx_dbg(mask, fmt, arg...) do {                  \
>> +     if (debug_mask & mask)                                  \
>> +             pr_debug(DRIVER_PREFIX fmt "\n", ##arg);        \
>> +} while (0)
>> +
>> +#define wcn36xx_dbg_dump(mask, prefix_str, buf, len) do {    \
>> +     if (debug_mask & mask)                                  \
>> +             print_hex_dump(KERN_DEBUG, prefix_str,          \
>> +                            DUMP_PREFIX_OFFSET, 32, 1,       \
>> +                            buf, len, false);                \
>> +} while (0)
>> +
>
> Please move the "\n" to the uses instead of the macro.
> This would be consistent with all the other ath macros.

Thanx, will fix in the next patch set.

-- 
Best regards,
Eugene
