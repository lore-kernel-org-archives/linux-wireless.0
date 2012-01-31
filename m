Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62393 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2AaOEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:04:44 -0500
Received: by qcqw6 with SMTP id w6so20599qcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 06:04:44 -0800 (PST)
Message-ID: <4F27F4DC.6080101@gmail.com> (sfid-20120131_150448_485195_FA871360)
Date: Tue, 31 Jan 2012 09:04:12 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [compat-wireless] modprobe -l is legacy compatibility mode and
 is being removed from some distros
References: <4F1F0810.2000306@gmail.com> <4F25BCAE.3040709@hauke-m.de>
In-Reply-To: <4F25BCAE.3040709@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2012 04:39 PM, Hauke Mehrtens wrote:
> On 01/24/2012 08:35 PM, Richard Farina wrote:
>> module-init-tools has been deprecated in favor of kmod in Arch Linux,
>> and kmod doesn't have the legacy --list option for modprobe.
>> This patch fixes the areas of the Makefile which actually needed the
>> output of modprobe -l. The other 100's of uses are just to echo info to
>> the screen which in this case will simply fail in an extremely noisy
>> fashion yet non-fatal way.
>>
>> Please apply to all branches.
>>
>> Signed-of-By: Rick Farina<sidhayn@gmail.com>
>>
>> diff -Naur compat-wireless-3.3-rc1-2/Makefile
>> compat-wireless-3.3-rc1-2-modinfo-migration/Makefile
>> --- compat-wireless-3.3-rc1-2/Makefile    2012-01-21 02:00:21.000000000
>> -0500
>> +++ compat-wireless-3.3-rc1-2-modinfo-migration/Makefile    2012-01-24
>> 14:27:20.000000000 -0500
>> @@ -9,11 +9,6 @@
>>   # Sometimes not available in the path
>>   MODPROBE := /sbin/modprobe
>>
>> -ifneq ($(wildcard $(MODPROBE)),)
>> -MADWIFI=$(shell $(MODPROBE) -l ath_pci)
>> -OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
>> -endif
>> -
> What happens if modinfo is not available? I do not know on what systems
> this is the case, but I do not think that modinfo is available when
> modprobe is not.
AFAIK this is never the case.  modinfo is packaged with 
module-init-tools and on Arch module-init-tools has been replaced by 
KMOD which also includes modinfo.  It would seem to me that at this 
point modinfo is a required tool and is always packaged with modprobe.

-Rick
>>   DESTDIR?=
>>
>>   ifneq ($(KERNELRELEASE),)
>> @@ -188,7 +183,7 @@
>>       @install scripts/athload    $(DESTDIR)/usr/sbin/
>>       @install scripts/b43load    $(DESTDIR)/usr/sbin/
>>       @install scripts/iwl-load    $(DESTDIR)/usr/sbin/
>> -    @if [ ! -z "$(MADWIFI)" ]&&  [ -z "$(DESTDIR)" ]; then \
>> +    @if [ `modinfo ath_pci>  /dev/null 2>&1` ]&&  [ -z "$(DESTDIR)" ];
>> then \
>>           echo ;\
>>           echo -n "Note: madwifi detected, we're going to disable it. "  ;\
>>           echo "If you would like to enable it later you can run:"  ;\
>> @@ -197,7 +192,7 @@
>>           echo Running athenable ath5k...;\
>>           /usr/sbin/athenable ath5k ;\
>>       fi
>> -    @if [ ! -z "$(OLD_IWL)" ]&&  [ -z "$(DESTDIR)" ]; then \
>> +    @if [ `modinfo iwl4965>  /dev/null 2>&1` ]&&  [ -z "$(DESTDIR)" ];
>> then \
>>           echo ;\
>>           echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
>>           echo "If you would like to enable it later you can run:"  ;\
>>
>

