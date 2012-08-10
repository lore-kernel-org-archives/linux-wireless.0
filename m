Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50829 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab2HJS2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 14:28:11 -0400
Received: by wgbdr13 with SMTP id dr13so1718668wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 11:28:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5025425A.2090207@hauke-m.de>
References: <2121451356.93690.1344518764022.JavaMail.root@neratec.com>
	<5025425A.2090207@hauke-m.de>
Date: Fri, 10 Aug 2012 14:28:09 -0400
Message-ID: <CAHashqAQ9tD3qmzMRNfzLcGbD2A9gykFjUbOhqZA=uLJBnQ4Gw@mail.gmail.com> (sfid-20120810_202815_228024_C2097769)
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
From: Andy Gospodarek <andy@greyhouse.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Phil Perry <phil@elrepo.org>, mcgrof@frijolero.org,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 1:18 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 08/09/2012 03:26 PM, Zefir Kurtisi wrote:
>> On 08/09/2012 06:40 AM, Andy Gospodarek wrote:
>>> This patch allows me to compile and load the latest compat modules on
>>> RHEL6.3.  Users of compat on RHEL6 should note that you should set
>>> CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.
>>>
>>> [...]
>>>
>>> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
>>> index 56d5961..09e4b6f 100644
>>> --- a/include/linux/compat-2.6.36.h
>>> +++ b/include/linux/compat-2.6.36.h
>>> @@ -98,6 +98,8 @@ struct pm_qos_request_list {
>>>   * Dummy printk for disabled debugging statements to use whilst maintaining
>>>   * gcc's format and side-effect checking.
>>>   */
>>> +/* mask no_printk as RHEL6 backports this */
>>> +#define no_printk(...) compat_no_printk(...)
>>>  static inline __attribute__ ((format (printf, 1, 2)))
>>>  int no_printk(const char *s, ...) { return 0; }
>>>
>>> [...]
>>
>> This at least breaks compilation on 2.6.35-22 with gcc throwing a
>> compat-2.6.36.h:104: error: ISO C requires a named argument before ‘...’
>>
>> It looks like no_printk() needs to be renamed to compat_no_printk()
>> to make it work as intended.
>>
>> This is a systematic mistake at several sections of this patch, where
>> the original function needs to be prefixed by 'compat_' to match the
>> related macro.
>>
>>
>> ---
>> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
>> index 8b02260..b6757c3 100644
>> --- a/include/linux/compat-2.6.36.h
>> +++ b/include/linux/compat-2.6.36.h
>> @@ -101,7 +101,7 @@ struct pm_qos_request_list {
>>  /* mask no_printk as RHEL6 backports this */
>>  #define no_printk(...) compat_no_printk(...)
>>  static inline __attribute__ ((format (printf, 1, 2)))
>> -int no_printk(const char *s, ...) { return 0; }
>> +int compat_no_printk(const char *s, ...) { return 0; }
>>
>>  #ifndef alloc_workqueue
>>  #define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active, 0)
>
> With this patch applied it works better, but I still get this error in
> drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c.
>
> brcmfmac has this line:
>
> #define brcmf_dbg(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
>
> so brcmf_dbg gets no_printk and not compat_no_printk.
>
> Why isn't "ifndef CONFIG_COMPAT_RHEL_6_3" put around the declaration of
> no_printk()?
>
> Hauke

Did you try the patch I posted last night that has the updated define
for no_printk()?  I saw the same error until I applied that patch.
