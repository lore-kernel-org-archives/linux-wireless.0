Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54419 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZGRPqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 11:46:14 -0400
Received: by ewy26 with SMTP id 26so1472976ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2009 08:46:12 -0700 (PDT)
Message-ID: <4A61EE43.4060003@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 16:46:11 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Rfkill rewrite
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2009-04-18 at 14:29 +0100, Alan Jenkins wrote:
>
>> API nit:
>> 
>>  * This function tells the rfkill core that the device is capable of
>>  * remembering soft blocks (which it is notified of via the set_block
>>  * method) -- this means that the driver may ignore the return value
>>  * from rfkill_set_hw_state().
>> 
>> Doesn't this conflict with the declaration of rfkill_set_hw_state() as
>> __must_check?
>
> Yeah, in a way it does, but I figure it's rare enough that those who
> really can ignore it can write
> 	(void) rfkill_set_hw_state(...)
>
> Don't really have a strong opinion, it just seemed the mistake in the
> other direction would be more common.

It seems my GCC has a stronger definition of "must" than you do :-).  I can't get rid of the warning by casting it to void.  So I'm not sure __must_check is really appropriate here.

drivers/platform/x86/hp-wmi.c: In function ‘hp_wmi_bios_setup’:
drivers/platform/x86/hp-wmi.c:467: warning: ignoring return value of ‘rfkill_set_hw_state’, declared with attribute warn_unused_result

$ grep -n rfkill_set_hw_state drivers/platform/x86/hp-wmi.c
467:            (void) rfkill_set_hw_state(wifi_rfkill,

$ gcc -v
Using built-in specs.
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr --enable-shared --with-system-zlib --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --enable-nls --with-gxx-include-dir=/usr/include/c++/4.2 --program-suffix=-4.2 --enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc --enable-mpfr --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)


Thanks
Alan
