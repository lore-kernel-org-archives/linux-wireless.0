Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56512 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab1FCLeI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 07:34:08 -0400
Message-ID: <4DE8C6A6.6080308@hauke-m.de> (sfid-20110603_133412_629811_75614E0B)
Date: Fri, 03 Jun 2011 13:33:58 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] compat-wireless: add support for kernel 3.XX
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de> <1307032525-18916-4-git-send-email-hauke@hauke-m.de> <BANLkTi=rfmTtb7ttTQQXskA8bkTewLAUrw@mail.gmail.com>
In-Reply-To: <BANLkTi=rfmTtb7ttTQQXskA8bkTewLAUrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for the review.

On 06/03/2011 11:07 AM, Jonas Gorski wrote:
> Hi,
> 
> On 2 June 2011 18:35, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> --- a/scripts/gen-compat-autoconf.sh
>> +++ b/scripts/gen-compat-autoconf.sh
>> @@ -155,6 +155,14 @@ for i in $(egrep '^CONFIG_|^ifdef CONFIG_|^ifndef CONFIG_|^endif #CONFIG_|^else
>>                echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_26\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,\2))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
>>                continue
>>                ;;
>> +       'ifdef+CONFIG_'* )
>> +               echo "#$i" | sed -e 's/+/ /' -e 's/\(ifdef CONFIG_COMPAT_KERNEL_3\)\([0-9]*\)/if (LINUX_VERSION_CODE < KERNEL_VERSION(3,\2,0))/' -e 's/\(#ifdef \)\(CONFIG_[^:space:]*\)/#if defined(\2) || defined(\2_MODULE)/'
>> +               continue
>> +               ;;
>> +       'ifndef+CONFIG_'* )
>> +               echo "#$i" | sed -e 's/+/ /' -e 's/\(ifndef CONFIG_COMPAT_KERNEL_3\)\([0-9]*\)/if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,\2,0))/' -e 's/\(#ifndef \)\(CONFIG_[^:space:]*\)/#if !defined(\2) && !defined(\2_MODULE)/'
>> +               continue
>> +               ;;
> 
> I admit, I don't have much shell script experience, but I'm surprised
> that having the same case multiple times works.
> I would probably just add the -e ' ... KERNEL_3\... ' part to the
> original sed lines (they are already much too long anyway ;-).
yes the patch is wrong, I will fix that.

> 
>>        'else+#CONFIG_'* | 'endif+#CONFIG_'* )
>>                echo "#$i */" |sed -e 's/+#/ \/* /g'
>>                continue
>> @@ -184,7 +192,12 @@ done
>>  # Deal with special cases. CONFIG_MAC80211_QOS is such a case.
>>  # We handle this specially for different kernels we support.
>>  if [ -f $KLIB_BUILD/Makefile ]; then
>> -       SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
>> +       MAJORLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^\([0-9]\)\..*/\1/p')
>> +       if [ $MAJORLEVEL -eq 2 ]; then
>> +               SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
>> +       else
>> +               SUBLEVEL=99
>> +       fi
> 
> You could drop setting sublevel to 99 by changing
> 
>>        if [ $SUBLEVEL -le 22 ]; then
> 
> to
> 
>         if [ $MAJORLEVEL -eq 2 -a $SUBLEVEL -le 22 ]
> 
> this would be a bit cleaner IMHO.
Yes that's better.
> 
> 
> Jonas

I will resend the patches with these fixes.

Hauke
