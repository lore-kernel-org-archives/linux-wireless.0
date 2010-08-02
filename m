Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40348 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0HBTkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 15:40:02 -0400
Received: by wyb39 with SMTP id 39so3628971wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 12:40:01 -0700 (PDT)
Message-ID: <4C571F0B.3000200@gmail.com>
Date: Mon, 02 Aug 2010 21:39:55 +0200
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] compat: define struct va_format introduced in v2.6.36
References: <4C55D22A.5040302@hauke-m.de> <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com> <AANLkTinfrBRm8J2G+k8bB6N-YniVkmUYOBkRpyF_tC2j@mail.gmail.com>
In-Reply-To: <AANLkTinfrBRm8J2G+k8bB6N-YniVkmUYOBkRpyF_tC2j@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



As on 2010-08-02 20:00, Luis R. Rodriguez did write:
> On Sun, Aug 1, 2010 at 3:02 PM, Kshitij Kulshreshtha
> <kkhere.geo@gmail.com> wrote:
>> Signed-off-by: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
>> ---
>>  include/linux/compat-2.6.36.h |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
>> index 0307108..b14c772 100644
>> --- a/include/linux/compat-2.6.36.h
>> +++ b/include/linux/compat-2.6.36.h
>> @@ -8,6 +8,11 @@
>>  #define kparam_block_sysfs_write(a)
>>  #define kparam_unblock_sysfs_write(a)
>>
>> +struct va_format {
>> +       const char *fmt;
>> +       va_list *va;
>> +};
>> +
>>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
>>
>>  #endif /* LINUX_26_36_COMPAT_H */
> 
> I'll apply this for now but what caller uses this for example?
> 

in linux-next.git
net/wireless/core.c:912
static int ___wiphy_printk(const char *level, const struct wiphy *wiphy,
                           struct va_format *vaf)



>   Luis

-- 
Kshitij Kulshreshtha

Institut für Mathematik,
Universität Paderborn,
Warburger Straße 100,
33098 Paderborn.

Büro: A3.319

Privatanschrift:
Arnikaweg 62
33100 Paderborn.
