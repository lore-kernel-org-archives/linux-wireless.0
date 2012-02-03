Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57127 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab2BCCuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 21:50:25 -0500
Received: by qcqw6 with SMTP id w6so1831370qcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 18:50:24 -0800 (PST)
Message-ID: <4F2B4B69.8050703@gmail.com> (sfid-20120203_035028_002497_9B362CDD)
Date: Thu, 02 Feb 2012 21:50:17 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [compat-wireless] modprobe -l is legacy compatibility mode and
 is being removed from some distros
References: <4F1F0810.2000306@gmail.com> <CAB=NE6VaU53v_qKuN_dBY+LhBxF5W0OLczGvJYg_if_nCn3nqQ@mail.gmail.com>
In-Reply-To: <CAB=NE6VaU53v_qKuN_dBY+LhBxF5W0OLczGvJYg_if_nCn3nqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/12 18:14, Luis R. Rodriguez wrote:
> On Tue, Jan 24, 2012 at 11:35 AM, Richard Farina <sidhayn@gmail.com> wrote:
>> module-init-tools has been deprecated in favor of kmod in Arch Linux, and
>> kmod doesn't have the legacy --list option for modprobe.
>> This patch fixes the areas of the Makefile which actually needed the output
>> of modprobe -l. The other 100's of uses are just to echo info to the screen
>> which in this case will simply fail in an extremely noisy fashion yet
>> non-fatal way.
>>
>> Please apply to all branches.
>>
>> Signed-of-By: Rick Farina <sidhayn@gmail.com>
>>
>> diff -Naur compat-wireless-3.3-rc1-2/Makefile
>> compat-wireless-3.3-rc1-2-modinfo-migration/Makefile
>> --- compat-wireless-3.3-rc1-2/Makefile    2012-01-21 02:00:21.000000000
>> -0500
> This patch form is not valid. Not sure if it was your SMTP or what but
> its busted and I cannot apply it even if I try to salvage it manually.
> Please consider using git on top of the latest master branch:
>
> git://github.com/mcgrof/compat-wireless.git
>
> And then please consider sending me patches using ssmtp or something
> that will respect the form so that I can apply the patch accordingly.
> For instructions you can read:
>
> http://wireless.kernel.org/en/developers/Documentation/git-guide
>
> You can read the ssmtp section, it covers gmail.

I read like 10 guides on how to submit patches, I just sent, I hope I
got it right....
>
>> +++ compat-wireless-3.3-rc1-2-modinfo-migration/Makefile    2012-01-24
>> 14:27:20.000000000 -0500
>> @@ -9,11 +9,6 @@
>>  # Sometimes not available in the path
>>  MODPROBE := /sbin/modprobe
>>
>> -ifneq ($(wildcard $(MODPROBE)),)
>> -MADWIFI=$(shell $(MODPROBE) -l ath_pci)
>> -OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
>> -endif
>> -
>>  DESTDIR?=
>>
>>  ifneq ($(KERNELRELEASE),)
>> @@ -188,7 +183,7 @@
>>     @install scripts/athload    $(DESTDIR)/usr/sbin/
>>     @install scripts/b43load    $(DESTDIR)/usr/sbin/
>>     @install scripts/iwl-load    $(DESTDIR)/usr/sbin/
>> -    @if [ ! -z "$(MADWIFI)" ] && [ -z "$(DESTDIR)" ]; then \
>> +    @if [ `modinfo ath_pci > /dev/null 2>&1` ] && [ -z "$(DESTDIR)" ]; then
>> \
> This check never values to true for me. Did you test it?
>
> $ if [ `modinfo ath9k > /dev/null 2>&1` ] ; then echo module exists;
> else echo module does not exist; fi
>
> module does not exist
>
> So at least for me this check does not work. Also consider using
> something like $(modinfo ath9k), it looks a lot nicer than the
> `modinfo ath9k` stuff.
Yeah... I messed up on that check in this patch as well as somewhere
else, the resend fixes it.

Thanks,
Rick Farina
>>         echo ;\
>>         echo -n "Note: madwifi detected, we're going to disable it. "  ;\
>>         echo "If you would like to enable it later you can run:"  ;\
>> @@ -197,7 +192,7 @@
>>         echo Running athenable ath5k...;\
>>         /usr/sbin/athenable ath5k ;\
>>     fi
>> -    @if [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
>> +    @if [ `modinfo iwl4965 > /dev/null 2>&1` ] && [ -z "$(DESTDIR)" ]; then
>> \
> Same here.
>
>   Luis
>

