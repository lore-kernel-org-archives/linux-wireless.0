Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36781 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbcDWIlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2016 04:41:25 -0400
Received: by mail-yw0-f172.google.com with SMTP id o66so145346855ywc.3
        for <linux-wireless@vger.kernel.org>; Sat, 23 Apr 2016 01:41:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJGS-GQ++-QK+em2sL46HRSQ2aXubfAdAgigZfWm6YgFQ@mail.gmail.com>
References: <CABPxzYLZ2thNWCQ6bQ0-Peic-X-FTpTv4wJxyXVdmBDQDRS8JA@mail.gmail.com>
 <1461353341.2726.14.camel@perches.com> <CABPxzYJOAFq4hrSpZkx_bmvsUGhR0PmsUvjbnw=ykUeHAVXYqw@mail.gmail.com>
 <1461363503.2726.17.camel@perches.com> <CABPxzYJmKpw+Z0xm0+-mVUx5-bLrbKKi3V3UGhKoAT4Uf68r2g@mail.gmail.com>
 <1461398719.2726.22.camel@perches.com> <CABPxzYJGS-GQ++-QK+em2sL46HRSQ2aXubfAdAgigZfWm6YgFQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 23 Apr 2016 14:11:04 +0530
Message-ID: <CABPxzYKwYVUCYmE16TeKzfmicyQSwcxtmbrNrJVRBS1AkDdB-A@mail.gmail.com> (sfid-20160423_104134_322168_F97867E0)
Subject: Re: Debug prints mac80211 drivers
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 23, 2016 at 1:53 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Sat, Apr 23, 2016 at 1:35 PM, Joe Perches <joe@perches.com> wrote:
>> On Sat, 2016-04-23 at 13:11 +0530, Krishna Chaitanya wrote:
>>> On Sat, Apr 23, 2016 at 3:48 AM, Joe Perches <joe@perches.com> wrote:
>>> >
>>> > On Sat, 2016-04-23 at 02:32 +0530, Krishna Chaitanya wrote:
>>> > >
>>> > > On Sat, Apr 23, 2016 at 12:59 AM, Joe Perches <joe@perches.com>
>>> > > wrote:
>>> > > >
>>> > > >
>>> > > >
>>> > > > On Fri, 2016-04-22 at 17:51 +0530, Krishna Chaitanya wrote:
>>> > > > >
>>> > > > >
>>> > > > > What is the recommended method for adding
>>> > > > > debug prints in mac80211 based drivers.
>>> > > > >
>>> > > > > 1) -DDEBUG + pr_debug ==> used by mac80211, brcm80211
>>> > > > > 2) -DDEBUG + dev_dbg ==> zd1201
>>> > > > > 3) dev_printk(KERN_DEBUG) ==> used by iwlwifi
>>> > > > > 4) printk(KERN_DEBUG) ==> Just to complete the list.
>>> > > > wiphy_dbg -> netif_dbg -> netdev_dbg -> dev_dbg -> pr_debug
>>> > > Ok, thats what checpatch --strict throws. but still different
>>> > > vendors
>>> > > follow
>>> > > different standards, so wanted to check if we should go strictly
>>> > > with
>>> > > checkpatch (or) is there any rationale behind choose each of the
>>> > > variant.
>>> > Generally the variants are used to produce sufficient
>>> > logging information to identify the appropriate device.
>>> >
>>> > Most all debugging printks shouldn't be emitted unless
>>> > actually debugging.
>>> >
>>> > >
>>> > > >
>>> > > > and CONFIG_DYNAMIC_DEBUG, no -DDEBUG required
>>> > > Yes, i understand. Till now we had this enabled, so pr_debug
>>> > > works just fine, but now it is disabled hence the question.
>>> > >
>>> > > Also there are pros and cons to having control using dyndbg,
>>> > > user can disable dyndbg, there be missing imp
>>> > imp?
>>> Sorry, important.
>>> >
>>> > >
>>> > >  debugs, in this case
>>> > > having module level (-DDEBUG) helps but if we want entire system
>>> > > to run in non-debug mode, disabling dyndbg helps.
>>> > Confused:
>>> >
>>> > dynamic debug printks aren't emitted by default
>>> > unless DEBUG is also defined or specifically
>>> > enabled by the user.
>>> I don't think so, enabling dynamic debug should suffice.
>>>
>>> 280 #if defined(CONFIG_DYNAMIC_DEBUG)
>>> 281 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it
>>> here */
>>> 282 #define pr_debug(fmt, ...) \
>>> 283         dynamic_pr_debug(fmt, ##__VA_ARGS__)
>>> 284 #elif defined(DEBUG)
>>> 285 #define pr_debug(fmt, ...) \
>>> 286         printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>>> 287 #else
>>> 288 #define pr_debug(fmt, ...) \
>>> 289         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>>> 290 #endif
>>>
>>
>> Nope.
>>
>> Look at dynamic_debug.h
>>
>> #if defined DEBUG
>> #define _DPRINTK_FLAGS_DEFAULT _DPRINTK_FLAGS_PRINT
>> #else
>> #define _DPRINTK_FLAGS_DEFAULT 0
>> #endif
>>
>> and
>>
>>           .flags =  _DPRINTK_FLAGS_DEFAULT,
>>
>> and
>>
>> #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)                \
>>         static struct _ddebug  __aligned(8)                     \
>>         __attribute__((section("__verbose"))) name = {          \
>>                 .modname = KBUILD_MODNAME,                      \
>>                 .function = __func__,                           \
>>                 .filename = __FILE__,                           \
>>                 .format = (fmt),                                \
>>                 .lineno = __LINE__,                             \
>>                 .flags =  _DPRINTK_FLAGS_DEFAULT,               \
>>         }
>>
>> and
>>
>> #define dynamic_pr_debug(fmt, ...)                              \
>> do {                                                            \
>>         DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
>>         if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  \
>>                 __dynamic_pr_debug(&descriptor, pr_fmt(fmt),    \
>>                                    ##__VA_ARGS__);              \
>> } while (0)
>>
>> So by default, it's not enabled to be output
> Ok, i understand. We did not advertise -DDEBUG but pr_debug still
> works, need to check if we are enabling it through some other option.
To conclude, for a device driver using option#2: -DDEBUG + dev_dbg should
suffice?
