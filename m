Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:38770 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbeB1QBX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 11:01:23 -0500
Received: by mail-io0-f171.google.com with SMTP id g21so3721655ioj.5
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 08:01:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519830361.2292.1.camel@sipsolutions.net>
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
 <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
 <1519830361.2292.1.camel@sipsolutions.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Wed, 28 Feb 2018 17:01:21 +0100
Message-ID: <CAJ0CqmU5uii64C2MwCgtFRVzfker4c4G9f5=M3Le8nf+Vkx96A@mail.gmail.com> (sfid-20180228_170143_974906_1F965618)
Subject: Re: [PATCH] mt7601u: remove a warning in mt7601u_efuse_physical_size_check()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, 2018-02-28 at 15:26 +0100, Lorenzo Bianconi wrote:
>>
>>       const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
>> -     u8 data[map_reads * 16];
>> +     u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE, 16)];
>>
> You could turn it upside down and make
>
> const int map_reads = ARRAY_SIZE(data);

map_reads is actually 2 since MT_EFUSE_USAGE_MAP_SIZE is 29. Using
ARRAY_SIZE(data) map_reads will be set to 32

Regards,
Lorenzo

>
> johannes
