Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52387 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759034Ab0JXTjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Oct 2010 15:39:55 -0400
Message-ID: <4CC48B84.1000506@hauke-m.de>
Date: Sun, 24 Oct 2010 21:39:48 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Blaise Gassend <blaise@willowgarage.com>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 1/3] compat: fix device_lock functions on non rt kernel
References: <1287857641-7882-1-git-send-email-hauke@hauke-m.de> <AANLkTimv9dohuKynRW3GaMUDAOtMKhf0xwr76+wc2vCW@mail.gmail.com>
In-Reply-To: <AANLkTimv9dohuKynRW3GaMUDAOtMKhf0xwr76+wc2vCW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2010 09:19 PM, Blaise Gassend wrote:
> I agree that CONFIG_NONE should have been CONFIG_PREEMPT_NONE. On the
> other hand, I disagree that CONFIG_PREEMPT_NONE and
> CONFIG_PREEMPT_VOLUNTARY should be removed. They might not be in the
> latest RT patch, but they are in older patches (2.6.29 in particular).
>  Leaving them in will not hinder kernels that no longer have
> CONFIG_PREEMPT_NONE and CONFIG_PREEMPT_VOLUNTARY. Removing them will
> cause the build to fail for some configurations of 2.6.29-rt, and
> probably others.

Hi Blaise,

in the Ubuntu 10.04 default kernel config CONFIG_PREEMPT_VOLUNTARY=y is
set, but it does not use the RT patches, so compat-wireless build
failed. If you are using a mainline kernel you can choose between
CONFIG_PREEMPT_NONE, CONFIG_PREEMPT_VOLUNTARY and CONFIG_PREEMPT (all
localed in kernel/Kconfig.preempt for a least kernel 2.6.24), so these
options are not indicating that the RT patches are applied. The RT patch
adds CONFIG_PREEMPT_RT and CONFIG_PREEMPT_DESKTOP and removes
CONFIG_PREEMPT, so choosing one of these options to detect that the RT
patch is applied is not a good idea. I do not had the time to look
through the hole rt patch to find a better indicator if it is applied so
I just removed the ones preventing compiling on normal kernels. I just
looked into patch-2.6.33.7-rt29.bz2 and not the other RT patches.

It will be nice if you could find a better option which is set in the rt
patch every time, but is never set in a normal kernel. As I see it none
of the CONFIG_PREEMPT_ is of that type.

compat.wireless focus at first to build on mainline kernels and if it is
no problem we are able to support some kernels with extra patches like
the rt patch, because most of the users are using a mainline kernel.

Hauke

> On Sat, Oct 23, 2010 at 11:13 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> CONFIG_NONE and CONFIG_PREEMPT_VOLUNTARY are not added by the last RT
>> patch. I have not found any references to CONFIG_NONE, probably
>> CONFIG_PREEMPT_NONE was meant, but that is also wrong like
>> CONFIG_PREEMPT_VOLUNTARY. These two options are also in the normal kernel
>> config system without the rt patch.
>>
>> This patch only checks for KConfig options added by the rt patch, but a
>> rt-patch user could also select PREEMPT_NONE or PREEMPT_VOLUNTARY, and
>> compat-wireless will not build. I do not think this will hapen often, so leave
>> it like this.
>>
>> This patch fixes build with all non rt-kernels.
>>
>> CC: Blaise Gassend <blaise@willowgarage.com>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  include/linux/compat-2.6.34.h |    9 +++------
>>  1 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
>> index 1cfd6e5..f710d08 100644
>> --- a/include/linux/compat-2.6.34.h
>> +++ b/include/linux/compat-2.6.34.h
>> @@ -142,8 +142,7 @@ do {                                                                \
>>
>>  static inline void device_lock(struct device *dev)
>>  {
>> -#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
>> -    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
>> +#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
>>         mutex_lock(&dev->parent->mutex);
>>  #else
>>        down(&dev->sem);
>> @@ -152,8 +151,7 @@ static inline void device_lock(struct device *dev)
>>
>>  static inline int device_trylock(struct device *dev)
>>  {
>> -#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
>> -    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
>> +#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
>>        return mutex_trylock(&dev->mutex);
>>  #else
>>        return down_trylock(&dev->sem);
>> @@ -162,8 +160,7 @@ static inline int device_trylock(struct device *dev)
>>
>>  static inline void device_unlock(struct device *dev)
>>  {
>> -#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
>> -    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
>> +#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
>>         mutex_unlock(&dev->mutex);
>>  #else
>>        up(&dev->sem);
