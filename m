Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from quad.pendre.co.uk ([195.137.4.79]:46844 "EHLO quad.pendre.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759951Ab2HIWYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 18:24:09 -0400
Message-ID: <5024364E.6030502@elrepo.org> (sfid-20120810_002416_626250_3720618B)
Date: Thu, 09 Aug 2012 23:14:38 +0100
From: Phil Perry <phil@elrepo.org>
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: Zefir Kurtisi <zefir.kurtisi@neratec.com>, mcgrof@frijolero.org,
	linux-wireless@vger.kernel.org,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
References: <1344487215-24143-1-git-send-email-andy@greyhouse.net> <2121451356.93690.1344518764022.JavaMail.root@neratec.com> <CAHashqCmcgXXDyyqwEYefTMXFDVFKm9GKydfbS14UCY_L443Vg@mail.gmail.com>
In-Reply-To: <CAHashqCmcgXXDyyqwEYefTMXFDVFKm9GKydfbS14UCY_L443Vg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/12 22:59, Andy Gospodarek wrote:
> On Aug 9, 2012 9:26 AM, "Zefir Kurtisi"<zefir.kurtisi@neratec.com>  wrote:
>>
>> On 08/09/2012 06:40 AM, Andy Gospodarek wrote:
>>> This patch allows me to compile and load the latest compat modules on
>>> RHEL6.3.  Users of compat on RHEL6 should note that you should set
>>> CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.
>>>
>>> [...]
>>>
>>> diff --git a/include/linux/compat-2.6.36.h
> b/include/linux/compat-2.6.36.h
>>> index 56d5961..09e4b6f 100644
>>> --- a/include/linux/compat-2.6.36.h
>>> +++ b/include/linux/compat-2.6.36.h
>>> @@ -98,6 +98,8 @@ struct pm_qos_request_list {
>>>    * Dummy printk for disabled debugging statements to use whilst
> maintaining
>>>    * gcc's format and side-effect checking.
>>>    */
>>> +/* mask no_printk as RHEL6 backports this */
>>> +#define no_printk(...) compat_no_printk(...)
>>>   static inline __attribute__ ((format (printf, 1, 2)))
>>>   int no_printk(const char *s, ...) { return 0; }
>>>
>>> [...]
>>
>> This at least breaks compilation on 2.6.35-22 with gcc throwing a
>> compat-2.6.36.h:104: error: ISO C requires a named argument before ‘...’
>>
>
> Actually that might be due to the fact that I chose to use no_printk(...)
> rather than no_printk(a,...).
>
> What version of gcc are you using?
>
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
>>   /* mask no_printk as RHEL6 backports this */
>>   #define no_printk(...) compat_no_printk(...)
>>   static inline __attribute__ ((format (printf, 1, 2)))
>> -int no_printk(const char *s, ...) { return 0; }
>> +int compat_no_printk(const char *s, ...) { return 0; }
>>
>>   #ifndef alloc_workqueue
>>   #define alloc_workqueue(name, flags, max_active)
> __create_workqueue(name, flags, max_active, 0)
>

Hi Andy, Zefir,

Thanks for these patches, this certainly moves us forward (the compat 
components do now compile on RHEL6.3); my build then errors out on 
drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc (I should apologise and 
state I'm trying to build the 3.5-3 stable tarball on RHEL6.3).

Here are the errors, which I believe are related to the above 
no_printk() issue:


   CC [M] 
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.o
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_cdc_msg':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:114: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_cdc_cmplt':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:134: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_cdc_query_dcmd':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:157: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:158: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:186: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:203: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_cdc_set_dcmd':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:238: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:239: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:265: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_dcmd':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:290: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:295: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:301: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:306: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_hdrpush':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:367: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_hdrpull':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:392: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:397: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:406: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:412: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:418: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:390: 
warning: unused variable 'drvr'
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_attach':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:441: 
error: expected expression before '...' token
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c: 
In function 'brcmf_proto_init':
/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c:468: 
error: expected expression before '...' token
make[5]: *** 
[/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.o] 
Error 1
make[4]: *** 
[/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211/brcmfmac] 
Error 2
make[3]: *** 
[/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless/brcm80211] 
Error 2
make[2]: *** 
[/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3/drivers/net/wireless] 
Error 2
make[1]: *** [_module_/home/phil/rpmbuild/BUILD/compat-wireless-3.5-3] 
Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.32-279.el6.x86_64'
make: *** [modules] Error 2

The only way I have found to work around this at the moment is to block 
out the offending no_printk() for RHEL6.3:

/*
  * Dummy printk for disabled debugging statements to use whilst maintaining
  * gcc's format and side-effect checking.
  */
/* mask no_printk as RHEL6.3 backports this */
#if (RHEL_MINOR < 3)
static inline __attribute__ ((format (printf, 1, 2)))
int no_printk(const char *s, ...) { return 0; }
#endif /* (RHEL_MINOR < 3) */

Not a very elegant solution but at least the code does now compile for 
me on RHEL6.3, so it's progress of sorts.

Regards,

Phil

