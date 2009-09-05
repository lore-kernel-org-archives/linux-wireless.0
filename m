Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:42398 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZIETg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 15:36:28 -0400
Received: by iwn5 with SMTP id 5so532112iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2009 12:36:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252142821.1175.10.camel@johannes.local>
References: <43e72e890909041515s38e7c502kf552a5cf90e99d94@mail.gmail.com>
	<1252142821.1175.10.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 5 Sep 2009 12:36:11 -0700
Message-ID: <43e72e890909051236x296dcd1v3106c414e3404253@mail.gmail.com>
Subject: Re: kmemleak reports on wireless-testing master-2009-09-04 + kmemleak
	tree
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 5, 2009 at 2:27 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-09-04 at 15:15 -0700, Luis R. Rodriguez wrote:
>> I get these with today's wireless-testing + pulling Catalin's kmemleak
>> tree. I nothing upon bootup, and then after a while I force a scan and
>> get (besides some other acpi stuff):
>>
>> unreferenced object 0xffff880039c7d700 (size 256):
>>   comm "events/1", pid 10, jiffies 4295050369
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
>>     [<ffffffff81118a83>] kmem_cache_alloc_node+0x193/0x200
>>     [<ffffffff8141dc6a>] __alloc_skb+0x4a/0x180
>>     [<ffffffff814ddb82>] wireless_send_event+0x1f2/0x410
>
> Do you have CONFIG_COMPAT?

Indeed, CONFIG_COMPAT=y

> And if you do, can you figure out whether
> this is "skb" or "compskb"?

How would I do that?

  Luis
