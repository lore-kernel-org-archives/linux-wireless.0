Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:43060 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZJKVca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 17:32:30 -0400
Received: by qw-out-2122.google.com with SMTP id 9so411788qwb.37
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 14:31:24 -0700 (PDT)
Message-ID: <4AD24EAA.4090907@lwfinger.net>
Date: Sun, 11 Oct 2009 16:31:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat-wireless: Fix the bleeding-edge version to build
 on 2.6.27
References: <4ac55601.EpUUwD1vnjBKSXDy%Larry.Finger@lwfinger.net> <4AD22B39.3070006@hauke-m.de>
In-Reply-To: <4AD22B39.3070006@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2009 02:00 PM, Hauke Mehrtens wrote:
> Larry Finger wrote:
>> When building the bleeding-edge compat-wireless for kernel 2.6.27,
>> several compilation errors were detected.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> Luis,
>>
>> I checked these patches on 2.6.27 and 2.6.31, but not for the intermediate
>> releases.
>>
>> Larry
>> ---
>>
>> Index: compat-wireless-2009-09-05/include/net/compat-2.6.28.h
>> ===================================================================
>> --- compat-wireless-2009-09-05.orig/include/net/compat-2.6.28.h
>> +++ compat-wireless-2009-09-05/include/net/compat-2.6.28.h
>> @@ -149,6 +149,7 @@ static inline void skb_queue_splice_tail
>>  struct module;
>>  struct tracepoint;
>>  
>> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
>>  struct tracepoint {
>>  	const char *name;		/* Tracepoint name */
>>  	int state;			/* State. */
>> @@ -159,6 +160,7 @@ struct tracepoint {
>>  					 * align these on the structure size.
>>  					 * Keep in sync with vmlinux.lds.h.
>>  					 */
>> +#endif
>>  
>>  #ifndef DECLARE_TRACE
>>  
>> @@ -179,13 +181,17 @@ struct tracepoint {
>>  		return -ENOSYS;						\
>>  	}
>>  
>> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
>>  #define DEFINE_TRACE(name)
>> +#endif
>>  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
>>  #define EXPORT_TRACEPOINT_SYMBOL(name)
>>  
>> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
>>  static inline void tracepoint_update_probe_range(struct tracepoint *begin,
>>  	struct tracepoint *end)
>>  { }
>> +#endif
>>  
>>  #endif
>>  
> 
> LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28) can not be true in
> compat-2.6.28.h. The definitions are not needed in compat-wireless any
> more. Removing this does not break compiling with mainline kernel 2.6.25
> to 2.6.32

Well... I was using the openSUSE 2.6.27 kernel, and it broke without
this statement, as did the compilation of the user on the o-penSUSE
forums!

>> Index: compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c
>> ===================================================================
>> --- compat-wireless-2009-09-05.orig/net/wireless/compat-2.6.28.c
>> +++ compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c
>> @@ -260,6 +260,7 @@ static unsigned long round_jiffies_commo
>>  	return j;
>>  }
>>  
>> +#if 0
>>  /**
>>   * round_jiffies_up - function to round jiffies up to a full second
>>   * @j: the time in (absolute) jiffies that should be rounded
>> @@ -274,5 +275,6 @@ unsigned long round_jiffies_up(unsigned
>>  	return round_jiffies_common(j, raw_smp_processor_id(), true);
>>  }
>>  EXPORT_SYMBOL_GPL(round_jiffies_up);
>> +#endif
>>  
>>  #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
> 
> The mainline kernel 2.6.27 does not contain round_jiffies_up. Are you
> using Suse? Suse adds some extra extensions into the kernel, we need an
> other way to deactivate the round_jiffies_up export. With this patch
> this symbol is missing while compiling against mainline kernel <=
> 2.6.27. An other user reported a problem with the Suse kernel in:
> http://marc.info/?l=linux-wireless&m=125393384728475

Yes, the openSUSE patched kernel sources for 2.6.27.

Larry
